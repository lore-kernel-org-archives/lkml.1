Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbYDHG2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYDHG2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 02:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYDHG2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 02:28:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:35379 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751213AbYDHG2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 02:28:35 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18AsiNFr50AAhpnwmj/0UcdllR/soV2MpNKxKdsVe
	HqvnCezSDajihI
Date: Tue, 8 Apr 2008 08:28:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: gpio patches in mmotm
In-Reply-To: <20080408060230.GA22071@digi.com>
Message-ID: <Pine.LNX.4.64.0804080812420.3556@axis700.grange>
References: <20080317173134.GA27282@digi.com> <Pine.LNX.4.64.0803171915020.8640@axis700.grange>
 <20080318160316.GA31588@digi.com> <Pine.LNX.4.64.0803181717240.5022@axis700.grange>
 <20080408060230.GA22071@digi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Uwe Kleine-König wrote:

> > I'm storing the GPIO number locally, and if the system doesn't have a 
> > valid GPIO for me, I'm storing an invalid GPIO number. Then at any time if 
> > the GPIO has to be used, I just verify if gpio_is_valid(), and if not, 
> > return an error code for this request, but the driver remains otherwise 
> > functional.
> OK, so in your driver you have:
> 
> 	if (gpio_is_valid(gpio)) {
> 		/* We have a data bus switch. */
> 		ret = gpio_request(gpio, "mt9m001");
> 		if (ret < 0) {
> 			dev_err(&mt9m001->client->dev, "Cannot get GPIO %u\n",
> 				gpio);
> 			return ret;
> 		}
> 		ret = gpio_direction_output(gpio, 0);
> 		if (ret < 0) {
> 			...
> 
> 
> In my eyes the following is better:
> 
> 	/* Do we have a data bus switch? */
> 	ret = gpio_request(gpio, "mt9m001");
> 	if (ret < 0) {
> 		if (ret != -EINVAL) {
> 			dev_err(...);
> 			return ret;
> 		}
> 	} else {
> 		ret = gpio_direction_output(gpio, 0);
> 		if (ret < 0) {
> 			...

Yes, you could do that. But then you have to test either before calling 
gpio_set_value_cansleep() or inside it. And the test you have to perform 
_is_ the validity check, so, you need it anyway.

> Then you don't need to extend the API.  Moreover with your variant the
> check that gpio is valid must be done twice[1].

Actually three times. The one before gpio_free() is not actually needed, 
right, it is anyway checked inside. But gpio_set_value_cansleep() doesn't 
check, so, it would be rude to call it with an invalid value.

> [1] OK, gpio_is_valid and gpio_request might be inline functions, but
> for "my" architecture it is not.

Which arch is it? As I said, you could simplify the two specific camera 
drivers by removing the checks where they are redundant. But on other 
occasions the checks have to be done anyway, so, it is not a question of 
runtime performance (apart from maybe the difference between calling a 
function and executing inline), but just of an extra API member, which you 
can have different opinions about:-)

Thanks
Guennadi
---
Guennadi Liakhovetski
