Return-Path: <linux-kernel-owner+w=401wt.eu-S934150AbYCFN0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150AbYCFN0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbYCFN0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:26:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:64049 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbYCFN0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:26:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=WSWFKPxvKUhAhfsdtuuVKDZMawtNyC9ic9pb7Ya6CnRUtaikD9jvnlHRbqHwEuUxLSSzIZMTHgG2Sc6eIedMRGmCpNEGX+SjJfzXqytrFoOa8YFKb7LcE+K6YSN17pWjQ2f0l6yt1yJOXsm/w5DK2EtDjE9bUiaqU526bm2/y9E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Linux 2.6.25-rc4
Date: Thu, 6 Mar 2008 14:38:21 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Anders Eriksson <aeriksson@fastmail.fm>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080306090029.GA6215@elte.hu> <20080306125929.GD17940@kernel.dk>
In-Reply-To: <20080306125929.GD17940@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803061438.22205.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008, Jens Axboe wrote:
> On Thu, Mar 06 2008, Ingo Molnar wrote:
> > 
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > In particular, the block layer changes should hopefully have sorted 
> > > themselves out, and CD burning etc hopefully works for people again. 
> > 
> > hm, tonight's randconfig bootrun produced a failing (soft-hung) kernel 
> > after about 120 iterations - and the log i captured _seems_ to indicate 
> > some block IO (or libata) completion weirdness.
> > 
> > unfortunately, it's not readily reproducible, and i triggered it with 
> > about 100 sched.git and 300 x86.git patches applied. BUT, virtually the 
> > same 100+300 patches queue produced a successful 1000+ randconfig 
> > testrun over the last weekend so i'm reasonably sure the regression is 
> > new and came in via upstream. Also, the config is UP (and it's a rather 
> > simple config in other aspects as well), so this must be something 
> > rather fundamental, not an SMP race.
> > 
> > I just spent about an hour trying to figure out a pattern but the bug 
> > just doesnt reproduce after 20 bootup attempts with the same bzImage. 
> > When it hung then it hung for hours, so the condition is permanent.
> > 
> > I've attached the bootup log which includes the SysRq-T output and the 
> > config. The hang seems to occur because an rc.sysinit task is not coming 
> > back from io_schedule():
> > 
> > rc.sysinit    D f75bcc24     0  1922   1893
> >        f761c810 00000086 f75bcd38 f75bcc24 1954bff5 00000015 f7746000 f761c974 
> >        f761c974 f7c17698 c180e7a8 f7747cc4 00000000 f7747ccc c180e7a8 c097bff7 
> >        c01a3acb c097c27d c01a3aa0 f7872a90 00000002 c01a3aa0 f7747e48 c097c2fc 
> > Call Trace:
> >  [<c097bff7>] io_schedule+0x37/0x70
> >  [<c01a3acb>] sync_buffer+0x2b/0x30
> >  [<c097c27d>] __wait_on_bit+0x4d/0x80
> >  [<c01a3aa0>] sync_buffer+0x0/0x30
> >  [<c01a3aa0>] sync_buffer+0x0/0x30
> >  [<c097c2fc>] out_of_line_wait_on_bit+0x4c/0x60
> >  [<c0142340>] wake_bit_function+0x0/0x40
> >  [<c01a3a51>] __wait_on_buffer+0x21/0x30
> >  [<c0209915>] ext3_bread+0x55/0x70
> >  [<c020cff8>] ext3_find_entry+0x258/0x660
> >  [<c03a0026>] avc_has_perm+0x46/0x50
> >  [<c03a0d14>] inode_has_perm+0x44/0x80
> >  [<c020de69>] ext3_lookup+0x29/0xa0
> >  [<c0189f90>] do_lookup+0x130/0x180
> >  [<c018b540>] __link_path_walk+0x340/0xd50
> >  [<c03a0d14>] inode_has_perm+0x44/0x80
> >  [<c018bf8a>] link_path_walk+0x3a/0xa0
> >  [<c016feb4>] __do_fault+0x1a4/0x3d0
> >  [<c018c1b7>] do_path_lookup+0x77/0x210
> >  [<c018cb57>] __user_walk_fd+0x27/0x40
> >  [<c01860d5>] vfs_stat_fd+0x15/0x40
> >  [<c016feb4>] __do_fault+0x1a4/0x3d0
> >  [<c01861ef>] sys_stat64+0xf/0x30
> >  [<c0125a5d>] do_page_fault+0x2ad/0x670
> >  [<c03db6cc>] trace_hardirqs_on_thunk+0xc/0x10
> >  [<c0115a5f>] sysenter_past_esp+0x5f/0x90
> >  =======================
> 
> Sorry, I have _no_ ideas on what this could be. We haven't really had
> any related changes in the block layer over that short a time frame. It
> could of course have been introduced earlier, since it seems to be quite
> elusive.
> 
> Presumably any hw issues would get noticed (like missing interrupt) and
> trigger the error handler, so it looks like this IO is still stuck in
> the queue somewhere. That mainly points the finger at AS, but given that
> you cannot reproduce I'm not sure how best to proceed with this...

The problem looks very similar to the one recently reported by Anders:

http://lkml.org/lkml/2008/2/22/239

"Trying out 2.6.25-rc2 smartd always causes my box to hang. I can switch 
vt:s and the keyboard seems to work.

Using sysrq-e I noticed a callpath open -> ext3 -> journals -> sync_buffer -> 
io_scheduel -> generic_unplig_device.
I'd guess the open stems from smartd. Removing smartd from the startup, I'm 
now using rc2 fine..."

Initially we thought that it is an IDE regression but after some testing
and further investigation it seems that IDE changes just made it more
likely to occur (yesterday it turned out that the kernel with the "guilty"
IDE commit sometimes boots fine).  The issue is easily reproducible.

PS We've already verified that it is not PREEMPT related or a compiler bug. 

Thanks,
Bart
