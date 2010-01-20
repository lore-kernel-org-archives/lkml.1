Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473Ab0ATA7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0ATA7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260Ab0ATA7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:59:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab0ATA7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:59:44 -0500
Date: Tue, 19 Jan 2010 19:56:41 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Steve French <sfrench@samba.org>
Subject: Re: [PATCH 38/40] cifs: use workqueue instead of slow-work
Message-ID: <20100119195641.7b6a17e4@tlielax.poochiereds.net>
In-Reply-To: <4B564B12.7020909@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	<1263776272-382-39-git-send-email-tj@kernel.org>
	<20100119072000.247ac894@tlielax.poochiereds.net>
	<4B564B12.7020909@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010 09:15:14 +0900
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 01/19/2010 09:20 PM, Jeff Layton wrote:
> >> @@ -584,13 +583,13 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
> >>  				pCifsInode->clientCanCacheAll = false;
> >>  				if (pSMB->OplockLevel == 0)
> >>  					pCifsInode->clientCanCacheRead = false;
> >> -				rc = slow_work_enqueue(&netfile->oplock_break);
> >> -				if (rc) {
> >> -					cERROR(1, ("failed to enqueue oplock "
> >> -						   "break: %d\n", rc));
> >> -				} else {
> >> -					netfile->oplock_break_cancelled = false;
> >> -				}
> >> +
> >> +				cifs_oplock_break_get(netfile);
> >> +				if (!queue_work(system_single_wq,
> >> +						&netfile->oplock_break))
> >> +					cifs_oplock_break_put(netfile);
> >> +				netfile->oplock_break_cancelled = false;
> >> +
> >>  				read_unlock(&GlobalSMBSeslock);
> >>  				read_unlock(&cifs_tcp_ses_lock);
> >>  				return true;
> > 
> > This block of code looks problematic. This code is run by the
> > cifs_demultiplex_thread (cifsd). We can't do an oplock_break_put in
> > this context, since it might trigger a blocking SMB and cause a
> > deadlock.
> 
> Okay, thanks for pointing it out.
> 
> > A while back, I backported this code to earlier kernels and used a
> > standard workqueue there. What I did there was to only do the "get" if
> > the queue_work succeeded, and then had the queued work take and
> > immediately drop the GlobalSMBSeslock first thing. Yes, it's ugly, but
> > it prevented the possible deadlock and didn't require adding anything
> > like completion vars to the struct.
> 
> Hmmm... Why is locking GlobalSMBSeslock necessary?
> cifs_oplock_break_get() can never fail and it seems that
> is_valid_oplock_break() should be holding valid reference by the time
> it enqueues the work, so wouldn't the following be sufficient?
> 
> 	if (queue_work(system_single_wq, &netfile->oplock_break))
> 		cifs_oplock_break_get(netfile);
> 

I guess I wasn't sure I could count on that. It seems unlikely that the
work would run before you did the "get", but unlikely races are even
harder to troubleshoot when they do get hit.

FWIW, it's not a terribly hot codepath, so taking and dropping the
spinlock shouldn't be too bad for performance. If you're certain that
we don't need to worry about it though, then maybe we can just skip
doing that.

> > Also, this change seems to have changed the logic a bit. The
> > oplock_break_cancelled flag is being set to false unconditionally, and
> > the printk was dropped. Not a big deal on the last part, but we can't
> > really do much with errors in this codepath so it might be helpful to
> > have some indication that there are problems here.
> 
> The thing is that slow_work_enqueue() can only fail if getting a
> reference fails.  In cifs' case, it always succeeds so there's no
> failure case to handle there.
> 

Ok, but here we're changing this to queue_work. Is that also guaranteed
to succeed here? If so, then dropping the printk is fine. If not, then
I think we should keep it in.

It's been a while since I overhauled this code, so I'll need to look
again at the semantics for the oplock_break_cancelled flag. It may be
ok to just set it unconditionally like this, but I'll need to check
and be sure.

-- 
Jeff Layton <jlayton@redhat.com>
