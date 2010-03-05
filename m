Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0CENZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 08:25:58 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:60559 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab0CENZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 08:25:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=NLbyOYoZNKLnQUJUA5oAwQbeo8+gjdY3PsnKTO9XuH+IdZJHCKz5NiHeHyzSy/HsmQ
         HwQHuIXbsC9RZIfRqSE85sUdGxtxkAm0M4l13mOk5Wfy6B96tlYWcUGbyTupnjwFLxEM
         mGIsyca1e0R4I1jCeJUjJlpkgcOgvfVEgiF4k=
MIME-Version: 1.0
From: Albert Strasheim <fullung@gmail.com>
Date: Fri, 5 Mar 2010 15:25:35 +0200
Message-ID: <5eec5f301003050525w653d25er34f4dee293f79b9@mail.gmail.com>
Subject: SAS multipath performance
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all

I've been doing some experiments with the 2.6.31 and 2.6.33 kernels
with multipathing to Sun JBODs over SAS.

Theoretically, our setup should allow throughput in the 3600 MB/sec
range, but we get about 2200-2300 MB/sec. Even taking into account the
various potential inefficiencies in the setup, it still seems like one
might be able to squeeze more out of this system.

We have the following hardware:

Sun Blade X6270
2* LSI SAS 1068E controllers
2* Sun J4400 JBODs with 1 TB disks (24 disks per JBOD)
Fedora Core 12
2.6.33 kernel from FC13 (also tried with latest 2.6.31 kernel from
FC12, same results)

The build of 2.6.33 is from here:

http://kojipkgs.fedoraproject.org/packages/kernel/2.6.33/4.fc13/

Here's the datasheet for the SAS hardware:

http://www.sun.com/storage/storage_networking/hba/sas/PCIe.pdf

It's using PCI Express 1.0a, 8x lanes. With a bandwidth of 250 MB/sec
per lane, we should be able to do 2000 MB/sec per SAS controller.

Each controller can do 3 Gb/sec per port and has two 4 port PHYs. We
connect both PHYs from a controller to a JBOD. So between the JBOD and
the controller we have 2 PHYs * 4 SAS ports * 3 Gb/sec = 24 Gb/sec of
bandwidth, which is more than the PCI Express bandwidth.

With write caching enabled and when doing big writes, each disk can
sustain about 80 MB/sec (near the start of the disk). With 24 disks,
that means we should be able to do 1920 MB/sec per JBOD.

I write to the disks using dd, since we're mostly interested in
sequential performance.

The multipath configuration for each disk looks as follows:

multipath {
  rr_min_io 100
  uid 0
  path_grouping_policy multibus
  failback manual
  path_selector "round-robin 0"
  rr_weight priorities
  alias somealias
  no_path_retry queue
  mode 0644
  gid 0
  wwid somewwid
}

I tried values of 50, 100, 1000 for rr_min_io, but it doesn't seem to
make much difference.

Along with varying rr_min_io I tried adding some delay between
starting the dd's to prevent all of them writing over the same PHY at
the same time, but this didn't make any difference, so I think the
I/O's are getting properly spread out.

According to /proc/interrupts, the SAS controllers are using a
"IR-IO-APIC-fasteoi" interrupt scheme. For some reason only core #0 in
the machine is handling these interrupts. I can improve performance
slightly by assigning a separate core to handle the interrupts for
each SAS controller:

echo 2 > /proc/irq/24/smp_affinity
echo 4 > /proc/irq/26/smp_affinity

Using dd to write to the disk generates "Function call interrupts" (no
idea what these are), which are handled by core #4, so I keep other
processes off this core too.

I run 48 dd's (one for each disk), assigning them to cores not dealing
with interrupts like so:

taskset -c somecore dd if=/dev/zero of=/dev/mapper/mpathx oflag=direct bs=128M

oflag=direct prevents any kind of buffer cache from getting involved.

None of my cores seem maxed out. The cores dealing with interrupts are
mostly idle and all the other cores are waiting on I/O as one would
expect.

Cpu0  :  0.0%us,  1.0%sy,  0.0%ni, 91.2%id,  7.5%wa,  0.0%hi,  0.2%si,  0.0%st
Cpu1  :  0.0%us,  0.8%sy,  0.0%ni, 93.0%id,  0.2%wa,  0.0%hi,  6.0%si,  0.0%st
Cpu2  :  0.0%us,  0.6%sy,  0.0%ni, 94.4%id,  0.1%wa,  0.0%hi,  4.8%si,  0.0%st
Cpu3  :  0.0%us,  7.5%sy,  0.0%ni, 36.3%id, 56.1%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.0%us,  1.3%sy,  0.0%ni, 85.7%id,  4.9%wa,  0.0%hi,  8.1%si,  0.0%st
Cpu5  :  0.1%us,  5.5%sy,  0.0%ni, 36.2%id, 58.3%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu6  :  0.0%us,  5.0%sy,  0.0%ni, 36.3%id, 58.7%wa,  0.0%hi,  0.0%si,  0.0%st
...
Cpu15 :  0.1%us,  5.4%sy,  0.0%ni, 36.5%id, 58.1%wa,  0.0%hi,  0.0%si,  0.0%st

Does anybody have any idea where my missing throughput went or how to
continue this investigation to find the reason for the bottleneck?

Thanks!

Regards

Albert Strasheim
