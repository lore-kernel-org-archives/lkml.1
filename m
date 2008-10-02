Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbYJBWYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbYJBWYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYJBWYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:24:37 -0400
Received: from outbound-mail-129.bluehost.com ([67.222.38.29]:37384 "HELO
	outbound-mail-129.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753580AbYJBWYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:24:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Gdn7WlHRO1+rUUhh0wiMsgmpmponSVqgP0RzoWCICGtvKbRqeBKb5ndPHWKx4PHOlROacmE1uhKNK3egcelYkA3JgTeeCKY5v7qvSM0zmeAp620SW/wB9FBEXQQBoNsC;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [RFC PATCH 02/12] On Tue, 23 Sep 2008, David Miller wrote:
Date: Thu, 2 Oct 2008 15:23:43 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org, kkeil@suse.de,
       agospoda@redhat.com, arjan@linux.intel.com, david.graham@intel.com,
       bruce.w.allan@intel.com, jkosina@suse.cz, john.ronciak@intel.com,
       tglx@linutronix.de, chris.jones@canonical.com, tim.gardner@intel.com,
       airlied@gmail.com
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com> <20080930031927.22950.4692.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20080930031927.22950.4692.stgit@jbrandeb-bw.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021523.45884.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping DaveM.  Does this look ok?  What else would we need for you to remove 
your range checking from sparc?

Thanks,
Jesse

On Monday, September 29, 2008 8:19 pm Jesse Brandeburg wrote:
> From: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> > I did some snooping around, and while doing so I noticed that the PCI
> > mmap code for x86 doesn't do one bit of range checking on the size, or
> > any other aspect of the request, wrt. the MMIO regions actually mapped
> > in the BARs of the PCI device.
>
> Here's a patch that adds range checking to the sysfs mappings at
> least.  This patch should catch the case where X (or some other
> process) tries to map beyond the specific BAR it's (supposedly)
> trying to access, making things safer in general.  FWIW both my
> F9 and development versions of X start up fine with this patch
> applied.
>
> DaveM, will this work for you on sparc?  It looked like your code
> was allowing bridge window mappings, but that behavior should be
> preserved as long as your bridge devices reflect their window
> sizes correctly in their pdev->resources?
>
> If we add similar code to the procfs stuff we wouldn't need to do
> any checking in the arches.
>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>
>  drivers/pci/pci-sysfs.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 9c71858..4d1aa6e 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -16,6 +16,7 @@
>
>
>  #include <linux/kernel.h>
> +#include <linux/sched.h>
>  #include <linux/pci.h>
>  #include <linux/stat.h>
>  #include <linux/topology.h>
> @@ -502,6 +503,8 @@ pci_mmap_resource(struct kobject *kobj, struct
> bin_attribute *attr, struct resource *res = (struct resource
> *)attr->private;
>  	enum pci_mmap_state mmap_type;
>  	resource_size_t start, end;
> +	unsigned long map_len = vma->vm_end - vma->vm_start;
> +	unsigned long map_offset = vma->vm_pgoff << PAGE_SHIFT;
>  	int i;
>
>  	for (i = 0; i < PCI_ROM_RESOURCE; i++)
> @@ -510,6 +513,17 @@ pci_mmap_resource(struct kobject *kobj, struct
> bin_attribute *attr, if (i >= PCI_ROM_RESOURCE)
>  		return -ENODEV;
>
> +	/*
> +	 * Make sure the range the user is trying to map falls within
> +	 * the resource
> +	 */
> +	if (map_offset + map_len > pci_resource_len(pdev, i)) {
> +		WARN(1, "process \"%s\" tried to map 0x%08lx-0x%08lx on BAR %d (size
> 0x%08lx)\n", +		     current->comm, map_offset, map_offset + map_len, i,
> +		     (unsigned long)pci_resource_len(pdev, i));
> +		return -EINVAL;
> +	}
> +
>  	/* pci_mmap_page_range() expects the same kind of entry as coming
>  	 * from /proc/bus/pci/ which is a "user visible" value. If this is
>  	 * different from the resource itself, arch will do necessary fixup.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Jesse Barnes, Intel Open Source Technology Center
