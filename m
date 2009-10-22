Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbZJVNDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbZJVNDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbZJVNDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:03:10 -0400
Received: from kuber.nabble.com ([216.139.236.158]:35552 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbZJVNDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:03:09 -0400
Message-ID: <26009516.post@talk.nabble.com>
Date: Thu, 22 Oct 2009 06:03:13 -0700 (PDT)
From: pajko <kpajko79@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v4 2/9] MIPS: add mips_timecounter_read() to get high
 precision timestamp
In-Reply-To: <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: kpajko79@gmail.com
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com> <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Wu Zhangjin wrote:
> 
> This patch implement a mips_timecounter_read(), which can be used to get
> high precision timestamp without extra lock.
> 
> It is based on the clock counter register and the
> timecounter/cyclecounter abstraction layer of kernel.
> 
> 

I don't like this. I think MIPS should have a custom sched_clock()
- which ftrace would use without any extra magic -, instead of the
default jiffies-based one. It's true that the 32-bit C0 counter is too
small, but I've successfully extended it in software by having a word
in memory for the upper part of a 64-bit counter and
incrementing it every time C0 rolls over. My code is ugly and maybe 
is racy, but works on our system.
Yesterday during getting that in shape I've found about that the
kernel even has a mechanism for that what I wanted to implement.

See here:
http://lxr.linux.no/#linux+v2.6.31/include/linux/cnt32_to_63.h#L34

And for a correct application of it:
http://lxr.linux.no/#linux+v2.6.31/arch/arm/plat-orion/time.c#L45

Next week I'll knock up something based on that and submit it for
review.

In my custom code (full 64-bit counter, not a 63-bit one like above)
I've set the scale factor to 15 for our system (Au1250 clocked at 756 MHz),
so
sched_clock() wraps around about every 6.2 days, and the upper word has
to be warmed up about every 5 sec. Numbers will be different for the code
using cnt32_to_63.h.

Regards,
Patrik

-- 
View this message in context: http://www.nabble.com/-PATCH--v4-1-9--tracing%3A-convert-trace_clock_local%28%29-as-weak-function-tp25993719p26009516.html
Sent from the linux-kernel mailing list archive at Nabble.com.

