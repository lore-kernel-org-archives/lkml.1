Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZATCHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZATCHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 21:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZATCHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 21:07:47 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49728 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbZATCHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 21:07:46 -0500
X-Sasl-enc: 6dvF7KmCE02jbn8v7y9DN+1seJaZfx0RS70K0chN8s/r 1232417263
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
From: Ian Kent <raven@themaw.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090119213146.GA31593@redhat.com>
References: <20090119124253.GA3268@redhat.com>
	 <1232372016.3136.155.camel@zeus.themaw.net>
	 <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com>
	 <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com>
	 <20090119191729.GB24852@redhat.com> <20090119193553.GA18170@us.ibm.com>
	 <20090119200420.GA26977@redhat.com> <20090119204839.GA21009@us.ibm.com>
	 <20090119213146.GA31593@redhat.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 11:07:45 +0900
Message-Id: <1232417265.3136.36.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 22:31 +0100, Oleg Nesterov wrote:
> On 01/19, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > 
> > > This is the next patch. This one does
> > > 
> > > 	--- CUR/fs/autofs/inode.c~1_AUTOFS	2009-01-12 23:07:46.000000000 +0100
> > > 	+++ CUR/fs/autofs/inode.c	2009-01-18 06:18:49.000000000 +0100
> > > 	@@ -78,7 +78,7 @@ static int parse_options(char *options, 
> > > 	 
> > > 		*uid = current_uid();
> > > 		*gid = current_gid();
> > > 	-	*pgrp = task_pgrp_nr(current);
> > > 	+	*pgrp = task_pgrp_vnr(current);
> > 
> > Ok, that was the one I had looked at earlier (though now I can't find
> > it).  But that just seems wrong to me.  We should certainly not be
> > caching a pid_vnr in the kernel.  That is imo incomparably worse than
> > storing a pid_nr.
> 
> We do not cache it. We use this pgrp as an argument for find_pid()
> right after return from parse_options(). And find_pid() uses
> current->nsproxy->pid_ns. That is why this is bugfix.
> 
> > Can we just jump straight to caching the struct pid?
> 
> Of course it is ugly to store pid_t and then call find_pid(),
> I don't understand why the code was written this way. But I
> am not going to cleanup this code ;)
> 
> (note also that the 2nd patch I sent for autofs4 does not use
>  pid_t at all).
> 
> > > passing pid_t's in from userspace uses current namespace, with
> > > or without the patch.
> >
> > Which makes sense on the one hand, but OTOH could be confusing
> > if as I requested we print out init_pid_ns values.  (sigh)
> 
> But it is not possible to pass the global pid_t from within
> the subnamespace via "pgrp=" option, automount (or whatever)
> just can't know it when it runs in the subnamespace.
> 
> > Yes... would it be overkill to just print both?
> 
> perharps, I don't know...
> 
> But this is imho a bit off-topic, we can change the debugging
> output later any way we like.

The use of pid_ts in debug statements could be confusing, but generally,
the debug output will only be used when the person gathering it is aware
of the environment it is collected in. We can change these as needed as
time passes.

We also send the pid_t via autofs request packets and it is used for
user space debug prints. It is open to the same confusion and I'm still
not sure how to deal with that but it isn't important to sort that out
now either, for the same reason as above.

Ian


