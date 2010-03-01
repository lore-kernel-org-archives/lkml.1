Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0CATeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:34:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:46444 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0CATeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:34:00 -0500
Message-ID: <4B8C1696.5030207@windriver.com>
Date: Mon, 01 Mar 2010 13:33:42 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org
Subject: Re: [PATCH 23/28] keyboard, input: Add hook to input to allow low
 level event clear
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com> <1267132893-23624-24-git-send-email-jason.wessel@windriver.com> <20100226080329.GD17062@core.coreip.homeip.net> <4B87F17B.6040305@windriver.com> <20100227075528.GA793@core.coreip.homeip.net> <4B8B3B08.7000705@windriver.com> <20100301050437.GE765@core.coreip.homeip.net> <4B8BF01D.7070507@windriver.com> <20100301183230.GA18380@core.coreip.homeip.net>
In-Reply-To: <20100301183230.GA18380@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Mar 2010 19:33:42.0835 (UTC) FILETIME=[1A151830:01CAB976]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Mon, Mar 01, 2010 at 10:49:33AM -0600, Jason Wessel wrote:
>   
>> Dmitry Torokhov wrote:
>>     
>>> On Sun, Feb 28, 2010 at 09:56:56PM -0600, Jason Wessel wrote:
>>>
>>>       
>>>> It is not obvious to me how walk through the input device list with the
>>>> right locks and then obtain the handle required to call the inject
>>>> input.  It does not appear that it is possible to hold the locks while
>>>> walking through the keycode device bitmap and issue calls to inject
>>>> input. Is there any kind of input API function to obtain the device bitmaps?
>>>>
>>>>         
>>> There is key_down bitmap right there in keyboard.c that reflects all
>>> keys that are considered "down" as far as keyboard driver is concerned.
>>> You can use input_handler_for_each_handle() for kbd_handler to iterate
>>> through all input handles and send "up" events for all keys that
>>> keyboard.c is considering as being "down". There is no harm in sending
>>> extra "up" events for keys that are not pressed - the event will simply
>>> be ignored by input core.
>>>
>>>       
>> Thanks for the explanation.
>>
>> Below is the new version.  You just have to decide if you want to
>> expose the keyboard bitmap as a global, or use an accessors function
>> inside keyboard.c.
>>     
>
> Looks much better, thanks. I do prefer accessor functions to exporintg
> variables.
>
>   
>> In X, it seems there is an unbalenced key up / down because
>> emulate_raw() puts the keys in, but the keyboard bit map is not
>> updated.
>>     
>
> Yes, if keyboard in raw mode (and it is while you are in X), then most
> of the keyboard.c code is not active.
>
>   
>>  I worked around it by adding in a keyboard bitmap update
>> prior to invoking the sysrq, so the kdb key free can free all the keys
>> later.
>>
>> I am not sure if there is a better way to fix the bitmap update.  I
>> did try moving the emulate_raw() around in a few combinations, but
>> nothing would yield the correct results for still allowing the
>> alt-print-screen work with the window capture in the window manager.
>>
>>     
>
> Maybe we should simply add key_raw_down bitmap? It is not expensive and
> would untangle the shiftstate computation in case of cooked keyboard
> from what you need for kdb.
>
> Another option would be writing your own tiny input handler that would
> attach to all keyboards like keyboard.c does and just maintain it's own
> bitmap of currently active keys. It would work regardless of what mode
> keyboard.c is (raw, mediumraw, etc). Actually, I like this idea a lot,
> it nicely decouples kdb from keyboard driver. 

Unfortunately the keyboard driver is what has the problem of its state
getting out of sync when the kernel makes use of the kdb_keyboard.c,
which is why I was trying to hook it in the first place.  If the sysrq
code could be moved to its own input driver does this problem go away
for all parties?

Even without kdb, when running X, the sysrq definitely does not behave
so well and a sysrq-KEY_PRESS is passed on to the input queue instead of
getting eaten.  For example when I do alt-sysrq-h, I see the help menu
flash in the terminal because it thinks I pressed alt-h and kept it held
down.

>> +static void kdb_keys_task(unsigned long not_used)
>> +{
>> +	if (!dbg_keys_cleared)
>> +		return;
>> +	kbd_dbg_clear_keys();
>> +	dbg_keys_cleared = false;
>> +}
>> +
>> +static DECLARE_TASKLET(kdb_keys_tasklet, kdb_keys_task, 0);
>>     
>
> Do you really need tasklet? Would not regular work_struct do? 

It was safe to schedule a tasklet from the caller context.  I assume it
is probably also safe to use a work_struct, but I had not checked.

> Also, the
> logic of dbg_keys_cleared seems to be inverted, not metioned the fact
> that it does not seem to be needed anymore. 

That is a result of iteration churn.  Easy enough to change.

> If you decide against a new
> input handler approach may I ask you to move the scheduling to
> keyboard.c as well - I know I originally said I wanted it in kdb but now
> that I thought about it some more I think keyboard.c is better.
>
>   

I can move this back into the keyboard.c.

As I mentioned before, I am not sure an input handler will solve the
higher level problem, that even beyond kdb, keys are getting stuck with
X and sysrq.  Perhaps we need a generic solution that is not even kdb
specific for clearing the state after a sysrq?

For kdb it does still need the same sort of hook because if you type in:

  echo g > /proc/sysrq-trigger

And hit enter, the enter key will get repeated over and over because it
happened to be depressed when the kernel debugger was entered, while in X.

This means we have two cases:

1) Cleanup key strokes or "consume keys" for sysrq
2) Clear keyboard state on a kernel resume from kdb

I am open to any reasonable solution.  The most recent patch I sent
works well for case 2, but never really addressed case 1, which has been
a problem with or without kdb.

Jason.

Jason.
