Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbZJZWD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbZJZWD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZJZWDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:03:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54231 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbZJZWDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:03:21 -0400
Date: Mon, 26 Oct 2009 15:02:40 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: jeremy@goop.org, x86@kernel.org
Subject: 2.6.32-rc not booting with Xen-3.2 (bisected)
Message-ID: <alpine.DEB.2.01.0910261445170.9408@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/6YDGEeYxdJ9eYHcn6Frgerk4ard0RuG8s3gA
 q1cFVGOL1hohyB99YoVt7iR1UCUIr3rmOYAFdoKeDUJEbvkbE3
 b3aEg8ioCIOzFytHy9+dw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running a Xen-3.2 Dom0 (Ubuntu 8.04 LTS, kernel 2.6.24) which is 
hosting several DomUs. One of them is a debian/unstable and I'm trying to 
run the latest -git version of Linus' tree. However, I wasn't able to test 
for a while and I noticed just now that I cannot boot 2.6.32-rc1 any more, 
2.6.31 (release) was booting fine. Unfortunately, "xm create sid.cfg -c" 
just says "Domain started", but then "xm list" just shows the DomU in "p" 
or in "b" state, and the console ("-c") isn't attached either, so I don't 
really know where the DomU stops (or panics). However, I was able to 
bisect it, I hope the bisection makes any sense:

------------------------------------
sid$ git bisect log
git bisect start
# good: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
git bisect good 74fca6a42863ffacaf7ba6f1936a9f228950f657
# bad: [17d857be649a21ca90008c6dc425d849fa83db5c] Linux 2.6.32-rc1
git bisect bad 17d857be649a21ca90008c6dc425d849fa83db5c
# good: [5d1fe0c98f2aef99fb57aaf6dd25e793c186cea3] Staging: vt6656: Integrate vt6656 into build system.
git bisect good 5d1fe0c98f2aef99fb57aaf6dd25e793c186cea3
# bad: [c720f5655df159a630fa0290a0bd67c93e92b0bf] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
git bisect bad c720f5655df159a630fa0290a0bd67c93e92b0bf
# good: [a03fdb7612874834d6847107198712d18b5242c7] Merge branch 'timers-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good a03fdb7612874834d6847107198712d18b5242c7
# good: [3530c1886291df061e3972c55590777ef1cb67f8] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
git bisect good 3530c1886291df061e3972c55590777ef1cb67f8
# bad: [84d6ae431f315e8973aac3c3fe1d550fc9240ef3] V4L/DVB (13033): pt1: Don't use a deprecated DMA_BIT_MASK macro
git bisect bad 84d6ae431f315e8973aac3c3fe1d550fc9240ef3
# bad: [068ed40b8fc14cd3d16b5cf2db59ecd735a68ca8] V4L/DVB (12939): SAA7164: Removed a duplicate call to address any PCI quirks.
git bisect bad 068ed40b8fc14cd3d16b5cf2db59ecd735a68ca8
# bad: [f4e96deb4513d044653027d4921fd7592195503a] V4L/DVB (12756): af9015: fix typo in register compare
git bisect bad f4e96deb4513d044653027d4921fd7592195503a
# good: [dd0a70c8f921708eba29ef9f30dde1f14a74af05] x86: Move tsc_init to late_time_init
git bisect good dd0a70c8f921708eba29ef9f30dde1f14a74af05
# bad: [53e712d0844e99b8d8720327470b86ef401fb727] V4L/DVB (12734): cx25821: Fix some compilation troubles
git bisect bad 53e712d0844e99b8d8720327470b86ef401fb727
# good: [7bd867dfb4e0357e06a3211ab2bd0e714110def3] x86: Move get/set_wallclock to x86_platform_ops
git bisect good 7bd867dfb4e0357e06a3211ab2bd0e714110def3
# bad: [78f28b7c555359c67c2a0d23f7436e915329421e] Merge branch 'x86-platform-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 78f28b7c555359c67c2a0d23f7436e915329421e
# good: [9c88b25bcfde51eccf2cca13d933a2948d0ca4eb] frv: clean up linker script using new linker script macros.
git bisect good 9c88b25bcfde51eccf2cca13d933a2948d0ca4eb
-----------------------------------

Version numbers and more for both the domU and dom0 are on:
http://nerdbynature.de/bits/2.6.32/dom0/dpkg-l.txt

Only the "Merge branch x86-platform-for-linus" pops out 
where a lot of x86 changes have been merged, but I have no
idea how to bisect within a "single" change.

Please advise.

Thanks,
Christian.
-- 
BOFH excuse #308:

CD-ROM server needs recalibration
