Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZKQLzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZKQLzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 06:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZKQLzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 06:55:04 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:37474 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbZKQLzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 06:55:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kPZ9UwjnuMP5Lo/peT9+2QsAZ9W2QV17gDxyMjWfcxfnMcMAIEU16uqMOTnx3URvGG
         lJjclvIdQH2JEZ2AMqLAdarfwbjgo5GMbPpwSum7QrE1KkbpBnp7epy1MahIrA+7Jvmn
         Khp+8SjEwihSBUN/ayvQLHOvKOutd8vclbKy4=
Date: Tue, 17 Nov 2009 14:55:03 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, alan@lxorguk.ukuu.org.uk,
       mgarski@post.pl
Subject: Re: [PATCH] kbd: (#7063) make CapsLock work as expected even for
 non-ASCII
Message-ID: <20091117115503.GB1657@x200>
References: <20091116135114.GA2719@x200>
 <20091116190739.GJ4764@const.famille.thibault.fr>
 <20091116195313.GB4462@x200>
 <20091116222738.GQ4764@const.famille.thibault.fr>
 <20091116225429.GB4764@const.famille.thibault.fr>
 <20091116230523.GC24961@x200>
 <20091116231520.GD4764@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091116231520.GD4764@const.famille.thibault.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 12:15:20AM +0100, Samuel Thibault wrote:
> Alexey Dobriyan, le Tue 17 Nov 2009 02:05:23 +0300, a écrit :
> > On Mon, Nov 16, 2009 at 11:54:29PM +0100, Samuel Thibault wrote:
> > > Samuel Thibault, le Mon 16 Nov 2009 23:27:38 +0100, a écrit :
> > > > > My keymap contains
> > > > > 
> > > > > 				keycode 44 = +z
> > > > > 		shift           keycode 44 = +Z
> > > > > 	altgr                   keycode 44 = U+044F        # CYRILLIC SMALL LETTER YA
> > > > > 	altgr   shift           keycode 44 = U+042F        # CYRILLIC CAPITAL LETTER YA
> > > > 
> > > > And U+044F / U+042F is not KT_LETTER.
> > > > 
> > > > Yes, there's no way you can express a unicode character in KT_LETTER.
> > > > Limited interface, but that's not a reason to break other interfaces.
> > > 
> > > One way to go would be to decrete that keysyms between 0xD800 and 0xE000
> > 
> > And this is going to help me with U+042F/U+044F how?

> --- a/drivers/char/keyboard.c
> +++ b/drivers/char/keyboard.c
> @@ -1258,6 +1258,15 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
>  	type = KTYP(keysym);
>  
>  	if (type < 0xf0) {
> +		if (keysym >= 0xD800 && keysym < 0xE000) {

keysym is 0x044F at this point.

> +			/* Surrogates in Unicode, here KT_LETTER variants of unicode U+0000-U+07FF */
> +			keysym -= 0xD800;
> +			if (vc_kbd_led(kbd, VC_CAPSLOCK)) {
> +				key_map = key_maps[shift_final ^ (1 << KG_SHIFT)];
> +				if (key_map)
> +					keysym = key_map[keycode];
> +			}
> +		}
>  		param.value = keysym;
>  		if (atomic_notifier_call_chain(&keyboard_notifier_list, KBD_UNICODE, &param) == NOTIFY_STOP)
>  			return;
> 
> Which BTW is correct while the proposed patch earlier wasn't: the
> param.value needs to be the final keysym.

OK, this I should fix.

> But again, that only solves the problem of the limited range
> U+0000-U+0800 and doesn't solve the é/É french keyboard problem.
> 
> Adding an interface to change the modifier lock / LED assignation would
> on the other hand permit kbd and console-setup to properly do proper
> capslock processing correctly.
