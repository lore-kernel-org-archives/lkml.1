Return-Path: <linux-kernel-owner+w=401wt.eu-S933716AbZJMHfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716AbZJMHfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbZJMHfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:35:17 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:23612 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbZJMHfO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;10:1>);
	Tue, 13 Oct 2009 03:35:14 -0400
Message-Id: <4AD449A702000078000197EE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 13 Oct 2009 08:34:31 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Thomas Schlichter" <thomas.schlichter@web.de>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Tejun Heo" <tj@kernel.org>, <x86@kernel.org>,
       "Yinghai Lu" <yinghai@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       <dri-devel@lists.sourceforge.net>, "Ingo Molnar" <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>,
       "Thomas Hellstrom" <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
	 available
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Thomas Schlichter <thomas.schlichter@web.de> 12.10.09 20:32 >>>
>@@ -268,11 +269,14 @@ EXPORT_SYMBOL(ioremap_nocache);
>  */
> void __iomem *ioremap_wc(resource_size_t phys_addr, unsigned long size)
> {
>-	if (pat_enabled)
>-		return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
>-					__builtin_return_address(0));
>-	else
>-		return ioremap_nocache(phys_addr, size);
>+	if (!pat_enabled) {
>+		void __iomem *ret = ioremap_nocache(phys_addr, size);
>+		if (ret)
>+			mtrr_add(phys_addr, size, MTRR_TYPE_WRCOMB, false);

This won't work if phys_addr or size aren't page aligned, or if size isn't
a power of two.

>+		return ret;
>+	}
>+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
>+				__builtin_return_address(0));
> }
> EXPORT_SYMBOL(ioremap_wc);
> 
>@@ -1010,8 +1011,13 @@ int set_memory_wc(unsigned long addr, int numpages)
> {
> 	int ret;
> 
>-	if (!pat_enabled)
>-		return set_memory_uc(addr, numpages);
>+	if (!pat_enabled) {
>+		ret = set_memory_uc(addr, numpages);
>+		if (!ret)
>+			mtrr_add(__pa(addr), numpages * PAGE_SIZE,
>+				 MTRR_TYPE_WRCOMB, false);

Similarly, this requires numpages to be a power of two.

>+		return ret;
>+	}
> 
> 	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
> 		_PAGE_CACHE_WC, NULL);

I think user mode code handles this by splitting the request and trying to
establish as many entries as possible (and those as big as possible).

Also, in all cases you pass 'false' for the 'increment' parameter, in order
to avoid having to tear down the established entries. While this may be
reasonable for kernel initiated mappings, I don't think that's acceptable
for such originating from user mode.

Jan

