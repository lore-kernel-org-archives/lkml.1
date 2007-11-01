Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbXKASBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbXKASBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbXKASBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:01:10 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:57383 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbXKASBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:01:08 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 14:01:08 EDT
X-IronPort-AV: E=Sophos;i="4.21,359,1188802800"; 
   d="scan'208";a="412521005"
Message-ID: <472A1222.70103@cisco.com>
Date: Thu, 01 Nov 2007 10:51:30 -0700
From: bc Wong <bcwong@cisco.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: filp usage when cpu busy
References: <47293248.9000906@cisco.com> <200711011505.15751.nickpiggin@yahoo.com.au>
In-Reply-To: <200711011505.15751.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2007 17:51:34.0557 (UTC) FILETIME=[D7CED4D0:01C81CAF]
Authentication-Results: sj-dkim-3; header.From=bcwong@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thursday 01 November 2007 12:56, bc Wong (chimwong) wrote:
>> Hi,
>>
>> With 2.6.16 x86_64 on a 4 core machine, I noticed
>> that the filp usage (according to /proc/slabinfo)
>> shoots up and keeps on increasing sharply when one
>> of the CPUs is (1) locked up, or (2) very busy
>> doing a lot of printk()'s with KERN_EMERG.
>>
>> In the case of (1), it's permanent until it runs
>> out of memory eventually. For (2), it's temporary;
>> filp count comes back down when the printk()'s are
>> done.
>>
>> I can't think of any relationship between a busy/
>> locked-up CPU and filp count. The system is still
>> functional. New short-lived processes kept being
>> created, but the overall number of processes is
>> stable.
>>
>> Does anyone know why filp count would go up like
>> that?
> 
> Yeah, it's probably because filp structures are freed by
> RCU, and if you have a locked up CPU then it can't go
> through a quiescent state so RCU stops freeing your filps.
> 
> If you add some cond_resched()s to your code, you should
> find that RCU will force a reschedule and things will work
> (actually, for 2.6.16, I'm not sure if RCU had the code to
> force a reschedule... it's force_quiescent_state() in
> kernel/rcupdate.c upstream).

Thanks! You're absolutely right. Btw, 2.6.16 does
have force_quiescent_state().

Cheers,
bc
