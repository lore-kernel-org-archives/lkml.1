Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYH0VGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYH0VGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYH0VGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:06:45 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:63578 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYH0VGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:06:44 -0400
Message-ID: <48B5C171.2000301@hypersurf.com>
Date: Wed, 27 Aug 2008 14:04:49 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Add cpufreq driver for the IBM PowerPC 750GX
References: <48B28F23.1000906@hypersurf.com> <200808261329.22699.arnd@arndb.de> <48B51A31.8090909@hypersurf.com> <200808271334.16712.arnd@arndb.de>
In-Reply-To: <200808271334.16712.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 27 August 2008, Kevin Diggs wrote:
> 
>>Arnd Bergmann wrote:
> 
> 
>>>Ok, thanks for the explanation. I now saw that you also
>>>use '_v' for variables (I guess). These should probably
>>>go the same way.
>>>
>>
>>Actually the _v means global variable. I would prefer to keep it.
> 
> 
> The reasoning on Linux is that you can tell from the declaration
> whether something is global or automatic. In fact, functions should
> be so short that you can always see all automatic declarations
> when you look at some code.
> 
> If you use nonstandard variable naming, people will never stop
> asking you about that, so it's easier to just to the same as
> everyone else.
>  
> 
>>>Then at least for the first two, the common coding style would
>>>be to leave out the '= 0'. For minmaxmode, the most expressive
>>>way would be to define an enum, like
>>>
>>>enum {
>>>	MODE_NORMAL,
>>>	MODE_MINMAX,
>>>};
>>>
>>>int minmaxmode = MODE_NORMAL;
>>>
>>
>>Since this is a boolean parameter I don't know? What if I change the
>>name to enable_minmax. And actually use the "bool" module parameter
>>type?
> 
> 
> Module parameter names should be short, so just "minmax" would
> be a good name, but better put the module_param() line right
> after that. If it's a bool type, I would just leave out the
> initialization.
> 
> 
>>>>..._min_max_mode is a boolean to hold the state of
>>>>minmaxmode. Seems to be only used to print the current
>>>>value.
>>>
>>>
>>>this looks like a duplicate then. why would you need both?
>>>It seems really confusing to have both a cpufreq attribute
>>>and a module attribute with the same name, writing to
>>>different variables. 
>>>
>>
>>I probably don't need both? I kinda treat the variables tied to module
>>parameters as read only.
> 
> 
> But you have marked as read/write in the module_param line.
> 
> I would prefer to just have the module parameter and have
> a tool to modify that one.
> 
> If a module parameter only makes sense as read-only, you
> should mark it as 0444 instead of 0644, but this one looks
> like it can be writable.
> 
> 
>>>Are there even SMP boards based on a 750? I thought only 74xx
>>>and 603/604 were SMP capable.
>>>
>>
>>Not that I have heard of. I thought it was lacking some hardware that
>>was needed to do SMP? Can the 603 do SMP?
> 
> 
> No, I was wrong about the 603. The machine I was thinking of is actually
> 604e.
> 
> 
>>>The completion would certainly be better than the sleep here, but
>>>I think you shouldn't need that in the first place. AFAICT, you
>>>have three different kinds of events that you need to protect
>>>against, when some other code can call into your module:
>>>
>>>1. timer function,
>>>2. cpufreq notifier, and
>>>3. sysfs attribute.
>>>
>>>In each case, the problem is a race between two threads that you
>>>need to close. In case of the timer, you need to call del_timer_sync
>>>because the timers already have this method builtin. For the other
>>>two, you already unregister the interfaces, which ought to be enough.
>>>
>>
>>The choice I made here was to wait for the timer to fire rather than
>>to delete it. I think it is easier to just wait for it than to delete
>>it and try to get things back in order. Though since this is in a
>>module exit routine it probably does not matter. Also I would have to
>>check whether there was an analogous HRTimer call and call the right
>>one.
> 
> 
> I think the module_exit() function should leave the frequency in a
> well-defined state, so the easiest way to get there is probably
> to delete the timer, and then manually set the frequency.
> 
> 	Arnd <><
> 
> 

