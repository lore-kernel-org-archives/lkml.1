Return-Path: <linux-kernel-owner+w=401wt.eu-S637731AbXECUc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637731AbXECUc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637745AbXECUc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:32:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S637734AbXECUcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:32:53 -0400
Message-ID: <463A468F.5010008@redhat.com>
Date: Thu, 03 May 2007 16:31:11 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] wrong usage of smp_processor_id()
References: <20070503200822.696754319@mvista.com>	 <463A421C.4080507@redhat.com> <1178223708.7997.0.camel@imap.mvista.com>
In-Reply-To: <1178223708.7997.0.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:

>>> Index: linux-2.6.21/kernel/latency_trace.c
>>> ===================================================================
>>> --- linux-2.6.21.orig/kernel/latency_trace.c
>>> +++ linux-2.6.21/kernel/latency_trace.c
>>> @@ -105,7 +105,7 @@ static inline int DEBUG_WARN_ON(int cond
>>>  #ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
>>>  # ifdef CONFIG_CRITICAL_PREEMPT_TIMING
>>>     static DEFINE_PER_CPU(int, trace_cpu_idle);
>>> -#  define irqs_off_preempt_count() (!__get_cpu_var(trace_cpu_idle) && preempt_count())
>>> +#  define irqs_off_preempt_count() (preempt_count() && !__get_cpu_var(trace_cpu_idle))
>>>  # else
>>>  #  define irqs_off_preempt_count() 0
>>>  # endif


> Isn't it a generic problem? It doesn't look specific to your change
> unless you made some changes to entry.S .
> 

See: http://lkml.org/lkml/2007/4/23/183

Specifically:


  #ifdef CONFIG_CRITICAL_IRQSOFF_TIMING
  # ifdef CONFIG_CRITICAL_PREEMPT_TIMING
-#  define irqs_off_preempt_count() preempt_count()
+   static DEFINE_PER_CPU(int, trace_cpu_idle);
+#  define irqs_off_preempt_count() (!__get_cpu_var(trace_cpu_idle) && 
preempt_count())
  # else
  #  define irqs_off_preempt_count() 0
  # endif
@@ -2153,6 +2154,20 @@ void notrace unmask_preempt_count(unsign
  }
  EXPORT_SYMBOL(unmask_preempt_count);


-- Steve
