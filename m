Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbZEOH6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbZEOH6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 03:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbZEOH6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 03:58:30 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:21763 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbZEOH6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 03:58:30 -0400
Message-Id: <4A0D3CC6020000780000108F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 15 May 2009 08:58:30 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <tj@kernel.org>
Cc: <mingo@elte.hu>, <andi@firstfloor.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 3/5] x86: fix pageattr handling for remap percpu
	 allocator
References: <1242361739-21186-1-git-send-email-tj@kernel.org>
 <1242361739-21186-4-git-send-email-tj@kernel.org>
In-Reply-To: <1242361739-21186-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Tejun Heo <tj@kernel.org> 15.05.09 06:28 >>>
>@@ -742,6 +744,27 @@ static int cpa_process_alias(struct cpa_data *cpa)
> 	}
> #endif
> 
>+	/*
>+	 * If the PMD page was partially used for per-cpu remapping,
>+	 * the remapped area needs to be split and modified.  Note
>+	 * that the partial recycling only happens at the tail of a
>+	 * partially used PMD page, so touching single PMD page is
>+	 * always enough.
>+	 */
>+	remapped = pcpu_pmd_remapped((void *)vaddr);

vaddr here is the passed-in address, but in order for the lookup to be positive
it needs to be the canonical address (i.e. the one pointing into the 1:1 mapping),
i.e. __va(cpa->pfn << PAGE_SHIFT), just like temp_cpa_vaddr gets calculated
earlier in the same function.

>+	if (remapped) {
>+		int max_pages = PFN_DOWN(PMD_SIZE - (vaddr & ~PMD_MASK));
>+
>+		alias_cpa = *cpa;
>+		temp_cpa_vaddr = (unsigned long)remapped;
>+		alias_cpa.vaddr = &temp_cpa_vaddr;
>+		alias_cpa.numpages = min(alias_cpa.numpages, max_pages);
>+		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
>+		ret = __change_page_attr_set_clr(&alias_cpa, 0);
>+		if (ret)
>+			return ret;
>+	}
>+
> 	return 0;
> }

Sorry for not having spotted this yesterday,
Jan

