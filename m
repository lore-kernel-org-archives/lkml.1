Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbYG0EF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbYG0EF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 00:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYG0EEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 00:04:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:26712 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbYG0EEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 00:04:45 -0400
Date: Sat, 26 Jul 2008 20:21:16 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Trent Piepho <tpiepho@freescale.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] leds: Support OpenFirmware led bindings
Message-ID: <20080727022116.GN12191@secretlab.ca>
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp> <1217019705-24244-2-git-send-email-tpiepho@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217019705-24244-2-git-send-email-tpiepho@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 02:01:45PM -0700, Trent Piepho wrote:
> Add bindings to support LEDs defined as of_platform devices in addition to
> the existing bindings for platform devices.

(adding devicetree-discuss@ozlabs.org to the cc list)

> New options in Kconfig allow the platform binding code and/or the
> of_platform code to be turned on.  The of_platform code is of course only
> available on archs that have OF support.
> 
> The existing probe and remove methods are refactored to use new functions
> create_gpio_led(), to create and register one led, and delete_gpio_led(),
> to unregister and free one led.  The new probe and remove methods for the
> of_platform driver can then share most of the common probe and remove code
> with the platform driver.
> 
> The suspend and resume methods aren't shared, but they are very short.  The
> actual led driving code is the same for LEDs created by either binding.

I like this approach.  I think it is a good pattern.

> The OF bindings are based on patch by Anton Vorontsov
> <avorontsov@ru.mvista.com>.  They have been extended to allow multiple LEDs
> per device.
> 
> Signed-off-by: Trent Piepho <tpiepho@freescale.com>
> ---
>  Documentation/powerpc/dts-bindings/gpio/led.txt |   44 ++++-
>  drivers/leds/Kconfig                            |   21 ++-
>  drivers/leds/leds-gpio.c                        |  225 ++++++++++++++++++-----
>  3 files changed, 236 insertions(+), 54 deletions(-)
> 
> diff --git a/Documentation/powerpc/dts-bindings/gpio/led.txt b/Documentation/powerpc/dts-bindings/gpio/led.txt
> index ff51f4c..ed01297 100644
> --- a/Documentation/powerpc/dts-bindings/gpio/led.txt
> +++ b/Documentation/powerpc/dts-bindings/gpio/led.txt
> @@ -1,15 +1,39 @@
> -LED connected to GPIO
> +LEDs connected to GPIO lines
>  
>  Required properties:
> -- compatible : should be "gpio-led".
> -- label : (optional) the label for this LED. If omitted, the label is
> -  taken from the node name (excluding the unit address).
> -- gpios : should specify LED GPIO.
> +- compatible : should be "gpio-leds".
>  
> -Example:
> +Each LED is represented as a sub-node of the gpio-leds device.  Each
> +node's name represents the name of the corresponding LED.
>  
> -led@0 {
> -	compatible = "gpio-led";
> -	label = "hdd";
> -	gpios = <&mcu_pio 0 1>;
> +LED node properties:
> +- gpios :  Should specify the LED GPIO.

Question: it is possible/desirable for a single LED to be assigned
multiple GPIO pins?  Say, for a tri-color LED?  (I'm fishing for
opinions; I really don't know if it would be a good idea or not)

> +- label :  (optional) The label for this LED.  If omitted, the label
> +  is taken from the node name (excluding the unit address).
> +- function :  (optional) This parameter, if present, is a string
> +  defining the function of the LED.  It can be used to put the LED
> +  under software control, e.g. Linux LED triggers like "heartbeat",
> +  "ide-disk", and "timer".  Or it could be used to attach a hardware
> +  signal to the LED, e.g. a SoC that can configured to put a SATA
> +  activity signal on a GPIO line.

This makes me nervous.  It exposes Linux internal implementation details
into the device tree data.  If you want to have a property that
describes the LED usage, then the possible values and meanings should be
documented here.

> +	memset(&led, 0, sizeof(led));
> +	for_each_child_of_node(np, child) {
> +		led.gpio = of_get_gpio(child, 0);
> +		led.name = of_get_property(child, "label", NULL) ? : child->name;

> +		led.default_trigger =
> +			of_get_property(child, "linux,default-trigger", NULL);

This isn't in the documented binding.  I assume that you mean 'function'
here?

Otherwise, the code looks pretty good to me.

g.

