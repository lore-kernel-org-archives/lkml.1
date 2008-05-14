Return-Path: <linux-kernel-owner+w=401wt.eu-S1760800AbYENBPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800AbYENBPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758177AbYENBPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:15:24 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62423 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751228AbYENBPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:15:22 -0400
Date: Wed, 14 May 2008 02:13:34 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 6/6] RTC: Trivially probe for an M41T80 (#2)
In-Reply-To: <20080513142829.2d737424@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805131759580.7267@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805130303430.535@cliff.in.clinika.pl>
 <20080513142829.2d737424@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> I don't like this. You are only supposed to declare in platform init
> structures, I2C devices that you are sure are present. Relying on the
> driver to not attach to the device if it is in fact not there sounds
> wrong, because the I2C device will still be declared, so it's

 Well, the theory behind I2C addressing is no two devices should ever
share the same location.  Now that being a mere 7-bit field (at least with
standard devices) does not give too much of a chance for the lack of
duplication being universally true.  However within a given system it is
possible to arrange for no conflicts to be present and any given location
to be possibly associated with a single type of device only.

 The end result of an optional device being declared and later on found by
its driver not to be present should have no harm, should it?

> confusing. Also, you consider that a driver silently failing to attach
> is a feature, and in your specific case it may be, but for other users
> it will be an annoyance: in the general case you want errors to be
> clearly reported.

 The question is whether it actually is an error or not.  Assuming the
configuration has been specified correctly, there are two cases possible
-- either the device is missing or the device is faulty.  If the latter,
an error should be reported.  If the former, it should or it should not.  
Depending on whether it is expected or not.  If for example the device is
meant to be there, but it has dropped off the PCB, then clearly it is an
error condition; if it is a manufacturing option that was not included in
this particular copy of the board, then it is expected and not a problem
at all (of course in this case it is indistinguishable from a dropped off
part).

 Not reporting errors for devices believed to be missing altogether would 
be similar to what drivers for some other devices that do not report 
themselves with identifiers do.  This is for example the case with most 
ISA devices -- if pokes at I/O ports indicate the device is not there, the 
driver quits silently.  Some do report they probe though.  Please note I 
do not mean such a driver should quit with a success returned.

> If you are not sure that an I2C device will be present, then you should
> not declare it as part of the I2C board info, but register it later
> with i2c_new_probed_device(). If this isn't possible or not convenient,
> then I'd rather add a probing variant of i2c_register_board_info() (or
> maybe a new flag in i2c_board_info.flags) than hack all i2c drivers to
> silent failures when devices are missing.

 Well, the SWARM can either have a ST M41T81 or a Xicor X1241 RTC.  It is
a manufacturing option and either of these will be present and no other
device will use the same address.  The presence of either is not recorded
anywhere, because you can query the hardware directly to see which one is
there -- there is no need to duplicate this information elsewhere, the
firmware supports both and I do not think it has any hardcoded notion of
what's on-board and what's not.  Note the M41T81 has a hardwired slave
address of 0x68 -- there are no additional address select pins.  
Similarly the RTC function of the X1241 only responds to 0x6f (and its
EEPROM to 0x57).

 Then I am not sure how i2c_new_probed_device() could be used for a
baseboard device.  With an option card bearing an I2C adapter it can be
done at the time the card, including the adapter, is initialized.  With a
baseboard adapter it really begs to be in board initialization.  It cannot
be tied to i2c-sibyte.c, because it is a generic adapter driver -- the SOC
can be used in any configuration, not just the SWARM and friends.  
Perhaps it can be done with proper platform device initialization for the
SWARM, but I fear it will not happen shortly.  Hmm...

 The idea to have a flag along the lines of I2C_CLIENT_OPTION marking 
the device may or may not be there in struct i2c_board_info seems 
reasonable, perhaps better for some cases than i2c_new_probed_device() 
even, as the lack of standardisation makes device-independent probes a bit 
dangerous as already noted in the function.  Here the device driver itself 
could perform probing in a known-safe way for the given device.

 And last but not least, this whole consideration may actually not matter
anymore as I have yet to encounter a SWARM or similar board featuring an
X1241 rather than an M41T81.  While no piece of documentation mentions it
(all the board documents simply state either of the RTC chips is present)  
I think X1241 chips were used for older revisions of the board which had
serious errata in the BCM1250A SOC requiring gross changes to GCC to get a
working kernel.  These changes were never pushed upstream and the old
version of the compiler they were intended for is no longer capable of
building Linux.  Therefore chances are there is no way to get a board with
the X1241 running under Linux.  And perhaps the antiquated support for the
X1241 that we have could be entirely dropped and the M41T81 assumed as a
fixture for these boards.

 Anybody cares to comment on the last paragraph?

 Please note this change is not strictly required for the rest of the set
to operate correctly on with an M41T81-equipped board, so let's perhaps
pull this single patch out till we reach some consensus and proceed with
the rest independently.

  Maciej
