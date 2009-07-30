Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbZG3JAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbZG3JAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZG3JAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:00:09 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55118 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZG3JAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:00:07 -0400
Date: Thu, 30 Jul 2009 11:00:05 +0200
From: Andreas Mohr <andi@lisas.de>
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roberto Oppedisano <roppedisano@infracomspa.it>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net
Subject: drm:radeon_cp_idle/reset error storm, console lockup (-rc4 git)
Message-ID: <20090730090005.GA4885@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0809090914300.1221@skynet.skynet.ie>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

encountered this problem myself, was able to regain access only via
remote login, then saw tons of (ratelimited)

[drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held, held  0 owner dc6513c0
dc6513c0
[drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without lock held,
held  0 owner dc6513c0 dc6513c0
[drm:radeon_cp_reset] *ERROR* radeon_cp_reset called without lock held,
held  0 owner dc6513c0 dc6513c0
[drm:radeon_cp_start] *ERROR* radeon_cp_start called without lock held,
held  0 owner dc6513c0 dc6513c0

dmesg output.

Did Alt-SysRq-T, related result part is:

Xorg          D 00000001     0  3867   3864 0x00400000
 dc686cb8 00003082 dfabeb70 00000001 00000003 dc66bbb0 dc66be28 00003282
 dfba0e40 dc537520 00003282 00003246 01ca5259 dfba0e00 dfba0e40 dc686ce8
 c115c4a5 00000000 dfba0e50 00000000 dc66bbb0 c1040b90 dfba0e40 dfba0e40
Call Trace:
 [<c115c4a5>] log_wait_commit+0x75/0xd0
 [<c1040b90>] ? autoremove_wake_function+0x0/0x50
 [<c115c618>] journal_force_commit_nested+0x38/0x60
 [<c110dc81>] ext3_should_retry_alloc+0x51/0x60
 [<c1114810>] ext3_write_begin+0x190/0x240
 [<c1112eb0>] ? ext3_get_block+0x0/0xf0
 [<c1079c16>] generic_file_buffered_write+0xe6/0x2a0
 [<c107a23b>] __generic_file_aio_write_nolock+0x22b/0x4e0
 [<c129d1f6>] ? radeon_cp_reset+0x76/0xf0
 [<c1283dda>] ? drm_ioctl+0x1da/0x370
 [<c107ae5b>] generic_file_aio_write+0x5b/0xd0
 [<c110f89d>] ext3_file_write+0x2d/0xc0
 [<c10a08f1>] do_sync_write+0xd1/0x110
 [<c1040b90>] ? autoremove_wake_function+0x0/0x50
 [<c10acd8a>] ? do_vfs_ioctl+0x6a/0x590
 [<c1024eaf>] ? set_next_entity+0x11f/0x1a0
 [<c10a13cc>] vfs_write+0x9c/0x160
 [<c1397f36>] ? schedule+0x376/0x4c0
 [<c10a0820>] ? do_sync_write+0x0/0x110
 [<c10a154d>] sys_write+0x3d/0x70
 [<c1002d35>] syscall_call+0x7/0xb


System: Debian testing, Athlon XP, new update to xserver-xorg-core to 2:1.6.2.901-1 from 1.6.2
(but I had desktop lockups slightly earlier already, and I'm pretty sure that was this).
ii  xserver-xorg-video-radeon                1:6.12.2-3                         X.Org X server -- ATI Radeon display driver

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV250 If [Radeon 9000] (rev 01)

So, is there some userspace waiting to be fixed here?

And is there any way to implement damage control? It's not overly nice to have joe random
userspace app being able to FUBAR an entire desktop, by forgetting an "important" lock. :)


Xorg.0.log parts:

(II) ImPS/2 Generic Wheel Mouse: Configuring as mouse
(**) ImPS/2 Generic Wheel Mouse: YAxisMapping: buttons 4 and 5
(**) ImPS/2 Generic Wheel Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device "ImPS/2 Generic Wheel Mouse" (type: MOUSE)
(**) ImPS/2 Generic Wheel Mouse: (accel) keeping acceleration scheme 1
(**) ImPS/2 Generic Wheel Mouse: (accel) filter chain progression: 2.00
(**) ImPS/2 Generic Wheel Mouse: (accel) filter stage 0: 20.00 ms
(**) ImPS/2 Generic Wheel Mouse: (accel) set acceleration profile 0
(II) ImPS/2 Generic Wheel Mouse: Device reopened after 8 attempts.
(II) config/hal: Adding input device ImPS/2 Generic Wheel Mouse
(**) ImPS/2 Generic Wheel Mouse: always reports core events
(**) ImPS/2 Generic Wheel Mouse: Device: "/dev/input/event4"
(WW) ImPS/2 Generic Wheel Mouse: device file already in use. Ignoring.
(II) UnloadModule: "evdev"
(EE) PreInit returned NULL for "ImPS/2 Generic Wheel Mouse"
(EE) config/hal: NewInputDeviceRequest failed (8)
(II) config/hal: removing device ImPS/2 Generic Wheel Mouse
(II) ImPS/2 Generic Wheel Mouse: Close
(II) UnloadModule: "evdev"

Backtrace:
0: /usr/bin/X(xorg_backtrace+0x3b) [0x813141b]
1: /usr/bin/X(xf86SigHandler+0x51) [0x80c55d1]
2: [0xffffe400]
3: /usr/bin/X(BlockHandler+0x94) [0x8090244]
4: /usr/bin/X(WaitForSomething+0x124) [0x812edc4]
5: /usr/bin/X(Dispatch+0x7e) [0x808c4de]
6: /usr/bin/X(main+0x3aa) [0x8071ada]
7: /lib/libc.so.6(__libc_start_main+0xe5) [0xb7c45775]
8: /usr/bin/X [0x8070fa1]

Fatal server error:
Caught signal 11.  Server aborting


Please consult the The X.Org Foundation support
         at http://wiki.x.org
 for help.
Please also check the log file at "/var/log/Xorg.0.log" for additional information.

(II) AT Translated Set 2 keyboard: Close
(II) UnloadModule: "evdev"
(II) AIGLX: Suspending AIGLX clients for VT switch
(EE) RADEON(0): RADEONWaitForIdleCP: CP idle -22
(EE) RADEON(0): Idle timed out, resetting engine...
(EE) RADEON(0): RADEONWaitForIdleCP: CP reset -22
(EE) RADEON(0): RADEONWaitForIdleCP: CP start -22
(EE) RADEON(0): RADEONWaitForIdleCP: CP idle -22
(EE) RADEON(0): Idle timed out, resetting engine...
(EE) RADEON(0): RADEONWaitForIdleCP: CP reset -22
(EE) RADEON(0): RADEONWaitForIdleCP: CP start -22
(EE) RADEON(0): RADEONWaitForIdleCP: CP idle -22
(EE) RADEON(0): Idle timed out, resetting engine...
(EE) RADEON(0): RADEONWaitForIdleCP: CP reset -22
(EE) RADEON(0): RADEONWaitForIdleCP: CP start -22
(EE) RADEON(0): RADEONWaitForIdleCP: CP idle -22
(EE) RADEON(0): Idle timed out, resetting engine...
(EE) RADEON(0): RADEONWaitForIdleCP: CP reset -22
(EE) RADEON(0): RADEONWaitForIdleCP: CP start -22
(EE) RADEON(0): RADEONWaitForIdleCP: CP idle -22


[etc.etc. ad nauseam]

I'm throwing an uneducated guess that this log means that there's some locking-up drm inconsistency
during server crash shutdown (subsystem shutdown order violation?)
which is rendering my entire machine useless, including blocking tty access.

Thanks a lot,

Andreas Mohr
