Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbZC2Uzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbZC2Uzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbZC2Uz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:55:28 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:19438 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbZC2Uz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:55:26 -0400
Date: Sun, 29 Mar 2009 22:55:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       Thomas Renninger <trenn@suse.de>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090329225501.0c1771f1@hyperion.delvare>
In-Reply-To: <20090329201617.GA10303@dreamland.darkstar.lan>
References: <20090204131708.GA2739@srcf.ucam.org>
	<20090204142606.1823661b@hyperion.delvare>
	<20090204142015.GB3923@srcf.ucam.org>
	<20090210145716.105ab58b@hyperion.delvare>
	<20090210140829.GA25397@srcf.ucam.org>
	<49919E08.5050002@redhat.com>
	<20090210172408.400cacee@hyperion.delvare>
	<20090227132740.GF1482@ucw.cz>
	<68676e00903240539i119b6d26j516ee131d4cd6781@mail.gmail.com>
	<49C8DE51.2010103@redhat.com>
	<20090329201617.GA10303@dreamland.darkstar.lan>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

On Sun, 29 Mar 2009 22:16:17 +0200, Luca Tettamanti wrote:
> Il Tue, Mar 24, 2009 at 02:21:21PM +0100, Hans de Goede ha scritto: 
> > On 03/24/2009 01:39 PM, Luca Tettamanti wrote:
> >> On Fri, Feb 27, 2009 at 2:27 PM, Pavel Machek<pavel@ucw.cz>  wrote:
> >>> Hi!
> >>>
> >>>>> For the record we have changed the default to strict in Fedora's
> >>>>> development branch, for 2 weeks or so now, including in the recently
> >>>>> released Fedora 11 release and we've had 0 complaints so far.
> >>>> Well, if the number of affected systems is small, this is good news.
> >>>> But this is only 2 weeks and one distribution, coverage isn't
> >>>> sufficient to claim anything yet IMHO.
> >>>>
> >>>> That being said... if there's a common consensus that switching to
> >>>> strict and dealing with fallouts is the best thing to do, and I'm the
> >>>> only one objecting to this, then I am ready to admit that I was wrong
> >>>> and let you proceed.
> >>> I believe that 'enable strict, deal with fallout' is the best
> >>> long-term strategy...
> >>
> >> Hello,
> >> the merge window for .30 is now open, what are we going to do with this issue?
> >>
> >
> > I think the consensus was to make the default strict and to merge the atk0110
> > driver, right?
> 
> Ok,
> here's a patch:
> ---
> The following patch changes the default value for option "acpi_enforce_resource"
> to strict. It enforces strict resource checking - disallowing access by native
> drivers to IO ports and memory regions claimed by ACPI firmware.
> 
> The patch is mainly aimed to block native hwmon drivers from touching
> monitoring chips that ACPI thinks it own.
> 
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
> ---
>  Documentation/kernel-parameters.txt |   16 ++++++++++++++++
>  drivers/acpi/osl.c                  |    6 +++---
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> Index: b/Documentation/kernel-parameters.txt
> ===================================================================
> --- a/Documentation/kernel-parameters.txt	2009-03-29 15:47:28.000000000 +0200
> +++ b/Documentation/kernel-parameters.txt	2009-03-29 15:51:30.000000000 +0200
> @@ -259,6 +259,22 @@
>  			to assume that this machine's pmtimer latches its value
>  			and always returns good values.
>  
> +	acpi_enforce_resources=	[ACPI]
> +			{ strict,  lax, no }

Other options use | as a delimited between allowed values.

> +			Check for resource conflicts between native drivers
> +			and ACPI OperationRegions (SystemIO and SystemMemory
> +			only). IO ports and memory declared in ACPI might be
> +			used by the ACPI subsystem in arbitrary AML code and
> +			can interfere with legacy drivers.
> +			strict (default): access to resources claimed by ACPI
> +			is denied; legacy drivers trying to access reserved
> +			resources will fail to load.

The driver will fail to _bind_ to the device, this doesn't mean that the
module will fail to load. In practice, PCI modules will still load
while "fake" platform modules will indeed fail to load. Many hwmon
drivers fall into the second category.

> +			lax: access to resources claimed by ACPI is allowed;
> +			legacy drivers trying to access reserved resources
> +			will load and a warning message is logged.

Ditto.

> +			no: ACPI OperationRegions are not marked as reserved,
> +			no further checks are performed.
> +
>  	agp=		[AGP]
>  			{ off | try_unsupported }
>  			off: disable AGP support
> Index: b/drivers/acpi/osl.c
> ===================================================================
> --- a/drivers/acpi/osl.c	2009-03-29 15:47:29.000000000 +0200
> +++ b/drivers/acpi/osl.c	2009-03-29 15:51:30.000000000 +0200
> @@ -1070,9 +1070,9 @@
>   * in arbitrary AML code and can interfere with legacy drivers.
>   * acpi_enforce_resources= can be set to:
>   *
> - *   - strict           (2)
> + *   - strict (default) (2)
>   *     -> further driver trying to access the resources will not load
> - *   - lax (default)    (1)
> + *   - lax              (1)
>   *     -> further driver trying to access the resources will load, but you
>   *     get a system message that something might go wrong...
>   *
> @@ -1084,7 +1084,7 @@
>  #define ENFORCE_RESOURCES_LAX    1
>  #define ENFORCE_RESOURCES_NO     0
>  
> -static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
> +static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
>  
>  static int __init acpi_enforce_resources_setup(char *str)
>  {

Other that these minor details:

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
