Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbXCWCkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbXCWCkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 22:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXCWCkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 22:40:05 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:5134 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbXCWCkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 22:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WxHxnnihG+lqg4SAni/kkwHXL5hLBj3rQkpQSqMFfzE/tN03Quar+qDPa0VGJqV+qMtSEmPD1k6r5tHtNwQIX0fPbxbs4WLRvKJqFcDCFyKT8CX9kP21uE3jtaxskQccsEJ5Gm7l2mRBssZ1qXg9LIk8Q6aqrFPL0tZJC+tvenM=
Message-ID: <8cd998d50703221940naec0905y56ec708eb11b81a2@mail.gmail.com>
Date: Fri, 23 Mar 2007 13:40:03 +1100
From: "Con Kolivas" <ckolivas@gmail.com>
To: tim.c.chen@linux.intel.com
Subject: Re: RSDL 0.31 causes slowdown
Cc: ck@vds.kolivas.org, linux-kernel@vger.kernel.org, kernel@kolivas.org
In-Reply-To: <1174598506.23795.62.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174598506.23795.62.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/03/07, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> Con,
>
> I've tried running Volanomark and found a 80% regression
> with RSDL 0.31 scheduler on 2.6.21-rc4 on a 2 socket Core 2 quad cpu
> system (4 cpus per socket, 8 cpus for system).
>
> The results are sensitive to rr_interval. Using Con's patch to increase
> rr_interval to a large value of 100,
> the regression reduced to 30% instead of 80%.
>
> I ran Volanomark in loopback mode with 10 chatrooms
> (20 clients per chatroom) configuration, with each client sending
> out 10000 messages.
>
> http://www.volano.com/benchmarks.html
>
> There are significant differences in the vmstat runqueue profile
> between the 2.6.21-rc4 and the one with RSDL.
>
> There are a lot less runnable jobs (see col 2) with RSDL 0.31  (rr_interval=15)
> and higher idle time.

Thanks Tim.

Volanomark is a purely yield() semantic dependant workload (as
discussed many times previously). In the earlier form of RSDL I
softened the effect of sched_yield but other changes since then have
made that softness bordering on a noop. Obviously when sched_yield is
relied upon that will not be enough. Extending the rr interval simply
makes the yield slightly more effective and is not the proper
workaround. Since expiration of arrays is a regular frequent
occurrence in RSDL then changing yield semantics back to expiration
should cause a massive improvement in these values, without making the
yields as long as in mainline. It's impossible to know exactly what
the final result will be since java uses this timing sensitive yield
for locking but we can improve it drastically from this. I'll make a
patch soon to change yield again.

--
-ck
