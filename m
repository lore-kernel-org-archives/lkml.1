Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZJLIav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZJLIav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZJLIav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:30:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:34126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbZJLIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:30:50 -0400
Date: Mon, 12 Oct 2009 10:30:15 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Regression?: keyboard state/LED inconsistency in
	2.6.32-rc1/2,3,4
Message-ID: <20091012083015.GA11483@suse.cz>
References: <200910121118.29415.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910121118.29415.mitov@issp.bas.bg>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 11:18:28AM +0300, Marin Mitov wrote:
> Hello,
> 
> I'm testing 2.6.32-rc1/2,3,4 and I'm using 2.6.31.3.
> There is a difference in keyboard/LED behavior.
> If in BIOS NumLock is set on, when the kernel starts
> it puts NumLock off and the LED state is off in 2.6.31.3
> (which is consistent), but in 2.6.32-rc1/2,3,4 the LED
> stays on (and this is not consistent with keyboard's state).
> 
> Comparing drivers/input/keyboard/atkbd.c (I'm using it)
> in 2.6.31.3 and 2.6.32-rc1/2,3,4 among others changes I
> found the following lines (see the patch bellow) deleted,
> so I propose either to add them again (this will restore 
> keyboard/LED consistency) or revert the patch that has 
> deleted them.

Oh, wow, those lines are quite clearly needed, I wonder why they got
deleted, and I'm too lazy to find the commit comment ...

> The better solution will be if the kernel preserves the state
> of the keyboard as set by BIOS.

That is certainly possible - by reading a BIOS variable from memory it's
possible to figure out what the BIOS setting was. But it has to be done
outside atkbd, because it affects all system keyboards, including eg.
USB.

Vojtech

> 
> Best regards.
> 
> Marin Mitov
> 
> P.S. The lines in the patch concerning "repeat rate" are
> not related with the "keyboard state/LED inconsistency",
> but have been also deleted (by mistake/intentionally) too.
> Could be dropped if necessary.
> 
> Marin Mitov
> 
> Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
> 
> ======================================================
> --- a/drivers/input/keyboard/atkbd.c	2009-10-11 20:15:27.000000000 +0300
> +++ b/drivers/input/keyboard/atkbd.c	2009-10-11 20:17:34.000000000 +0300
> @@ -773,6 +773,23 @@
>  static int atkbd_activate(struct atkbd *atkbd)
>  {
>  	struct ps2dev *ps2dev = &atkbd->ps2dev;
> +	unsigned char param[1];
> +
> +/*
> + * Set the LEDs to a defined state.
> + */
> +
> +	param[0] = 0;
> +	if (ps2_command(ps2dev, param, ATKBD_CMD_SETLEDS))
> +		return -1;
> +
> +/*
> + * Set autorepeat to fastest possible.
> + */
> +
> +	param[0] = 0;
> +	if (ps2_command(ps2dev, param, ATKBD_CMD_SETREP))
> +		return -1;
>  
>  /*
>   * Enable the keyboard to receive keystrokes.
> @@ -1141,6 +1158,14 @@
>  			return -1;
>  
>  		atkbd_activate(atkbd);
> +
> +/*
> + * Restore repeat rate and LEDs (that were reset by atkbd_activate)
> + * to pre-resume state
> + */
> +		if (!atkbd->softrepeat)
> +			atkbd_set_repeat_rate(atkbd);
> +		atkbd_set_leds(atkbd);
>  	}
>  
>  	atkbd_enable(atkbd);
> 

-- 
Vojtech Pavlik
Director SuSE Labs
