Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYHHHu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYHHHu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYHHHuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:50:15 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47793 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYHHHuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:50:14 -0400
Date: Fri, 8 Aug 2008 17:50:10 +1000
From: Simon Horman <horms@verge.net.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Allow compile with CONFIG_DEBUG_INFO=y, X86_PAE not set on gcc
	3.4.5
Message-ID: <20080808075008.GA23123@verge.net.au>
References: <20080808050429.GA8473@verge.net.au> <489BE9C3.2010006@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489BE9C3.2010006@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 11:37:55PM -0700, Jeremy Fitzhardinge wrote:
> Simon Horman wrote:
>> Hi,
>>
>> It appears that "x86: preallocate and prepopulate separately"
>> (d8d5900ef8afc562088f8470feeaf17c4747790f) introduced a minor regression.
>> The build fails on gcc 3.4.5 if CONFIG_DEBUG_INFO=y (that is gcc is
>> called with -g) and X86_PAE not set.
>>
>> There was previously some discussion of this without resolution.
>> http://lkml.org/lkml/2008/7/18/250
>>
>> 	arch/x86/mm/pgtable.c: In function `pgd_prepopulate_pmd':
>> 	arch/x86/mm/pgtable.c:222: internal compiler error: in remove_insn, at emit-rtl.c:3746
>> 	Please submit a full bug report,
>> 	with preprocessed source if appropriate.
>> 	See <URL:http://gcc.gnu.org/bugs.html> for instructions.
>>
>> 	# i686-unknown-linux-gnu-gcc --version
>> 	i686-unknown-linux-gnu-gcc (GCC) 3.4.5
>>
>> My investigations seem to show that gcc 3.4.5 can't cope with the following
>> construct:
>>
>> 	for (i = 0; i < 0; i++)
>> 		...
>>
>> or more specifically:
>>
>> 	for (i = 0; i < PREALLOCTED_PMDS; i++)
>> 		...
>>
>> when PREALLOCTED_PMDS is 0. That is, when X86_PAE is not set.
>>
>> This patch resolves this problem by moving the relevant code inside
>> #define X86_PAE and providing dummy functions outside !X86_PAE.
>>
>> Signed-off-by: Simon Horman <horms@verge.net.au>
>>   
>
> We resolved the other report by saying that gcc 3.4.4 is broken. It  
> seems 3.4.5 is as well.  Could you just update the compiler?  I'd rather  
> not have to clutter the code with more ifdefs if we can possibly avoid 
> it.

I'm not sure that I would call that resolved.

The patch doesn't add any extra ifdefs. It just explicitly provides
empty functions rather than relying on the compiler to optimise
things out.

If gcc 3.4.4 and 3.4.5 really aren't valid compilers to use that is fine.
But it seems rather silly that this somewhat simple change renders
them unusable for this config.

> Does putting
>
> 	if (PREALLOCATED_PMDS == 0)
> 		return;
>
>
> before the for loop help?

Yes, it does. The code does compile with the following:

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 557b2ab..938cfe2 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -152,6 +152,9 @@ static void free_pmds(pmd_t *pmds[])
 {
 	int i;
 
+	if (PREALLOCATED_PMDS == 0)
+		return;
+
 	for(i = 0; i < PREALLOCATED_PMDS; i++)
 		if (pmds[i])
 			free_page((unsigned long)pmds[i]);
@@ -162,6 +165,9 @@ static int preallocate_pmds(pmd_t *pmds[])
 	int i;
 	bool failed = false;
 
+	if (PREALLOCATED_PMDS == 0)
+		return 0;
+
 	for(i = 0; i < PREALLOCATED_PMDS; i++) {
 		pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL|__GFP_REPEAT);
 		if (pmd == NULL)
@@ -187,6 +193,9 @@ static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
 {
 	int i;
 
+	if (PREALLOCATED_PMDS == 0)
+		return;
+
 	for(i = 0; i < PREALLOCATED_PMDS; i++) {
 		pgd_t pgd = pgdp[i];
 
@@ -207,6 +216,9 @@ static void pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmds[])
 	unsigned long addr;
 	int i;
 
+	if (PREALLOCATED_PMDS == 0)
+		return;
+
 	pud = pud_offset(pgd, 0);
 
  	for (addr = i = 0; i < PREALLOCATED_PMDS;
