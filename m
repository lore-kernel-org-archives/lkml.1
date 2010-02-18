Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0BROEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 09:04:38 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:48530 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab0BROEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 09:04:36 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: Stupid futex question - 2.6.33-rc7-mmotm0210
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1266501862_4162P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Feb 2010 09:04:22 -0500
Message-ID: <10057.1266501862@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4B7D48F3.01D5,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1266501862_4162P
Content-Type: text/plain; charset=us-ascii

Kernel: x86_64 2.6.33-rc7-mmotm0210

I'm debugging a problem where pulseaudio is getting killed with a SIGKILL
out of the blue.  It appears to be a problem where pulseaudio sets
RLIMIT_RTTIME and the bound gets exceeded.  Analysis with 'top' shows
a short spike of 96% system time, and the tail end of strace shows this:

[pid 25065] 01:50:20.371484 ioctl(28, USBDEVFS_CONTROL, 0x7fd3d76f630c) = 0 <0.000015>
[pid 25065] 01:50:20.371548 ioctl(28, 0x40045532, 0x7fd3d76f636c) = 0 <0.000016>
[pid 25065] 01:50:20.371611 open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK|O_CLOEXEC <unfinished ...>
[pid 25064] 01:50:20.371678 <... write resumed> ) = 8 <0.002104>
[pid 25064] 01:50:20.371718 futex(0xc2ec00, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 25066] 01:50:21.408392 +++ killed by SIGKILL +++
PANIC: handle_group_exit: 25066 leader 25064
[pid 25065] 01:50:21.408442 +++ killed by SIGKILL +++
PANIC: handle_group_exit: 25065 leader 25064
01:50:21.420354 +++ killed by SIGKILL +++

thread 25064 apparently gets gunned down due to RTTIME because it spent a whole
second in a futex() call - is it reasonable for futex() to not return for that
long?

In other words - kernel bug because futex() should return, or pulseaudio bug
for not understanding futex() can snooze a while?

If a kernel bug, anybody got a better idea than nuking the RLIMIT_RTTIME call,
waiting for it to repeat (takes between 1 minute and 1 hour or so), and
whomping it a few times with sysrq-T?


--==_Exmh_1266501862_4162P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLfUjmcC3lWbTT17ARAqK6AJ96r7l2IFT6YtdgpvxezC+5BbZKXACfTFsK
yIQ5QjzxZPAfWAXL/4ZImWs=
=O5BU
-----END PGP SIGNATURE-----

--==_Exmh_1266501862_4162P--

