Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0CIAvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:51:14 -0500
Received: from LION.seas.upenn.edu ([158.130.12.194]:49224 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab0CIAvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:51:12 -0500
Message-ID: <4B959B69.80705@seas.upenn.edu>
Date: Mon, 08 Mar 2010 19:50:49 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100222 Thunderbird/3.0.1
MIME-Version: 1.0
To: mickib1@gmail.com
CC: jkosina@suse.cz, chatty@enac.fr, peterhuewe@gmx.de, micki@n-trig.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       rafi@seas.upenn.edu
Subject: Re: [PATCH 1/7] HID: N-trig MTM Driver fix and cleanup patch 1
References: <1268082827-2680-1-git-send-email-micki@n-trig.com>
In-Reply-To: <1268082827-2680-1-git-send-email-micki@n-trig.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 04:13 PM, mickib1@gmail.com wrote:
> From: micki<micki@micki-laptop.(none)>
>
> Add Change Log and defines of MTM firmware.
> Add debug Paramater change Driver name in hid_driver structure
>
> N-trig is changing the way people interact with computers by providing a dual-mode pen and true multi-touch input device, specifically designed for today's advanced computing world.
> N-trig DuoSense® solution provides a real Hands-on computing® experience, and sets the stage for OEMs and ISVs to introduce innovative computer products and applications for an intuitive, Hands-on® experience directly onscreen.
> DuoSense digitizers are easily integrated into existing technologies, support all LCDs, keep devices slim and light, and can be implemented in a broad range of products, ranging from small notebooks to large LCDs.
> N-trig has offices in Israel, the US, Taiwan and Japan.

Is that just in your .sig?

> Signed-off-by: Micki Balanga<micki@n-trig.com>
> ---
>   drivers/hid/hid-ntrig.c |   94 ++++++++++++++++++++++++++++++++++++++++++++--
>   1 files changed, 89 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> index 3234c72..e99342d 100644
> --- a/drivers/hid/hid-ntrig.c
> +++ b/drivers/hid/hid-ntrig.c
> @@ -3,7 +3,18 @@
>    *
>    *  Copyright (c) 2008 Rafi Rubin
>    *  Copyright (c) 2009 Stephane Chatty
> + *  Copyright (c) 2010 N-TRIG
>    *
> + *	1.0 - Rafi Rubin ( Version From 2010-02-13 02:13:05)
> + *		This cleans up the identification of multitouch
> + *		groups and enables the end of group sync.
> + *		Taps are now explicitly handled to adjust for the changes in the
> + *		event stream in multitouch mode.
> + *		Added triple and quad tap for the benefit of
> + *		tools that recognize different tap types but
> + *		do not have full multi touch support.
> + *	1.1 - N-trig - Add Change Log and defines of MTM firmware.
> + *		Add debug Paramater change Driver name in hid_driver structure
>    */

I don't know that the change log needs to be in the code file itself. 
The point was more that your commit messages should give us an idea 
about what your changing.  Jiri, what's your take on that?

> +/*
> + * Pen Event Field Declaration
> + */
> +#define	EVENT_PEN_TIP		0x03
> +#define	EVENT_PEN_RIGHT		0x05
> +#define	EVENT_TOUCH_PEN		0x07
> +#define EVENT_PEN_IN_RANGE	0x01

You still haven't actually established why its necessary to fuss with 
pen events if we split the pen off to a separate input device.

> +/*
> + * MTM 4 last bytes of report descriptor
> + */
> +#define REPORT_GENERIC1		0x01
> +#define REPORT_MT		0x02
> +#define REPORT_PALM		0x03
> +#define REPORT_GENERIC2		0x04

When its not too inconvenient, it would be better to put defines in the 
patches where you actually use them.  I know these are actually useful, 
but if we stop here they aren't actually used.


> +#define NTRIG_USB_DEVICE_ID	0x0001
Already defined in hid-ids.h



> +
> +/*
> + * MTM fields
> + */
> +#define PEN_REPORT_SIZE		0x48

The report seems to specifically identify itself.  Why not use that 
clear identification instead of something less clear that may change in 
the future (even if there are no plans at the moment).  If nothing else 
this relieves a little pressure on your hardware/firmware designers.

 From the rdesc of my screen in the debug fs:
INPUT(1)[INPUT]
     Field(0)
       Physical(Digitizers.Stylus)

Paraphrasing ntrig_probe from 2.6.33:

   list_for_each_entry(hidinput, &hdev->inputs, list)
	switch (hidinput->report->field[0]->application)
	case  HID_DG_PEN:
		input->name = "N-Trig Pen";
		break;
	case HID_DG_TOUCHSCREEN:

Note that in this one case I do use this to identify the report, and 
thus need to pick a field which you could argue is a potential hazard, 
but you haven't made that point.  So please tell us what's wrong with 
this before you toss it out for something different.

> +#define MAX_FINGERS_SUPPORT	0x06

Again, is it really a good idea to keep this quantity fixed?  Especially 
in light of the press release that suggests your company is considering 
devices that support more fingers.

> +#define END_OF_REPORT		0x64

I should comment where you put the code that uses this, but you put them 
in separate patches.

I don't see why you tie up a group of contacts by emitting TRACKING_ID 
0x64.  The group should already by wrapped up with an input_sync, which 
you have.  Therefore this extra event doesn't actually provide any 
additional information.  Furthermore, sending a bogus tracking id may 
upset other user space tools.

> +/*
> + * Dummy Finger Declaration
> + */
> +#define X_CORD_VAL		0x00
> +#define Y_CORD_VAL		0x00
> +#define DX_CORD_VAL		0xFA
> +#define DY_CORD_VAL		0x96
> +#define GENERIC_BYTE_VAL	0x0D

The naming of these constants seems a little messy.  Perhaps something 
more like "DUMMY_X, DUMMY_DX"....

> +#define MTM_FRAME_INDEX		0xff000001
> +#define MTM_PROPROETARY		0xff000002

Thank you, we should have named these constants earlier.

> +#define MODULE_NAME "hid_ntrig"
> -	.name = "ntrig",

I left off the "hid_" prefix based on what I saw in the other hid 
drivers.  Jiri, is there a standard to follow or do you have an opinion 
about this?

Rafi
