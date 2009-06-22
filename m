Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZFVGnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZFVGnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZFVGnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:43:35 -0400
Received: from mga07.intel.com ([143.182.124.22]:9969 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752294AbZFVGne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:43:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,266,1243839600"; 
   d="scan'208";a="157018462"
Message-ID: <4A3F2816.7040103@linux.intel.com>
Date: Mon, 22 Jun 2009 08:43:34 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to 	disk, mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>	 <4A3E7F38.7030300@linux.intel.com> <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com> <4A3EE668.5090400@jp.fujitsu.com>
In-Reply-To: <4A3EE668.5090400@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Maciej Rutecki wrote:
>>> Also a "a few minutes" suggest something might be going wrong
>>> with the poll handler.  Does the problem still happen
>>> with you use CONFIG_X86_NEW_MCE again, but before
>>> resume do
>>>
>>> echo 0 > /sys/device/system/machinecheck/machinecheck0/check_interval
>>>
>>> On the other hand you should get a crash very fast with
>>>
>>> echo 1 > /sys/device/system/machinecheck/machinecheck0/check_interval
>> I didn't instructions from above, but I found something else. After
>> normal boot I try:
>>
>> echo 1 > /sys/devices/system/machinecheck/machinecheck0/check_interval
>>
>> I I found this in dmesg:
>>
>> [  141.704025] ------------[ cut here ]------------
>> [  141.704039] WARNING: at arch/x86/kernel/cpu/mcheck/mce.c:1102
>> mcheck_timer+0xf5/0x100()
> 
> I see.  At least this warning will be cleared by following patch.
>   WARN_ON(smp_processor_id() != data);
> 
> But I'm not sure whether this can cause system hangs or not.

It might actually. If two different handlers run on the same CPU
they could re-add a timer twice, which might cause loops in the timer
list etc.

Maciej, can you test Seto-san's patch please?

BTW this is probably related to

commit eea08f32adb3f97553d49a4f79a119833036000a
Author: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Date:   Thu Apr 16 12:16:41 2009 +0530

     timers: Logic to move non pinned timers

it might be also useful to test if reverting that patch makes
the problem go away. But with this patch we need the add_timer_on change.

-Andi
