Return-Path: <linux-kernel-owner+w=401wt.eu-S1764962AbYCFMwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764962AbYCFMwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYCFMwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:52:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56749 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYCFMwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:52:40 -0500
Date: Thu, 6 Mar 2008 13:52:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
Message-ID: <20080306125215.GD20173@elte.hu>
References: <47CDBB87.8090906@goop.org> <20080304212821.GB8944@elte.hu> <47CDBEDC.1050302@goop.org> <20080305064814.GB28398@elte.hu> <Pine.LNX.4.64.0803051407310.22243@blonde.site> <47CECEE9.3000801@goop.org> <Pine.LNX.4.64.0803051721200.13410@blonde.site> <47CEF20D.5070608@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CEF20D.5070608@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> It seems to me that the correct fix is to just make __set_fixmap 
> disable preemption for its duration; it probably doesn't make much 
> difference for the native case, and it makes Xen happy.

actually, i think the correct approach is to remove the TLB flushing and 
perhaps to check that the old pte is not present. Do we ever _change_ 
mappings via __set_fixmap()? I think we only ever install them.

but if we ever change them somewhere then the correct approach is to do 
a flush_tlb_all(). It's not just about preemption but about the fact 
that we modified the kernel address space and we must propagate that to 
all CPUs.

the vmalloc() backtrace you sent - how did set_pte_pfn() get into that 
codepath - vmalloc shouldnt be using __set_fixmap().

	Ingo
