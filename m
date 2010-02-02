Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0BBReM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:34:12 -0500
Received: from www17.your-server.de ([213.133.104.17]:44745 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0BBReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:34:10 -0500
Subject: Re: [PATCH] i915: slow acpi_lid_open() causes flickering
From: Thomas Meyer <thomas@m3y3r.de>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1265069248.25140.407.camel@Joe-Laptop.home>
References: <1265048453.2619.8.camel@localhost.localdomain>
	 <20100201143348.cb9fa1e3.akpm@linux-foundation.org>
	 <1265069248.25140.407.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 18:33:15 +0100
Message-ID: <1265131995.5910.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 01.02.2010, 16:07 -0800 schrieb Joe Perches:
> On Mon, 2010-02-01 at 14:33 -0800, Andrew Morton wrote:
> > On Mon, 01 Feb 2010 19:20:53 +0100
> > Thomas Meyer <thomas@m3y3r.de> wrote:
> > > acpi_lid_open() could take up to 10ms on my computer.
> > > Some component is calling the drm GETCONNECTOR ioctl many times in a row.
> > > This results in flickering (for example, when starting a video).
> > > Fix it by assuming an always connected lid status.
> > > 
> > > This fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=14670
> > > 
> > > ---
> > >  drivers/gpu/drm/i915/intel_lvds.c |   15 ++++++++++++++-
> > >  1 files changed, 14 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> > > index aa74e59..0f0779c 100644
> > > --- a/drivers/gpu/drm/i915/intel_lvds.c
> > > +++ b/drivers/gpu/drm/i915/intel_lvds.c
> []
> > > @@ -643,7 +655,8 @@ static enum drm_connector_status intel_lvds_detect(struct drm_connector *connect
> > >  {
> > >  	enum drm_connector_status status = connector_status_connected;
> > >  
> > > -	if (!acpi_lid_open() && !dmi_check_system(bad_lid_status))
> > > +	if (!dmi_check_system(slow_lid_status) && !dmi_check_system(bad_lid_status))
> > > +	    if (!acpi_lid_open())
> > >  		status = connector_status_disconnected;
> > >  
> > >  	return status;
> 
> Shouldn't this use an && test instead of a 4 space indent of a new statement?
> 
> +	if (!dmi_check_system(slow_lid_status) && !dmi_check_system(bad_lid_status) &&
> +	    !acpi_lid_open())
> 

Won't this lead to the execution of dmi_check_system() AND
dmi_check_system() AND acpi_lid_open() every time the
intel_lvds_detect() function is called?

And this is what I want to prevent: Do not call acpi_lid_open(), when
the system is found in the dmi table.

What do you think?

mfg
thomas


