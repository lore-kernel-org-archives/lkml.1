Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078Ab0A3Uoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0A3Uoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267Ab0A3Uoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:44:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46903 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab0A3Uog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:44:36 -0500
Date: Sat, 30 Jan 2010 21:44:25 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] platform_driver_register: warn if probe is in
	.init.text
Message-ID: <20100130204425.GA16345@pengutronix.de>
References: <20100122173846.GA11057@suse.de> <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de> <87y6jnw6qa.fsf@devron.myhome.or.jp> <20100126084741.GC20792@pengutronix.de> <20100128011403.GB24068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100128011403.GB24068@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 27, 2010 at 05:14:03PM -0800, Greg KH wrote:
> On Tue, Jan 26, 2010 at 09:47:41AM +0100, Uwe Kleine-König wrote:
> > On Mon, Jan 25, 2010 at 06:09:01AM +0900, OGAWA Hirofumi wrote:
> > > Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:
> > > > +int platform_driver_register(struct platform_driver *drv)
> > > > +{
> > > > +	int ret = __platform_driver_register(drv);
> > > > +
> > > > +#if defined(CONFIG_HOTPLUG)
> > > > +	/*
> > > > +	 * drivers that are registered by platform_driver_register
> > > > +	 * should not have their probe function in .init.text.  The
> > > > +	 * reason is that a probe can happen after .init.text is
> > > > +	 * discarded which then results in an oops.  The alternatives
> > > > +	 * are using .devinit.text for the probe function or "register"
> > > > +	 * with platform_driver_probe.
> > > > +	 */
> > > > +	if (drv->probe && kernel_init_text_address((unsigned long)drv->probe))
> > > > +		pr_warning("oops-warning: probe function of platform driver %s"
> > > > +			       " lives in .init.text\n", drv->driver.name);
> > > > +#else
> > > > +	/*
> > > > +	 * without HOTPLUG probe functions can be discarded after the driver is
> > > > +	 * loaded.
> > > > +	 * There is a little chance for false positives, namely if the driver is
> > > > +	 * registered after the .init sections are discarded.
> > > > +	 */
> > > > +	if (drv->probe && !kernel_init_text_address((unsigned long)drv->probe))
> > > > +		pr_info("probably the probe function of platform driver %s can"
> > > > +				" be moved to .init.text\n", drv->driver.name);
> > > > +#endif
> > > > +	return ret;
> > > > +}
> > > 
> > > Um..., can't we extend modpost or such one for this? I think the static
> > > analysis is better (assume the changing ->probe dynamically is really
> > > rare).
> > I like the idea and will look later into modpost if this can be done
> > there.
> 
> That would be nice to do instead, as we already do checks like this
> today, and might make more sense.
> 
> And could you do it for all probe functions, and not just the platform
> devices?  Don't all busses have this same problem?
I think so, yes.  And I made some changes to modpost to detect those.
Tested on two defconfigs (ARCH=arm) it yields three hits, all valid.

I send the series as reply to this mail or you can get it via git, see
below.

The first six patches should not change behaviour, only do some cleanup
and preparation for the last patch.

The most interesting patch is "make symbol white list a per mismatch
type variable".  It allows a white list per section mismatch type and
so allows to say:

	*driver (in .data) might reference to .devinit.text but not
	.init.text

That's what the last patch does.

Best regards
Uwe

The following changes since commit 499a2673713c85734a54c37dd90b4b729de399c4:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../dtor/input

are available in the git repository at:

  git://git.pengutronix.de/git/ukl/linux-2.6.git modpost

Uwe Kleine-König (7):
      modpost: members of *driver structs should not point to __init functions
      modpost: define ALL_XXX{IN,EX}IT_SECTIONS
      modpost: give most mismatch constants a better name
      modpost: pass around const struct sectioncheck * instead of enum mismatch
      modpost: remove now unused NO_MISMATCH constant
      modpost: make symbol white list a per mismatch type variable
      modpost: don't allow *driver to reference .init.*

 scripts/mod/modpost.c |  152 ++++++++++++++++++++++++++++---------------------
 1 files changed, 88 insertions(+), 64 deletions(-)

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
