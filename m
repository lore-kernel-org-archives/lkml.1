Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZIYVts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZIYVts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 17:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZIYVtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 17:49:47 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:31016 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZIYVtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 17:49:46 -0400
Subject: Re: [origin tree boot crash] NULL pointer dereference, IP:
	[<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <1253758420.9794.59.camel@minggr.sh.intel.com>
References: <alpine.LFD.2.00.0909190237560.22030@localhost.localdomain>
	 <20090923213052.GA6648@elte.hu>
	 <1253756114.9794.43.camel@minggr.sh.intel.com>
	 <1253757510.9794.55.camel@minggr.sh.intel.com>
	 <1253758420.9794.59.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Fri, 25 Sep 2009 15:47:14 -0600
Message-Id: <1253915234.16789.14.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 10:13 +0800, Lin Ming wrote:
> On Thu, 2009-09-24 at 09:58 +0800, Lin Ming wrote:
> > On Thu, 2009-09-24 at 09:35 +0800, Lin Ming wrote:
> > > On Thu, 2009-09-24 at 05:30 +0800, Ingo Molnar wrote:
> > > > > commit 15b8dd53f5ffaf8e2d9095c423f713423f576c0f
> > > > > Date:   Mon Jun 29 13:39:29 2009 +0800
> > > > >
> > > > >     ACPICA: Major update for acpi_get_object_info external interface
> > > > 
> > > > this one is causing boot crashes in -tip testing: 

> hp-agp.c need the same fix.
> Could you refresh your patch with this one?

I think Len has already applied the series containing the acpiphp_ibm.c
fix.  I tested that one and verified that it fixed an actual crash.

I think your hp-agp.c patch below is correct, and I don't object if you
want to submit it, but I don't *think* we'll have a problem even without
it.

We will only touch "info->hardware_id.string[]" if we have already found
an HP vendor-defined CSR space descriptor.  Any device with that
descriptor should have a HID.

Bjorn

> diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
> index 7bead4c..d83c4a8 100644
> --- a/drivers/char/agp/hp-agp.c
> +++ b/drivers/char/agp/hp-agp.c
> @@ -492,8 +492,10 @@ zx1_gart_probe (acpi_handle obj, u32 depth, void *context, void **ret)
>  		status = acpi_get_object_info(handle, &info);
>  		if (ACPI_SUCCESS(status)) {
>  			/* TBD check _CID also */
> -			info->hardware_id.string[sizeof(info->hardware_id.length)-1] = '\0';
> -			match = (strcmp(info->hardware_id.string, "HWP0001") == 0);
> +			if (info->valid & ACPI_VALID_HID)
> +				match = !strcmp(info->hardware_id.string, "HWP0001");
> +			else
> +				match = 0;
>  			kfree(info);
>  			if (match) {
>  				status = hp_acpi_csr_space(handle, &sba_hpa, &length);
> diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
> index a9d926b..e7be66d 100644
> --- a/drivers/pci/hotplug/acpiphp_ibm.c
> +++ b/drivers/pci/hotplug/acpiphp_ibm.c
> @@ -406,7 +406,6 @@ static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
>  			__func__, status);
>  		return retval;
>  	}
> -	info->hardware_id.string[sizeof(info->hardware_id.length) - 1] = '\0';
>  
>  	if (info->current_status && (info->valid & ACPI_VALID_HID) &&
>  			(!strcmp(info->hardware_id.string, IBM_HARDWARE_ID1) ||
> 
> 
> > 
> > Below patch should fix the crash.
> > http://patchwork.kernel.org/patch/49090/ 
> > 
> > Subject: [PATCH v3 01/17] ACPICA: fixup after acpi_get_object_info() change
> > 
> > Commit 15b8dd53f5ffa changed info->hardware_id from a static array to
> > a pointer.  If hardware_id is non-NULL, it points to a NULL-terminated
> > string, so we don't need to terminate it explicitly.  However, it may
> > be NULL; in that case, we *can't* add a NULL terminator.
> > 
> > This causes a NULL pointer dereference oops for devices without _HID.
> > 
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > CC: Lin Ming <ming.m.lin@intel.com>
> > CC: Bob Moore <robert.moore@intel.com>
> > CC: Gary Hade <garyhade@us.ibm.com>
> > ---
> >  drivers/pci/hotplug/acpiphp_ibm.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
> > index a9d926b..e7be66d 100644
> > --- a/drivers/pci/hotplug/acpiphp_ibm.c
> > +++ b/drivers/pci/hotplug/acpiphp_ibm.c
> > @@ -406,7 +406,6 @@ static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
> >  			__func__, status);
> >  		return retval;
> >  	}
> > -	info->hardware_id.string[sizeof(info->hardware_id.length) - 1] = '\0';
> >  
> >  	if (info->current_status && (info->valid & ACPI_VALID_HID) &&
> >  			(!strcmp(info->hardware_id.string, IBM_HARDWARE_ID1) ||
> > 
> > 
> > ---
> > Lin Ming
> > 
> > > 
> > > commit 718fb0de8ff88f71b3b91a8ee8e42e60c88e5128
> > > Author: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > > Date:   Thu Aug 6 23:18:12 2009 +0000
> > > 
> > >     ACPI: fix NULL bug for HID/UID string
> > >     
> > >     acpi_device->pnp.hardware_id and unique_id are now allocated pointers,
> > >     replacing the previous arrays.  acpi_device_install_notify_handler()
> > >     oopsed on the NULL hid when probing the video device, and perhaps other
> > >     uses are vulnerable too.  So initialize those pointers to empty strings
> > >     when there is no hid or uid.  Also, free hardware_id and unique_id when
> > >     when acpi_device is going to be freed.
> > >     
> > >     http://bugzilla.kernel.org/show_bug.cgi?id=14096
> > >     
> > >     Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> > >     Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > >     Signed-off-by: Len Brown <len.brown@intel.com>
> > > 
> > > Thanks,
> > > Lin Ming
> > 
> 

