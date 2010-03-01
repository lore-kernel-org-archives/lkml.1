Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0CAScp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:32:45 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:64310 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0CAScn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:32:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iJvF1okdvw1ivBbFoA5DWK58spoMnspJn6OGdt+WAHaZN4pwmydavg6NTWedlN04L/
         5ge1HltL296Kf+eFv52bV9u1mxOKlhJngIgyeLpVGqODWGENuupC3N2fMnt/RaV/PYb6
         JVDyoKPi1cCBwY2mcNVj4rbnpBUHh2BbdNnrk=
Date: Mon, 1 Mar 2010 10:32:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-input@vger.kernel.org
Subject: Re: [PATCH 23/28] keyboard, input: Add hook to input to allow low
 level event clear
Message-ID: <20100301183230.GA18380@core.coreip.homeip.net>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
 <1267132893-23624-24-git-send-email-jason.wessel@windriver.com>
 <20100226080329.GD17062@core.coreip.homeip.net>
 <4B87F17B.6040305@windriver.com>
 <20100227075528.GA793@core.coreip.homeip.net>
 <4B8B3B08.7000705@windriver.com>
 <20100301050437.GE765@core.coreip.homeip.net>
 <4B8BF01D.7070507@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8BF01D.7070507@windriver.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 10:49:33AM -0600, Jason Wessel wrote:
> Dmitry Torokhov wrote:
> > On Sun, Feb 28, 2010 at 09:56:56PM -0600, Jason Wessel wrote:
> > 
> >> It is not obvious to me how walk through the input device list with the
> >> right locks and then obtain the handle required to call the inject
> >> input.  It does not appear that it is possible to hold the locks while
> >> walking through the keycode device bitmap and issue calls to inject
> >> input. Is there any kind of input API function to obtain the device bitmaps?
> >>
> > 
> > There is key_down bitmap right there in keyboard.c that reflects all
> > keys that are considered "down" as far as keyboard driver is concerned.
> > You can use input_handler_for_each_handle() for kbd_handler to iterate
> > through all input handles and send "up" events for all keys that
> > keyboard.c is considering as being "down". There is no harm in sending
> > extra "up" events for keys that are not pressed - the event will simply
> > be ignored by input core.
> > 
> 
> Thanks for the explanation.
> 
> Below is the new version.  You just have to decide if you want to
> expose the keyboard bitmap as a global, or use an accessors function
> inside keyboard.c.

Looks much better, thanks. I do prefer accessor functions to exporintg
variables.

> 
> In X, it seems there is an unbalenced key up / down because
> emulate_raw() puts the keys in, but the keyboard bit map is not
> updated.

Yes, if keyboard in raw mode (and it is while you are in X), then most
of the keyboard.c code is not active.

>  I worked around it by adding in a keyboard bitmap update
> prior to invoking the sysrq, so the kdb key free can free all the keys
> later.
> 
> I am not sure if there is a better way to fix the bitmap update.  I
> did try moving the emulate_raw() around in a few combinations, but
> nothing would yield the correct results for still allowing the
> alt-print-screen work with the window capture in the window manager.
> 

Maybe we should simply add key_raw_down bitmap? It is not expensive and
would untangle the shiftstate computation in case of cooked keyboard
from what you need for kdb.

Another option would be writing your own tiny input handler that would
attach to all keyboards like keyboard.c does and just maintain it's own
bitmap of currently active keys. It would work regardless of what mode
keyboard.c is (raw, mediumraw, etc). Actually, I like this idea a lot,
it nicely decouples kdb from keyboard driver. For an example of really
simple handler take a look at drivers/input/apm-power.c

> Thanks,
> Jason.
> 
> ---
> From: Jason Wessel <jason.wessel@windriver.com>
> Subject: [PATCH] keyboard,kgdboc: Allow key release on kernel resume
> 
> When using a keyboard with kdb, a hook point to free all the
> keystrokes is required for resuming kernel operations.
> 
> This is mainly because there is no way to force the end user to hold
> down the original keys that were pressed prior to entering kdb when
> resuming the kernel.
> 
> The kgdboc driver will call kdb_clear_keys() just prior to resuming
> the kernel execution which will create a tasklet to run
> kbd_dbg_clear_keys() inside the keyboard.c.
> 
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: linux-input@vger.kernel.org
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> 
> ---
>  drivers/char/keyboard.c         |   27 +++++++++++++++++++++++++++
>  drivers/serial/kgdboc.c         |   13 +++++++++++++
>  include/linux/kbd_kern.h        |    1 +
>  include/linux/kdb.h             |    3 +++
>  kernel/debug/kdb/kdb_keyboard.c |   25 +++++++++++++++++++++++++
>  5 files changed, 69 insertions(+)
> 
> --- a/drivers/char/keyboard.c
> +++ b/drivers/char/keyboard.c
> @@ -379,6 +379,32 @@ static void to_utf8(struct vc_data *vc, 
>  	}
>  }
>  
> +static int kbd_dbg_clear_keys_helper(struct input_handle *handle, void *data)
> +{
> +	unsigned int *keycode = data;
> +	input_inject_event(handle, EV_KEY, *keycode, 0);
> +	return 0;
> +}
> +
> +/* Called to clear the any key presses after resuming the kernel. */
> +void kbd_dbg_clear_keys(void) {

Style - function opening brace on a separate line please.

> +	unsigned int i, j, k;
> +
> +	for (i = 0; i < ARRAY_SIZE(key_down); i++) {
> +		if (!key_down[i])
> +			continue;
> +
> +		k = i * BITS_PER_LONG;
> +
> +		for (j = 0; j < BITS_PER_LONG; j++, k++) {
> +			if (!test_bit(k, key_down))
> +				continue;
> +			input_handler_for_each_handle(&kbd_handler, &k,
> +				      kbd_dbg_clear_keys_helper);
> +		}
> +	}
> +}
> +
>  /*
>   * Called after returning from RAW mode or when changing consoles - recompute
>   * shift_down[] and shift_state from key_down[] maybe called when keymap is
> @@ -1206,6 +1232,7 @@ static void kbd_keycode(unsigned int key
>  	if (sysrq_down && !down && keycode == sysrq_alt_use)
>  		sysrq_down = 0;
>  	if (sysrq_down && down && !rep) {
> +		set_bit(keycode, key_down);
>  		handle_sysrq(kbd_sysrq_xlate[keycode], tty);
>  		return;
>  	}
> --- a/drivers/serial/kgdboc.c
> +++ b/drivers/serial/kgdboc.c
> @@ -17,6 +17,7 @@
>  #include <linux/kdb.h>
>  #include <linux/tty.h>
>  #include <linux/console.h>
> +#include <linux/kbd_kern.h>
>  
>  #define MAX_CONFIG_LEN		40
>  
> @@ -35,12 +36,16 @@ static struct tty_driver	*kgdb_tty_drive
>  static int			kgdb_tty_line;
>  
>  #ifdef CONFIG_KDB_KEYBOARD
> +static bool			kgdboc_use_kbd;
> +
>  static int kgdboc_register_kbd(char **cptr)
>  {
> +	kgdboc_use_kbd = false;
>  	if (strncmp(*cptr, "kbd", 3) == 0) {
>  		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
>  			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
>  			kdb_poll_idx++;
> +			kgdboc_use_kbd = true;
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
> +		kdb_clear_keys(); /* Release all pressed keys */
> +}
>  #else /* ! CONFIG_KDB_KEYBOARD */
>  #define kgdboc_register_kbd(x) 0
>  #define kgdboc_unregister_kbd()
> +#define kgdboc_clear_kbd()
>  #endif /* ! CONFIG_KDB_KEYBOARD */
>  
>  static int kgdboc_option_setup(char *opt)
> @@ -213,6 +225,7 @@ static void kgdboc_post_exp_handler(void
>  	/* decrement the module count when the debugger detaches */
>  	if (!kgdb_connected)
>  		module_put(THIS_MODULE);
> +	kgdboc_clear_kbd();
>  }
>  
>  static struct kgdb_io kgdboc_io_ops = {
> --- a/include/linux/kbd_kern.h
> +++ b/include/linux/kbd_kern.h
> @@ -144,6 +144,7 @@ struct console;
>  int getkeycode(unsigned int scancode);
>  int setkeycode(unsigned int scancode, unsigned int keycode);
>  void compute_shiftstate(void);
> +void kbd_dbg_clear_keys(void);
>  
>  /* defkeymap.c */
>  
> --- a/include/linux/kdb.h
> +++ b/include/linux/kdb.h
> @@ -93,6 +93,9 @@ typedef int (*get_char_func)(void);
>  extern get_char_func kdb_poll_funcs[];
>  extern int kdb_get_kbd_char(void);
>  
> +/* KDB keyboard hooks */
> +extern void kdb_clear_keys(void);
> +
>  static inline
>  int kdb_process_cpu(const struct task_struct *p)
>  {
> --- a/kernel/debug/kdb/kdb_keyboard.c
> +++ b/kernel/debug/kdb/kdb_keyboard.c
> @@ -13,6 +13,7 @@
>  #include <linux/ctype.h>
>  #include <linux/module.h>
>  #include <linux/io.h>
> +#include <linux/kbd_kern.h>
>  
>  /* Keyboard Controller Registers on normal PCs. */
>  
> @@ -210,3 +211,27 @@ int kdb_get_kbd_char(void)
>  	return keychar & 0xff;
>  }
>  EXPORT_SYMBOL_GPL(kdb_get_kbd_char);
> +
> +static bool dbg_keys_cleared;
> +/*
> + * input_dbg_clear_keys - Clear any keyboards if they have a call back,
> + * after returning from the kernel debugger
> + */
> +static void kdb_keys_task(unsigned long not_used)
> +{
> +	if (!dbg_keys_cleared)
> +		return;
> +	kbd_dbg_clear_keys();
> +	dbg_keys_cleared = false;
> +}
> +
> +static DECLARE_TASKLET(kdb_keys_tasklet, kdb_keys_task, 0);

Do you really need tasklet? Would not regular work_struct do? Also, the
logic of dbg_keys_cleared seems to be inverted, not metioned the fact
that it does not seem to be needed anymore. If you decide against a new
input handler approach may I ask you to move the scheduling to
keyboard.c as well - I know I originally said I wanted it in kdb but now
that I thought about it some more I think keyboard.c is better.

> +
> +void kdb_clear_keys(void)
> +{
> +	if (dbg_keys_cleared)
> +		return;
> +	dbg_keys_cleared = true;
> +	tasklet_schedule(&kdb_keys_tasklet);
> +}
> +EXPORT_SYMBOL_GPL(kdb_clear_keys);

Thanks.

-- 
Dmitry
