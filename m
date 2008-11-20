Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbYKTXVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbYKTXVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYKTXVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:21:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754687AbYKTXVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:21:31 -0500
Date: Thu, 20 Nov 2008 15:20:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: penguin-kernel@i-love.sakura.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: Random freeze (Re: mmotm 2008-11-19-02-19 uploaded)
Message-Id: <20081120152054.2f757251.akpm@linux-foundation.org>
In-Reply-To: <4401.1227222347@turing-police.cc.vt.edu>
References: <200811200609.mAK69ZbZ053438@www262.sakura.ne.jp>
	<4401.1227222347@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 18:05:47 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Thu, 20 Nov 2008 15:09:35 +0900, Tetsuo Handa said:
> > Hello.
> > 
> > > The mm-of-the-moment snapshot 2008-11-19-02-19 has been uploaded to
> > Recent mmotm randomly freezes on /sbin/modprobe and read(). 2.6.28-rc2-mm1 was OK.
> 
> I'm seeing very similar hangs on -mmotm-11-17 as well. I've hit it 3 times
> today, all while disk activity was moderately heavy (things like 'yum update',
> or a 'find . | xargs grep', and so on).
> 
> Managed to catch one while netconsole was active - I didn't have any messages
> for bugs/warns/oopsen.  Apparently, somebody is holding a lock. (I also have an
> alt-sysrq-t from this incident, but that's about 10 times as big, didn't want
> to abuse vger too much.. ;)
> 
> [ 3932.912494] SysRq : Show Blocked State
> [ 3932.913465]   task                        PC stack   pid father
> [ 3932.913465] pdflush       D ffff88007e247cf0  5776   303      2
> [ 3932.913465]  ffff88007e247c50 0000000000000002 ffff88007e247bb0 ffff88007dcf54d8
> [ 3932.913465]  ffff88007e247c00 ffffffff8081c780 ffffffff8081c780 ffff88007f269040
> [ 3932.913465]  ffff88007f232040 ffff88007f269398 000000007e247be0 ffff88007f269398
> [ 3932.913465] Call Trace:
> [ 3932.913465]  [<ffffffff80252a1a>] ? getnstimeofday+0x4a/0xa6
> [ 3932.913465]  [<ffffffff80567f2e>] io_schedule+0x63/0xa5
> [ 3932.913465]  [<ffffffff8027e44d>] sync_page+0x78/0x7f
> [ 3932.913465]  [<ffffffff80568380>] __wait_on_bit+0x47/0x79
> [ 3932.913465]  [<ffffffff8027e3d5>] ? sync_page+0x0/0x7f
> [ 3932.913465]  [<ffffffff8027e5ed>] wait_on_page_bit+0x6e/0x75
> [ 3932.913465]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
> [ 3932.913465]  [<ffffffff80286343>] ? pagevec_lookup_tag+0x22/0x2b
> [ 3932.913465]  [<ffffffff8027eed9>] wait_on_page_writeback_range+0x75/0x13d
> [ 3932.913465]  [<ffffffff8027efc1>] filemap_fdatawait+0x20/0x22
> [ 3932.913465]  [<ffffffff8027f0cc>] filemap_write_and_wait+0x27/0x33
> [ 3932.913465]  [<ffffffff802c7c32>] sync_blockdev+0x1b/0x1d
> [ 3932.913465]  [<ffffffff802c2242>] __sync_inodes+0x74/0xbf
> [ 3932.913465]  [<ffffffff802c22a6>] sync_inodes+0x19/0x33
> [ 3932.913465]  [<ffffffff802c5378>] do_sync+0x1a/0x77
> [ 3932.913465]  [<ffffffff80285a4c>] pdflush+0x145/0x1f8
> [ 3932.913465]  [<ffffffff802c535e>] ? do_sync+0x0/0x77
> [ 3932.913465]  [<ffffffff80285907>] ? pdflush+0x0/0x1f8
> [ 3932.913465]  [<ffffffff8024ba10>] kthread+0x49/0x76
> [ 3932.913465]  [<ffffffff8020cb79>] child_rip+0xa/0x11
> [ 3932.913465]  [<ffffffff8020bfe5>] ? restore_args+0x0/0x30
> [ 3932.913465]  [<ffffffff8024b9c7>] ? kthread+0x0/0x76
> [ 3932.913465]  [<ffffffff8020cb6f>] ? child_rip+0x0/0x11

The traditional cause of the above trace is that someone mucked up the
block/driver/irq-routing layer and we lost an IO completion.

It's also of course possible (but less common) that someone mucked up
the VFS.  It would be interesting to revert
do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary.patch.


