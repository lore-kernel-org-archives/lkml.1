Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYCKTUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYCKTUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYCKTUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:20:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:6037 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbYCKTUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:20:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,481,1199692800"; 
   d="scan'208";a="532230194"
Date: Tue, 11 Mar 2008 12:15:16 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Alex Chiang <achiang@hp.com>, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20080311121516.42e3a727@appleyard>
In-Reply-To: <474E6E82.40307@jp.fujitsu.com>
References: <20071117182954.GA25003@ldl.fc.hp.com>
	<20071119233225.GA6931@us.ibm.com>
	<20071126222253.GA31708@ldl.fc.hp.com>
	<474E6E82.40307@jp.fujitsu.com>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 16:47:14 +0900
Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:

> > Hi Gary, Kenji-san, et. al,
> > 
> > * Gary Hade <garyhade@us.ibm.com>:
> >> Alex, What I was trying to suggest is a boot-time kernel
> >> option, not a kernel configuration option.  The basic idea is
> >> to give the user (with a single binary kernel) the ability to
> >> include your ACPI-PCI slot driver feature changes only when
> >> they are really needed.  In addition to reducing the number of
> >> system/PCI hotplug driver combinations where your changes would
> >> need to be validated, I believe would also help alleviate other
> >> worries (e.g. Andi Kleen's memory consumption concern).  I
> >> believe this goal could also be achieved with the kernel config
> >> option by making the pci_slot module runtime loadable with the
> >> PCI hotplug drivers only visiting your new code when the
> >> pci_slot driver is loaded, although I think this would be more
> >> difficult to implement.
> > 
> > I have modified my patch series so that the final patch that
> > introduces my ACPI-PCI slot driver is a full-fledged module, that
> > has a tristate Kconfig option.
> > 
> 
> Thank you for your good job.
> 
> I tested shpchp and pciehp both with and without pci_slot module.
> There seems no regression from shpchp and pciehp's point of view.
> (I had a little concern about the hotplug slots' name that vary
> depending on whether pci_slot functionality is enabled or disabled.
> But, now that we can build pci_slot driver as a kernel module, I
> don't think it is a big problem).
> 
> Only the problems is that I got Call Traces with the following error
> messages when pci_slot driver was loaded, and one strange slot named
> '1023' was registered (other slots are fine). This is the same problem
> I reported before.
> 
>     sysfs: duplicate filename '1023' can not be created
>     WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> 
>     kobject_add failed for 1023 with -EEXIST, don't try to register
>     things with the same name in the same directory.
> 
> On my system, hotplug slots themselves can be added, removed and
> replaced with the ohter type of I/O box. The ACPI firmware tells OS
> the presence of those slots using _STA method (That is, it doesn't
> use 'LoadTable()' AML operator). On the other hand, current pci_slot
> driver doesn't check _STA. As a result, pci_slot driver tryied to
> register the invalid (non-existing) slots. The ACPI firmware of my
> system returns '1023' if the invalid slot's _SUN is evaluated. This
> is the cause of Call Traces mentioned above. To fix this problem,
> pci_slot driver need to check _STA when scanning ACPI Namespace.
> 
> I'm sorry for reporting this so late. I'm attaching the patch to fix
> the problem. This is against 2.6.24-rc3 with your patches applied.
> Could you try it?
> 
> BTW, acpiphp also seems to have the same problem...
> 
> Thanks,
> Kenji Kaneshige

Hello - back to this mail for a moment.  I wanted to talk about acpiphp
again.  You say that acpiphp has this same problem as Alex's driver wrt
evalating _SUN on a non existant object.  If we skip registering the
slot in acpiphp's register_slot function if it returns 0 for _STA, we
will not detect any hotplug slots, since leaf nodes will return 0 for
_STA if a device is not present. Should we only skip it if it's parent
is a p2p bridge that has _EJ0 and the parent's _STA says empty?

Your input is appreciated,
Kristen

> 
> ---
>  drivers/acpi/pci_slot.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> Index: linux-2.6.24-rc3/drivers/acpi/pci_slot.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/drivers/acpi/pci_slot.c
> +++ linux-2.6.24-rc3/drivers/acpi/pci_slot.c
> @@ -113,10 +113,17 @@ register_slot(acpi_handle handle, u32 lv
>  	int device;
>  	unsigned long sun;
>  	char name[KOBJ_NAME_LEN];
> +	acpi_status status;
> +	struct acpi_device *dummy_device;
>  
>  	struct pci_slot *pci_slot;
>  	struct pci_bus *pci_bus = context;
>  
> +	/* Skip non-existing device object. */
> +	status = acpi_bus_get_device(handle, &dummy_device);
> +	if (ACPI_FAILURE(status))
> +		return AE_OK;
> +
>  	if (check_slot(handle, &device, &sun))
>  		return AE_OK;
>  
> @@ -150,12 +157,18 @@ walk_p2p_bridge(acpi_handle handle, u32 
>  	acpi_status status;
>  	acpi_handle dummy_handle;
>  	acpi_walk_callback user_function;
> +	struct acpi_device *dummy_device;
>  
>  	struct pci_dev *dev;
>  	struct pci_bus *pci_bus;
>  	struct p2p_bridge_context child_context;
>  	struct p2p_bridge_context *parent_context = context;
>  
> +	/* Skip non-existing device object. */
> +	status = acpi_bus_get_device(handle, &dummy_device);
> +	if (ACPI_FAILURE(status))
> +		return AE_OK;
> +
>  	pci_bus = parent_context->pci_bus;
>  	user_function = parent_context->user_function;
>  
> 
