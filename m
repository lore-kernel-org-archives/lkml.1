Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755Ab0AXMPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0AXMPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 07:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717Ab0AXMPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 07:15:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab0AXMPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 07:15:32 -0500
Date: Sun, 24 Jan 2010 07:13:34 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Steve French <sfrench@samba.org>
Subject: Re: [PATCH UPDATED 38/40] cifs: use workqueue instead of slow-work
Message-ID: <20100124071334.0f12276e@tlielax.poochiereds.net>
In-Reply-To: <4B5C03EE.3000007@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	<1263776272-382-39-git-send-email-tj@kernel.org>
	<20100119072000.247ac894@tlielax.poochiereds.net>
	<4B564B12.7020909@kernel.org>
	<20100119195641.7b6a17e4@tlielax.poochiereds.net>
	<4B565B26.3060709@kernel.org>
	<4B59889D.7050903@kernel.org>
	<20100122064528.0223d708@tlielax.poochiereds.net>
	<4B5C03EE.3000007@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010 17:25:18 +0900
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 01/22/2010 08:45 PM, Jeff Layton wrote:
> >> @@ -584,13 +583,18 @@ is_valid_oplock_break(struct smb_hdr *bu
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
> >> +				/*
> >> +				 * cifs_oplock_break_put() can't be called
> >> +				 * from here.  Get reference after queueing
> >> +				 * succeeded.  cifs_oplock_break() will
> >> +				 * synchronize using GlobalSMSSeslock.
> >> +				 */
> >> +				if (queue_work(system_single_wq,
> >> +					       &netfile->oplock_break))
> >> +					cifs_oplock_break_get(netfile);
> >> +				netfile->oplock_break_cancelled = false;
> >> +
> > 
> > I think we want to move the setting of netfile->oplock_break_cancelled
> > inside of the if above it.
> > 
> > If the work is already queued, I don't think we want to set the flag to
> > false. Doing so might be problematic if we somehow end up processing
> > this oplock break after a previous oplock break/reconnect/reopen
> > sequence, but while the initial oplock break is still running.
> 
> Hmmm.... I can surely do that but that would be different from the
> original code.  slow_work_enqueue() doesn't distinguish between
> successful enqueue and the one which got ignored because the work was
> already queued.  With conversion to queue_work(), there's no failure
> case there so setting oplock_break_cancelled always is equivalent to
> the original code.  Even if changing it is the right thing to do, it
> should probably be done with a separate patch as it changes the logic.
> Are you sure it needs to be changed?
> 

I'm pretty sure we do. This flag only gets set to true if there's a
reconnection event. If there is one, then any oplock break queued up
before that happened is now invalid and shouldn't be sent.

It's a fairly minor point however. Even if we send the oplock break,
it's very unlikely to be treated as valid by the server as I don't
think the file would have a chance to be reopened prior to that.

If this is the way that the code works now, then let's go ahead with
your version and I'll plan to queue up a separate patch to change that
behavior after your changes go in.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
