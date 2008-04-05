Return-Path: <linux-kernel-owner+w=401wt.eu-S1751764AbYDEEF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbYDEEF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 00:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYDEEFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 00:05:50 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:26003 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751193AbYDEEFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 00:05:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QHsgqAFgFNxaWGvKkd5wXuTVgL8WMcKItsqmGzdhRuFvmwbfPT95urRuv7M6nKQ0SCwutI1UXtiJxLuGYvH5ExKj4p0dq7wkCxAY/UKrShRovteiLnSwc7mfDGTYlWilYRU38/fLUvpV4D+3qo9xTaBvQgR95aa5O2MJaEDlkhs=  ;
X-YMail-OSG: UaqgEesVM1lo2fFRhM.XBo8kkH2r7.GNZkJWhR8foRJiFUIyLfTjuInmp4vfn0fomPbYn4OtNQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: userspace GPIO access (WAS: [patch/rfc 2/4] pcf875x ...)
Date: Fri, 4 Apr 2008 21:05:47 -0700
User-Agent: KMail/1.9.6
Cc: Trent Piepho <tpiepho@freescale.com>, Jean Delvare <khali@linux-fr.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>
References: <200710291809.29936.david-b@pacbell.net> <Pine.LNX.4.64.0804032014190.20532@t2.domain.actdsltmp> <1207285076.4082.75.camel@moss.renham>
In-Reply-To: <1207285076.4082.75.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804042105.47687.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008, Ben Nizette wrote:
> David, you're kinda the gatekeeper here; any input from you on which
> approach is to be preferred, essential features etc?

I won't much care about /dev/... vs /sys/... though I'd
probably have used sysfs myself (just because it's much
simpler and doesn't need to imply mdev/udev and classes).

The configuration part of each driver bothers me:

 - Mike's simple_gpio requires manual kernel config
   to set up the platform_device nodes ... and thus
   rules out the first usage scenarios I ever heard
   of for such a userspace mechanism.

 - Trent's gpio_class exposes all GPIOs, even ones
   that are claimed by kernel drivers ... and thus
   makes it easy to clobber kernel driver state.
   (Plus it won't work on most built-in GPIOs, since
   they by and large don't have parent devices.)

What I'd like to see is userspace config commands to
cause the gpio_request() ... *maybe* something like

    echo 42 foo 0 > .../gpio_config

	... causing error-checked versions of:

    gpio_request(42, "foo")
    gpio_direction_output(42, 0)

	... then some .../gpio42 file, read/write, appears

and

    echo 84 bar in > .../gpio_config

	... causing error-checked versions of:

    gpio_request(84, "bar")
    gpio_direction_input(84)

	... then some .../gpio84 file, read-only, appears

Though arguably the label could just always be "userspace"
(it's mostly for /sys/kernel/debug/gpio), and the default could
be to configure as an input (unless an output value was given).
Plus, there should be some way to cause gpio_free() too.

A potential advantage of the /dev/... node approach would be
that it's easier to support an IRQ-backed poll() mechanism
for inputs.

- Dave

