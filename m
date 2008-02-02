Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbYBBJcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbYBBJcV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbYBBJcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:32:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53975 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYBBJcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:32:06 -0500
Date: Sat, 2 Feb 2008 10:31:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>,
       Zach Amsden <zach@vmware.com>
Subject: Re: [PATCH 3 of 5] x86/pgtable.h: demacro ptep_set_access_flags
Message-ID: <20080202093149.GD12044@elte.hu>
References: <patchbomb.1201908323@localhost> <cfac9c32b71b989fe256.1201908326@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfac9c32b71b989fe256.1201908326@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> +static inline int ptep_set_access_flags(struct vm_area_struct *vma,
> +					unsigned long address, pte_t *ptep,
> +					pte_t entry, int dirty)
> +{
> +	int changed = !pte_same(*ptep, entry);
> +	if (changed && dirty) {
> +		*ptep = entry;
> +		pte_update_defer(vma->vm_mm, address, ptep);
> +		flush_tlb_page(vma, address);
> +	}
> +	return changed;
> +}

another thing: these inlines are a bit fat and they are used in more 
than one place. Please move them into pgtable.c. The rule of thumb is: 
if an inline is more than 2 lines big, it is a likely candidate for 
uninlining. (and even many 2-liners, and even some 1-liners are 
candidates) Especially under paravirt the MMU inlines grow these update 
notifiers so they become even fatter.

having functions instead of inlines also simplifies the type 
dependencies by quite a degree.

	Ingo
