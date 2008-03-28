Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYC1XBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYC1XBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbYC1XBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:01:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55007 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbYC1XBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:01:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
Date: Sat, 29 Mar 2008 00:01:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200803281509.23107.david-b@pacbell.net> <20080328225604.GA7136@linux-os.sc.intel.com>
In-Reply-To: <20080328225604.GA7136@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803290001.18912.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 28 of March 2008, Venki Pallipadi wrote:
> On Fri, Mar 28, 2008 at 03:09:22PM -0700, David Brownell wrote:
> > On Friday 28 March 2008, Pallipadi, Venkatesh wrote:
> > > You should have a dmesg line which looks like
> > > ACPI: CPU0 (power states: C1[C1] C2[C2]
> > > Do you see C2 in such line?
> > 
> > Yes:
> > 
> > ACPI: CPU0 (power states: C1[C1] C2[C2])
> 
> 
> David,
> 
> I think I figured out the bug...
> 
> Can you try the below patch and confirm that it works (over upstream - ignore
> the earlier revert patch I sent to you).
> 
> Thanks,
> Venki
> 
> ----
> 
> 
> Patch to fix huge number of wakeups reported due to recent changes in
> processor_idle.c. The problem was that the entry_method determination was
> broken due to one of the recent commits (bc71bec91f987) causing
> C1 entry to not to go to halt. This should also fix the hang reported here.
> http://bugzilla.kernel.org/show_bug.cgi?id=10093

Ah, thanks for figuring that out.  As a regression fix, it should go upstream
ASAP, I think.

 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> ---
>  drivers/acpi/processor_idle.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/drivers/acpi/processor_idle.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_idle.c	2008-03-28 15:31:13.000000000 -0700
> +++ linux-2.6/drivers/acpi/processor_idle.c	2008-03-28 15:40:50.000000000 -0700
> @@ -848,6 +848,7 @@ static int acpi_processor_get_power_info
>  		/* all processors need to support C1 */
>  		pr->power.states[ACPI_STATE_C1].type = ACPI_STATE_C1;
>  		pr->power.states[ACPI_STATE_C1].valid = 1;
> +		pr->power.states[ACPI_STATE_C1].entry_method = ACPI_CSTATE_HALT;
>  	}
>  	/* the C0 state only exists as a filler in our array */
>  	pr->power.states[ACPI_STATE_C0].valid = 1;
> @@ -960,6 +961,9 @@ static int acpi_processor_get_power_info
>  				 cx.address);
>  		}
>  
> +		if (cx.type == ACPI_STATE_C1) {
> +			cx.valid = 1;
> +		}
>  
>  		obj = &(element->package.elements[2]);
>  		if (obj->type != ACPI_TYPE_INTEGER)
> 
> 
