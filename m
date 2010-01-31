Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280Ab0AaQCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0AaQCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 11:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655Ab0AaQCT
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 11:02:19 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:42666 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0AaQCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 11:02:18 -0500
Date: Sun, 31 Jan 2010 17:02:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
       Michal Marek <mmarek@suse.cz>
Cc: Greg KH <greg@kroah.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] platform_driver_register: warn if probe is in
	.init.text
Message-ID: <20100131160213.GA14896@merkur.ravnborg.org>
References: <20100122173846.GA11057@suse.de> <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de> <87y6jnw6qa.fsf@devron.myhome.or.jp> <20100126084741.GC20792@pengutronix.de> <20100128011403.GB24068@kroah.com> <20100130204425.GA16345@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100130204425.GA16345@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 09:44:25PM +0100, Uwe Kleine-K?nig wrote:
> Hello,
> 
> On Wed, Jan 27, 2010 at 05:14:03PM -0800, Greg KH wrote:
> > On Tue, Jan 26, 2010 at 09:47:41AM +0100, Uwe Kleine-König wrote:
> > > On Mon, Jan 25, 2010 at 06:09:01AM +0900, OGAWA Hirofumi wrote:
> > > > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:
> > > > > +int platform_driver_register(struct platform_driver *drv)
> > > > > +{
> > > > > +	int ret = __platform_driver_register(drv);
> > > > > +
> > > > > +#if defined(CONFIG_HOTPLUG)
> > > > > +	/*
> > > > > +	 * drivers that are registered by platform_driver_register
> > > > > +	 * should not have their probe function in .init.text.  The
> > > > > +	 * reason is that a probe can happen after .init.text is
> > > > > +	 * discarded which then results in an oops.  The alternatives
> > > > > +	 * are using .devinit.text for the probe function or "register"
> > > > > +	 * with platform_driver_probe.
> > > > > +	 */
> > > > > +	if (drv->probe && kernel_init_text_address((unsigned long)drv->probe))
> > > > > +		pr_warning("oops-warning: probe function of platform driver %s"
> > > > > +			       " lives in .init.text\n", drv->driver.name);
> > > > > +#else
> > > > > +	/*
> > > > > +	 * without HOTPLUG probe functions can be discarded after the driver is
> > > > > +	 * loaded.
> > > > > +	 * There is a little chance for false positives, namely if the driver is
> > > > > +	 * registered after the .init sections are discarded.
> > > > > +	 */
> > > > > +	if (drv->probe && !kernel_init_text_address((unsigned long)drv->probe))
> > > > > +		pr_info("probably the probe function of platform driver %s can"
> > > > > +				" be moved to .init.text\n", drv->driver.name);
> > > > > +#endif
> > > > > +	return ret;
> > > > > +}
> > > > 
> > > > Um..., can't we extend modpost or such one for this? I think the static
> > > > analysis is better (assume the changing ->probe dynamically is really
> > > > rare).
> > > I like the idea and will look later into modpost if this can be done
> > > there.
> > 
> > That would be nice to do instead, as we already do checks like this
> > today, and might make more sense.
> > 
> > And could you do it for all probe functions, and not just the platform
> > devices?  Don't all busses have this same problem?
> I think so, yes.  And I made some changes to modpost to detect those.
> Tested on two defconfigs (ARCH=arm) it yields three hits, all valid.
> 
> I send the series as reply to this mail or you can get it via git, see
> below.
> 
> The first six patches should not change behaviour, only do some cleanup
> and preparation for the last patch.
> 
> The most interesting patch is "make symbol white list a per mismatch
> type variable".  It allows a white list per section mismatch type and
> so allows to say:
> 
> 	*driver (in .data) might reference to .devinit.text but not
> 	.init.text
> 
> That's what the last patch does.

Michael is handling kbuild stuff now and that may include modpost stuff.
So added Michael - then you guys can decide way forward.

The modpost patches looks OK at a quick view.
You can consider adding:

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
