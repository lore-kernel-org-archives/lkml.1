Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0CHBnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 20:43:52 -0500
Received: from LION.seas.upenn.edu ([158.130.12.194]:37009 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0CHBnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 20:43:45 -0500
Message-ID: <4B94541C.5090509@seas.upenn.edu>
Date: Sun, 07 Mar 2010 20:34:20 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Micki Balanga <micki@n-trig.com>
CC: jkosina@suse.cz, chatty@enac.fr, peterhuewe@gmx.de,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: N-trig Finger Pen Multitouch fix
References: <48A28051AC6D7A48B64F28272458190301AF29@Exchange-IL.n-trig.com>
In-Reply-To: <48A28051AC6D7A48B64F28272458190301AF29@Exchange-IL.n-trig.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

First let me thank you for contributing to the development of this driver.


I suggest you use scripts/checkpatch.pl it will catch a number of style issues.
 Dmitry was kind enough to point it out when I sent in my recent set of patches.


Mostly it looks like this patch is the delta from an almost completely
independently developed driver.  That makes it considerably more work to analyze
the fundamental differences.  I would have preferred to see a set of patches
which first mutate the existing code to match your naming conventions (if that
is so desired) and then patches that show how things are actually different (A
lesson I've learned the hard way).

I see quite a number of changes that handle the protocol better than my version,
would you be offended if I begin to absorb those and submit joint patches?  I'm
not sure about the proper etiquette for that.


On 03/07/10 14:04, Micki Balanga wrote:
> The purpose of this patch is to enable Linux users to experience the
> complete N-trig DuoSense pen and true multi-touch solution capabilities
> over a Linux platform. This driver has been carefully and thoroughly
> tested by N-trig, over a period of several months.

What user space tools have you tested this driver with?  It does not seem to
work well with the wacom and evdev drivers.

What improvements beyond the driver that's in 2.6.33 are you targeting?


> + * The driver will support MTM firwmare Pen, Finger (Up to 6)

Is this code intended to support older firmwares as well?  It would be best not
to break the driver for users with legacy firmwares without reason.


> +#define PEN_REPORT_SIZE                0x48
> +#define MAX_FINGERS_SUPPORT    0x06

Are these guaranteed to be kept constant for the foreseeable future?  I've
already seen hints that N-Trig may move to 10+ fingers in the not to distant future.

http://www.n-trig.com/Content.aspx?Page=PressReleases&PressReleaseId=541

I was starting to move to non-fixed finger limits before I pulled the finger
tracking code.

> -       if (field->application == HID_DG_PEN)
> -               return 0;

> +               if (PEN_REPORT_SIZE == field->report->size) {

What was wrong with using field->application to detect the pen?  On a side note,
after splitting the touch and pen events to separate input devices, I found that
the pen events conform quite well to the hid spec and don't need special
handling.  Is there something I missed?



> +#define MODULE_NAME "hid_ntrig"
> +
> +
> +#define info(format, arg...) \
> +       printk(KERN_INFO "%s: " format , MODULE_NAME , ## arg)
> +#define ntrig_dbg(format, arg...) \
> +       do { \
> +               if (debug) \
> +                       printk(KERN_DEBUG "%s: " format, \
> +                       MODULE_NAME , ## arg); \
> +       } while (0)

>  static struct hid_driver ntrig_driver = {
>         .name = "ntrig",

Might want to use the #define for that too.


> +                       case HID_DG_CONTACTCOUNT:
> +                               nt_rpt->real_fingers = value;
> +                               nt_rpt->fake_fingers =
> MAX_FINGERS_SUPPORT - value;

> +                                               if (MAX_FINGERS_SUPPORT
> == nt_rpt->fake_fingers--) {

Would you care to explain "fake_fingers"?  I'm not really seeing why it helps
when you already have real_fingers.  It looks like you use that to detect some
ghost events, but really again, fingers should be fine at that point.

That does remind me that I pulled that special case when I cleaned up my last
patch set and forgot to put it back.

Are the fake finger events intentional or just a bug?

> -               case HID_DG_PEN:
> -                       input->name = "N-Trig Pen";
> -                       break;
> -               case HID_DG_TOUCHSCREEN:
> -                       input->name =
> -                               (hidinput->report->field[0]
> -                                ->physical) ?
> -                               "N-Trig Touchscreen" :
> -                               "N-Trig MultiTouch";

Do you have something against the device naming, or did you delete that
unintentionally?

> +                     /*
> +                      * These command will implement later accroding to
> demand
> +                      */
> +               case REPORTID_SET_MODE_DUAL:    /* FALLTHRU */
> +               case REPORTID_CALIBRATION:      /* FALLTHRU */
> +               case REPORTID_GET_VERSION:      /* FALLTHRU */
> +               case REPORTID_GET_MODE:         /* FALLTHRU */
> +               case REPORTID_SET_MODE_PEN:     /* FALLTHRU */
> +               case REPORTID_SET_MODE_TOUCH:   /* FALLTHRU */
> +               case REPORTID_CALIBRATION_RESPOND:/* FALLTHRU */
> +               case HID_CAPACITORS_CALIB:      /* FALLTHRU */
> +               case HID_GET_CAPACITORS_CALIB_DONE:

Getting the firmware version would be my top priority, its been on my list of
things to write for months.  I'd like to see the firmware version printed when
the module is loaded and available through sysfs.

I've heard a few people complain about calibration, but most users, including
myself, have not seen any calibration issues.

Any chance of getting a tool to install firmware updates?



Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkuUVBkACgkQwuRiAT9o60+htACgt+S+ON/9GWwXP+dliEU9GdQN
TaoAoPUW4Ndlfg0MAWnoEcg4H1ZHU1VO
=NQkb
-----END PGP SIGNATURE-----
