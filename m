Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbYG1UeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbYG1UeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbYG1Udu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:33:50 -0400
Received: from gw.goop.org ([64.81.55.164]:48723 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494AbYG1Udt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:33:49 -0400
Message-ID: <488E2D28.9060602@goop.org>
Date: Mon, 28 Jul 2008 13:33:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] xen: fix allocation and use of large ldts
References: <488C97FE.2010606@goop.org> <20080728122648.GC5515@elte.hu>
In-Reply-To: <20080728122648.GC5515@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> When the ldt gets to more than 1 page in size, the kernel uses vmalloc
>> to allocate it.  This means that:
>> - when making the ldt RO, we must update the pages in both the vmalloc
>>   mapping and the linear mapping to make sure there are no RW aliases.
>> - we need to use arbitrary_virt_to_machine to compute the machine addr
>>   for each update
>>     
>
> applied to tip/x86/xen, thanks Jeremy.
>   

Thanks.  Here's a follow-up tidy patch.

Subject: xen: tidy up ldt fixes

Add a proper comment for set_aliased_prot() and fix an
unsigned long/void * warning.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -395,8 +395,10 @@
 }
 
 /*
- * If 'v' is a vmalloc mapping, then find the linear mapping of the
- * page (if any) and also set its protections to match:
+ * Set the page permissions for a particular virtual address.  If the
+ * address is a vmalloc mapping (or other non-linear mapping), then
+ * find the linear mapping of the page and also set its protections to
+ * match.
  */
 static void set_aliased_prot(void *v, pgprot_t prot)
 {
@@ -545,8 +547,7 @@
 static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
 				const void *ptr)
 {
-	unsigned long lp = (unsigned long)&dt[entrynum];
-	xmaddr_t mach_lp = arbitrary_virt_to_machine(lp);
+	xmaddr_t mach_lp = arbitrary_virt_to_machine(&dt[entrynum]);
 	u64 entry = *(u64 *)ptr;
 
 	preempt_disable();


