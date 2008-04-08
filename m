Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYDHQT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYDHQT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYDHQTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:19:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:14750 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYDHQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Zkft73EFwle8mps8MNYabnTMS2watYtjbMJJxSp0reUnAIXGkFnwikQkINv3W6QGyBYpNxVTQse2Y7YupdE3CrQseGdPJjrPAA85iUQNHjtaluMOn1cr7MzDObkaRMY+9ig5Rwiu9rGpj+nGBwnvrxISFGOzFbAqSHuQfdT5PIw=
Date: Tue, 8 Apr 2008 20:18:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: bootmem allocator
Message-ID: <20080408161834.GC7656@cvg>
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu> <87iqytqwl7.fsf@basil.nowhere.org> <86802c440804071445l7bef949fg5c500f0c09ae40e@mail.gmail.com> <aa79d98a0804072114q300e336eoec814ad6053c934d@mail.gmail.com> <47FAF593.4020503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FAF593.4020503@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Mon, Apr 07, 2008 at 09:33:23PM -0700]
> Cyrill Gorcunov wrote:
>> I think it would be a good idea ;) Btw maybe would be better to call
>> memset on the code witch relies on "clear" memory explicitly? So we will
>> clear memory allocated *only* if we really need this.
>
> Are there any users of bootmem which will allocate a significant amount of 
> memory and don't need it zeroed?
>
> 	-hpa
>

Well, the only really significant allocation I found is in
arch/ia64/kernel/iosapi.c:

---[...]---
static struct iosapic_rte_info * __init_refok iosapic_alloc_rte (void)
{
	int i;
	struct iosapic_rte_info *rte;
	int preallocated = 0;

	if (!iosapic_kmalloc_ok && list_empty(&free_rte_list)) {
--->		rte = alloc_bootmem(sizeof(struct iosapic_rte_info) *
				    NR_PREALLOCATE_RTE_ENTRIES);
		if (!rte)
			return NULL;
		for (i = 0; i < NR_PREALLOCATE_RTE_ENTRIES; i++, rte++)
			list_add(&rte->rte_list, &free_rte_list);
	}

	if (!list_empty(&free_rte_list)) {
		rte = list_entry(free_rte_list.next, struct iosapic_rte_info,
				 rte_list);
		list_del(&rte->rte_list);
		preallocated++;
	} else {
		rte = kmalloc(sizeof(struct iosapic_rte_info), GFP_ATOMIC);
		if (!rte)
			return NULL;
	}

	memset(rte, 0, sizeof(struct iosapic_rte_info));
	if (preallocated)
		rte->flags |= RTE_PREALLOCATED;

	return rte;
}
---[...]---

but it requires zeroed memory too. So, no, I didn't found any large
number of bytes allocated by bootmem scheme without needing of its
clearing.

		- Cyrill -
