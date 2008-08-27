Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYH0JOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYH0JOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYH0JOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:14:24 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:60227 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYH0JOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:14:23 -0400
Message-ID: <48B51A31.8090909@hypersurf.com>
Date: Wed, 27 Aug 2008 02:11:13 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Add cpufreq driver for the IBM PowerPC 750GX
References: <48B28F23.1000906@hypersurf.com> <200808251343.18027.arnd@arndb.de> <48B354FC.1090001@hypersurf.com> <200808261329.22699.arnd@arndb.de>
In-Reply-To: <200808261329.22699.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 26 August 2008, Kevin Diggs wrote:
> 
>>Arnd Bergmann wrote:
>>
>>>On Monday 25 August 2008, Kevin Diggs wrote:
> 
> 
>>>Most people list their email address here as well
>>>
>>
>>For reasons I'd rather not go into, my email address is not likely
>>to remain valid for much longer.
> 
> 
> Maybe you should get a freemail account somewhere then.
> It's better if people have a way to Cc the author of
> a file when they make changes to it.
> 
That won't really help either.
> 
>>>drop the _t here, or make explicit what is meant by it.
>>>
>>
>>Now that I look at it the _t is supposed to be at the end. It is
>>meant to indicate that this is a structure tag or type. I'll
>>remove it.
> 
> 
> Ok, thanks for the explanation. I now saw that you also
> use '_v' for variables (I guess). These should probably
> go the same way.
> 
Actually the _v means global variable. I would prefer to keep it.
> 
>>>>+static DECLARE_COMPLETION(cf750gx_v_exit_completion);
>>>>+
>>>>+static unsigned int override_min_core = 0;
>>>>+static unsigned int override_max_core = 0;
>>>>+static unsigned int minmaxmode = 0;
>>>>+
>>>>+static unsigned int cf750gx_v_min_core = 0;
>>>>+static unsigned int cf750gx_v_max_core = 0;
>>>>+static int cf750gx_v_idle_pll_off = 0;
>>>>+static int cf750gx_v_min_max_mode = 0;
>>>>+static unsigned long cf750gx_v_state_bits = 0;
>>>
>>>
>>>Is 0 a meaningful value for these? If it just means 'uninitialized',
>>>then better don't initialize them in the first place, for clarity.
>>>
>>
>>The first 3 are module parameters. For the first 2, 0 means
>>that they were not set. minmaxmode is a boolean. 0 is the
>>default of disabled.
> 
> 
> Then at least for the first two, the common coding style would
> be to leave out the '= 0'. For minmaxmode, the most expressive
> way would be to define an enum, like
> 
> enum {
> 	MODE_NORMAL,
> 	MODE_MINMAX,
> };
> 
> int minmaxmode = MODE_NORMAL;
> 
Since this is a boolean parameter I don't know? What if I change the
name to enable_minmax. And actually use the "bool" module parameter
type?
> 
>>..._min_max_mode is a boolean to hold the state of
>>minmaxmode. Seems to be only used to print the current
>>value.
> 
> 
> this looks like a duplicate then. why would you need both?
> It seems really confusing to have both a cpufreq attribute
> and a module attribute with the same name, writing to
> different variables. 
> 
I probably don't need both? I kinda treat the variables tied to module
parameters as read only.
> 
> Are there even SMP boards based on a 750? I thought only 74xx
> and 603/604 were SMP capable.
> 
Not that I have heard of. I thought it was lacking some hardware that
was needed to do SMP? Can the 603 do SMP?
> 
>>>>+static int cf750gx_pll_switch_cb(struct notifier_block *nb, unsigned long
>>>>+       action, void *data)
>>>>+{
>>>>+struct cf750gx_t_call_data *cd;
>>>>+unsigned int idle_pll;
>>>>+unsigned int pll_off_cmd;
>>>>+unsigned int new_pll;
>>>
>>>
>>>The whitespace appears damaged here.
>>>
>>
>>Just a coding style thing. I put declarations (or definitions -
>>I get the two confused?) on the same indent as the block they are
>>in. Is this a 15 yard illegal procedure penalty?
> 
> 
> I've never seen that style before. Better do what everyone
> else does here, e.g. using 'indent -kr -i8'.
> 
Ok, I'll fix this.
> 
>>>>+       dprintk(__FILE__">%s()-%d:  Modifying PLL:  0x%x\n", __func__, __LINE__,
>>>>+               new_pll);
>>>
>>>
>>>Please go through all your dprintk and see if you really really need all of them.
>>>Usually they are useful while you are doing the initial code, but only get in the
>>>way as soon as it starts working.
>>>
>>
>>This from a code readability standpoint? Or an efficiency one?
>>I think the cpufreq stuff has a debug configure option that
>>disables compilation of these unless enabled.
> 
> 
> It's more about readability.
> 
I removed a few. Let me know if I should whack some more (and which ones).
> 
>>>>+       result = pllif_register_pll_switch_cb(&cf750gx_v_pll_switch_nb);
>>>>+
>>>>+       cf750gx_v_pll_lock_nb.notifier_call = cf750gx_pll_lock_cb;
>>>>+       cf750gx_v_pll_lock_nb.next =
>>>>+               (struct notifier_block *)&cf750gx_v_lock_call_data;
>>>
>>>
>>>These casts look wrong, cf750gx_v_lock_call_data is not a notifier_block.
>>>What are you trying to do here?
>>>
>>
>>Just a little sneaky. I should document in the kernel doc though.
> 
> 
> No, better avoid such hacks instead of documenting them. I think I
> now understand what you do there, and if I got it right, you should
> just pass two arguments to pllif_register_pll_switch_cb.
> 
I'll fix this.
> 
>>>>+static int cf750gx_cpu_exit(struct cpufreq_policy *policy)
>>>>+{
>>>>+       dprintk("%s()\n", __func__);
>>>>+
>>>>+       /*
>>>>+        * Wait for any active requests to ripple through before exiting
>>>>+        */
>>>>+       wait_for_completion(&cf750gx_v_exit_completion);
>>>
>>>
>>>This "wait for anything" use of wait_for_completion looks wrong, 
>>>because once any other function has done the 'complete', you won't
>>>wait here any more.
>>>
>>>What exactly are you trying to accomplish with this?
>>>
>>
>>Originall I had something like:
>>
>>	while(some_bit_is_still_set)
>>		sleep
>>
>>I think you suggested I use a completion because it is in
>>fact simpler than a sleep. Now that I think about it also seems
>>intuitive to give the system a hint as to when something will
>>be done. 'complete' just means there is no timer pending (unless,
>>of course, I screwed up the code).
> 
> 
> The completion would certainly be better than the sleep here, but
> I think you shouldn't need that in the first place. AFAICT, you
> have three different kinds of events that you need to protect
> against, when some other code can call into your module:
> 
> 1. timer function,
> 2. cpufreq notifier, and
> 3. sysfs attribute.
> 
> In each case, the problem is a race between two threads that you
> need to close. In case of the timer, you need to call del_timer_sync
> because the timers already have this method builtin. For the other
> two, you already unregister the interfaces, which ought to be enough.
> 
The choice I made here was to wait for the timer to fire rather than
to delete it. I think it is easier to just wait for it than to delete
it and try to get things back in order. Though since this is in a
module exit routine it probably does not matter. Also I would have to
check whether there was an analogous HRTimer call and call the right
one.
> 
> 	Arnd <><
> 

