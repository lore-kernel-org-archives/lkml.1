Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbYCCRnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbYCCRnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbYCCRkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:40:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38437 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbYCCRk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:40:29 -0500
Date: Mon, 3 Mar 2008 18:40:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: torvalds@linux-foundation.org, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Message-ID: <20080303174009.GA19131@elte.hu>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CC2A3D.1000307@linux.intel.com>
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/pgtable_32.c:387 pmd_bad+0x44/0x53()
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.25-rc3 #14
>  [<c0424ba5>] warn_on_slowpath+0x41/0x67
>  [<c0408c5c>] ? native_sched_clock+0x94/0xa6
>  [<c043f432>] ? lock_release_holdtime+0x1a/0x115
>  [<c04702d4>] ? handle_mm_fault+0x297/0x7e2
>  [<c063eee6>] ? _spin_unlock+0x1d/0x20
>  [<c04707f0>] ? handle_mm_fault+0x7b3/0x7e2
>  [<c04851c1>] ? do_sync_read+0xab/0xe9
>  [<c0417223>] pmd_bad+0x44/0x53
>  [<c046f37f>] follow_page+0x8b/0x1f2
>  [<c0470aa0>] get_user_pages+0x281/0x2ef

hm. I suspect some gcc related difference related to the handling of 
this masking:

   pmd_val(x) & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)

versus:

   pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)

perhaps it will work if you change it to:

   pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER & ~_PAGE_PSE & ~_PAGE_NX)

?

in any case, the commit has to be reverted as it clearly isnt a NOP on 
your box as it was intended to be. (it should only have made a 
difference in a rare hugetlbfs case)

	Ingo
