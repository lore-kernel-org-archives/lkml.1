Return-Path: <linux-kernel-owner+w=401wt.eu-S1763907AbXFGPg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763907AbXFGPg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760090AbXFGPgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:36:18 -0400
Received: from styx.suse.cz ([82.119.242.94]:34872 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750923AbXFGPgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:36:17 -0400
Date: Thu, 7 Jun 2007 17:36:39 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: problem with softraw and keycodes > 128
Message-ID: <20070607153639.GB5775@suse.cz>
References: <4667C00D.40708@hhs.nl> <20070607131503.GA26905@suse.cz> <46681C5B.80201@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46681C5B.80201@hhs.nl>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 04:55:23PM +0200, Hans de Goede wrote:

> >Since the table mapping Linux event keycodes to the synthesized XT
> >scancodes in step 6. is constant and shared for all (even USB and other)
> >keyboards, this means that the Linux kernel always presents a virtual
> >"Linux keyboard" to X.
> >
> >The "Linux keyboard" always sends the same scancodes for keys with the
> >same meaning, regardless of what the real hardware does.
> 
> But doesn't it only know the meaning after doing a setkeycodes for 
> easy-access keys? 

Most microsoft-compatible keys work by default without setkeycodes. But
yes, for those that aren't in the default table, it only knows the
meaning after you tell it with setkeycodes.

> I find it somewhat counter inituitive that doing 
> "setkeycodes e023 163" will give me a keycode 163 on the console (as 
> reported by showkeys), but will send a scancode of 153 to the X-server.

As I said, the algorithms/table to compute the keycode from the XT
scancodes are different in the kernel and in the X server, and that
can't be changed without breaking backwards compatibility.

The good news is that while the numbers aren't the same, there is a 1:1
mapping, that is, you'll get 153 in the server for 163 in the kernel,
always, regardless of the keyboard used or regardless of the actual key
you assigned this code to.

And I don't have the mapping table: It could likely be fairly easily
created by simply going through all the keys and writing the results
down.

> Well to be honest I'm looking for a somewhat more quick fix then that. Let 
> me try to explain. Xorg comes with keyboard descriptions for many 
> special-access keys having keyboards. These descriptions can be easily 
> selected by the end user from the kde / gnome keyboard properties applets.
> 
> This however only works with softraw=0 for 2 reasons:
> 1) without softraw=0 the key presses never reach the server when there 
> hasn't
>    been an setkeycodes command for the easy access key
> 2) even if a setkeycodes command was given, then the keycode given to
>    setkeycodes doesn't match the scancode seen by xorg, messing things up.
>    (unless one uses setkeycodes with a reverse mapping of the mapping done 
>    in
>     the kernel)
> 
> There are 3 ways out of this:
> 1) write special loadkey maps for all the easy access keyboards, since 
> unlike X
>    loadkeys AFAIK doesn't support inheriting keys from a global layout, the
>    number of language-layout <-> keyboard model variants would become quite
>    frightening.

No. You just need a 'setkeycodes' map for the extra keys, and that's
language-independent.

>    When loadkeys has been thought to map the special keys according to the
>    linuxkeyboard codes, then X needs to be tought how to handle a linux
>    keyboard and default to this
> 
>    Also configuration utils need to be written to properly set things up for
>    loadkeys, as autodetecting this is impossible

X doesn't get the loadkeys (keymap) processed data, it gets the
keycodes, which are only affected by setkeycodes.

> 2) Somehow fix things so that selecting the right model in gnome/kde
>    keyboard-preferences will make the keys work. Like it does now with
>    softraw=0. Which leads me to asking what are the downsides of using
>    softraw=0?

It doesn't work with anything else but PS/2 keyboards. It's useless on
eg. USB.

>    What about be default defining keycodes for all the 128+ scancodes
>    not yet defined, and defining these in such a way that the actual
>    scancodes is what gets send to X?

Ugly.

>    Or maybe it would be an option to send the raw scancode just like
>    is done with softraw=0 when there is no mapping (instead of
>    ignoring the key as is done now).

That'd confuse people even more than the current situation.

>    Since the xkb discriptions for most of the easy access keyboards
>    have been written by Suse, I assume the tested them and it works
>    for them. Does anyone know how suse does this?

I don't think it does work. One of our guys is trying to fix it by

	1) Converting the xkb multimedia keyboard descriptions to setkeycodes descriptions
	2) Creating a "linux keyboard" X xkb description

Then, after loading the setkeycodes at boot for the right keyboard
ty[e, AT keyboard will work fine, and USB and other keyboards will not
need *any* setup to have their multimedia keys working out of the box.

-- 
Vojtech Pavlik
Director SuSE Labs
