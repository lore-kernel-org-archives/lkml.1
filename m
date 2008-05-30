Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbYE3RZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbYE3RZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 13:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYE3RZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 13:25:25 -0400
Received: from smtp7.server.rpi.edu ([128.113.2.227]:58545 "EHLO
	smtp7.server.rpi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbYE3RZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 13:25:24 -0400
X-Greylist: delayed 5386 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 13:25:24 EDT
Message-ID: <48402334.3000809@rpi.edu>
Date: Fri, 30 May 2008 11:54:28 -0400
From: David Brigada <brigad@rpi.edu>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Wim Van Sebroeck <wim@iguana.be>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Samuel Tardieu <sam@rfc1149.net>,
       Mike Frysinger <vapier.adi@gmail.com>, Mingarelli@infomag
Subject: Re: drivers/watchdog/geodewdt.c: build fix
References: <20080525100944.GA4084@infomag.infomag.iguana.be> <20080530150250.GA21945@elte.hu> <20080530153919.GC12123@cosmic.amd.com> (sfid-20080530_164416_506376_742BDB7D)
In-Reply-To: <20080530153919.GC12123@cosmic.amd.com> (sfid-20080530_164416_506376_742BDB7D)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-RPI-SA-Score: undef - spam scanning disabled
X-CanItPRO-Stream: default
X-Canit-Stats-ID: Bayes signature not available
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to compile a kernel with this support, and noticed this 
bug, too.  The interface was changed in commit 
fa28e067c3b8af96c79c060e163b1387c172ae75, with the message:

 > We had planned to use the 'owner' field for allowing re-allocation of
 > MFGPTs; however, doing it by module owner name isn't flexible enough. 
  > So, drop this for now.  If it turns out that we need timers in
 > modules, we'll need to come up with a scheme that matches the
 > write-once fields of the MFGPTx_SETUP register, and drops ponies from 
 > the sky.

I may be reading this incorrectly, but it seems that to do this 
correctly, we would either need to drop module support for this driver 
or rework the MFGPT code.  I'm not sure there's a kernel hook for 
dropping ponies from the sky quite yet.

Thanks,
David Brigada

Jordan Crouse wrote:
> On 30/05/08 17:02 +0200, Ingo Molnar wrote:
>> * Wim Van Sebroeck <wim@iguana.be> wrote:
>>
>>> Author: Jordan Crouse <jordan.crouse@amd.com>
>>> Date:   Mon Jan 21 10:07:00 2008 -0700
>>>
>>>     [WATCHDOG] Add a watchdog driver based on the CS5535/CS5536 MFGPT timers
>> -tip testing found the following build failure on latest -git:
>>
>>   drivers/watchdog/geodewdt.c: In function 'geodewdt_probe':
>>   drivers/watchdog/geodewdt.c:225: error: too many arguments to function 'geode_mfgpt_alloc_timer'
>>   make[1]: *** [drivers/watchdog/geodewdt.o] Error 1
>>   make: *** [drivers/watchdog/geodewdt.o] Error 2
>>
>> with this config:
>>
>>   http://redhat.com/~mingo/misc/config-Fri_May_30_15_19_52_CEST_2008.bad
>>
>> find the fix below.
>>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: Jordan Crouse <jordan.crouse@amd.com>
> 
>> ---
>>  drivers/watchdog/geodewdt.c |    3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> Index: tip/drivers/watchdog/geodewdt.c
>> ===================================================================
>> --- tip.orig/drivers/watchdog/geodewdt.c
>> +++ tip/drivers/watchdog/geodewdt.c
>> @@ -221,8 +221,7 @@ geodewdt_probe(struct platform_device *d
>>  {
>>  	int ret, timer;
>>  
>> -	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY,
>> -					MFGPT_DOMAIN_WORKING, THIS_MODULE);
>> +	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
>>  
>>  	if (timer == -1) {
>>  		printk(KERN_ERR "geodewdt:  No timers were available\n");
>>
> 

