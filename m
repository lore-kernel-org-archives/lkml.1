Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbZDGUmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbZDGUmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 16:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760297AbZDGUmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 16:42:07 -0400
Received: from a4.complang.tuwien.ac.at ([128.130.173.65]:60208 "EHLO
	a4.complang.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759778AbZDGUmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:42:06 -0400
X-Greylist: delayed 2252 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 16:42:06 EDT
Subject: Out-of-order writing by disk drives
To: linux-kernel@vger.kernel.org
Date: Tue, 7 Apr 2009 22:04:29 +0200 (CEST)
From: "Anton Ertl" <anton@mips.complang.tuwien.ac.at>
Reply-To: anton@mips.complang.tuwien.ac.at
X-Info: DVR-Nummer der TU Wien: 0005886
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1LrHX3-0003u5-2G@a4.complang.tuwien.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have released a new version of hdtest, a program that tests whether
hard disks write out-of-order relative to the order that the writes
were passed to them from the OS.  You find the program at

http://www.complang.tuwien.ac.at/anton/hdtest/

Here I mainly present the results from my tests, and explain enough
about the program so you know what I am talking about.


HOW DOES IT WORK?

It writes the blocks in an order like this:

1000-0-1001-0-1002-0-...

This sequence seems to inspire PATA and SATA disks to write
out-of-order (in the order 1000-1001-1002-...-0).  So you turn off the
drive's power while running the program.  The written blocks contain
certain data that another program from the suite can check after you
power the drive up again.


RESULTS

I performed two sets of tests, one in November 1999, and one in April
2009.  The results have not changed much.  In both tests disks wrote
data seriously out-of-order in their default configuration; they can
delay the writing of block 0 in this test for quite a long time.

In more detail:

In 2009 I tested three drives (and accessed the whole drive) under
Linux 2.6.18 on Debian Etch; the USB enclosure used was a Tsunami
Elegant 3.5" Enclosure that has PATA and SATA disk drive interfaces.

* Maxtor L300R0 PATA (300GB) connected through an USB enclosure: In
  two tests it wrote the consecutive blocks 47 and 34 blocks after the
  last written block 0.

* Seagate ST340062 Model 0A PATA (7200.10, 400GB):
   connected through a USB enclosure:
    3 times the result was as if it had written the blocks in-order
    1 time  it wrote  3064 blocks out-of-order
    2 times it wrote 18384 blocks out-of-order
   connected directly via PATA cable:
    1 time it wrote 1972 blocks out-of-order

* Seagate ST340062 Model 0AS SATA (7200.10, 400GB) connected through a
  USB enclosure:
    1 time the result was as if it had written the blocks in-order
    2 times it wrote  3064 blocks out-of-order
    1 time  it wrote  6128 blocks out-of-order
    1 time  it wrote 12256 blocks out-of-order
    1 time it did not write block 0 at all

It is interesting that the number of blocks that is found to be
out-of-order is often a multiple of 3064.  Maybe this is a multiple of
a track size; no other explanations come to mind.

In 1999 I tested two drives (and accessed one partition) under
Linux-2.2.1 on RedHat 5.1.  The two drives were a Quantum Fireball
CR8.4A (8GB) and an IBM-DHEA-36480 (6GB), both connected directly via
PATA.  I did one test with each of the disks, and they did not even
write block 0 once on the platters before I turned off the power.

I also tested the Quantum with write caching disabled (hdparm -W 0).
Hdtest was now quite noisy and produced the in-order result.


CONCLUSION

Applications and file systems requiring in-order writes (i.e.,
basically all of them) should use barriers or turn off write caching
for the disk drive(s) they use.  Unfortunately, the Linux ext3 file
system does not use barriers by default; use the mount option
barrier=1 to enable them, e.g. by putting a line like this in
/etc/fstab:

/dev/md2        /home           ext3    defaults,barrier=1      1	2

- anton
