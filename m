Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZKDRKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZKDRKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZKDRKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:10:46 -0500
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:55460 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757142AbZKDRKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:10:45 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2009 12:10:45 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ScNxd1vl53Ihp98wI/puaP+smXVep6KiSR9mueZ3ck1gM1dMvq0OPlRJbGV+teZ7yhyuEGSl8WvsPjVPhRboGY8iFOl7dEyTmgXnarGWTKGY8ZCAmfXrCbY/npKkwsF3;
Date: Wed, 4 Nov 2009 09:04:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Chiang <achiang@hp.com>, Yu Zhao <yu.zhao@intel.com>,
       Matthew Wilcox <willy@linux.intel.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: [PATCH] pci: fix nit in ROM BAR size probing
Message-ID: <20091104090409.496540a1@jbarnes-piketon>
In-Reply-To: <20091029152459.GA5480@redhat.com>
References: <20091029152459.GA5480@redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009 17:24:59 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> When probing for ROM BAR size, we should not
> change bits 1:10 in this BAR, because these
> bits are marked as "reserved for future use" in PCI spec,
> so changing them might have side effects.
> 
> No such issue for I/O or memory, as there is
> an implementation note in PCI spec which explicitly allows
> writing 0xfffffffff there.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/pci/probe.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 8105e32..d65aae4 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -163,12 +163,12 @@ int __pci_read_base(struct pci_dev *dev, enum
> pci_bar_type type, {
>  	u32 l, sz, mask;
>  
> -	mask = type ? ~PCI_ROM_ADDRESS_ENABLE : ~0;
> +	mask = type ? PCI_ROM_ADDRESS_MASK : ~0;
>  
>  	res->name = pci_name(dev);
>  
>  	pci_read_config_dword(dev, pos, &l);
> -	pci_write_config_dword(dev, pos, mask);
> +	pci_write_config_dword(dev, pos, l | mask);
>  	pci_read_config_dword(dev, pos, &sz);
>  	pci_write_config_dword(dev, pos, l);

Applied to linux-next, thanks.  Another possible enhancement here would
be to make the mask into a switch based on the type, since mem32 and
mem64 "BARs" (added by willy for doing BAR-like stuff) could probably
use ~0 as well.

Jesse
