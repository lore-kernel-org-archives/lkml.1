Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYG3SSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYG3SSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYG3SSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:18:35 -0400
Received: from mercury.realtime.net ([205.238.132.86]:38401 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753171AbYG3SSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:18:32 -0400
In-Reply-To: <20080730100701.GA3696@wavehammer.waldi.eu.org>
References: <20080730073438.GA29700@wavehammer.waldi.eu.org> <20080730062919.GA27281@wavehammer.waldi.eu.org> <200807300913.m6U9DluI040346@sullivan.realtime.net> <20080730100701.GA3696@wavehammer.waldi.eu.org>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <1c40eb67dca2b1ee99dc81a400464f87@bga.com>
Content-Transfer-Encoding: 7bit
Cc: ppcdev <linuxppc-dev@ozlabs.org>, Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bastian Blank <waldi@debian.org>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH] hvc - register all available consoles (was: Re: [PATCH] powerpc/lpar - defer prefered console setup)
Date: Wed, 30 Jul 2008 13:18:35 -0500
To: Bastian Blank <waldi@debian.org>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me, I'm not subscribed to the list.

On Wed Jul 30 at 20:07:01 EST in 2008, Bastian Blank wrote:
> On Wed, Jul 30, 2008 at 04:13:47AM -0500, Milton Miller wrote:
>> On Wed Jul 30 at 17:34:38 EST in 2008, Bastian Blank wrote:
>>> On Wed, Jul 30, 2008 at 08:29:19AM +0200, Bastian Blank wrote:
>>>> Okay, so hvc_console is the culprit. It don't register a preferred
>>>> console if it knows it is not the first in the list.
>>>
>>> The patch registers all available hvc consoles. It adds one "struct
>>> console" for all possible hvc consoles.
>>
>> [ a 6 page patch adding forward declartions, arrays of console
>> structs, moving lots of code and creating N struct console in the
>> hvc_driver shell]
>>
>> After previously having written:
>>> On Wed, Jul 30, 2008 at 08:23:13AM +0200, Bastian Blank wrote:
>>>> On Wed, Jul 30, 2008 at 12:34:51PM +1000, Michael Ellerman wrote:
>>>>> On Mon, 2008-07-28 at 20:56 +0200, Bastian Blank wrote:
>>>>>  * add_preferred_console - add a device to the list of preferred 
>>>>> consoles.
>>>>>  ...
>>>>>  * The last preferred console added will be used for kernel 
>>>>> messages
>>>>>  * and stdin/out/err for init.
>>>>>
>>>>> The last console will be added by the console= parsing, and so 
>>>>> that will
>>>>> be used. The console we add in the pseries setup is only used if 
>>>>> nothing
>>>>> is specified on the command line.
>>>>
>>>> Okay, then there is a completely different problem. In the case of
>>>> "console=hvc0 console=hvc1" it uses the _first_ add stdin/out bla 
>>>> and
>>>> ignores the second one completely.
>>>
>>> Okay, so hvc_console is the culprit. It don't register a preferred
>>> console if it knows it is not the first in the list.
>>>
>>> Bastian
>>
>>
>> [ back to the patch ]
>>> -/*
>>> - * Early console initialization.  Precedes driver initialization.
>>> - *
>>> - * (1) we are first, and the user specified another driver
>>> - * -- index will remain -1
>>> - * (2) we are first and the user specified no driver
>>> - * -- index will be set to 0, then we will fail setup.
>>> - * (3)  we are first and the user specified our driver
>>> - * -- index will be set to user specified driver, and we will fail
>>> - * (4) we are after driver, and this initcall will register us
>>> - * -- if the user didn't specify a driver then the console will 
>>> match
>>> - *
>>> - * Note that for cases 2 and 3, we will match later when the io 
>>> driver
>>> - * calls hvc_instantiate() and call register again.
>>> - */
>>> -static int __init hvc_console_init(void)
>>> -{
>>> -   register_console(&hvc_con_driver);
>>> -   return 0;
>>>
>>
>>
>> Please explain how the reasoning you removed breaks down.
>> What is your usage case?
>
> I have several hvc consoles on a Power hypervisor.

A pretty short description, lacking detail.

>
>> More importantly , how is this different than, say, 
>> drivers/serial/8250.c,
>> which also registers just one struct console?
>> would not console=ttyS0 console=ttyS1 have the same problem?
>
> Yes, it have the same problem. Only one of the two (I think the first)
> will get enabled as console.

So lets try to fix the generic code and not one driver.

>> Please instrument the calls to register_console and 
>> add_preferred_console
>> and give a detailed description of the problem you are encountering.
>
> | add_preferred_console("hvc", 4, NULL)
>
> This call was added recently by the Power LPAR code.

Not really, it was added in 2.6.16 in 2005 
(463ce0e103f419f51b1769111e73fe8bb305d0ec), but we recently stopped 
avoiding the call in your use case.  But the same issue would exist if 
the boot loader issued a console= then appended a user supplied 
console=, so lets try to fix the whole problem.

> | add_preferred_console("hvc", 1, NULL)
>
> This comes from the command line ("console=hvc1").

So this meets the assertion that the latter preferred console came from 
the command line, and the command line is supposed to get the last 
console registered.

> | hvc_config_driver.index == -1
> | register_console(&hvc_con_driver)
> | hvc_config_driver.index == 4

So you did not indicate which call site of register_console in the hvc 
driver was called.

When I broke it out the hvc_driver from its clients, there were two 
call paths to register the console, as mentioned in the conmment I 
quoted.  Which path is the problem?


> This call is used to detect the id of the to be enabled hvc device. See
> the comment of hvc_console_init.  register_console sets it to the
> _first_ id it finds, in this case 4.  There is no other call to
> register_console because there is no hvc console with id 4 registered
> and hvc_instantiate checks this.
>
> The list of consoles looks like:
> - hvc, 4
> - hvc, 1
>

So you claim on the call to register_console, both 
add_preferred_console calls had occurred, but the code set changed 
console->index from -1 to that of the first call instead of the last 
match for the driver?   That sounds like the real bug.

> The boot console (udbg0) is destructed later without a real console
> remaining.
>
>> Perhaps the real fix should be scan the command line for console= at
>> console_init time?   How does that compare to __setup that is called 
>> now?

No, I was referring to console_init (in drivers/char/tty_io.c or so 
called from init/main.c).   I was thinking perhaps that the __setup 
function had not been run so we saw only the setup_arch call and not 
the command_line call to add_preferred_console had occurred, but that 
appears not to be the case.

> This was removed because it break different things. See
> 5faae2e5d1f53df9dce482032c8486bc3a1feffc.

No that is a different check.   That was a scanning for console= by the 
setup_arch code.  And it appears kernel/printk.c now has an explicit 
exported variable for drivers to check that console= had been found on 
the command line.  Although it would still not trigger in this case 
because we call before the command line is processed, as you noted, the 
design should take the last one as Michael noted and therefore it 
should work.

>>
>> NACK
>> you broke this assertion:
>>>  /*
>>>   * Initial console vtermnos for console API usage prior to full 
>>> console
>>>   * initialization.  Any vty adapter outside this range will not 
>>> have usable
>>>   * console interfaces but can still be used as a tty device.  This 
>>> has to be
>>>   * static because kmalloc will not work during early console init.
>>>   */
>
> Well. It speaks about "range", but in fact it was exactly one.

No you are counting the wrong thing.  The design is supposed to support 
any single port to be the console (we have one struct console), but 
only one that registers in a fixed slot (hvc_instantiate) in the range 
(0, MAX_HVC_CONSOLES), can be selected for a console driver.

>> The idea is you might want serial port to 250 other partitions, but 
>> only
>> need to have your choice of console be on the first 8 or so.
>
> hvc is limited to 16 devices.

You are limited to one of the first 16 devices/ports being selectable 
as your console, but the number of tty devices is a totally separate 
option, and is limited by the number of tty structs we allocate (which 
should be dynamic) and the range of the minor that we register.

Don't confuse the current defaults (which might insanely be 8 ttys but 
16 possible fixed slots to choose your console from) from the designed 
flexibility.

milton

