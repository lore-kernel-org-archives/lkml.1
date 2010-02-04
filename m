Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab0BDH4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:56:49 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:28490 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab0BDH4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:56:46 -0500
Date: Wed, 3 Feb 2010 23:56:42 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Tejun Heo <tj@kernel.org>
Subject: Re: [2.6.33-rc6-git regression] idr fix breaks Xorg
Message-ID: <20100204075642.GA28286@hexapodia.org>
References: <20100204012837.GC538@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204012837.GC538@hexapodia.org>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 05:28:37PM -0800, Andy Isaacson wrote:
> On my Dell Latitude e4300 commit 859ddf0974 ("idr: fix a critical
> misallocation bug") causes Xorg to segfault with the following
> backtrace:
> 
> ...
> (II) intel(0): Initializing HW Cursor
> (II) intel(0): No memory allocations
> 
> Backtrace:
> 0: /usr/bin/X11/X(xorg_backtrace+0x26) [0x4f00c6]
> 1: /usr/bin/X11/X(xf86SigHandler+0x41) [0x4852c1]
> 2: /lib/libc.so.6 [0x7fbdad071530]
> 3: /usr/lib/xorg/modules/drivers//intel_drv.so [0x7fbdab8a1cbd]
> 4: /usr/lib/xorg/modules/drivers//intel_drv.so(gen4_render_state_init+0x416) [0x
> 7fbdab8a2a36]
> 5: /usr/lib/xorg/modules/drivers//intel_drv.so [0x7fbdab87d3e8]
> 6: /usr/lib/xorg/modules/drivers//intel_drv.so [0x7fbdab87e6fb]
> 7: /usr/bin/X11/X(AddScreen+0x1d4) [0x4337c4]
> 8: /usr/bin/X11/X(InitOutput+0x76f) [0x46f27f]
> 9: /usr/bin/X11/X(main+0x1fe) [0x433ece]
> 10: /lib/libc.so.6(__libc_start_main+0xfd) [0x7fbdad05cabd]
> 11: /usr/bin/X11/X [0x433509]
> Saw signal 11.  Server aborting.

strace perhaps shows some more illuminating results; I suspect the
SEGV is due to a failed ioctl.  (This is a different run than the above,
obviously.)

1265267921.566623 ioctl(8, 0xc020645e, 0x7fffe2196980) = 0
1265267921.566944 ioctl(8, 0x400c645f, 0x7fffe21969a0) = 0
1265267921.567272 brk(0x20e7000)        = 0x20e7000
1265267921.567602 ioctl(8, 0x40046460, 0x7fffe21969a0) = 0
1265267921.567922 ioctl(8, 0xc010645b, 0x7fffe2196990) = 0
1265267921.568269 ioctl(8, 0xc020645e, 0x7fffe2196980) = -1 EBADF (Bad file descriptor)
1265267921.568649 write(2, "../../../libdrm/intel/intel_bufmgr_gem.c:637: Error mapping buffer 1073741824 (gen4 WM state): Bad file descriptor .\n", 117) = 117
1265267921.569039 --- SIGSEGV (Segmentation fault) @ 0 (0) ---

The full strace is at
http://web.hexapodia.org/~adi/bugs/201002-xorg-segv/Xorg.strace

-andy
