Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbYGAId7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbYGAId7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYGAIde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:33:34 -0400
Received: from ns.suse.de ([195.135.220.2]:60437 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYGAIda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:33:30 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Len Brown <lenb@kernel.org>
Subject: Check for BIOS bugs - Original Subject: Re: [PATCH 23/70] ACPICA: Workaround for reversed _PRT entries from BIOS
Date: Tue, 1 Jul 2008 10:33:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
       Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Huang Cheng <cheng.huang@intel.com>, firmwarekit-discuss@bughost.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <1213947852-10924-1-git-send-email-lenb@kernel.org> <deade3c973eb9c98d2a6cfed658bbb49e693894a.1213947350.git.len.brown@intel.com>
In-Reply-To: <deade3c973eb9c98d2a6cfed658bbb49e693894a.1213947350.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011033.27887.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 June 2008 09:43:25 Len Brown wrote:
> From: Bob Moore <robert.moore@intel.com>
>
> Some BIOSs erroneously reverse the _PRT SourceName and the
> SourceIndex.  Detect and repair this problem. MS ACPI also allows
> and repairs this problem, thus ACPICA must also.

It would be great to have an interface to report this as a BIOS defect.

Something like:

FIRMWARE_BUG_ON(FIRM_WARN, "erroneously reversed the _PRT source_name", ACPI_ 
Bug);

FIRMWARE_BUG_ON(severity, description, component);

If say CONFIG_FIRMWARE_DEBUG is set this could send a netlink event to 
userspace and e.g. linuxfirmwarekit can grab it.
linuxfirmwarekit currently implements it's own scripts and even worse, parses 
dmesg to find BIOS bugs, which is not really maintenable.

IMO the kernel developers themselves need an interface where they can report 
bugs while seeing and fixing them.

Huang Cheng posted a nice patch on the linuxfirmwarekit list a while ago 
(unfortunately the patch was attached not inlined):
http://www.bughost.org/pipermail/firmwarekit-discuss/2008-March/000166.html

I mean it needs some cleanup (e.g. the file name was the bug number, there 
need to be a general interface created, e.g. as  shown above, etc.).
But this is IMO a good idea and might be worth adding to the kernel (when 
written :) ).
Comments?

        Thomas

PS: I added Bjorn as in the PNP parts BIOSes are pretty much messed up.
One reason is that AFAIK ACPI parts are glued together. Having dozens/hundreds 
of device declarations in a BIOS of which huge parts have not been written by 
yourself, it is very hard for vendors to check for correctness.
While Bjorn and others are adding quirks and workarounds for specific devices, 
machines or general BIOS bugs it would be great to be able to point vendors 
to these bugs by a simple tool.

> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/acpi/resources/rscreate.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/resources/rscreate.c
> b/drivers/acpi/resources/rscreate.c index faddaee..70c84ec 100644
> --- a/drivers/acpi/resources/rscreate.c
> +++ b/drivers/acpi/resources/rscreate.c
> @@ -285,6 +285,23 @@ acpi_rs_create_pci_routing_table(union
> acpi_operand_object *package_object, }
>
>  		/*
> +		 * If the BIOS has erroneously reversed the _PRT source_name (index 2)
> +		 * and the source_index (index 3), fix it. _PRT is important enough to
> +		 * workaround this BIOS error. This also provides compatibility with
> +		 * other ACPI implementations.
> +		 */
> +		obj_desc = sub_object_list[3];
> +		if (!obj_desc
> +		    || (ACPI_GET_OBJECT_TYPE(obj_desc) != ACPI_TYPE_INTEGER)) {
> +			sub_object_list[3] = sub_object_list[2];
> +			sub_object_list[2] = obj_desc;
> +
> +			ACPI_WARNING((AE_INFO,
> +				      "(PRT[%X].Source) SourceName and SourceIndex are reversed,
> fixed", +				      index));
> +		}
> +
> +		/*
>  		 * 3) Third subobject: Dereference the PRT.source_name
>  		 * The name may be unresolved (slack mode), so allow a null object
>  		 */


