Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967916Ab0B0Hzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 02:55:38 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:32840 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967879Ab0B0Hzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 02:55:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DSia6TP+oM05cFQmcO/UJhtVbowZma0OAFIV4mKccq3G6/WHRXuy26lC8LSyzmUlBf
         CjoL7rg3U/GNpXonOUFSdJWbv2CPnkrszRAktuu6dWeN61n/bxUyIgQb11N+2SY9ftT7
         4SupKQy1Soxnvjv4IIL6rXHiXnI6g315RDxVQ=
Date: Fri, 26 Feb 2010 23:55:28 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net,
       Henrik Rydberg <rydberg@euromail.se>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH 23/28] keyboard, input: Add hook to input to allow low
 level event clear
Message-ID: <20100227075528.GA793@core.coreip.homeip.net>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
 <1267132893-23624-24-git-send-email-jason.wessel@windriver.com>
 <20100226080329.GD17062@core.coreip.homeip.net>
 <4B87F17B.6040305@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B87F17B.6040305@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 10:06:19AM -0600, Jason Wessel wrote:
> Dmitry Torokhov wrote:
> > On Thu, Feb 25, 2010 at 03:21:28PM -0600, Jason Wessel wrote:
> >> When using a keyboard with kdb, on resuming the system there needs to
> >> be a hook to allow for the keyboard state to get reset.
> >>
> >> This is mainly because there is no way to force the end user to hold
> >> down the original keys that were pressed prior to entering kdb.
> >>
> > 
> > Instead of adding all the new hook can't you copy the bitmap of
> > currently pressed keys when you invoke kdb and theni, on exit, use
> > input_inject_event() to clear bitmasks in the devices?
> > 
> 
> I know just a little more about the input system then I did 6 months
> ago.  I am not sure that input_inject_event() is exactly what should
> be used, but perhaps you had a different idea in mind.
> 
> I created a new patch which uses the same sort of concept.  I moved
> the key release code from input_disconnect_device() into a common
> function, so that it could be called by the debugger key free hook.
> 

The problem with your patch is that you end up using input_pass_event()
which only passes events to handler, but it does not reset device state.
This will cause loss of the first press of the same button after
returning from kdb. input_inject_event() should do what you need. You
just need to do it from a tasklet or, better yet (there is no
performance issue) schedule a work on keventd so you don't deadlock
on the event lock. It will also do all necessary locking, which is
something you seem to be ignoring.

...

> 
> --- a/drivers/char/keyboard.c
> +++ b/drivers/char/keyboard.c
> @@ -1195,6 +1195,11 @@ static void kbd_keycode(unsigned int key
>  			if (keycode < BTN_MISC && printk_ratelimit())
>  				printk(KERN_WARNING "keyboard.c: can't emulate rawmode for keycode %d\n", keycode);
>  
> +	if (down)
> +		set_bit(keycode, key_down);
> +	else
> +		clear_bit(keycode, key_down);
> +

You sure it is not too early? Right now any key while in SysRq mode is
ignored, with your change it will affect the shift state without
actually passing the key press to userspace.

>  #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
>  	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
>  		if (!sysrq_down) {
> @@ -1237,11 +1242,6 @@ static void kbd_keycode(unsigned int key
>  		raw_mode = 1;
>  	}
>  
> -	if (down)
> -		set_bit(keycode, key_down);
> -	else
> -		clear_bit(keycode, key_down);
> -
>  	if (rep &&
>  	    (!vc_kbd_mode(kbd, VC_REPEAT) ||
>  	     (tty && !L_ECHO(tty) && tty_chars_in_buffer(tty)))) {
> --- a/drivers/serial/kgdboc.c
> +++ b/drivers/serial/kgdboc.c
> @@ -17,6 +17,7 @@
>  #include <linux/kdb.h>
>  #include <linux/tty.h>
>  #include <linux/console.h>
> +#include <linux/input.h>
>  
>  #define MAX_CONFIG_LEN		40
>  
> @@ -35,12 +36,16 @@ static struct tty_driver	*kgdb_tty_drive
>  static int			kgdb_tty_line;
>  
>  #ifdef CONFIG_KDB_KEYBOARD
> +static int kgdboc_use_kbd;  /* 1 if we use a keyboard */

bool?

> +
>  static int kgdboc_register_kbd(char **cptr)
>  {
> +	kgdboc_use_kbd = 0;
>  	if (strncmp(*cptr, "kbd", 3) == 0) {
>  		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
>  			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
>  			kdb_poll_idx++;

Hm, no locking here whatsoever?

> +			kgdboc_use_kbd = 1;
>  			if (cptr[0][3] == ',')
>  				*cptr += 4;
>  			else
> @@ -63,9 +68,16 @@ static void kgdboc_unregister_kbd(void)
>  		}
>  	}
>  }
> +
> +static inline void kgdboc_clear_kbd(void)
> +{
> +	if (kgdboc_use_kbd)
> +		input_dbg_clear_keys(); /* Release all pressed keys */

I'd rather have the input_dbg_clear_keys() being implemented right here,
along with the tasklet/work handling, instead of puttin it in the input
core.

-- 
Dmitry
