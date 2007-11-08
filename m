Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbXKHSI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbXKHSI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761140AbXKHSIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:08:50 -0500
Received: from mga06.intel.com ([134.134.136.21]:23310 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760662AbXKHSIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:08:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,390,1188802800"; 
   d="scan'208";a="266114649"
Date: Thu, 8 Nov 2007 10:07:39 -0800
From: Mark Gross <mgross@linux.intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 breaks C-state support on Intel T7200 x86_64
Message-ID: <20071108180739.GA5062@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <3624.1194542384@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3624.1194542384@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 12:19:44PM -0500, Valdis.Kletnieks@vt.edu wrote:
> (Sorry for not reporting this sooner - I haven't been running off battery
> much in the last 3 weeks, so I didn't notice it till now...)
> 
> Dell Latitude D820 laptop, T7200 Core2 Duo CPU, x86_64 kernel.
> 
> As reported by 'powertop' on a basically idle machine:
> 
> 2.6.23-mm1:
> 
> Cn                Avg residency       P-states (frequencies)
> C0 (cpu running)        (100.0%)        2.00 Ghz     0.8%
> C1                0.0ms ( 0.0%)         1.67 Ghz     0.0%
> C2                0.0ms ( 0.0%)         1333 Mhz     0.0%
> C3                0.0ms ( 0.0%)         1000 Mhz    99.2%
> 
> 2.6.23-rc8-mm2:
> 
> Cn                Avg residency       P-states (frequencies)
> C0 (cpu running)        ( 0.3%)         2.00 Ghz     0.0%
> C1                0.0ms ( 0.0%)         1.67 Ghz     0.0%
> C2                0.0ms ( 0.0%)         1333 Mhz     0.0%
> C3               31.5ms (99.7%)         1000 Mhz   100.0%
> 
> In addition, the ACPI power estimate reported about 25 watts for 23-mm1,
> but only 21 watts for -rc8-mm2, a significant regression.

well, thats because you burn less watts if you get into C3.  

> 
> I bisected this down to this set of patches:
> 
> pm-qos-infrastructure-and-interface.patch
> pm-qos-infrastructure-and-interface-fix.patch
> pm-qos-infrastructure-and-interface-vs-git-acpi.patch
> pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
> latencyc-use-qos-infrastructure.patch

yipes!  I'll look at it right away.  It looks like an integration issue
with CPU-IDLE patches (those control the C-state entry).  I'll get it
fixed up.

> 
> The patch says:
> 
>   To register the default pm_qos target for the specific parameter, the
>   process must open one of /dev/[cpu_dma_latency, network_latency,
>   network_throughput]
> 
>   As long as the device node is held open that process has a registered
>   requirement on the parameter.  The name of the requirement is
>   "process_<PID>" derived from the current->pid from within the open system
>   call.
> 
> I shouldn't have to have a process open a /dev/file, write a number, and then
> stay around forever so the file doesn't close in order to get the same behavior
> I was getting by default before.  What needs to happen to get this to not
> be a behavior regression/change?
>
you won't have such a process (at least I highly doubt you do)  I need
to fix this.  Thanks for taking the time to bisect it and reporting it to me!

--mgross
