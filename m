Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbYI1K7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbYI1K7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 06:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYI1K7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 06:59:39 -0400
Received: from www.tglx.de ([62.245.132.106]:37550 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbYI1K7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 06:59:38 -0400
Date: Sun, 28 Sep 2008 12:58:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jason Vas Dias <jason.vas.dias@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [Bug #11516] severe performance degradation on x86_64 going from
 2.6.26-rc9 -&gt; 2.6.27-rc5
In-Reply-To: <200809280138.57672.jason.vas.dias@gmail.com>
Message-ID: <alpine.LFD.1.10.0809281250270.27026@apollo.tec.linutronix.de>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik> <200809230549.28544.jason.vas.dias@gmail.com> <alpine.LFD.1.10.0809271104300.27026@apollo.tec.linutronix.de> <200809280138.57672.jason.vas.dias@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2008, Jason Vas Dias wrote:
> The problem is not "slow booting" - indeed, as noted in the bug, boot time up to the point
> where user space should start is very similar to the non-problematic 2.6.26 kernels.
> 
> The USB problem is that @ 10 messages per second are emitted to the log:
> Sep 28 00:41:51 localhost kernel: [   11.985257] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
> Sep 28 00:41:51 localhost kernel: [   12.789240] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
> Sep 28 00:41:51 localhost kernel: [   12.937169] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> Sep 28 00:41:51 localhost kernel: [   12.937188] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
> Sep 28 00:41:51 localhost kernel: [   13.041167] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
> Sep 28 00:41:51 localhost kernel: [   13.041186] hub 6-0:1.0: state 7 ports 10 chg 0000 evt 0000
> Sep 28 00:41:51 localhost kernel: [   13.453734] hub 6-0:1.0: state 7 ports 10 chg 0000 evt 0020
> Sep 28 00:41:51 localhost kernel: [   13.453748] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
> Sep 28 00:41:51 localhost kernel: [   13.846512] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
> Sep 28 00:41:51 localhost kernel: [   14.220994] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
> 
> Why should USB be emitting state change messages when no state has changed ?

That's a separate question.

> I think this is because the core PM-timer (clocksource is acpi-pm) is kaput ,
> and every driver that depends on high-resolution timers gets confused .

No, if the pmtimer would be defect your machine would not even reach
user space.

I analysed the proc/acpi data of .25 and .27 and the machine is set to
throttling state T7 (12%) which would explain that behaviour halfways.

Can you please verify if that state is always T7 on your machine with
.27 ?

Also please add "acpi.debug_level=0x11" to the kernel command line so
we can get some more information out of the ACPI code.

> Displaying text on the terminal is @ 140 times slower under 2.6.27
> kernels than under 2.6.26 kernels .  Downloads over the network take
> @ 1000 times longer under 2.6.27 than under 2.6.26.  Disk I/O is @
> 100 times slower.

That's indeed insane.
 
> There are numerous log messages about "interrupt during system call"
> (EINTR) from user-space processes.

Separate problem as well.

Please let us concentrate on the throttling aspect and not mix
USB/EINTR stuff into it for now.

Thanks,

	tglx
