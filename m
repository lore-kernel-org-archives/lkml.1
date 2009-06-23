Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbZFWQwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbZFWQwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZFWQvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:51:55 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:34457 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZFWQvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:51:54 -0400
Date: Tue, 23 Jun 2009 12:51:39 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 6/8] SFI: add ACPI extensions
In-reply-to: <87my7z16u5.fsf@basil.nowhere.org>
Message-id: <alpine.LFD.2.00.0906231236290.21402@localhost.localdomain>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
 <505434cf34f7438a65262060df88b0638511684d.1245740912.git.len.brown@intel.com>
 <87my7z16u5.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Andi Kleen wrote:
> Len Brown <lenb@kernel.org> writes:

> > diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> > @@ -277,6 +277,9 @@ int __init acpi_table_parse(char *id, acpi_table_handler handler)

> > +	if (acpi_disabled)
> > +		return 1;

> This seems like a weird place to hook this in. Shouldn't that be somewhere else, more
> high level?

acpi_table_parse() is actually a high-level API available to drivers.

Today, drivers tend to test acpi_disabled on their own,
which may be too high level...

The catalyst for this change, IIR, was the PCI code calling
and not checking the return value:

--- a/arch/x86/pci/mmconfig-shared.c
...
@@ -606,7 +607,8 @@ static void __init __pci_mmcfg_init(int early)
...
-               acpi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
+               if (acpi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg))
+                       sfi_acpi_table_parse(ACPI_SIG_MCFG, NULL, NULL, 0, pci_parse_mcfg);
...


> > +	num_entries = (xsdt->header.length - sizeof(struct acpi_table_header) /
> > +		sizeof(u64));
> > +
> > +	pr_debug(PREFIX "XSDT has %d entries\n", num_entries);
> > +
> > +	for (i = 0; i < num_entries; i++)
> > +		sfi_tb_install_table(xsdt->table_offset_entry[i], SFI_ACPI_TABLE);
> 
> Shouldn't this have some more sanity checking, e.g. for overflows?

good observation. Although we did already check the signature and 
checksum, I don't see that we yet have a sanity check either here
or in sfi_tb_install_table() itself.

thanks,
-Len


