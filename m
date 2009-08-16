Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbZHPMzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbZHPMzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 08:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZHPMzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 08:55:24 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:62584 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbZHPMzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 08:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wus7k+L6IZqkT63yZFKJT0SVrzUhguAdiJ1reRlZPksP6Ztc8Ff8bUx+WPcB6Z8dFT
         DmG7ycXKtWtsTExim8QUmUEPZ+WxSpKQF5M6J2zlaMAjYgh/rZyK4xPyv1Bnn4yZgaw5
         ND+RCH0aksG5cTN0maypura5bqFf2baP5Kcq0=
MIME-Version: 1.0
In-Reply-To: <tnxab228ibo.fsf@pc1117.cambridge.arm.com>
References: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com>
	 <tnxab228ibo.fsf@pc1117.cambridge.arm.com>
Date: Sun, 16 Aug 2009 13:55:22 +0100
Message-ID: <6278d2220908160555m2aba699euf2133e07c1626941@mail.gmail.com>
Subject: Re: [2.6.31-rc6, BTRFS] potential memory leaks...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
       Chris Mason <chris.mason@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 5:35 PM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>> There is good chance that the BTRFS kmemleak reports using 2.6.31-rc6
>> [1] are false-positives, due to the overwriting of the static pointers
>> [2]. Does this ring true with anyone else?
>
> If you do a few echo scan > /sys/kernel/debug/kmemleak, do they
> disappear?
>
> The static pointers are scanned by kmemleak, unless they are in the
> .data.init section (which is removed anyway).

The above reports I picked _are_ transient indeed.

Directed more to LKML, every mount (at least on ext4 and BTRFS), we do
see persistent reports [1], even after scanning, unmount and more
scanning.

Daniel

--- [1]

unreferenced object 0xffff88006133d260 (size 32):
  comm "mount", pid 27209, jiffies 4300626089
  backtrace:
    [<ffffffff810de2f1>] create_object+0x141/0x2d0
    [<ffffffff810de5c5>] kmemleak_alloc+0x55/0x60
    [<ffffffff810dadfb>] __kmalloc_track_caller+0x17b/0x260
    [<ffffffff810c1429>] kstrdup+0x39/0x70
    [<ffffffffa01d2b9a>] btrfs_parse_options+0x5a/0x3a0 [btrfs]
    [<ffffffffa01edf45>] open_ctree+0x9c5/0x13f0 [btrfs]
    [<ffffffffa01d24ec>] btrfs_get_sb+0x3fc/0x500 [btrfs]
    [<ffffffff810e2478>] vfs_kern_mount+0x58/0xd0
    [<ffffffff810e255e>] do_kern_mount+0x4e/0x110
    [<ffffffff810fc55a>] do_mount+0x2ca/0x8d0
    [<ffffffff810fcc1b>] sys_mount+0xbb/0xf0
    [<ffffffff8100bdeb>] system_call_fastpath+0x16/0x1b

unreferenced object 0xffff88007a5d9c80 (size 128):
  comm "mount", pid 2030, jiffies 4294963872
  backtrace:
    [<ffffffff810de2f1>] create_object+0x141/0x2d0
    [<ffffffff810de5c5>] kmemleak_alloc+0x55/0x60
    [<ffffffff810da14b>] __kmalloc+0x18b/0x270
    [<ffffffff81162c8d>] ext4_mb_init+0x1cd/0x670
    [<ffffffff8114e363>] ext4_fill_super+0x1883/0x2810
    [<ffffffff810e388d>] get_sb_bdev+0x17d/0x1b0
    [<ffffffff8114a8c3>] ext4_get_sb+0x13/0x20
    [<ffffffff810e2478>] vfs_kern_mount+0x58/0xd0
    [<ffffffff810e255e>] do_kern_mount+0x4e/0x110
    [<ffffffff810fc55a>] do_mount+0x2ca/0x8d0
    [<ffffffff810fcc1b>] sys_mount+0xbb/0xf0
    [<ffffffff8100bdeb>] system_call_fastpath+0x16/0x1b

unreferenced object 0xffff88006071a000 (size 8192):
  comm "mount", pid 27460, jiffies 4303151389
  backtrace:
    [<ffffffff810de2f1>] create_object+0x141/0x2d0
    [<ffffffff810de5c5>] kmemleak_alloc+0x55/0x60
    [<ffffffff810d9f73>] kmem_cache_alloc+0x153/0x1a0
    [<ffffffff81171ec7>] journal_init_common+0x1e7/0x2a0
    [<ffffffff81172995>] jbd2_journal_init_inode+0x15/0x1b0
    [<ffffffff8114e869>] ext4_fill_super+0x1d89/0x2810
    [<ffffffff810e388d>] get_sb_bdev+0x17d/0x1b0
    [<ffffffff8114a8c3>] ext4_get_sb+0x13/0x20
    [<ffffffff810e2478>] vfs_kern_mount+0x58/0xd0
    [<ffffffff810e255e>] do_kern_mount+0x4e/0x110
    [<ffffffff810fc55a>] do_mount+0x2ca/0x8d0
    [<ffffffff810fcc1b>] sys_mount+0xbb/0xf0
    [<ffffffff8100bdeb>] system_call_fastpath+0x16/0x1b
-- 
Daniel J Blueman
