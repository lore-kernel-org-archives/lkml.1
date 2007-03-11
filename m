Return-Path: <linux-kernel-owner+w=401wt.eu-S933052AbXCKEbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbXCKEbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 23:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933055AbXCKEbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 23:31:37 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:38132 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933052AbXCKEbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 23:31:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=suRmoUkxD6P+LqLoarbn/MLoVAwM6s0JTYWlDrpMoXfbgsD5JMUI7wWJhfUtw1eA270cCrvQVNRs857xfKoPdCXzGMZzr0u3y4xMpomptSvkjgrWjRj/RaowggUMAAtEXrre/KIvF7G3041sAZbvvsgSAvi2+U1lSfRSNQAFXCA=  ;
X-YMail-OSG: wdOGlvoVM1k62RvxfFAr5sRezwtf2ckjhpUDFPYzJJnsGfDP0Dk7o6XNeyZxsBGkAvAn2YwAishCocx.RK87EEabuEgPx3PpmGTXVHN6mOrxfXb.Pq2NANlrGqdcFnw71Te5tMHTO9DhIFc-
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v2] Bitbanging i2c bus driver using the GPIO API
Date: Sat, 10 Mar 2007 20:31:32 -0800
User-Agent: KMail/1.7.1
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
References: <200703091345.44744.david-b@pacbell.net> <11735324081261-git-send-email-hskinnemoen@atmel.com> <20070310211550.c694555d.khali@linux-fr.org>
In-Reply-To: <20070310211550.c694555d.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703102031.34186.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2007 12:15 pm, Jean Delvare wrote:
> Hi Haavard,
> 
> On Sat, 10 Mar 2007 14:13:28 +0100, Haavard Skinnemoen wrote:
> > This is a very simple bitbanging i2c bus driver utilizing the new
> > arch-neutral GPIO API. Useful for chips that don't have a built-in
> > i2c controller, additional i2c busses, or testing purposes.

This updated version looks a lot better.  However it doesn't address
the API change -- gpio_direction_output(gpio, initial_value) -- which
is understandable since that patch hasn't yet merged.


> I like the idea very much. Would this let us get rid of i2c-ixp2000?
> i2c-ixp4xx? scx200_i2c? Other drivers?

There's CONFIG_GENERIC_GPIO support for ixp4xx (nyet upstream, ISTR it's
waiting on the gpio_direction_output update), so that one should be
particularly easy to replace.  Presumably some other bitbang drivers
could vanish before long too.


> What value will you get if the SDA pin is open-drain and currently in
> output mode?

For output GPIOs, gpio_get_value() is specified to either return the
actual value at the pin ... or zero, if the hardware can't do that.
Most GPIO pins *can* do that.  (Specifically, that's how AT91 GPIOs
work, open drain or otherwise.)

(However, there can be various latencies involved.  On one chip
when I wrote the output value, then immediately read it back, I
got the old value.  Reason:  the GPIO controller clock needed
to tick first in order to latch the new input value!  It was only
about 30 MHz, so the back-to-back instructions were too fast.  You
can also sometimes notice capacitance causing similar delays.
Of course those latencies apply regardless of pin direction.)

I think Haavard is assuming the GPIO actually returns that value,
since otherwise there'd be no point in trying to use the open drain
mode.  It'd be worth capturing that in the i2c-gpio.h definition
for that struct.


> Are such GPIO pins actually able to detect that the pin is 
> low while they are not themselves driving it low?

Given a "yes" to the above, then clearly "yes" here too.  As
I noted, if it can't actually sense the value at the pin, that
function should always return zero.

- Dave

