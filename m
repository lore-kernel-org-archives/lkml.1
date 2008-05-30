Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbYE3QEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbYE3QEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYE3QEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:04:37 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:50921 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbYE3QEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:04:36 -0400
X-BigFish: VPS-39(zz1418M1432R98dR7efV1805M7cf0izz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K1OV9D-03-RWM-01
Date: Fri, 30 May 2008 10:05:05 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: David Brigada <brigad@rpi.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Wim Van Sebroeck <wim@iguana.be>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Samuel Tardieu <sam@rfc1149.net>,
       Mike Frysinger <vapier.adi@gmail.com>, Mingarelli@infomag.amd.com
Subject: Re: drivers/watchdog/geodewdt.c: build fix
Message-ID: <20080530160505.GA12722@cosmic.amd.com>
References: <20080525100944.GA4084@infomag.infomag.iguana.be> <20080530150250.GA21945@elte.hu> <20080530153919.GC12123@cosmic.amd.com> <48402334.3000809@rpi.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48402334.3000809@rpi.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 30 May 2008 16:03:17.0718 (UTC) FILETIME=[AC8D1F60:01C8C26E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/08 11:54 -0400, David Brigada wrote:
> I was trying to compile a kernel with this support, and noticed this bug, 
> too.  The interface was changed in commit 
> fa28e067c3b8af96c79c060e163b1387c172ae75, with the message:
>
> > We had planned to use the 'owner' field for allowing re-allocation of
> > MFGPTs; however, doing it by module owner name isn't flexible enough.  > 
> So, drop this for now.  If it turns out that we need timers in
> > modules, we'll need to come up with a scheme that matches the
> > write-once fields of the MFGPTx_SETUP register, and drops ponies from > 
> the sky.
>
> I may be reading this incorrectly, but it seems that to do this correctly, 
> we would either need to drop module support for this driver or rework the 
> MFGPT code.  I'm not sure there's a kernel hook for dropping ponies from 
> the sky quite yet.

I think the hamster dropping code is queued for 2.6.27, so at least we're
up to mammals.

The story here is that in an unfortunate instance of bad planning the
MFGPT timers can only be configured once, so a module can't allocate a
timer at init and release it when it is done.  The original object of this
code was to try give the timer back to a module if it happened to go away
and come back, but that is clearly a more complex process then just simply
storing the module name, and this code fell into bitrot.

So its not so much that we need to drop module support, rather it needs to
be understood that if you remove and insert your module on a regular basis
you will run out of timers, and deprive others of the timers too. I think
that is a reasonable restriction to impose, given the limited usefulness 
of these timers for general purpose use.

Jordan

> Jordan Crouse wrote:
>> On 30/05/08 17:02 +0200, Ingo Molnar wrote:
>>> * Wim Van Sebroeck <wim@iguana.be> wrote:
>>>
>>>> Author: Jordan Crouse <jordan.crouse@amd.com>
>>>> Date:   Mon Jan 21 10:07:00 2008 -0700
>>>>
>>>>     [WATCHDOG] Add a watchdog driver based on the CS5535/CS5536 MFGPT 
>>>> timers
>>> -tip testing found the following build failure on latest -git:
>>>
>>>   drivers/watchdog/geodewdt.c: In function 'geodewdt_probe':
>>>   drivers/watchdog/geodewdt.c:225: error: too many arguments to function 
>>> 'geode_mfgpt_alloc_timer'
>>>   make[1]: *** [drivers/watchdog/geodewdt.o] Error 1
>>>   make: *** [drivers/watchdog/geodewdt.o] Error 2
>>>
>>> with this config:
>>>
>>>   http://redhat.com/~mingo/misc/config-Fri_May_30_15_19_52_CEST_2008.bad
>>>
>>> find the fix below.
>>>
>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> Acked-by: Jordan Crouse <jordan.crouse@amd.com>
>>> ---
>>>  drivers/watchdog/geodewdt.c |    3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> Index: tip/drivers/watchdog/geodewdt.c
>>> ===================================================================
>>> --- tip.orig/drivers/watchdog/geodewdt.c
>>> +++ tip/drivers/watchdog/geodewdt.c
>>> @@ -221,8 +221,7 @@ geodewdt_probe(struct platform_device *d
>>>  {
>>>  	int ret, timer;
>>>  -	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY,
>>> -					MFGPT_DOMAIN_WORKING, THIS_MODULE);
>>> +	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
>>>   	if (timer == -1) {
>>>  		printk(KERN_ERR "geodewdt:  No timers were available\n");
>>>
>
>

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

