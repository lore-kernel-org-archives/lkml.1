Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbZAHVli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbZAHVli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 16:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbZAHVla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 16:41:30 -0500
Received: from colo.lackof.org ([198.49.126.79]:59389 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZAHVl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 16:41:29 -0500
Date: Thu, 8 Jan 2009 14:41:16 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Dirk Hohndel <hohndel@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: git-latest: kernel oops in IOMMU setup
Message-ID: <20090108214116.GB20506@colo.lackof.org>
References: <20090108120538.0176d348@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108120538.0176d348@infradead.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 12:05:38PM -0800, Dirk Hohndel wrote:
> 
> latest git from Linus. On a Thinkpad x200s with VT-d enabled (if I
> disable VT-d, this of course goes away). 
> 
> The oops happens very early during boot in device_to_iommu (called
> from domain_context_mapping_one).
> 
> Looking at the code dump and the disassembled function here's where
> the error happens:
> 
> static struct intel_iommu *device_to_iommu(u8 bus, u8 devfn)
> {
>         struct dmar_drhd_unit *drhd = NULL;
>         int i;
> 
>         for_each_drhd_unit(drhd) {
>                 if (drhd->ignored)
>                         continue;
> 
>                 for (i = 0; i < drhd->devices_cnt; i++)
>                         if (drhd->devices[i]->bus->number == bus &&
> --> drhd->devices[0] is NULL
>                             drhd->devices[i]->devfn == devfn)
>                                 return drhd->iommu;
> 
> 
> Given how early this happens it's a little hard to provide logs, etc. I
> literally used delay_boot=100 and wrote things down by hand (forgot my
> digital camera) and then added printk's to verify).
> 
> please let me know what other data I should collect.

If you can, a back trace. Basically just need to know which caller
is tripping over this. But there can't be that many callers and they
are all in this file:
0 intel-iommu.c device_to_iommu            431 static struct intel_iommu *device_to_iommu(u8 bus, u8 devfn)
1 intel-iommu.c domain_context_mapping_on 1471 iommu = device_to_iommu(bus, devfn);
2 intel-iommu.c domain_context_mapped     1593 iommu = device_to_iommu(pdev->bus->number, pdev->devfn);
3 intel-iommu.c domain_remove_dev_info    1684 iommu = device_to_iommu(info->bus, info->devfn);
4 intel-iommu.c vm_domain_remove_one_dev_ 2773 iommu = device_to_iommu(pdev->bus->number, pdev->devfn);
5 intel-iommu.c vm_domain_remove_one_dev_ 2803 if (device_to_iommu(info->bus, info->devfn) == iommu)
6 intel-iommu.c vm_domain_remove_all_dev_ 2836 iommu = device_to_iommu(info->bus, info->devfn);
7 intel-iommu.c intel_iommu_attach_device 3023 iommu = device_to_iommu(pdev->bus->number, pdev->devfn);

so it should be possible to figure out which one is called
before the dev is setup. It's unlikely to be anything with
"remove" in the name. :)

My guess is it's intel_iommu_attach_device being called "too early".

hth,
grant


hth,
grant

> 
> The system ran fine with the 2.6.28 release kernel.
> 
> /D
> 
> -- 
> Dirk Hohndel
> Intel Open Source Technology Center
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
