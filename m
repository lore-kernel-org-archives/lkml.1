Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYKMAAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYKMAAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 19:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYKMAAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 19:00:42 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:41284 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752407AbYKMAAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 19:00:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OQsdVBAA8sAWSzxpd00+/abwzgLirGBlqQk6dOBPVdRbAGONBfefI0jqG3GdvfwELrXC05zDWazxO9hfvwZTlCdxQJeAlApTuzPBMcN8ygq8IRWabQ0y5LDGy31Sdt6V/ZTel1zBmUSqXq0gaddLjL8BSqHeyv7sDyQmi8Zrmtc=  ;
X-YMail-OSG: fod7.FEVM1nAFI4wWrlKcJJ7nsLqfVnUHkUdfSA43Sjd6QxyIETov_VVFBzlzfIPNfWZhqtTYZmkIRFC8g4cIB52.pNpaHVHZksaWXQ1p8CGfcxwiei3jY03XsxEkfjlLxWl8T4vHbrIo4DKzkg4XSk9
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Date: Wed, 12 Nov 2008 16:00:34 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>
References: <200811091531.46003.david-b@pacbell.net> <20081112112525.GA8767@sirena.org.uk> <1226528635.6727.256.camel@vega.slimlogic.co.uk>
In-Reply-To: <1226528635.6727.256.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121600.34399.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008, Liam Girdwood wrote:
> On Wed, 2008-11-12 at 11:25 +0000, Mark Brown wrote:
> > On Mon, Nov 10, 2008 at 08:56:19PM -0800, David Brownell wrote:
>
> > > Less surprising/confusing would be if regulator_{en,dis}able() did
> > > its own refcounting and called down to regulator_dev when changing
> > > a per-client refcount to/from zero.  (Easy patch, for later.)
> > 
> > Yeah, either way is fine for me - don't know if Liam has a strong
> > opinion.  The main benefit of not doing it is that encourages people to
> > avoid consumers sharing the clients which causes problems when clients
> > share the regulator.

Not refcounting enables/disables gets to be a PITA though; that's
why the the IRQ and clock frameworks gave up on the not-counted
versions of their enable/disable calls a long time ago.

The typical problem scenario is that two parts of the same driver
have independent needs to make sure something is enabled.  If it's
not OK to enable() something that's already enabled(), the driver
itself will need to reinvent a refcounting scheme.

That kind of refcount patch would be a net code shrink anyway.  :)


> Fwiw, the main design intention here was to have a 1:1 mapping between a
> consumer device and a struct regulator 

As in, an LCD display and its touchscreen might be in
the same power domain (regulator_dev, internal to the
framework) but would have different regulator structs.

In that case the most likely scenario would be two
drivers needing to enable() so it's not trying to
talk to controllers that are powered off.  Voltage
would normally be fixed.


> so that we could easily store per 
> consumer power data (for mode switching, easier debug, sysfs) and avoid
> any issues between sharing the clients. I'd be happy for this change as
> long as we can keep the per consumer data.

Right, I wasn't talking about changing that model.

- Dave

