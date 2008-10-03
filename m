Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbYJCNVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbYJCNVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 09:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbYJCNVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 09:21:24 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:45839 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbYJCNVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 09:21:23 -0400
Date: Fri, 3 Oct 2008 15:21:17 +0200
From: Jan Kasprzak <kas@fi.muni.cz>
To: arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: IRQ balancing on a router
Message-ID: <20081003132117.GM16624@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
X-Muni-Spam-TestIP: 147.251.48.3
X-Muni-Envelope-From: kas@fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 03 Oct 2008 15:21:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

I have a dual-CPU router/firewall with five gigabit NICs. Recently I have
found that irqbalance (0.55 from Fedora 9/x86_64) gives a suboptimal
IRQ to CPU mapping on this box:

	During traffic spikes, it assings two NICs to one CPU, and the
other three to the second CPU. However, this does not account for
the fact that packets coming from the uplink interface are way more
expensive to handle than the rest of the traffic: most iptables rules
apply to the packets received from the uplink interface. The result is
that the CPU which receives IRQs for the uplink interface
is 100 % busy (softirq mostly), while the other one is 90% idle.

	Setting the IRQ mapping by hand (uplink to one CPU, all the other
NICs to the other CPU) makes a well balanced system (both CPUs 30-60 % busy).
I am not sure whether my configuration is too special, but it might be
worth trying to make irqbalance daemon cope also with this usage pattern.

	Another problem is that with one CPU 100 % busy in the kernel
the system latency of user-space programs is _way_ too high. For example,
MRTG graphs from my router used to have blank stripes (i.e.  snmpd
has failed to respond in time). Also the shell response time was bad,
even though I was logged in using SSH over the interface, which at that
time had its IRQ routed to the other CPU.

	With the same network load and manual IRQ to CPU assignment,
MRTG works well and both snmpd and shell response time is good.

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>>  If you find yourself arguing with Alan Cox, you’re _probably_ wrong.  <<
>>     --James Morris in "How and Why You Should Become a Kernel Hacker"  <<
