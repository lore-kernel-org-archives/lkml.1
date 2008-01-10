Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbYAJSvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbYAJSvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbYAJSvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:51:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:23350 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbYAJSvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:51:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="363671660"
Message-ID: <47866364.1010501@intel.com>
Date: Thu, 10 Jan 2008 10:26:44 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <478657C1.8040107@intel.com> <47865FFD.2010407@nortel.com>
In-Reply-To: <47865FFD.2010407@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jan 2008 18:27:31.0211 (UTC) FILETIME=[76309DB0:01C853B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Kok, Auke wrote:
> 
>> You're using 2.6.10... you can always replace the e1000 module with the
>> out-of-tree version from e1000.sf.net, this might help a bit - the
>> version in the
>> 2.6.10 kernel is very very old.
> 
> Do you have any reason to believe this would improve things?  It seems
> like the problem lies in the NAPI/softirq code rather than in the e1000
> driver itself, no?

your real issue is that your userspace app is hogging the CPU. While network is
not really cpu intensive, it does require that ample time at many intervals is
given to the CPU to run cleanups and prevent FIFO issues.

alternatively, you can increase your rx/tx ring descriptor count (with ethtool),
which basically makes it easier for the hardware not to be serviced for a longer
period, since there are more buffers available and the card can go longer on when
userspace is hogging the CPU.

>> it also appears that your app is eating up CPU time. perhaps setting
>> the app to a
>> nicer nice level might mitigate things a bit.
> 
> If we're not handling the softirq work from ksoftirqd how would changing
> scheduler settings affect anything?

correct, it might not.

>> Also turn off the in-kernel irq
>> mitigation, it just causes cache misses and you really need the
>> network irq to sit
>> on a single cpu at most (if not all) the time to get the best
>> performance. Use the
>> userspace irqbalance daemon instead to achieve this.
> 
> Using userspace irqbalance would be some effort to test and deploy
> properly.  However, as a quick test I tried setting the irq affinity for
> this device and it didn't help.

irqbalance is a simple userspace app that drops into any system seemlessly and
does the best job all around - often it beats manual tuning of smp_affinity even ;)

Auke
