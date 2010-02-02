Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0BBRcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:32:13 -0500
Received: from www17.your-server.de ([213.133.104.17]:56784 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0BBRcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:32:08 -0500
Subject: Re: [PATCH] i915: slow acpi_lid_open() causes flickering
From: Thomas Meyer <thomas@m3y3r.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <4B676B20.8060808@gmail.com>
References: <1265048453.2619.8.camel@localhost.localdomain>
	 <20100201143348.cb9fa1e3.akpm@linux-foundation.org>
	 <4B676B20.8060808@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 18:30:58 +0100
Message-ID: <1265131858.5910.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 01.02.2010, 16:00 -0800 schrieb Justin P. Mattock:
> On 02/01/10 14:33, Andrew Morton wrote:
> > On Mon, 01 Feb 2010 19:20:53 +0100
> > Thomas Meyer<thomas@m3y3r.de>  wrote:
> >
> >> acpi_lid_open() could take up to 10ms on my computer.
> >> Some component is calling the drm GETCONNECTOR ioctl many times in a row.
> >> This results in flickering (for example, when starting a video).
> >> Fix it by assuming an always connected lid status.
> >>
> >> This fixes bug http://bugzilla.kernel.org/show_bug.cgi?id=14670
> >>
> >> ---
> >>   drivers/gpu/drm/i915/intel_lvds.c |   15 ++++++++++++++-
> >>   1 files changed, 14 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> >> index aa74e59..0f0779c 100644
> >> --- a/drivers/gpu/drm/i915/intel_lvds.c
> >> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> >> @@ -632,6 +632,18 @@ static const struct dmi_system_id bad_lid_status[] = {
> >>   	{ }
> >>   };
> >>
> >> +/* Some lid devices take a long time to report the lid status, assume they're connected*/
> >> +static const struct dmi_system_id slow_lid_status[] = {
> >> +	{
> >> +		.ident = "Aspire 1810T",
> >> +		.matches = {
> >> +			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> >> +			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1810T"),
> >> +		},
> >> +	},
> >> +	{ }
> >> +};
> >> +
> >>   /**
> >>    * Detect the LVDS connection.
> >>    *
> >> @@ -643,7 +655,8 @@ static enum drm_connector_status intel_lvds_detect(struct drm_connector *connect
> >>   {
> >>   	enum drm_connector_status status = connector_status_connected;
> >>
> >> -	if (!acpi_lid_open()&&  !dmi_check_system(bad_lid_status))
> >> +	if (!dmi_check_system(slow_lid_status)&&  !dmi_check_system(bad_lid_status))
> >> +	    if (!acpi_lid_open())
> >>   		status = connector_status_disconnected;
> >>
> >>   	return status;
> >
> > The patch is missing your Signed-off-by: line.  I cheekily added it.
> > Please check Documentation/SubmittingPatches, let me know if you
> > disagree with this, thanks.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> I'm wondering if just adding your DMI entry to
> bad_lid_status[] is all that is really needed.
> (this way it saves bits in the kernel).

I tried that with no success. I guess to execute the if statement the
functions acpi_lid_open() and dmi_check_system() needs to be executed
and that leads to the flickering.

maybe it helps to just reorder the if statement? first execute
dmi_check_system() and then execute acpi_lid_open(), but as both
conditions are connected via an "AND" I guess the acpi_lid_open() still
will be executed each time dmi_check_system() is executed.

mfg
thomas


