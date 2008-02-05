Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYBEG40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYBEG40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYBEG4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:56:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:56260 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYBEG4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:56:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=jrtNcXZ9/9EWPoul2/Mi2BSkAVc+AnS9/9kiu9DBiudxNFrkG5v84cAy0FpJT15m5ef2x/WgcG0Tc5cUEAVuNdpPsDV17k63CbBAP/cMOVH8wN77jPYmcuoK9xVutBVOGuDjLFEoQnn0fkIi16bUeObqDjeBJ1a0KuZ+WDdL2FE=
Message-ID: <47A80889.3030200@gmail.com>
Date: Tue, 05 Feb 2008 13:56:09 +0700
From: Igor M Podlesny <for.poige+linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071205 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: > global_flush_tlb() would be the correct one.
References: <43d009740802022335y21c3f93ep4e444bef71338045@mail.gmail.com>	 <20080202235103.20dd9768.akpm@linux-foundation.org>	 <47A71040.5000300@gmail.com>	 <20080204052709.12f4e0d3.akpm@linux-foundation.org>	 <47A7F4DB.3070406@gmail.com>	<47A80218.3040304@gmail.com>	 <20080204223430.415161e9@laptopd505.fenrus.org>	 <47A805C3.9050303@gmail.com> <1202194390.28740.8.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1202194390.28740.8.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-02-05 13:53, Zachary Amsden wrote:
> On Tue, 2008-02-05 at 13:44 +0700, Igor M Podlesny wrote:
>> On 2008-02-05 13:34, Arjan van de Ven wrote:
>> [...]
>> >> 	1) To have compiled it I had to replace global_flush_tlb()
>> >> call with __flush_tlb_all() and still guessing was it(?) a correct
>> >> replacment at all :-)
>> > 
>> > it is not; 
>> 
>> 	I see, thanks. What would be the correct one? ;-)
> 
> global_flush_tlb() would be the correct one.
> 
	Looking at the kernel's patch I don't think so:

-void global_flush_tlb(void)
-{
-       struct list_head l;
-       struct page *pg, *next;
-
-       BUG_ON(irqs_disabled());
-
-       spin_lock_irq(&cpa_lock);
-       list_replace_init(&df_list, &l);
-       spin_unlock_irq(&cpa_lock);
-       flush_map(&l);
-       list_for_each_entry_safe(pg, next, &l, lru) {
-               list_del(&pg->lru);
-               clear_bit(PG_arch_1, &pg->flags);
-               if (PageReserved(pg) || !cpu_has_pse || page_private(pg) != 0)
-                       continue;
-               ClearPagePrivate(pg);
-               __free_page(pg);
-       }
-}
-
-EXPORT_SYMBOL(global_flush_tlb);

-- 
