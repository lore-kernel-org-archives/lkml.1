Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYBIRKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYBIRKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYBIRKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:10:14 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:29690 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbYBIRKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:10:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=MRamJmBUU4V97X7PfhNHKANu83jVNgLKOPuwAr7btzWPifjU6dyxlOX7ZbHCucaetotAkJvit1hVIQfgcIkZra9jUwkQqzlvaxeunMql3oPaFtmlZmJSRQXL90OifpZxntXkLQPqQxP7QlVeU9GalyDjGFecK0ng50tGi0K57X8=
Message-ID: <5a4c581d0802090910k5e7d44a5x31e80bc3d82dde18@mail.gmail.com>
Date: Sat, 9 Feb 2008 18:10:09 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-git2: Oracle 11g VKTM process enters R state on startup and is unkillable
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally had a bit of time to try out different kernel versions to find
 out where this began... and it's in 2.6.24-git2.

What happens: Oracle 11g starts up and forks a number of so
 called background processes. Starting in  2.6.24-git2 the VKTM
 process never fully completes its initialization but gets in R state,
 never accumulating CPU, and can't be straced/gdb'd/killed.

Sysrq-T reports for VKTM looks like this

Feb  9 16:10:46 sandman kernel:  =======================
Feb  9 16:10:46 sandman kernel: oracle        R running   2684  2258      1
Feb  9 16:10:46 sandman kernel:        f591dfb0 00200086 f6bbc3c4
f6863cc0 c010547a 00000000 b794f62c b7b70600
Feb  9 16:10:46 sandman kernel:        b79453dc f591d000 c0103caa
b794f62c b7943708 b79453e4 b7b70600 b79453dc
Feb  9 16:10:46 sandman kernel:        bfb0dd5c b79500b0 0000007b
0000007b c0320000 ffffffff 0e072d7a 00000073
Feb  9 16:10:46 sandman kernel: Call Trace:
Feb  9 16:10:46 sandman kernel:  [<c010547a>] ? do_IRQ+0xac/0xc1
Feb  9 16:10:46 sandman kernel:  [<c0103caa>] work_resched+0x5/0x16
Feb  9 16:10:46 sandman kernel:  [<c0320000>] ? pci_setup+0xb3/0x104
Feb  9 16:10:46 sandman kernel:  =======================


2.6.24-git1 is okay
2.6.24-git2 is bad
...
2.6.24-git20 is bad

Only differences in kernel .config between -git1 and -git2 are

[asuardi@sandman src]$ diff .config-2.6.24-git[12]
3,4c3,4
< # Linux kernel version: 2.6.24-git1
< # Sat Jan 26 01:04:43 2008
---
> # Linux kernel version: 2.6.24-git2
> # Sat Jan 26 12:10:15 2008
121a122,123
> CONFIG_CLASSIC_RCU=y
> # CONFIG_PREEMPT_RCU is not set
187a190
> # CONFIG_RCU_TRACE is not set
230a234
> # CONFIG_SCHED_HRTICK is not set
755a760
> # CONFIG_PATA_NINJA32 is not set
1807a1813
> # CONFIG_LATENCYTOP is not set

Symptom is similar to what Rafael reported here

  http://www.ussg.iu.edu/hypermail/linux/kernel/0801.3/4114.html

 and similarly VKTM attempts to run at elevated priority as normal
 user process (Oracle kernel binary is not setuid root).


Peter Zijlstra's patches mentioned in the above thread, at

 http://programming.kicks-ass.net/kernel-patches/sched-rt-group ,

 do not appear to be in -git20 yet.


I'm available for further testing. Thanks, ciao,

--alessandro

 "We act as though comfort and luxury were the chief requirements
   of life, when all that we need to make us really happy is
   something to be enthusiastic about."

   (Charles Kingsley)
