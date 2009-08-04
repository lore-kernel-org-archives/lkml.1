Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbZHDV1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbZHDV1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932598AbZHDV1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:27:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547AbZHDV1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:27:48 -0400
Date: Tue, 4 Aug 2009 14:24:04 -0700
From: Greg KH <gregkh@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31rc5 RAID10 lockdep report - sysfs_nofity_dirent locking
 issue
Message-ID: <20090804212404.GA26390@suse.de>
References: <20090804141425.GA2831@redhat.com>
 <58e2e493d0855face4e7d3fbf7ee65b9.squirrel@neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58e2e493d0855face4e7d3fbf7ee65b9.squirrel@neil.brown.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 07:13:08AM +1000, NeilBrown wrote:
> On Wed, August 5, 2009 12:14 am, Dave Jones wrote:
> > Report from a user we received today ..
> > (https://bugzilla.redhat.com/show_bug.cgi?id=515471)
> >
> > 	Dave
> >
> >
> > =================================
> > [ INFO: inconsistent lock state ]
> > 2.6.31-0.118.rc5.fc12.x86_64 #1
> > ---------------------------------
> > inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> > md126_resync/475 [HC0[0]:SC1[1]:HE1:SE0] takes:
> > (sysfs_open_dirent_lock){+.?...}, at: [<ffffffff811a7d08>]
> > sysfs_notify_dirent+0x2c/0x75
> 
> So the problem is that sysfs_open_dirent_lock is sometimes called
> with SOFTIRQs enabled, and sometimes called in a SOFTIRQ and this
> can lead to a deadlock.
> 
> The call from in a softirq is in sysfs_notify_dirent which is a very
> small atomic function which I would certainly like to be able to
> call from any context.
> 
> So the fix would be to use spin_lock_irq on the sysfs_open_dirent_lock ??
> Or should it be spin_lock_bh ??
> 
> Attached is a suggestion for a patch.
> 
> Greg: does that look right?  If so I'll add a changelog entry and
> submit it properly (after at least a compile test...)

Yes, it looks correct, if it passes your tests :)

thanks,

greg k-h
