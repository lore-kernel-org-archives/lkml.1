Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0BWR7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:59:13 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:45130 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0BWR7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:59:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xj7mvz4f3dIADB25RjBMXXyb3pDGEUaT35If6H/v+VuRhpZQARYe7dwe4MP2fnoU1H
         Pxlums2QK+5YFNIqhdFgdrs12IuZsHX8Uoz2N/Kqz8Mt+DWOCx+aJJ+9MS1+ZD1Q04H5
         NOLyvUbFVSROwF/gYyGk2S/qgRTig32IiZEC8=
Date: Tue, 23 Feb 2010 09:58:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michael Thayer <Michael.Thayer@Sun.COM>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1]: input: add support for VirtualBox touchscreen
 emulation to the Lifebook driver
Message-ID: <20100223175852.GA11301@core.coreip.homeip.net>
References: <1266923615.3602.85.camel@michael-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266923615.3602.85.camel@michael-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Tue, Feb 23, 2010 at 12:13:35PM +0100, Michael Thayer wrote:
> This patch adds support for VirtualBox touchscreen emulation to the Lifebook
>  input driver.
> 
> The device will be present as an extension to the PS/2 mouse emulation in the
> next major release of VirtualBox.  We chose to emulate the Lifebook touchscreen
> mainly in order to simplify in-kernel support, as the Lifebook driver is active
> by default in most kernel configurations.  We had to extend the protocol
> slightly as we wish to provide five mouse buttons and a two-way scroll wheel to
> virtual guest systems, and we tried to do this in the most non-intrusive way
> possible with regard to the current driver, which is the reason for the slightly
> unusual handling of mouse buttons three to five.

I am wondering if it is a good idea to piggy-back on Lifebook. The
devices are sufficiently different with Lifebook really having 2
separate devices (touchscreen and either regular external mouse or a
touchpad) and VirtualBox having asingle device that looks like a pointer
(not a touchscreen since pointer moves constantly, not while "touching")
with absolute coordinates reporting.

I think it would be better if we had separate protocol module for that.
The fact that Lifebook is enabled in many current configurations should
not affect the decision - current distributions will have to chose to
backport the change and if they decide to do so will activate the config
option; users compiling their own kernels will decide if they want it.
Also, VirualBox may be popular enough to condition the new option on
EMBEDDED so that it is active by default.

> 
> Most changes in the driver are conditional on the VirtualBox DMI string being
> found.  A notable exception is the removal of the keybit fields for the left,
> right and middle buttons for the first device.

This issue should be fixed in the recent kernels.

> The current X.Org evdev driver
> was seeing these and treating the device as a touchpad instead of a touchscreen.
> I also tested this with a vanilla Ubuntu Lucid live CD while emulating the
> original device and presenting a suitable DMI string.
> 
> Signed-off-by: Michael Thayer <michael.thayer@sun.com>
> --- lifebook.c	2010-02-23 12:01:32.941643681 +0100
> +++ lifebook-vbox.c	2010-02-23 11:44:57.831664482 +0100
> @@ -1,6 +1,8 @@
>  /*
>   * Fujitsu B-series Lifebook PS/2 TouchScreen driver
> + * Also used for Oracle VirtualBox mouse integration
>   *
> + * Copyright (c) 2010 Oracle.  All rights reserved.
>   * Copyright (c) 2005 Vojtech Pavlik <vojtech@suse.cz>
>   * Copyright (c) 2005 Kenan Esau <kenan.esau@conan.de>
>   *
> @@ -41,6 +43,15 @@ static int lifebook_set_6byte_proto(cons
>  	return 0;
>  }
>  
> +static bool lifebook_use_vbox_proto;
> +
> +static int lifebook_set_vbox_proto(const struct dmi_system_id *d)
> +{
> +	lifebook_use_6byte_proto = true;
> +	lifebook_use_vbox_proto = true;
> +	return 0;
> +}
> +
>  static const struct dmi_system_id lifebook_dmi_table[] = {
>  	{
>  		.ident = "FLORA-ie 55mi",
> @@ -115,6 +126,13 @@ static const struct dmi_system_id lifebo
>  			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook B142"),
>  		},
>  	},
> +	{
> +		.ident = "VirtualBox",
> +		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "VirtualBox"),
> +		},
> +		.callback = lifebook_set_vbox_proto,
> +	},
>  	{ }
>  };
>  
> @@ -180,6 +198,21 @@ static psmouse_ret_t lifebook_process_by
>  				((packet[0] & 0x10) ? packet[1] - 256 : packet[1]));
>  			input_report_rel(dev2, REL_Y,
>  				 -(int)((packet[0] & 0x20) ? packet[2] - 256 : packet[2]));
> +			if (lifebook_use_vbox_proto && !(packet[0] & 0x04)) {
> +				unsigned btn = (packet[0] >> 6);
> +
> +				input_report_key(dev2, BTN_MIDDLE, btn == 1);
> +				input_report_key(dev2, BTN_SIDE, btn == 2);
> +				input_report_key(dev2, BTN_EXTRA, btn == 3);
> +			}
> +			if (lifebook_use_vbox_proto && (packet[0] & 0x04)) {
> +				unsigned wheel = (packet[0] >> 6);
> +
> +				input_report_rel(dev2, REL_WHEEL,
> +					(wheel == 0) - (wheel == 1));
> +				input_report_rel(dev2, REL_HWHEEL,
> +					(wheel == 2) - (wheel == 3));
> +			}
>  		}
>  		input_report_key(dev2, BTN_LEFT, packet[0] & 0x01);
>  		input_report_key(dev2, BTN_RIGHT, packet[0] & 0x02);
> @@ -200,11 +233,17 @@ static int lifebook_absolute_mode(struct
>  	/*
>  	   Enable absolute output -- ps2_command fails always but if
>  	   you leave this call out the touchsreen will never send
> -	   absolute coordinates
> +	   absolute coordinates.
> +
> +	   Note that old versions of VirtualBox which didn't emulate the
> +	   touchscreen also failed to return an error here, so if we are
> +	   running inside VirtualBox, we actually have to make sure that
> +	   the command fails!
>  	*/
>  	param = lifebook_use_6byte_proto ? 0x08 : 0x07;
> -	ps2_command(ps2dev, &param, PSMOUSE_CMD_SETRES);
> -
> +	if (!ps2_command(ps2dev, &param, PSMOUSE_CMD_SETRES) &&
> +		lifebook_use_vbox_proto)
> +		return -1;
>  	return 0;
>  }
>  
> @@ -251,11 +290,14 @@ int lifebook_detect(struct psmouse *psmo
>  		return -1;
>  
>  	if (set_properties) {
> -		psmouse->vendor = "Fujitsu";
> -		psmouse->name = "Lifebook TouchScreen";
> +		psmouse->vendor = !lifebook_use_vbox_proto ? "Fujitsu" :
> +			"VirtualBox";
> +		psmouse->name =  !lifebook_use_vbox_proto ?
> +			"Lifebook TouchScreen" :
> +			"Mouse Integration" ;
>  	}
>  
> -        return 0;
> +	return 0;
>  }
>  
>  static int lifebook_create_relative_device(struct psmouse *psmouse)
> @@ -274,7 +316,8 @@ static int lifebook_create_relative_devi
>  		 "%s/input1", psmouse->ps2dev.serio->phys);
>  
>  	dev2->phys = priv->phys;
> -	dev2->name = "PS/2 Touchpad";
> +	dev2->name = !lifebook_use_vbox_proto ? "PS/2 Touchpad" :
> +		"Virtual PS/2 Mouse";
>  	dev2->id.bustype = BUS_I8042;
>  	dev2->id.vendor  = 0x0002;
>  	dev2->id.product = PSMOUSE_LIFEBOOK;
> @@ -285,6 +328,13 @@ static int lifebook_create_relative_devi
>  	dev2->relbit[BIT_WORD(REL_X)] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
>  	dev2->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
>  		BIT_MASK(BTN_RIGHT);
> +	if (lifebook_use_vbox_proto) {
> +		__set_bit(BTN_MIDDLE, dev2->keybit);
> +		__set_bit(REL_WHEEL, dev2->relbit);
> +		__set_bit(REL_HWHEEL, dev2->relbit);
> +		__set_bit(BTN_SIDE, dev2->keybit);
> +		__set_bit(BTN_EXTRA, dev2->keybit);
> +	}
>  
>  	error = input_register_device(priv->dev2);
>  	if (error)
> @@ -310,6 +360,14 @@ int lifebook_init(struct psmouse *psmous
>  	dev1->evbit[0] = BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
>  	dev1->relbit[0] = 0;
>  	dev1->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
> +	/*
> +	   The psmouse-base driver enables these bits, but if the X.Org
> +	   evdev driver sees them it thinks we are a touchpad, not a
> +	   touchscreen.
> +	*/
> +	psmouse->dev->keybit[BIT_WORD(BTN_MOUSE)] &= ~(BIT_MASK(BTN_LEFT) |
> +		BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT));
> +
>  	input_set_abs_params(dev1, ABS_X, 0, max_coord, 0, 0);
>  	input_set_abs_params(dev1, ABS_Y, 0, max_coord, 0, 0);
> 
> 
> -- 
> Sun Microsystems GmbH        Michael Thayer
> Werkstrasse 24               VirtualBox engineer
> 71384 Weinstadt, Germany     mailto:michael.thayer@sun.com
> 
> Sitz der Gesellschaft:
> Sun Microsystems GmbH, Sonnenallee 1, 85551 Kirchheim-Heimstetten
> Amtsgericht Muenchen: HRB 161028
> Geschaeftsfuehrer: Thomas Schroeder, Wolfgang Engels, Wolf Frenkel
> Vorsitzender des Aufsichtsrates: Martin Haering
> 

-- 
Dmitry
