Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbZASUs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbZASUs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbZASUsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:48:42 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:50270 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632AbZASUsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:48:41 -0500
Date: Mon, 19 Jan 2009 14:48:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
       hpa@zytor.com, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119204839.GA21009@us.ibm.com>
References: <1232363717.3136.134.camel@zeus.themaw.net> <20090119124253.GA3268@redhat.com> <1232372016.3136.155.camel@zeus.themaw.net> <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com> <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com> <20090119191729.GB24852@redhat.com> <20090119193553.GA18170@us.ibm.com> <20090119200420.GA26977@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119200420.GA26977@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 01/19, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > 
> > > Actually, I am very much surprized this one-liner patch has so
> > > many questions. Isn't it "obiously correct" ?
> > 
> > I'm not sure which one-liner you're talking about.  In fact,
> > the patch I'm looking at right now isn't the one i looked at
> > before my last response.  Dangit.
> > 
> > The patch turning the cached pid_t into a struct pid is
> > certainly mostly right.  It shouldn't store a pid_t.
> 
> This is the next patch. This one does
> 
> 	--- CUR/fs/autofs/inode.c~1_AUTOFS	2009-01-12 23:07:46.000000000 +0100
> 	+++ CUR/fs/autofs/inode.c	2009-01-18 06:18:49.000000000 +0100
> 	@@ -78,7 +78,7 @@ static int parse_options(char *options, 
> 	 
> 		*uid = current_uid();
> 		*gid = current_gid();
> 	-	*pgrp = task_pgrp_nr(current);
> 	+	*pgrp = task_pgrp_vnr(current);

Ok, that was the one I had looked at earlier (though now I can't find
it).  But that just seems wrong to me.  We should certainly not be
caching a pid_vnr in the kernel.  That is imo incomparably worse than
storing a pid_nr.

Can we just jump straight to caching the struct pid?

> 		*minproto = *maxproto = AUTOFS_PROTO_VERSION;
> 
> > But as for passing pid_t's in from userspace
> 
> passing pid_t's in from userspace uses current namespace, with
> or without the patch.

Which makes sense on the one hand, but OTOH could be confusing
if as I requested we print out init_pid_ns values.  (sigh)

> > and especially
> > printing them out in error messages, I believe what Ian was
> > trying to do before, which seemed sensible, was to always
> > use values in the init_pid_ns.  After all, if you do a DPRINTK
> > with pid_vnr(somepid), then by the time a human reads the logs
> > the subjective pidns might no longer exist.  So for logs I'd
> > tend to agree with printing out the pid_t in the init_pid_ns.
> 
> OK, may be this makes sense, this was not discussed yet. This
> can be changed. But otoh, if this code runs within the sub
> namespace, then it is not easy to see why oz_mode == true
> if we print the value in init_pid_ns.
> 
> Oleg.

Yes... would it be overkill to just print both?

Or maybe I'm being silly.  Every pidns goes away eventually
including the init_pid_ns :)

-serge
