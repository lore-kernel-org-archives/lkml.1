Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0CAD5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 22:57:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:64964 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab0CAD5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 22:57:54 -0500
Message-ID: <4B8B3B08.7000705@windriver.com>
Date: Sun, 28 Feb 2010 21:56:56 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net,
       Henrik Rydberg <rydberg@euromail.se>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH 23/28] keyboard, input: Add hook to input to allow low
 level event clear
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com> <1267132893-23624-24-git-send-email-jason.wessel@windriver.com> <20100226080329.GD17062@core.coreip.homeip.net> <4B87F17B.6040305@windriver.com> <20100227075528.GA793@core.coreip.homeip.net>
In-Reply-To: <20100227075528.GA793@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Mar 2010 03:56:57.0617 (UTC) FILETIME=[3D297010:01CAB8F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> The problem with your patch is that you end up using input_pass_event()
> which only passes events to handler, but it does not reset device state.
> This will cause loss of the first press of the same button after
> returning from kdb. input_inject_event() should do what you need. You
> just need to do it from a tasklet or, better yet (there is no
> performance issue) schedule a work on keventd so you don't deadlock
> on the event lock. It will also do all necessary locking, which is
> something you seem to be ignoring.
>
> ...
>
>   

For now I am just going to drop this patch from the series, and I think
we should pick up the continuation of the discussion on the
linux-input.  The lack of this patch simply means keys can stuck down
sometimes if you go in and out of the kernel debug shell when running
X.   People were able to live with this a long time in the original kdb
v4.4, so they can live with it a while longer while a solution is hashed
out to "unstick the keys".

This will allow me to re-issue a pull request which has no patches which
are in the discussion state.

It is not obvious to me how walk through the input device list with the
right locks and then obtain the handle required to call the inject
input.  It does not appear that it is possible to hold the locks while
walking through the keycode device bitmap and issue calls to inject
input. Is there any kind of input API function to obtain the device bitmaps?

>> --- a/drivers/char/keyboard.c
>> +++ b/drivers/char/keyboard.c
>> @@ -1195,6 +1195,11 @@ static void kbd_keycode(unsigned int key
>>  			if (keycode < BTN_MISC && printk_ratelimit())
>>  				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", keycode);
>>  
>> +	if (down)
>> +		set_bit(keycode, key_down);
>> +	else
>> +		clear_bit(keycode, key_down);
>> +
>>     
>
> You sure it is not too early? Right now any key while in SysRq mode is
> ignored, with your change it will affect the shift state without
> actually passing the key press to userspace.
>
>   

I think it is possible to drop this chunk and leave it as it was because
the work is definitely going to move to a tasklet which occurs after the
sysrq and the key events will be synced at that point.

Previously the problem was trying to process the key bitmaps inside the
sysrq.

>> --- a/drivers/serial/kgdboc.c
>> +++ b/drivers/serial/kgdboc.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/kdb.h>
>>  #include <linux/tty.h>
>>  #include <linux/console.h>
>> +#include <linux/input.h>
>>  
>>  #define MAX_CONFIG_LEN		40
>>  
>> @@ -35,12 +36,16 @@ static struct tty_driver	*kgdb_tty_drive
>>  static int			kgdb_tty_line;
>>  
>>  #ifdef CONFIG_KDB_KEYBOARD
>> +static int kgdboc_use_kbd;  /* 1 if we use a keyboard */
>>     
>
> bool?
>
>   

Agreed, I'll fix that in a future iteration.
>   
>> +
>>  static int kgdboc_register_kbd(char **cptr)
>>  {
>> +	kgdboc_use_kbd = 0;
>>  	if (strncmp(*cptr, "kbd", 3) == 0) {
>>  		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
>>  			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
>>  			kdb_poll_idx++;
>>     
>
> Hm, no locking here whatsoever?
>
>   

There is no locking needed here.  This only takes place at the kernel
module configuration.

>   
>> @@ -63,9 +68,16 @@ static void kgdboc_unregister_kbd(void)
>>  		}
>>  	}
>>  }
>> +
>> +static inline void kgdboc_clear_kbd(void)
>> +{
>> +	if (kgdboc_use_kbd)
>> +		input_dbg_clear_keys(); /* Release all pressed keys */
>>     
>
> I'd rather have the input_dbg_clear_keys() being implemented right here,
> along with the tasklet/work handling, instead of puttin it in the input
> core.
>
>   


That is fine with me, it is just not obvious to me which API calls you
need in order to be able iterate through the key bit maps and get
handles to call the inject input event.

Jason
