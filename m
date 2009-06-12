Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbZFLJSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbZFLJSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbZFLJSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:18:47 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:44759 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbZFLJSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:18:46 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-10.arcor-online.net 92B3228F08F
Subject: Re: (forw) [bugzilla-daemon@bugzilla.kernel.org: [Bug 12309] Large
 I/O operations result in slow performance and high iowait times]
From: Thomas Pilarski <thomas.pi@arcor.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Thomas Pilarski <thomas.pi@arcor.de>, Christoph Hellwig <hch@lst.de>,
       akpm@linux-foundation.org
In-Reply-To: <20090608204544.GB26832@elte.hu>
References: <20090608182929.GA26458@Krystal>
	 <20090608204544.GB26832@elte.hu>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 11:18:44 +0200
Message-Id: <1244798324.4973.66.camel@balrog.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have executed some tests and the improvements in kernel 30 are
gigantic.

The time of starting applications during heavy i/o is shorter on kernel
30 than on kernel 20, which was the fastest kernel for me. The first
part of the patch from comment #366 @ kernel bug 12309 improves the
desktop responsiveness in kernel 29 and 30, but kernel 29 was still bad,
while the kernel 30 was fine during my tests. It must be only one part
of the bad commit. 

+ if (cfqd->rq_in_driver && cfq_cfqq_idle_window(cfqq))
+    return 0;

The fsync problem still exists. Firefox is unusable during heavy i/o.
This problem exists in every kernel I have tested (17, 18, 20, 22, 24,
26, 27, 28, 29 and 30). I could not tests the kernel 15, as I was not
able to start the X server.

A high i/o wait time was in every of these kernels too, even in the
kernel 15. 

NCQ should be disabled on my test drive, because I have no access to
read or write the queue_depth file. If I chmod +w queue_depth, I can
read a one. Write access fails with an i/o error. It's an Ultrabay sata
drive in my ThinkPad. The main drive shows 31 as queue_depth and it's
read- and writeable.

For testing I have used 16 concurrent writing dd processes. My tests
were stating gimp, eclipse, compiling the kernel, switching windows and
desktops. The desktop performance (starting application / working)
during heavy i/o on the kernel 30 is really great. Even better than in
the kernel 20, which was the best kernel for me. But the cpu usage of
the kernel 30 is higher and I have some short stall (mouse freezes)
shorter than 1s while updating the screen at 1920x1200 in vesa mode and
at 800MHz. These stalls exists with the kernel 20 too, but are shorter.
The freezes disappear on enabling the cpu scaling or setting the cpu to
max frequency. 

The patch improves the start up time e.g. of eclipse from ~2min during
heavy i/o to ~1:30min in kernel 30. The overall throughput is nearby the
same, ~70% of disk capacity during 16 writing processes. Every app
started quick from the same disk, even during loadavg of ~20. There
where no mouse freezes with the patch. I could even use the input
assistance of eclipse, although it takes a while (~5s the first time ).
Gimp started even faster than in kernel 20. Everything was quick and
without any stall in spite of such a high load (up to 25). I had no
typing delays in the console. It's really great. I could only not test
any virtual machines, as the vmware kernel driver does not work with the
kernel 30, but I have done some quick tests with virtualbox and it looks
fine. 

I have executed all these tests on a patched and an unpatched kernel 20,
29 and 30 without smp support and the a final test on the patched kernel
30 with smp and multicore support to have the direct comparison.

The final tests includes a test with 16 concurrent reading and writing
processes on the same partition, a test with one reading and writing dd
process on the same partition and a test with one writing dd process.
All partitions where ext3, mounted with relatime and data=ordered. The
partition for the writing processes was formated before every test.

My real installation does not show such a clearly improvement or even a
regression compared to kernel 29, but I just started to use it and it's
an installation on a full encrypted lvm drive.

I am not sure, if it's really the source of the problem or it's a lucky
state, which let's the problem disappear for my machine on my test
installation. I doubt the seconds case. I don't known how to prove it
reliable. I have tried the AS with the kernel 30 with smp support too,
and there seems to be an improvement too. The startup times are in some
cases better and in some cases worse, but I didn't have any desktop
freezes at all. 

Thank you all for your work, the results are impressive.


Best regard,

Thomas Pilarski

