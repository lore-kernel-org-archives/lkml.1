Return-Path: <linux-kernel-owner+w=401wt.eu-S1751666AbZJWE6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbZJWE6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 00:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZJWE6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 00:58:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:50925 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbZJWE6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 00:58:47 -0400
X-ExtLoop1: 1
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>, Thomas Hellstrom <thellstrom@vmware.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, Thomas Schlichter <thomas.schlichter@web.de>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockrwd@gmail.com>
In-Reply-To: <20091023133152.1a15ba69@jbarnes-x200>
References: <1394846127@web.de>
	 <4ADF32A0020000780001B20A@vpn.id2.novell.com>
	 <20091021173514.GA32227@elte.hu>
	 <200910212201.36578.thomas.schlichter@web.de>
	 <1256205210.2530.28.camel@sbs-t61>
	 <1256225689.32075.6.camel@gaiman.anholt.net>
	 <1256248050.2546.9.camel@sbs-t61>	<20091023081047.4d8abc29@jbarnes-x200>
	 <1256256717.2534.6.camel@sbs-t61>
	 <1256262799.15120.8.camel@gaiman.anholt.net>
	 <20091023133152.1a15ba69@jbarnes-x200>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 22 Oct 2009 21:58:15 -0700
Message-Id: <1256273896.2569.10.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 21:31 -0700, Jesse Barnes wrote:
> Here's a quick & dirty version, totally untested.  A cleaner approach
> would be to separate the WC mapping routines and hide the return
> -EINVAL in arch specific code...

Jesse How about this patch? Doing this in x86 is cleaner.

I would like Acks/sign-offs-by Thomas, Eric and Jesse, if it is ok with
this patch and works.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, pat: return EINVAL for pci mmap WC request for !pat_enabled

Thomas Schlichter reported:
> X.org uses libpciaccess which tries to mmap with write combining enabled via
> /sys/bus/pci/devices/*/resource0_wc. Currently, when PAT is not enabled, the
> kernel does fall back to uncached mmap. Then libpciaccess thinks it succeeded
> mapping with write combining enabled and does not set up suited MTRR entries.
> ;-(

Instead of silently mapping pci mmap region as UC minus in the case
of !pat_enabled and wc request, we can return error. Eric Anholt mentioned
that caller (like X) typically follows up with UC minus pci mmap request and
if there is a free mtrr slot, caller will manage adding WC mtrr.

Jesse Barnes says:
> Older versions of libpciaccess will behave better if we do it that way
> (iirc it only allocates an MTRR if the resource_wc file doesn't exist or
> fails to get mapped).

Reported-by: Thomas Schlichter <thomas.schlichter@web.de>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b22d13b..a672f12 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -282,6 +282,15 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		return -EINVAL;
 
 	prot = pgprot_val(vma->vm_page_prot);
+
+	/*
+ 	 * Return error if pat is not enabled and write_combine is requested.
+ 	 * Caller can followup with UC MINUS request and add a WC mtrr if there
+ 	 * is a free mtrr slot.
+ 	 */
+	if (!pat_enabled && write_combine)
+		return -EINVAL;
+
 	if (pat_enabled && write_combine)
 		prot |= _PAGE_CACHE_WC;
 	else if (pat_enabled || boot_cpu_data.x86 > 3)


