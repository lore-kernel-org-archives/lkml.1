Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYFSAQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYFSAQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYFSAQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:16:21 -0400
Received: from gw.goop.org ([64.81.55.164]:40803 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbYFSAQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:16:20 -0400
Message-ID: <4859A528.1010107@goop.org>
Date: Wed, 18 Jun 2008 17:15:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction	abstraction
References: <b020e42384197b824320.1213615800@localhost>	<1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org>
In-Reply-To: <4859A149.9090004@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Benjamin Herrenschmidt wrote:
>   
>> On Mon, 2008-06-16 at 04:30 -0700, Jeremy Fitzhardinge wrote:
>>   
>>     
>>> The only current user of this interface is mprotect
>>>     
>>>       
>> Do you plan to use it with fork ultimately ?
>>   
>>     
>
> Good point, I'd overlooked that.  I guess that means using it in 
> ptep_set_wrprotect().
Along the lines of:

--- a/include/asm-x86/pgtable.h	Wed Jun 18 13:54:49 2008 -0700
+++ b/include/asm-x86/pgtable.h	Wed Jun 18 17:03:39 2008 -0700
@@ -491,7 +491,11 @@
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pte_t *ptep)
 {
-	clear_bit(_PAGE_BIT_RW, (unsigned long *)&ptep->pte);
+	pte_t pte = ptep_modify_prot_start(mm, addr, ptep);
+	
+	pte = pte_wrprotect(pte);
+
+	ptep_modify_prot_commit(mm, addr, ptep, pte);
 	pte_update(mm, addr, ptep);
 }
 

	J

