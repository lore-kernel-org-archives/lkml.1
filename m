Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbZD1XgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbZD1XgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZD1Xfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:35:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198AbZD1Xfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:35:51 -0400
Date: Tue, 28 Apr 2009 16:30:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Gallatin <gallatin@myri.com>
Cc: linux-kernel@vger.kernel.org, rick.jones2@hp.com, brice@myri.com,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: IRQ / SoftIRQ CPU time accounting broken by
 457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4
Message-Id: <20090428163004.46733752.akpm@linux-foundation.org>
In-Reply-To: <49F078FA.6010507@myri.com>
References: <49F078FA.6010507@myri.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Thu, 23 Apr 2009 10:19:38 -0400
Andrew Gallatin <gallatin@myri.com> wrote:

> When running netperf for some 10GbE tests, I noticed
> that  IRQ and SOFTIRQ CPU time is no longer reported for an
> otherwise idle CPU on recent kernels, at least for x86_64.
> 
> If I take a 2-CPU system, and bind the NIC IRQ to CPU0, and
> bind the user-space netserver daemon to CPU1, the problem
> is obvious when blasting 10Gb/s of traffic at it.  I see
> no CPU used for irq or softirq on CPU0, even though it is
> handling 13K interrupts/sec:
> 
> 
> 
> % mpstat -P 0 1
> Linux 2.6.30-rc1 (venice)       04/22/09
> 
> 11:25:25     CPU   %user   %nice %system %iowait    %irq   %soft   %idle 
>     intr/s
> 11:25:26       0    0.00    0.00    0.00    0.00    0.00    0.00  100.00 
>   13248.00
> 11:25:27       0    0.00    0.00    0.00    0.00    0.00    0.00  100.00 
>   13280.00
> 
> Common sense tells me that is wrong, and oprofile verifies there is
> a lot happening on CPU0.  Further, when I run a cpu-soaker in
> usermode bound to CPU0, I start to see irq, softirq, etc,
> being correctly identified:
> 
> 11:28:02     CPU   %user   %nice %system %iowait    %irq   %soft   %idle 
>     intr/s
> 11:28:03       0   45.10    0.00    0.00    0.00    1.96   52.94    0.00 
>   13019.61
> 11:28:04       0   46.46    0.00    0.00    0.00    2.02   51.52    0.00 
>   13414.14
> 
> The problem is observable, but much less obvious when using a more
> common, e1000 1GbE NIC (15% softirq is missing, rather than 50%).
> 
> I spent a few hours git-bisecting until I finally got here:
> 
> % git-bisect bad
> Bisecting: 0 revisions left to test after this
> [457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4] fix scaled & unscaled cputime 
> accounting
> 
> I have neither CONFIG_NO_HZ, CONFIG_VIRT_CPU_ACCOUNTING, or XEN configured.
> 

Thanks for doing the bisection.

457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4 was merged late last year, so
this regression has been around for a while.

We might have fixed it in more recent kernels - stranger things have
happened ;)

