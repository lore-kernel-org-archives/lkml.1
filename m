Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYDHGCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYDHGCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 02:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYDHGCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 02:02:36 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:20748 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751276AbYDHGCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 02:02:35 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-29.messagelabs.com!1207634554!682746!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Tue, 8 Apr 2008 08:02:30 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: gpio patches in mmotm
Message-ID: <20080408060230.GA22071@digi.com>
References: <20080317173134.GA27282@digi.com> <Pine.LNX.4.64.0803171915020.8640@axis700.grange> <20080318160316.GA31588@digi.com> <Pine.LNX.4.64.0803181717240.5022@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0803181717240.5022@axis700.grange>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 08 Apr 2008 06:02:31.0335 (UTC) FILETIME=[21C09370:01C8993E]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15836.005
X-TM-AS-Result: No--23.593000-8.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Guennadi,


Guennadi Liakhovetski wrote:
> Please, do not trim the CC: list. I've also added lkml.
Oh, thanks.  I thought I'm used to hitting reply-to-all 8-(.
I also added Andrew back (even though adding lkml might be just as good.
:-))

> On Tue, 18 Mar 2008, Uwe Kleine-KЖnig wrote:
> > Guennadi Liakhovetski wrote:
> > > On Mon, 17 Mar 2008, Uwe Kleine-KЖnig wrote:
> > > 
> > > > I'm nure sure if I like gpio_is_valid().  When do you think it should be
> > > > used?  (i.e. in which situations gpio_request doesn't do the right
> > > > thing?)
> > > 
> > > For example, in situations similar to what I have in mt9m001 and mt9v022 
> > > camera drivers. Those cameras can be built with an i2c gpio extender, 
> > > which can be used to switch between 8 and 10 bit data bus widths. But that 
> > > extender is not always available. So, those drivers request a gpio, and if 
> > > it is not available on the system, the gpio_is_valid() test fails.
> > I found your patch, but no tree where it applies.  Can you point me to a
> > tree where it applies?
> 
> These drivers are currently in the v4l-dvb tree 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=summary in 
> the devel branch.
OK, when I searched your driver I found the tree, but only looked in the
master (=HEAD) branch.
 
> > Why isn't it enough that gpio_request fails in such a situation?
> 
> I'm storing the GPIO number locally, and if the system doesn't have a 
> valid GPIO for me, I'm storing an invalid GPIO number. Then at any time if 
> the GPIO has to be used, I just verify if gpio_is_valid(), and if not, 
> return an error code for this request, but the driver remains otherwise 
> functional.
OK, so in your driver you have:

	if (gpio_is_valid(gpio)) {
		/* We have a data bus switch. */
		ret = gpio_request(gpio, "mt9m001");
		if (ret < 0) {
			dev_err(&mt9m001->client->dev, "Cannot get GPIO %u\n",
				gpio);
			return ret;
		}
		ret = gpio_direction_output(gpio, 0);
		if (ret < 0) {
			...


In my eyes the following is better:

	/* Do we have a data bus switch? */
	ret = gpio_request(gpio, "mt9m001");
	if (ret < 0) {
		if (ret != -EINVAL) {
			dev_err(...);
			return ret;
		}
	} else {
		ret = gpio_direction_output(gpio, 0);
		if (ret < 0) {
			...

Then you don't need to extend the API.  Moreover with your variant the
check that gpio is valid must be done twice[1].

For me gpio_is_valid would only make sense if there might be situations
where you want to know if a certain GPIO exists but even if it does you
won't gpio_request it.

Best regards
Uwe

[1] OK, gpio_is_valid and gpio_request might be inline functions, but
for "my" architecture it is not.
-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
