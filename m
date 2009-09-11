Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZIKHjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZIKHjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZIKHjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:39:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50692 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbZIKHi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:38:59 -0400
Message-ID: <4AA9FE67.5000503@cn.fujitsu.com>
Date: Fri, 11 Sep 2009 15:38:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: peterz@infradead.org, rjw@sisk.pl, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] sched: fix cpu_down deadlock
References: <4AA0FEBF.7040104@gmail.com> <1252496510-11898-1-git-send-email-jirislaby@gmail.com> <4AA9E9B3.8060901@cn.fujitsu.com> <4AA9EE21.5040007@gmail.com>
In-Reply-To: <4AA9EE21.5040007@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 09/11/2009 08:09 AM, Lai Jiangshan wrote:
>> Does this bug occur when a cpu is being offlined or
>> when the system is being suspended?
>> Or Both?
> 
> Hi, I tried echo 0/1 > /sys/devices/system/cpu/cpu1/online in a loop,
> but it didn't trigger the bug. It happened only on suspend/resume cycle
> (in the end I found even swsusp in qemu suffers from this).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

OK, I knew where this bug is.

I thought the corresponding bit in cpu_active_mask is cleared before
_cpu_down(), but I missed the system-suspend path:disable_nonboot_cpus().

There is a bug in disable_nonboot_cpus() even if my patch is removed.

cpu_active_map is wrong during suspending.(scheduler system who uses
cpu_active_map are still working while suspending)

You need:

int disable_nonboot_cpus(void)
{
	....
	....

	/*
	 * You need adding 'set_cpu_active(cpu, false);' here
	 * to fix this bug and make my patch works well.
	 */
	error = _cpu_down(cpu, 1);

	....
	....
}

Lai.

