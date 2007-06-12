Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbXFLJsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbXFLJsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 05:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXFLJsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 05:48:10 -0400
Received: from styx.suse.cz ([82.119.242.94]:51295 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750741AbXFLJsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 05:48:08 -0400
Date: Tue, 12 Jun 2007 12:00:57 +0200
From: Jan Kara <jack@suse.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
Message-ID: <20070612100057.GB6590@duck.suse.cz>
References: <46680BB8.50404@rtr.ca> <20070607084142.42583639.akpm@linux-foundation.org> <46682E4E.1070303@redhat.com> <20070607124507.79d8da54.akpm@linux-foundation.org> <466A175C.1000906@rtr.ca> <20070611111457.GB26561@atrey.karlin.mff.cuni.cz> <466DD0E9.1060506@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466DD0E9.1060506@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-06-07 18:47:05, Mark Lord wrote:
> Jan Kara wrote:
> >>Andrew Morton wrote:
> >>>On Thu, 07 Jun 2007 12:11:58 -0400
> >>>Chuck Ebbert <cebbert@redhat.com> wrote:
> >>>
> >>>>On 06/07/2007 11:41 AM, Andrew Morton wrote:
> >>>>>>  mount /var/lib/mythtv -oremount,ro
> >>>>>>  sync
> >>>>>>  umount /var/lib/mythtv
> >>>>>Did this succeed?  If the application is still truncating that file, 
> >>>>>the
> >>>>>umount should have failed.
> >>>>Shouldn't sync should wait for truncate to finish?
> >>>I can't think of anything in there at present which would cause that to
> >>>happen, and it's not immediately obvious how we _could_ make it happen - 
> >>>we
> >>>have an inode which potentially has no dirty pages and which is itself
> >>>clean.  The truncate can span multiple journal commits, so forcing a
> >>>journal commit in sync() won't necessarily block behind the truncate.
> >>>
> >>>I guess we could ask sync to speculatively take and release every inode's
> >>>i_mutex or something.  But even that would involve quite some 
> >>>hoop-jumping
> >>>due to those infuriating spinlock-protected list_heads on the superblock.
> >>>
> >>>hmm.
> >>Okay, I added more instrumentation and retested today.
> >>
> >>Good and Bad.
> >>The umount does indeed fail while the massive unlink is happening,
> >>so I can just loop on that a few times before giving up.
> >>
> >>But.. the earlier "remount,ro".. well.. I don't know what it does.
> >>I did get it to lock up solid, though.. hung on the "remount,ro"
> >>when issued during an unlink of a 15GB file.  The disk I/O eventually
> >>completes, and drives go idle, but the system remains hung inside
> >>the remount,ro call.
> >>
> >>Alt-sysrq-T was functioning, so I have some screen shots (.jpg) here:
> >>
> >> http://rtr.ca/remount_ro/
> >  Thanks for the traces.
> >
> >>That's definitely a bug.
> >  Yes. We have a nice lock inversion there. ext3_remount() is called
> >with sb->s_lock held and waits for transaction to finish in
> >journal_lock_updates(). On the other hand ext3_orphan_del() is called
> >inside a transaction and tries to do lock_super()... Bad luck.
> 
> Peachy.  Do you have enough knowledge here to generate a fix for this?
> Maybe just have the remount break out, releasing all locks, and then 
> loop and retry (or return -EBUSY?) when this happens?
  Yes, I'll try to cook up some patch. As I'm looking through the code,
ext3_remount seems to be the only place where we need to start a
transaction under s_lock. So probably we could release sb->s_lock for
the time we have to wait for a transaction...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
