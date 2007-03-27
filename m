Return-Path: <linux-kernel-owner+w=401wt.eu-S965292AbXC0HMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292AbXC0HMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965291AbXC0HMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:12:53 -0400
Received: from gw.goop.org ([64.81.55.164]:33115 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965292AbXC0HMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:12:51 -0400
Message-ID: <4608C3F5.1030106@goop.org>
Date: Tue, 27 Mar 2007 00:12:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Zachary Amsden <zach@vmware.com>, James Morris <jmorris@namei.org>,
       Dan Hecht <dhecht@vmware.com>, Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Prarit Bhargava <prarit@redhat.com>,
       Chris Lalancette <clalance@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>
Subject: Re: [patch 1/2] Ignore stolen time in the softlockup watchdog
References: <20070327053816.881735237@goop.org> <20070327054106.664262413@goop.org> <4608C121.4050309@cosmosbay.com>
In-Reply-To: <4608C121.4050309@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Jeremy Fitzhardinge a écrit :
>
>> +static DEFINE_PER_CPU(unsigned long long, touch_timestamp);
>
> ...
>
>>  void touch_softlockup_watchdog(void)
>>  {
>> -    __raw_get_cpu_var(touch_timestamp) = jiffies;
>> +    __raw_get_cpu_var(touch_timestamp) = sched_clock();
>>  }
>
> Not very clear if this is safe on 32bit, since this is not anymore
> atomic.

Hm, good point.  Don't think it matters very much.  These values are
per-cpu, and if an interrupt happens between the word updates and the
intermediate values causes a timeout, then it was pretty marginal
anyway.  I guess the worst case is if the low-word gets written first,
and it goes from a high value to low, then it could be sampled as if
time had gone back by up to ~4 seconds.

I'll give it another look.

    J
