Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYLPSER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYLPSER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 13:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYLPSEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 13:04:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:12533 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYLPSEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 13:04:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=acqBXdPnNX6p65m+4zIP6wMNdZG5g96MtFdODX0yHp5tSndsATQ4A9TAqR7ZYwYYzV
         f1/zTkUeRe78tR5YLBtg7PD6b3EWVZUpj2nzNVF2ZjB6WKWC6KKXo1SfhriQu5SYAEkM
         8US6tPKyOF/Tv3LMjCgDmo0eceVXrUrPgcMWg=
Message-ID: <4947ED8C.1010709@tuffmail.co.uk>
Date: Tue, 16 Dec 2008 18:03:56 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Subject: hibernation bug - swap goes AWOL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is on 2.6.27-rc9.  I can easily test patches, or a more recent
kernel version.

I think I've run across a bug in hibernation.  Steps to reproduce:

1) Conspire to ensure insufficient swap space for hibernation
2) Attempt to hibernate, and fail
3) Attempt to hibernate *again*, and fail
4) try swapoff

Outcome:

# swapoff /dev/sda6
swapoff: /dev/sda6: Invalid argument
# cat /proc/swaps
Filename                                Type            Size    Used   
Priority
/dev/sda6                               partition       1494004 1350564 -1

Incidentally "swapoff -a" fails silently, which I think is a bug in
swapoff (i.e. it should report the error).

I don't see any backtraces in dmesg; the only errors it shows is the
failure to hibernate

If I free up some memory and try to hibernate again, I get a different
error - "Cannot find swap device, try swapon -a.".  Now swapon -a
doesn't work, but if I target the specific device...

# swapon /dev/sda6
# cat /proc/swaps
Filename                                Type            Size    Used   
Priority
/dev/sda6                               partition       1494004 331060  -1
/dev/sda6                               partition       1494004 0       -2

Wheee!  Interestingly I can now hibernate and resume.  But it's not
safe; my desktop session dies horribly.

Thanks
Alan

[ 1541.499324] kdeinit[10614]: segfault at 0 ip 00007fbd8515139a sp
00007fff8e04cf80 error 4 in libc-2.7.so[7fbd850dc000+158000]
[ 1541.520988] kdeinit[7322]: segfault at 0 ip 00007fbd8515139a sp
00007fff8e04cf50 error 4 in libc-2.7.so[7fbd850dc000+158000]
[ 1541.545512] kio_file[7343]: segfault at ffffffff00000000 ip
ffffffff00000000 sp 00007fff8e04c8a8 error 14
[ 1541.680883] Xorg[6928]: segfault at 692 ip 00007fb391c5bb92 sp
00007fff99e6a6c0 error 4 in ld-2.7.so[7fb391c4e000+1d000]

(ignore this bit, I think it happens every time X starts)
[ 1541.686628] Xorg:6928 freeing invalid memtype d0020000-d002a000
[ 1541.686748] Xorg:6928 freeing invalid memtype d002a000-d0032000
[ 1541.686848] Xorg:6928 freeing invalid memtype d0032000-d0042000
[ 1541.686948] Xorg:6928 freeing invalid memtype d0042000-d0043000
[ 1541.687221] Xorg:6928 freeing invalid memtype d0100000-d0740000
[ 1541.687421] Xorg:6928 freeing invalid memtype d077f000-d1a00000
[ 1541.687549] Xorg:6928 freeing invalid memtype d1a00000-d2040000
[ 1541.687649] Xorg:6928 freeing invalid memtype d2040000-d2680000
[ 1541.687750] Xorg:6928 freeing invalid memtype d2680000-d4680000
[ 1542.116794] Xorg:6928 freeing invalid memtype d0000000-d0020000

[ 1542.343673] pidgin[7505] general protection ip:7fcfdab92c92
sp:7fffe4e46ca0 error:0 in libX11.so.6.2.0[7fcfdab52000+ff000]
[ 1542.366374] update-notifier[7372] general protection ip:7f543a2acb92
sp:7fff424bc4a0 error:0 in ld-2.7.so[7f543a29f000+1d000]
[ 1545.569879] skge eth2: disabling interface
[ 1545.575729] skge eth2: enabling interface
[ 1545.579087] ADDRCONF(NETDEV_UP): eth2: link is not ready
[ 1546.966466] gedit[7423]: segfault at ffff88003740d448 ip
00007fb76a5d9053 sp 00007fff7ecf11d0 error 5 in
libqt-mt.so.3.3.8[7fb76a1f8000+9df000]
[ 1547.262323] skge eth2: Link is up at 100 Mbps, full duplex, flow
control both
[ 1547.262656] ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
[ 1547.831519] evince[7916] general protection ip:7f92c525b794
sp:7fffcd46a680 error:0 in ld-2.7.so[7f92c524d000+1d000]
[ 1547.964072] python[7526]: segfault at 200515 ip 00007f98515237e3 sp
00007fff59737530 error 4 in ld-2.7.so[7f985151a000+1d000]
[ 1549.013419] console-kit-dae[6506]: segfault at 28 ip 00007f310cf8b7c5
sp 00007fff1519ef40 error 4 in ld-2.7.so[7f310cf82000+1d000]
[ 1557.926527] eth2: no IPv6 routers present
[ 1568.747175] dcopserver[7325]: segfault at 4617998 ip 00007fbd85111409
sp 00007fff8e04c7e0 error 4 in libc-2.7.so[7fbd850dc000+158000]
[ 1569.959891] eth2: no IPv6 routers present


