Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbYENJKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbYENJKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 05:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYENJJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 05:09:59 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:7787 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYENJJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 05:09:59 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K0UPF4-02-6SL-01
Date: Wed, 14 May 2008 11:09:23 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
Message-ID: <20080514090923.GC5607@alberich.amd.com>
References: <20080513204206.GA17781@damson.getinternet.no> <20080514065605.GB21369@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514065605.GB21369@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 May 2008 09:08:56.0261 (UTC) FILETIME=[235BD750:01C8B5A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 08:56:05AM +0200, Ingo Molnar wrote:
> 
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
> > Hi,
> > 
> > Recap: powertop shows between 200-400 wakeups/second with the 
> > description "<kernel IPI>: Rescheduling interrupts" when all 
> > processors have load (e.g. I need to run two busy-loops on my 2-CPU 
> > system for this to show up).
> 
> ok, could you try the fix below? It was a mistake to make mwait use 
> dependent on power considerations - on a desktop CPU it is unlikely to 
> use more power than a simple HLT - and the IPIs are extra scheduling 
> latency and extra power used.

It depends on the CPU. For AMD CPUs that support MWAIT this is wrong.
Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings then
depend on a clock divisor and current Pstate of the core.

If all cores of a processor are in halt state (C1) the processor can
enter the C1E (C1 enhanced) state. If mwait is used this will never
happen.

Thus HLT saves more power than MWAIT here.

It might be best to switch off the mwait flag for these AMD CPU
families like it was introduced with commit
f039b754714a422959027cb18bb33760eb8153f0 (x86: Don't use MWAIT on AMD
Family 10)


Andreas


