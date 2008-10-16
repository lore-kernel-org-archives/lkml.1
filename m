Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYJPE3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYJPE3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 00:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYJPE3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 00:29:17 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:43194 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYJPE3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 00:29:16 -0400
Date: Thu, 16 Oct 2008 06:29:09 +0200
From: Arjan Opmeer <arjan@opmeer.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: akpm@linux-foundation.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20081016042909.GA12122@adopmeer.homeip.net>
References: <20080914032344.GA16228@adopmeer.homeip.net> <20080919041727.GB7594@core.corenet.prv> <20080919070530.GA7599@adopmeer.homeip.net> <20081016030515.GA28113@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016030515.GA28113@amd.corenet.prv>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [PATCH] input: Update Elantech touchpad driver to v5 for
	kernel 2.6.27-rc5-mm1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dmitry,

On Wed, Oct 15, 2008 at 11:05:15PM -0400, Dmitry Torokhov wrote:
> > 
> > As far as I know the touchpad does not report pressure
> 
> I see. In this case the driver should not really report ABS_PRESSURE but
> only BTN_TOUCH. I understand that this would require synaptics X driver
> changes but that should be OK. I wrote a patch to the X driver which seems
> to be working if I bastardize my synaptics touchpad but I would like to
> have it tested with real Elantech device. I am attaching the version of
> Elantech driver that I want to apply (there were some timy changes) and
> the patch to teh Synaptics X driver (against recent git pull from its
> repository). If you could give it a try that would be grand.

Well, there we have a problem. My laptop with the Elantech touchpad died. So
I no longer have any hardware to try your changes on!

Maybe we should just put the code out there and see what happens?


As I was reading over the patch I found some small things you might want to
change.

> dropped (users wishing to use touchpad in relative mode can use
> standard PS/2 protocol emilation done in hardware). The driver
                         ^^^^^^^^^ emulation

> +	case 2:
> +		/* We don't now how to check parity in protocol v2 */
                            ^^^ know

> +		/*
> +		 * Read back reg 0x10. The touchpad is probably initalising
> +		 * and not ready until we read back the value we just wrote.
> +		 */

Although the fact that we can read back the registers contents means we
didn't jam the touchpad EC by initialising with the wrong register values
earlier, it occured to me that we never actually test the value we read
back.

> +		do {
> +			rc = elantech_read_reg(psmouse, 0x10, &val);
> +			if (rc == 0)

Shouldn't this read

   if (rc == 0 && val == etd->reg 10)

?

> +	for (i = 1; i < 256; i++)
> +		etd->parity[i] = (etd->parity[i & (i - 1)] ^ 1);
                                 ^                            ^
Why did I put these parentheses there?

> +	/*
> +	 * Assume every version greater than this is new EeePC style
> +	 * hardware with 6 byte packets
> +	 */
> +	if ((etd->fw_version_maj >= 0x02) && (etd->fw_version_min >= 0x30)) {

In your quest of removing parentheses don't you want to remove these ones too?
:)

> +/*
> + * Try Elantech touchpad.
> + */
> +	if (max_proto > PSMOUSE_IMEX && 
> +			elantech_detect(psmouse, set_properties) == 0) {
> +		if (!set_properties || elantech_init(psmouse) == 0)
> +			return PSMOUSE_ELANTECH;

I see you moved the Elantech detection up. I put it after the pmouse_reset
on purpose as a safety measure because when initially developing the driver
I managed to get the touchpad all confused and not responding properly to
its magic knock. However this was using the serio_raw interface, so it might
not be necessary in this case.


Arjan
