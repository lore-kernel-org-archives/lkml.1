Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXJ3Bz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXJ3Bz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 21:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbXJ3BzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 21:55:10 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:39796 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752124AbXJ3BzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 21:55:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=IVCrRXQl7Mkv3t4+ovweCpnqArNWww0Q1mmTUObABdG1/rhOEsPtxJNWxq5uvQ4oA0J2UJEexFw0CgLkRE+CLO081qtshRLN6xsWP8g7S0IgM57wB0qcbGX9u6vydca3+/vnj3caWf3sDe1T3ljhy3PGn23HAadL1QN+33q6SHc=  ;
X-YMail-OSG: iTbSiMsVM1lrG8jR7OoJAQdvwmVzXLHzEh4v3EjrPojeVAFOO3eu.33ovJCcdC.DjysTzLUG5Q--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch/rfc 0/4] GPIO implementation framework
Date: Mon, 29 Oct 2007 18:50:12 -0700
User-Agent: KMail/1.9.6
Cc: Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, Tony Lindgren <tony@atomide.com>,
       Jean Delvare <khali@linux-fr.org>, "eric miao" <eric.y.miao@gmail.com>,
       Kevin Hilman <khilman@mvista.com>, Paul Mundt <lethal@linux-sh.org>,
       Ben Dooks <ben@trinity.fluff.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710291850.13061.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When we hashed out the Documentation/gpio.txt GPIO programming
interfaces last year, there were a few features in the "we want
this eventually, but can live without it for now" category.
Following this post are patches adding some of those features.

Two core patches are:

 - Implementation framework in lib/gpiolib.c ... the interface
   provided to GPIO _users_ is unchanged, but providers can now
   hook up through a "gpio_chip" that lets multiple types of
   GPIO provider coexist.  Examples:  SOC-native GPIOs, ones
   provided by an FPGA, I2C or SPI GPIO expanders, etc.

   (I'm thinking this is pretty much ready to merge into MM,
   unless someone turns up a blocking issue...)

 - I2C driver for common pcf8574/8575 GPIO expanders ... these
   are pretty common on embedded hardware, and it's routine for
   external trees to have ugly board-specific hacks exposing
   those GPIOs to drivers.  Unlike such hacks, I think support
   using standard GPIO calls should be mergable upstream.

   (IMO this is ready to merge too, although I know Jean would
   like additional infrastructure which could let us obsolete
   existing drivers, instead of just offering an alternative for
   systems that need kernel access instead of userspace access.)

Two more patches show how they can be used:

 - Platform conversion for DaVinci ... making the SOC-native
   GPIOs plug in through gpiolib instead of directly, except
   when callers can leverage the inline optimization.

 - Board conversion (partial) for DaVinci EVM ... exposing
   the LEDs hooked up to one pcf8574a chip using leds-gpio,
   along with the A/V clocks (and a random user switch) on
   another pcf chip.  A third pcf chip isn't converted; it'd
   mean changing half a dozen drivers, none of which are yet
   upstream.

If the gpiolib patch merges into MM, then I think it'd be
realistic to expect some platforms and boards to be using
this new infrastructure in 2.6.25 ...

- Dave

