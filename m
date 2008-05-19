Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbYESUiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbYESUiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYESUhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:37:55 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:4756 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYESUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:37:53 -0400
Date: Mon, 19 May 2008 22:37:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 6/6] RTC: Trivially probe for an M41T80 (#2)
Message-ID: <20080519223718.3c89aa40@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805131759580.7267@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805130303430.535@cliff.in.clinika.pl>
	<20080513142829.2d737424@hyperion.delvare>
	<Pine.LNX.4.55.0805131759580.7267@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Wed, 14 May 2008 02:13:34 +0100 (BST), Maciej W. Rozycki wrote:
> > I don't like this. You are only supposed to declare in platform init
> > structures, I2C devices that you are sure are present. Relying on the
> > driver to not attach to the device if it is in fact not there sounds
> > wrong, because the I2C device will still be declared, so it's
> 
>  Well, the theory behind I2C addressing is no two devices should ever
> share the same location.  Now that being a mere 7-bit field (at least with
> standard devices) does not give too much of a chance for the lack of
> duplication being universally true.  However within a given system it is
> possible to arrange for no conflicts to be present and any given location
> to be possibly associated with a single type of device only.
> 
>  The end result of an optional device being declared and later on found by
> its driver not to be present should have no harm, should it?

As I wrote above: the I2C device will be listed as present forever. I
believe it's pretty confusing to have a device listed
under /sys/bus/i2c/devices which is in fact not present on the system.
On top of that, in case of modular setups with proper coldplug support,
the I2C device driver will be loaded automatically when the device is
declared, but will not be removed automatically when the probe fails,
so this is wasted memory.

> > confusing. Also, you consider that a driver silently failing to attach
> > is a feature, and in your specific case it may be, but for other users
> > it will be an annoyance: in the general case you want errors to be
> > clearly reported.
> 
>  The question is whether it actually is an error or not.  Assuming the
> configuration has been specified correctly, there are two cases possible
> -- either the device is missing or the device is faulty.  If the latter,
> an error should be reported.  If the former, it should or it should not.  
> Depending on whether it is expected or not.  If for example the device is
> meant to be there, but it has dropped off the PCB, then clearly it is an
> error condition; if it is a manufacturing option that was not included in
> this particular copy of the board, then it is expected and not a problem
> at all (of course in this case it is indistinguishable from a dropped off
> part).
> 
>  Not reporting errors for devices believed to be missing altogether would 
> be similar to what drivers for some other devices that do not report 
> themselves with identifiers do.  This is for example the case with most 
> ISA devices -- if pokes at I/O ports indicate the device is not there, the 
> driver quits silently.  Some do report they probe though.  Please note I 
> do not mean such a driver should quit with a success returned.

The comparison with ISA devices does not hold: ISA devices are created
by their own drivers (much like the legacy I2C device drivers.) Thus,
when the probe fails, they can simply delete the device they created (or
even better, they can delay the device creation until they are sure
that the device is there.) New-style I2C device drivers do not create
their devices, so they don't get a chance to delete them nor to delay
their creation.

> > If you are not sure that an I2C device will be present, then you should
> > not declare it as part of the I2C board info, but register it later
> > with i2c_new_probed_device(). If this isn't possible or not convenient,
> > then I'd rather add a probing variant of i2c_register_board_info() (or
> > maybe a new flag in i2c_board_info.flags) than hack all i2c drivers to
> > silent failures when devices are missing.
> 
>  Well, the SWARM can either have a ST M41T81 or a Xicor X1241 RTC.  It is
> a manufacturing option and either of these will be present and no other
> device will use the same address.  The presence of either is not recorded
> anywhere, because you can query the hardware directly to see which one is
> there -- there is no need to duplicate this information elsewhere, the
> firmware supports both and I do not think it has any hardcoded notion of
> what's on-board and what's not.  Note the M41T81 has a hardwired slave
> address of 0x68 -- there are no additional address select pins.  
> Similarly the RTC function of the X1241 only responds to 0x6f (and its
> EEPROM to 0x57).
> 
>  Then I am not sure how i2c_new_probed_device() could be used for a
> baseboard device.  With an option card bearing an I2C adapter it can be
> done at the time the card, including the adapter, is initialized.  With a
> baseboard adapter it really begs to be in board initialization.  It cannot
> be tied to i2c-sibyte.c, because it is a generic adapter driver -- the SOC
> can be used in any configuration, not just the SWARM and friends.  
> Perhaps it can be done with proper platform device initialization for the
> SWARM, but I fear it will not happen shortly.  Hmm...

It could certainly be implemented in terms of i2c_new_probed_device()
in i2c-sibyte, if it was a proper platform driver with proper platform
data. I admit it wouldn't be necessarily very elegant, in particular if
we have more similar cases in the future. That could still do for now,
though. Converting i2c-sibyte to a proper platform driver is needed
anyway.

>  The idea to have a flag along the lines of I2C_CLIENT_OPTION marking 
> the device may or may not be there in struct i2c_board_info seems 
> reasonable, perhaps better for some cases than i2c_new_probed_device() 
> even, as the lack of standardisation makes device-independent probes a bit 
> dangerous as already noted in the function.  Here the device driver itself 
> could perform probing in a known-safe way for the given device.

The flag in struct i2c_board_info would trigger the exact same probing
mechanism as i2c_new_probed_device() does. The whole point it to test
for the presence of the device _before_ its driver is loaded. It you
have to let the I2C device driver decide, then it's already too late:
the I2C device is created and it won't go even if the probe fails.

If said probing mechanism doesn't work properly for some devices, we'll
improve it, but it has to stay in i2c-core.

> (...)
>  Please note this change is not strictly required for the rest of the set
> to operate correctly on with an M41T81-equipped board, so let's perhaps
> pull this single patch out till we reach some consensus and proceed with
> the rest independently.

Agreed.

-- 
Jean Delvare
