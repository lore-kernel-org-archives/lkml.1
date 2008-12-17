Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752232AbYLQSwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbYLQSwz (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYLQSwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:52:46 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36710 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYLQSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:52:45 -0500
Date: Wed, 17 Dec 2008 12:52:41 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 1/2] mqueue ns: move mqueue_mnt into struct
	ipc_namespace
Message-ID: <20081217185241.GA25250@us.ibm.com>
References: <20081217175513.GA23291@us.ibm.com> <20081217175531.GA23331@us.ibm.com> <1229538964.17206.421.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229538964.17206.421.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Wed, 2008-12-17 at 11:55 -0600, Serge E. Hallyn wrote:

Thanks for taking look.

...
> > -#if defined(CONFIG_SYSVIPC) && defined(CONFIG_IPC_NS)
> > +#ifdef CONFIG_POSIX_MQUEUE
> > +extern void mq_init_ns(struct ipc_namespace *ns);
> > +/* default values */
> > +#define DFLT_QUEUESMAX 256     /* max number of message queues */
> > +#define DFLT_MSGMAX    10      /* max number of messages in each queue */
> > +#define HARD_MSGMAX    (131072/sizeof(void *))
> > +#define DFLT_MSGSIZEMAX 8192   /* max message size */
> > +#else
> > +#define mq_init_ns(ns)
> > +#endif
> 
> Do all these empty suckers need do{}while(0)'s?

Couldn't hurt for future-proofing.  Will do, thanks.

> > @@ -109,11 +98,25 @@ static inline struct mqueue_inode_info *MQUEUE_I(struct inode *inode)
> >  	return container_of(inode, struct mqueue_inode_info, vfs_inode);
> >  }
> > 
> > +void mq_init_ns(struct ipc_namespace *ns) {
> > +	ns->mq_queues_count  = 0;
> > +	ns->mq_queues_max    = DFLT_QUEUESMAX;
> > +	ns->mq_msg_max       = DFLT_MSGMAX;
> > +	ns->mq_msgsize_max   = DFLT_MSGSIZEMAX;
> > +	ns->mq_mnt           = mntget(init_ipc_ns.mq_mnt);
> > +}
> 
> Heh, I read that as a structure definition at first!  Could you put that
> bracket on a new line.

That's actually taken care of in the followup patch - same with
mq_exit_ns.  Sorry about that.  (Still I'd rather not bother with
the patch flux to change it just in this patch, since whenever
I do that I inevitably mess up something else)

> This part of the patch is nice.  The -'s are next to the +'s and it is
> easy to audit.
> 
> The rest of the patch looks good.  Mostly simple substitutions, and it
> is pretty obvious what is going on.

Thanks.  I'm hoping that Pavel and Eric will give their input and
maybe we can put this thing to bed  :)

-serge
