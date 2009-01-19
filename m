Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbZASVeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbZASVeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZASVeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:34:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41179 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZASVeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:34:00 -0500
Date: Mon, 19 Jan 2009 22:31:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
       hpa@zytor.com, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119213146.GA31593@redhat.com>
References: <20090119124253.GA3268@redhat.com> <1232372016.3136.155.camel@zeus.themaw.net> <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com> <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com> <20090119191729.GB24852@redhat.com> <20090119193553.GA18170@us.ibm.com> <20090119200420.GA26977@redhat.com> <20090119204839.GA21009@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119204839.GA21009@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> > 
> > This is the next patch. This one does
> > 
> > 	--- CUR/fs/autofs/inode.c~1_AUTOFS	2009-01-12 23:07:46.000000000 +0100
> > 	+++ CUR/fs/autofs/inode.c	2009-01-18 06:18:49.000000000 +0100
> > 	@@ -78,7 +78,7 @@ static int parse_options(char *options, 
> > 	 
> > 		*uid = current_uid();
> > 		*gid = current_gid();
> > 	-	*pgrp = task_pgrp_nr(current);
> > 	+	*pgrp = task_pgrp_vnr(current);
> 
> Ok, that was the one I had looked at earlier (though now I can't find
> it).  But that just seems wrong to me.  We should certainly not be
> caching a pid_vnr in the kernel.  That is imo incomparably worse than
> storing a pid_nr.

We do not cache it. We use this pgrp as an argument for find_pid()
right after return from parse_options(). And find_pid() uses
current->nsproxy->pid_ns. That is why this is bugfix.

> Can we just jump straight to caching the struct pid?

Of course it is ugly to store pid_t and then call find_pid(),
I don't understand why the code was written this way. But I
am not going to cleanup this code ;)

(note also that the 2nd patch I sent for autofs4 does not use
 pid_t at all).

> > passing pid_t's in from userspace uses current namespace, with
> > or without the patch.
>
> Which makes sense on the one hand, but OTOH could be confusing
> if as I requested we print out init_pid_ns values.  (sigh)

But it is not possible to pass the global pid_t from within
the subnamespace via "pgrp=" option, automount (or whatever)
just can't know it when it runs in the subnamespace.

> Yes... would it be overkill to just print both?

perharps, I don't know...

But this is imho a bit off-topic, we can change the debugging
output later any way we like.

Oleg.

