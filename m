Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYDHJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYDHJdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYDHJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:33:12 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:32426 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752372AbYDHJdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:33:11 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-9.tower-164.messagelabs.com!1207647189!13911357!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Tue, 8 Apr 2008 11:33:05 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: gpio patches in mmotm
Message-ID: <20080408093305.GA8141@digi.com>
References: <20080317173134.GA27282@digi.com> <Pine.LNX.4.64.0803171915020.8640@axis700.grange> <20080318160316.GA31588@digi.com> <Pine.LNX.4.64.0803181717240.5022@axis700.grange> <20080408060230.GA22071@digi.com> <Pine.LNX.4.64.0804080812420.3556@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0804080812420.3556@axis700.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 08 Apr 2008 09:33:05.0989 (UTC) FILETIME=[8C97C750:01C8995B]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15836.006
X-TM-AS-Result: No--17.123700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Guennadi,

Guennadi Liakhovetski wrote:
> On Tue, 8 Apr 2008, Uwe Kleine-König wrote:
> 
> > > I'm storing the GPIO number locally, and if the system doesn't have a 
> > > valid GPIO for me, I'm storing an invalid GPIO number. Then at any time if 
> > > the GPIO has to be used, I just verify if gpio_is_valid(), and if not, 
> > > return an error code for this request, but the driver remains otherwise 
> > > functional.
> > OK, so in your driver you have:
> > 
> > 	if (gpio_is_valid(gpio)) {
> > 		/* We have a data bus switch. */
> > 		ret = gpio_request(gpio, "mt9m001");
> > 		if (ret < 0) {
> > 			dev_err(&mt9m001->client->dev, "Cannot get GPIO %u\n",
> > 				gpio);
> > 			return ret;
> > 		}
> > 		ret = gpio_direction_output(gpio, 0);
> > 		if (ret < 0) {
> > 			...
> > 
> > 
> > In my eyes the following is better:
> > 
> > 	/* Do we have a data bus switch? */
> > 	ret = gpio_request(gpio, "mt9m001");
> > 	if (ret < 0) {
> > 		if (ret != -EINVAL) {
> > 			dev_err(...);
> > 			return ret;
> > 		}
> > 	} else {
> > 		ret = gpio_direction_output(gpio, 0);
> > 		if (ret < 0) {
> > 			...
> 
> Yes, you could do that. But then you have to test either before calling 
> gpio_set_value_cansleep() or inside it. And the test you have to perform 
> _is_ the validity check, so, you need it anyway.
Ah, OK.  Before setting the value you must assert that you *requested* the
gpio (and not that it is valid).  In your driver that seems to be
equivalent.

Still I would prefer to store the information that the additional GPIO
is not available explicitly in the driver (e.g. by setting gpio = -1)
because gpio != -1 might be cheaper than gpio_is_valid(gpio).

And I don't like extending an API only to provide a second way to do
something without saving code or performance.

> > Then you don't need to extend the API.  Moreover with your variant the
> > check that gpio is valid must be done twice[1].
> 
> Actually three times. The one before gpio_free() is not actually needed, 
> right, it is anyway checked inside.
That's wrong.  gpio_free as provided by gpiolib does the check, the
variant of ns9xxx does not.  I think it's not explicit, but as gpio_free
must only be called on a requested gpio, I don't see why this check
should be done by gpio_free.

>                                     But gpio_set_value_cansleep() doesn't 
> check, so, it would be rude to call it with an invalid value.
> 
> > [1] OK, gpio_is_valid and gpio_request might be inline functions, but
> > for "my" architecture it is not.
> 
> Which arch is it?
arch/arm/mach-ns9xxx.  It's not (yet) fully supported in vanilla, but it
includes support for different SOCs that have a different handling of
their GPIOs.  E.g. the ns9360 has one gpio configuration register per 8
gpios, the ns9215 has one per 4 gpios.  Or another thing: ns9215 has
108 gpios, ns9210 has only 54 where the first 50 gpios are identical to
the first 50 of ns9215, and the last 4 gpios are identical to gpios
105-108 on ns9215.  So gpio_is_valid for ns9xxx has to look like:

	int gpio_is_valid(int gpio)
	{
		...
		if (processor_is_ns9210())
			return gpio >= 0 && gpio < 108 && !(gpio >= 50 && gpio < 105);
		...
	}

(In my eyes that hole is ugly, but with it can calculate the address of
the configuration register without case splitting and can handle ns9215
and ns9210 identically---apart from the is-valid check.)

If you're deeper interested you can compare
- http://ftp1.digi.com/support/documentation/90000675_C.pdf (ns9360);
- http://ftp1.digi.com/support/documentation/90000847_B.pdf (ns9215);
  and
- http://ftp1.digi.com/support/documentation/90000846_B.pdf (ns9210).

>                   As I said, you could simplify the two specific camera 
> drivers by removing the checks where they are redundant. But on other 
> occasions the checks have to be done anyway, so, it is not a question of 
> runtime performance (apart from maybe the difference between calling a 
> function and executing inline), but just of an extra API member, which you 
> can have different opinions about:-)
So you reason that the alternative approach allows only a slight
simplification and so is not worth considering?  But obviously
yes, I have a different opinion. :-)

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
