Return-Path: <linux-kernel-owner+w=401wt.eu-S965091AbXJPSIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965091AbXJPSIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765197AbXJPSIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:08:21 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47713 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764540AbXJPSIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:08:19 -0400
Subject: Re: [patch 2/3] Introduce BOOTMEM_EXCLUSIVE
From: Dave Hansen <haveblue@us.ibm.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       akpm@linux-foundation.org, ak@suse.de
In-Reply-To: <20071016162858.545617122@strauss.suse.de>
References: <20071016162857.635479952@strauss.suse.de>
	 <20071016162858.545617122@strauss.suse.de>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 11:08:16 -0700
Message-Id: <1192558097.17464.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 18:28 +0200, Bernhard Walle wrote:
> 
> @@ -736,7 +736,7 @@ static int __init smp_scan_config (unsig
>                         smp_found_config = 1;
>                         printk(KERN_INFO "found SMP MP-table at %08lx\n",
>                                                 virt_to_phys(mpf));
> -                       reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE);
> +                       reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE, 0);
>                         if (mpf->mpf_physptr) {
>                                 /* 

Could you give all of these 0's a name?  I really hate seeing random
magic numbers in these things.  0 completely kills the ability of
someone to read the code and figure out what it is trying to do without
going and looking at reserve_bootmem().

Or, alternatively, do something like this:

-extern void reserve_bootmem(unsigned long addr, unsigned long size);
+/*
+ * If flags is 0, then the return value is always 0 (success). If
+ * flags contains BOOTMEM_EXCLUSIVE, then -EBUSY is returned if the
+ * memory already was reserved.
+ */
+extern int reserve_bootmem(unsigned long addr, unsigned long size, int flag);
+int reserve_bootmem(unsigned long addr, unsigned long size)
+{
+	/* the 0 is because we don't
+	return reserve_bootmem_exclusive(addr, size, 0);
+}

Where all of the existing callers stay the same.  But, the ones wanting
exclusive access actually call the _exclusive() variant.  

-- Dave

