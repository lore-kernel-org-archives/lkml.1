Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbYJDJ7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbYJDJ7I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 05:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYJDJ6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 05:58:54 -0400
Received: from nebensachen.de ([195.34.83.29]:60961 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbYJDJ6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 05:58:53 -0400
X-Hashcash: 1:20:081004:bzolnier@gmail.com::IaufRVHcbFBnBn0Y:0000000000000000000000000000000000000000000CVU9
X-Hashcash: 1:20:081004:grundler@google.com::1FqQ5Ozw3AuCzesS:0000000000000000000000000000000000000000003E0R
X-Hashcash: 1:20:081004:jeff@garzik.org::LVZs/5ixUlkG5FyE:002dhs
X-Hashcash: 1:20:081004:randy.dunlap@oracle.com::ZQAkSsAwJGkDqKrI:000000000000000000000000000000000000007Xbr
X-Hashcash: 1:20:081004:htejun@gmail.com::k3DaIJ2J9y6mTSX5:04F+n
X-Hashcash: 1:20:081004:linux-ide@vger.kernel.org::ET6/GC13cgk3TFry:0000000000000000000000000000000000002yJX
X-Hashcash: 1:20:081004:linux-kernel@vger.kernel.org::YwPR13Dux2HjxH4J:0000000000000000000000000000000005Qpi
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Grant Grundler" <grundler@google.com>, Jeff Garzik <jeff@garzik.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v2] Add documentation for hard disk shock protection interface
References: <87d4j2n3dn.fsf@denkblock.local>
	<20080917163145.9870.8575.stgit@denkblock.local>
	<200809181628.34569.bzolnier@gmail.com>
Date: Sat, 04 Oct 2008 11:55:20 +0200
Message-ID: <8763o8znuf.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Wednesday 17 September 2008 09:40:06 Elias Oltmanns wrote:
>> Put some information (and pointers to more) into the kernel's doc tree,
>
>> describing briefly the interface to the kernel's disk head unloading
>> facility. Information about how to set up a complete shock protection
>> system under GNU/Linux can be found on the web and is referenced
>> accordingly.
>> 
>> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
>
> applied

Here is some final polish including various spelling corrections
pointed out by Grant Grundler and Peter Moulder. Also, I have added some
information about the timing constraints related to disk head parking.
The patch looks more impressive than it really is and I think it would
be alright just to incorporate it into the original patch so as not to
clutter up the git log.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---
diff --git a/Documentation/laptops/disk-shock-protection.txt b/Documentation/laptops/disk-shock-protection.txt
index 1f93462..0e6ba26 100644
--- a/Documentation/laptops/disk-shock-protection.txt
+++ b/Documentation/laptops/disk-shock-protection.txt
@@ -2,7 +2,7 @@ Hard disk shock protection
 ==========================
 
 Author: Elias Oltmanns <eo@nebensachen.de>
-Last modified: 2008-09-16
+Last modified: 2008-10-03
 
 
 0. Contents
@@ -27,34 +27,35 @@ situations are anticipated. The desire to have such a feature
 available on GNU/Linux systems has been the original motivation to
 implement a generic disk head parking interface in the Linux kernel.
 Please note, however, that other components have to be set up on your
-system in order to get disk shock protection working (see section
-3. References below for pointers to more information about that).
+system in order to get disk shock protection working (see
+section 3. References below for pointers to more information about
+that).
 
 
 2. The interface
 ----------------
 
-For each ATA device the kernel exports the file
+For each ATA device, the kernel exports the file
 block/*/device/unload_heads in sysfs (here assumed to be mounted under
 /sys). Access to /sys/block/*/device/unload_heads is denied with
 -EOPNOTSUPP if the device does not support the unload feature.
-Otherwise, writing an integer value to file will take the heads of the
-respective drive off the platter and block all I/O operations for the
-specified number of milliseconds. When the timeout expires and no
-further disk head park request has been issued in the meantime, normal
-operation will be resumed. The maximal value accepted for a timeout is
-30000 milliseconds. Exceeding this limit will return -EOVERFLOW, but
-heads will be parked anyway and the timeout will be set to 30 seconds.
-However, you can always change a timeout to any value between 0 and
-30000 by issuing a subsequent head park request before the timeout of
-the previous one has expired. In particular, the total timeout can
-exceed 30 seconds and, more importantly, you can cancel a previously
-set timeout and resume normal operation immediately by specifying a
-timeout of 0. Values below -2 are rejected with -EINVAL (see below for
-the special meaning of -1 and -2). If the timeout specified for a
-recent head park request has not yet expired, reading from
-/sys/block/*/device/unload_heads will report the number of
-milliseconds remaining until normal operation will be resumed;
+Otherwise, writing an integer value to this file will take the heads
+of the respective drive off the platter and block all I/O operations
+for the specified number of milliseconds. When the timeout expires and
+no further disk head park request has been issued in the meantime,
+normal operation will be resumed. The maximal value accepted for a
+timeout is 30000 milliseconds. Exceeding this limit will return
+-EOVERFLOW, but heads will be parked anyway and the timeout will be
+set to 30 seconds. However, you can always change a timeout to any
+value between 0 and 30000 by issuing a subsequent head park request
+before the timeout of the previous one has expired. In particular, the
+total timeout can exceed 30 seconds and, more importantly, you can
+cancel a previously set timeout and resume normal operation
+immediately by specifying a timeout of 0. Values below -2 are rejected
+with -EINVAL (see below for the special meaning of -1 and -2). If the
+timeout specified for a recent head park request has not yet expired,
+reading from /sys/block/*/device/unload_heads will report the number
+of milliseconds remaining until normal operation will be resumed;
 otherwise, reading the unload_heads attribute will return 0.
 
 For example, do the following in order to park the heads of drive
@@ -69,32 +70,39 @@ A simple
 will show you how many milliseconds are left before normal operation
 will be resumed.
 
+A word of caution: The fact that the interface operates on a basis of
+milliseconds may raise expectations that cannot be satisfied in
+reality. In fact, the ATA specs clearly state that the time for an
+unload operation to complete is vendor specific. The hint in ATA-7
+that this will typically be within 500 milliseconds apparently has
+been dropped in ATA-8.
+
 There is a technical detail of this implementation that may cause some
 confusion and should be discussed here. When a head park request has
 been issued to a device successfully, all I/O operations on the
 controller port this device is attached to will be deferred. That is
 to say, any other device that may be connected to the same port will
 be affected too. The only exception is that a subsequent head unload
-request to that other devvice will be executed immediately. Further
+request to that other device will be executed immediately. Further
 operations on that port will be deferred until the timeout specified
 for either device on the port has expired. As far as PATA (old style
 IDE) configurations are concerned, there can only be two devices
 attached to any single port. In SATA world we have port multipliers
-which means that a user issued head parking request to one device may
-actually result in stopping I/O to a whole bunch of devices. Hwoever,
+which means that a user-issued head parking request to one device may
+actually result in stopping I/O to a whole bunch of devices. However,
 since this feature is supposed to be used on laptops and does not seem
 to be very useful in any other environment, there will be mostly one
 device per port. Even if the CD/DVD writer happens to be connected to
 the same port as the hard drive, it generally *should* recover just
 fine from the occasional buffer under-run incurred by a head park
 request to the HD. Actually, when you are using an ide driver rather
-than it's libata counterpart (i.e. your disk is called /dev/hda
-instead of /dev/sda), then parking the heads of drive A will generally
-not affect the mode of operation of drive B on the same port as
-described above. It is only when a port reset is required to recover
-from an exception on drive B that further I/O operations on that drive
-(and the reset itself) will be delayed until drive A is no longer in
-the parked state.
+than its libata counterpart (i.e. your disk is called /dev/hda
+instead of /dev/sda), then parking the heads of one drive (drive X)
+will generally not affect the mode of operation of another drive
+(drive Y) on the same port as described above. It is only when a port
+reset is required to recover from an exception on drive Y that further
+I/O operations on that drive (and the reset itself) will be delayed
+until drive X is no longer in the parked state.
 
 Finally, there are some hard drives that only comply with an earlier
 version of the ATA standard than ATA-7, but do support the unload
@@ -121,7 +129,7 @@ source development of the required software components so far, Linux
 support for shock protection varies considerably between different
 hardware implementations. Ideally, this section should contain a list
 of pointers at different projects aiming at an implementation of shock
-protection on different systeems. Unfortunately, I only know of a
+protection on different systems. Unfortunately, I only know of a
 single project which, although still considered experimental, is fit
 for use. Please feel free to add projects that have been the victims
 of my ignorance.
@@ -129,9 +137,6 @@ of my ignorance.
 - http://www.thinkwiki.org/wiki/HDAPS
   See this page for information about Linux support of the hard disk
   active protection system as implemented in IBM/Lenovo Thinkpads.
-  (FIXME: The information there will have to be updated once this
-  patch has been approved or the user interface has been agreed upon
-  at least.)
 
 
 4. CREDITS
