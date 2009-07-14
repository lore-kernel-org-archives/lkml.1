Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZGNUdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZGNUdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 16:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbZGNUdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 16:33:46 -0400
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:56097 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756474AbZGNUdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VWBa83r6Wabm0cyBz5W0b0UqBSNeHuh0dPMvtPJ9hFJlhNJByTxR4NRGSiYTqvyRRzfc4zcBRRcpvRNcRmRGYA6Dth5mPZSg0dXX+s3MoUfW/L/BAXPRAutnnb34qA6U;
Date: Tue, 14 Jul 2009 13:33:42 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Chiang <achiang@hp.com>
Cc: lenb@kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/3] ACPI/PCI Hotplug: acpiphp cleanup
Message-ID: <20090714133342.1337d839@jbarnes-g45>
In-Reply-To: <20090714200431.GC15021@ldl.fc.hp.com>
References: <20090710193601.30165.62311.stgit@bob.kio>
	<20090714122731.1ebea158@jbarnes-g45>
	<20090714200431.GC15021@ldl.fc.hp.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009 14:04:31 -0600
Alex Chiang <achiang@hp.com> wrote:

> * Jesse Barnes <jbarnes@virtuousgeek.org>:
> > Haven't heard from Len yet, but I'm a bit nervous about adding this
> > to for-linus.  We already have a fix upstream for the
> > acpi_get_pci_dev issue right?  So there's no hurry on this set of
> > (nice) cleanups is there?
> 
> The problem is that I introduced an assumption in
> acpiphp_configure_bridge, which calls acpi_get_pci_dev. That call may
> fail on systems with non-materialized PCI root bridges.
> 
> Fixing that assumption was addressed by this hunk in patch 2/3:
> 
> @@ -1387,16 +1363,7 @@ static void acpiphp_sanitize_bus(struct
> pci_bus *bus) /* Program resources in newly inserted bridge */
>  static int acpiphp_configure_bridge (acpi_handle handle)
>  {
> -       struct pci_dev *dev;
> -       struct pci_bus *bus;
> -
> -       dev = acpi_get_pci_dev(handle);
> -       if (!dev) {
> -               err("cannot get PCI domain and bus number for
> bridge\n");
> -               return -EINVAL;
> -       }
> -
> -       bus = dev->bus;
> +       struct pci_bus *bus = pci_bus_from_handle(handle);
> 
>         pci_bus_size_bridges(bus);
>         pci_bus_assign_resources(bus);
> 
> Now, my systems cannot do PCI root bridge hotplug, so that line
> where we call acpi_get_pci_dev() won't cause us to fail, but I'm
> concerned about machines in the wild that:
> 
> 	a) can do PCI root bridge hotplug
> 	b) have non-materialized PCI root bridges
> 
> Maybe that is a small set of machines...
> 
> I agree that this series is on the large side for -rc4 and
> beyond, but I'd prefer to fix it now.
> 
> The thing is, a "minimal" fix wouldn't save us that much, since
> we'd still have to export acpi_pci_root stuff. We could maybe
> drop patch 3/3 which makes the final diffstat look like this:
> 
>  drivers/acpi/pci_root.c            |   17 +-----
>  include/acpi/acpi_bus.h            |   14 +++++
>  drivers/pci/hotplug/acpiphp_glue.c |  108
> ++++++++++++------------------------ 3 files changed, 53
> insertions(+), 86 deletions(-)
> 
> Hm, actually, I can actually make that even smaller by separating
> out the interface change.
> 
> Would you like me to do that and resubmit? I'd still need an ACK
> from Len re: acpi_pci_root...

How about I actually send a reply this time...

No you don't need to re-submit; assuming Len comes back quickly we can
put this into my for-linus branch. Len, we just need your ack to apply
this series.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
