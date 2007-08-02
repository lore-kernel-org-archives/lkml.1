Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbXHBHd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbXHBHd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 03:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXHBHdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 03:33:22 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:41301 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbXHBHdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 03:33:21 -0400
Message-ID: <46B1A51C.3040402@sw.ru>
Date: Thu, 02 Aug 2007 13:34:20 +0400
From: Vasily Averin <vvs@sw.ru>
Organization: SW-soft
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.10) Gecko/20070301 SUSE/1.8_seamonkey_1.0.8-0.1 SeaMonkey/1.0.8
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: broken timer on VIA K8T800 chipset?
References: <46AD57BF.8090106@sw.ru>	 <1f1b08da0707301113r173adba0yd2585263e89fd8@mail.gmail.com> <1f1b08da0707301807h62a24b3o786beed607ae5fcd@mail.gmail.com> <46AEBDDD.2020107@sw.ru>
In-Reply-To: <46AEBDDD.2020107@sw.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Averin wrote:
> john stultz wrote:
>> On 7/29/07, Vasily Averin <vvs@sw.ru> wrote:
>>> I've investigated why my testnode freezes. When I found that node is freezed
>>> again I've started to press Sysrq keys and noticed the following negative time jump.

I've found the reason of timer-related issue on the node.
I've noticed that number of timer interrupts is not changed (irq 0 in
/proc/interrupts). Timer interrupt is not works, jiffies is not not
incremented and timers cannot awake.

xtime and wall_to_monolitic are not changed, but ktime_get() returns
non-constant values because of __get_realtime_clock_ts corrects
nanoseconds. Correction vaule is different for various clocksourcses:
for "tsc" clocksource it is more noticeable (~4400 sec on my node).
Obviously for other clocksources correction value is not too big.

When correction value overflows we can observe negative time jump.

On the other hand timers are not critical for schedulers work, it uses
readtsc for timestaps and therefore node is not hangs completely.

However Now I have new question: why timer can hangs on VIA K8T800
chipset? How is possible to fix or at least workaround this issue?

I've try to disable irqbalance -- probably it will make the node more
stable.

thank you,
	Vasily Averin

