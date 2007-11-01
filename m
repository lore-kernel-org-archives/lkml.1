Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbXKATNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbXKATNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbXKATNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:13:01 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47179 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbXKATNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:13:00 -0400
Date: Thu, 1 Nov 2007 11:45:55 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, Greg Kroah-Hartman <gregkh@suse.de>,
       Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] x86: check boundary in count/setup_resource called by get_current_resources
Message-ID: <20071101184555.GB5955@us.ibm.com>
References: <200711010120.30410.yinghai.lu@sun.com> <20071101013239.992840bd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101013239.992840bd.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 01:32:39AM -0700, Andrew Morton wrote:
> On Thu, 01 Nov 2007 01:20:29 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > [PATCH] x86: check boundary in count/setup_resource called by get_current_resources
> > 
> > need to check info->res_num less than PCI_BUS_NUM_RESOURCES, so
> > info->bus->resource[info->res_num] = res will not beyond of bus resource array
> > when acpi resutrn too many resource entries.
> > 
> 
> Isn't this a bit of a problem?  It sounds like PCI_BUS_NUM_RESOURCES is to
> small for that system?  If so, some sort of dynamic allocation might be
> needed.

I should have considered the possible resource array overrun
when I created these functions.  I had assumed (apparently
incorrectly) that the old PCI_BUS_NUM_RESOURCES value of 4
was based on a spec defined limit on the maximum number of 
resources that _CRS can return.

I recently noticed the potential overrun myself while backporting
the code to kernel source where PCI_BUS_NUM_RESOURCES was initially
defined as 4.  This happened on a system where the _CRS associated
with one of the root bridges returned 5 resources with the 5th causing
a write beyond the end of the array.  Increasing PCI_BUS_NUM_RESOURCES
to the current value of 8 eliminated the overrun that I experienced 
but after discovering that there is apparently no limit on the
number of resources that _CRS can return I had intended to post
a change similar to what Yinghai Lu is proposing.

With the current PCI_BUS_NUM_RESOURCES value, _CRS can return 
up to 8 resources before the pci_bus resource array is totally
saturated but it should be noted that if a transparent bridge
is present below the root bridge it's child bus will only see
the first 5 resources.

The current fixed pci_bus resource array size of 8 is adequate 
(for storing _CRS returned resource and visibility across
transparent bridges) on those systems that I work on but without
a bound on the number of resources returned by _CRS some sort
of dynamic allocation certainly makes sense.

Note that exposure to this issue is currently limited to those
that use the 'pci=use_crs' kernel option. 

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

