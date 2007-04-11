Return-Path: <linux-kernel-owner+w=401wt.eu-S1161120AbXDKAK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120AbXDKAK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 20:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161133AbXDKAK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 20:10:57 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:30265 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161120AbXDKAK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 20:10:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yHYRQU9qSPvZKIOZ31SkRQ104IqK2r20xprXSBCCnHOcn4WAGW0OC38WWDWVS7XPwr8Ebuz0RV28mshuBLmUocSbmy1mmhoFXD0dUjjQ5n+cJHP9qsPE1FloVLKhFWFoXUFN085MAcGNdc9281XJuplKdsGTfKZIA23VGNf6LiA=  ;
X-YMail-OSG: CLAQqWwVM1kDa7dppJJ6zmbK7v30vCmVYQxg.g4TA1tSfyxYP_Md2p9eTZPrPndU9rM2u3S9jw--
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Date: Tue, 10 Apr 2007 17:10:50 -0700
User-Agent: KMail/1.7.1
Cc: Zhang Rui <rui.zhang@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       lenb@kernel.org, "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704031741.42273.david-b@pacbell.net> <200704071308.07571.david-b@pacbell.net> <200704101629.18412.david-b@pacbell.net>
In-Reply-To: <200704101629.18412.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704101710.50936.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007 4:29 pm, David Brownell wrote:
> 	... the appended
> patch goes on top of the previous pnpacpi patch, and should (nyet tested!)
> fix another place I saw that warning.

And here's a tested version.  Curiouser and curiouser.  I think the mapping
of ACPI tables to sysfs nodes still needs a bunch of work...

- Dave

==========	CUT HERE
Handle PNP devices that have the same IDs a bit more sanely ... this at least
arranges multiple one-to-one mappings between PNP nodes and ACPI nodes that
all share the same PNP0c02 id.  (Maybe mapped to the wrong node though...)

This remains a hack, since it masks failures where PNP0a03 (a PCI root bridge)
is handled by ACPI special case code (/sys/devices/pci0000:00 on my systems
instead of /sys/devices/pnp0/pnp00:0/pci0000:00!) not pure PNPACPI logic.

I suspect that pnp_dev.number and some acpi_device field need to be compared,
(so the right PNP0c02 nodes hook up to each other, PNP0a03 likewise) but I'll
leave that to someone who knows how those ACPI table lookups "should" work.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- g26.orig/drivers/pnp/pnpacpi/core.c	2007-04-10 01:38:53.000000000 -0700
+++ g26/drivers/pnp/pnpacpi/core.c	2007-04-10 16:35:13.000000000 -0700
@@ -243,6 +243,7 @@ static int __init acpi_pnp_match(struct 
 
 	/* true means it matched */
 	return acpi->flags.hardware_id
+		&& !acpi_get_physical_device(acpi->handle)
 		&& compare_pnp_id(pnp->id, acpi->pnp.hardware_id);
 }
 
