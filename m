Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbZCWTHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbZCWTHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZCWTHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:07:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:48753 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbZCWTHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:07:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,409,1233561600"; 
   d="scan'208";a="123289331"
Date: Mon, 23 Mar 2009 12:07:20 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error: freeing invalid memtype
Message-ID: <20090323190720.GA16831@linux-os.sc.intel.com>
References: <49C03208.6050603@gmail.com> <1237399938.4529.208.camel@localhost.localdomain> <49C572CC.6090704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C572CC.6090704@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 04:05:48PM -0700, Kevin Winchester wrote:
> Pallipadi, Venkatesh wrote:
> > Kevin,
> > 
> > Can you please send me the output of
> > # cat /debug/x86/pat_memtype_list
> > 
> > (with debugfs mounted at /debug) as soon as you login into X and also
> > when you start seeing these errors with etracer and glxinfo.
> > 
> 
> Here is the output before attempting to run glxinfo:
> : :
> : :
> 
> Does that help track down the problem?  I am about to try disabling PAT
> in my config to see if that fixes things.
> 

Can you please try the patch below and let me whether it helps.

Thanks,
Venki

x86, PAT: Change vma prot in pci_mmap to reflect inherited prot
    
While looking at the issue in the thread
http://marc.info/?l=dri-devel&m=123606627824556&w=2
noticed a bug in pci PAT code and memory type setting.
    
pci mmap code did not set the proper protection in vma, when it
inherited protection in reserve_memtype. This bug only affects
the case where there exists a WC mapping before X does an mmap
with /proc or /sys pci interface. This will cause X userlevel
mmap from /proc or /sysfs to fail on fork.
    
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5ead808..f234a37 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -319,6 +319,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 			return -EINVAL;
 		}
 		flags = new_flags;
+		vma->vm_page_prot = __pgprot(
+			(pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK) |
+			flags);
 	}
 
 	if (((vma->vm_pgoff < max_low_pfn_mapped) ||
