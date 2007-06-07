Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbXFGPAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbXFGPAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbXFGO7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:59:52 -0400
Received: from frosty.hhs.nl ([145.52.2.15]:47556 "EHLO frosty.hhs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXFGO7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:59:51 -0400
Message-ID: <46681C5B.80201@hhs.nl>
Date: Thu, 07 Jun 2007 16:55:23 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Vojtech Pavlik <vojtech@suse.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: problem with softraw and keycodes > 128
References: <4667C00D.40708@hhs.nl> <20070607131503.GA26905@suse.cz>
In-Reply-To: <20070607131503.GA26905@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.2/RELEASE, bases: 07062007 #320093, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vojtech Pavlik wrote:
> On Thu, Jun 07, 2007 at 10:21:33AM +0200, Hans de Goede wrote:
> 
> Hans,
> 
>> I've been experimenting with getting the internetkeys on several
>> keyboards to work. My biggest problem with this currently is the
>> following:
> 
>> Step 1: press key, dmesg says:
>> 	atkbd.c: Unknown key released (translated set 2, code 0xa3 on  isa0060/serio0).
>> 	atkbd.c: Use 'setkeycodes e023 <keycode>' to make it known.
>> Step 2: map key: setkeycodes e023 163
>> Step 3: run xev, press key. X-keycode is: 153 instead of 163 ?
> 
> 
>> Doing:
>> 	echo -n 0 >/sys/devices/platform/i8042/serio1/softraw
>> However does make them identical.
> 
> this is a well known problem. It's not easy to explain and next to
> impossible to fix within the scope of operation of your test case -
> otherwsie it'd be fixed ages ago.
> 
> The explanation why this happen will be a little longer, and will follow
> the life of a keystroke as it passes through the different layers.
> 
> 	1. First, the user presses a key. Since we're talking a 102-key
> 	PS/2-type keyboard here, the keyboard scans its matrix and figures out
> 	the position of the key. Then, since the connection to the PC is running
> 	in AT mode, it translates the key to a string (one to eight bytes) of
> 	AT-compatible scancodes.
> 
> 	2. The i8042 in the computer receives the scancodes, translates them to
> 	XT-compatible scancodes and makes them available to the OS.
> 
> 	3. In OS the i8042.c gets the scancodes and forwards them to atkbd.c
> 
> 	4. atkbd.c decodes the string of scancodes and turns them into a single
> 	Linux input event, and forwards it to the input core.
> 
> 	5. The Linux input core dispatches the events to char/keyboard.c.
> 
> 	6. keyboard.c, a part of the VT driver, sees that X told the VT that it
> 	wants the "raw mode", which means that the VT should give the keystrokes
> 	as the original string of XT scancodes. Hence (when softraw is 1), it
> 	consults a table and synthesizes what it thinks the original string of
> 	bytes could have been and gives that to X. For all keys that atkbd.c
> 	knows by default, this string is IDENTICAL to what atkbd.c has received.
> 
> 	7. X takes the string, and using an algorithm similar to, but DIFFERENT
> 	from the algoithm that atkbd.c uses, it converts them to an X scancode.
> 	The X scancodes are similar to, but different from the Linux event
> 	keycodes, for historical reasons going back to the 90's.
> 
> 	8. Using an xmodmap table compiled from xkb sources, X converts the X
> 	scancode to an X keysym.
> 
> In the softraw == 0 case, the original string of XT scancodes is passed
> all along the path to X, so that X really gets what the keyboard sent.
> 
> Since the table mapping Linux event keycodes to the synthesized XT
> scancodes in step 6. is constant and shared for all (even USB and other)
> keyboards, this means that the Linux kernel always presents a virtual
> "Linux keyboard" to X.
> 
> The "Linux keyboard" always sends the same scancodes for keys with the
> same meaning, regardless of what the real hardware does.
> 

But doesn't it only know the meaning after doing a setkeycodes for easy-access 
keys? I find it somewhat counter inituitive that doing "setkeycodes e023 163" 
will give me a keycode 163 on the console (as reported by showkeys), but will 
send a scancode of 153 to the X-server.

> And this is why X sees a different code in softraw==1 mode than in
> softraw==0 mode: In the first it gets the virtual "Linux keyboard", in
> the other it gets access to the real hardware.
> 
>> Problem, as the xkb files for these keyboards expect the X-keycode to
>> be 163, as just it is under the console. Now I know that X-keycodes !=
>> console-keycodes, for example the A key is 30 on the console and 38 in
>> X, but in the case of this special keys, both the xkb files for these
>> internet keyboards (written by suse) and config files for special
>> daemons like lineak, expect them to be identical.
> 
> This is wrong. Someone simply needs to write a xkb/lineak description
> for the "Linux keyboard", and then all these problems will go away.
> 

Well to be honest I'm looking for a somewhat more quick fix then that. Let me 
try to explain. Xorg comes with keyboard descriptions for many special-access 
keys having keyboards. These descriptions can be easily selected by the end 
user from the kde / gnome keyboard properties applets.

This however only works with softraw=0 for 2 reasons:
1) without softraw=0 the key presses never reach the server when there hasn't
    been an setkeycodes command for the easy access key
2) even if a setkeycodes command was given, then the keycode given to
    setkeycodes doesn't match the scancode seen by xorg, messing things up.
    (unless one uses setkeycodes with a reverse mapping of the mapping done in
     the kernel)

There are 3 ways out of this:
1) write special loadkey maps for all the easy access keyboards, since unlike X
    loadkeys AFAIK doesn't support inheriting keys from a global layout, the
    number of language-layout <-> keyboard model variants would become quite
    frightening.

    When loadkeys has been thought to map the special keys according to the
    linuxkeyboard codes, then X needs to be tought how to handle a linux
    keyboard and default to this

    Also configuration utils need to be written to properly set things up for
    loadkeys, as autodetecting this is impossible

2) Somehow fix things so that selecting the right model in gnome/kde
    keyboard-preferences will make the keys work. Like it does now with
    softraw=0. Which leads me to asking what are the downsides of using
    softraw=0?
    What about be default defining keycodes for all the 128+ scancodes not yet
    defined, and defining these in such a way that the actual scancodes is what
    gets send to X?
    Or maybe it would be an option to send the raw scancode just like is done
    with softraw=0 when there is no mapping (instead of ignoring the key as is
    done now).

    Since the xkb discriptions for most of the easy access keyboards have been
    written by Suse, I assume the tested them and it works for them. Does anyone
    know how suse does this?

3) Forget about all this and leave things as is, this one clearly does not have
    my preference.

Regards,

Hans

