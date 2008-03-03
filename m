Return-Path: <linux-kernel-owner+w=401wt.eu-S1762167AbYCCRvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762167AbYCCRvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbYCCRvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:51:18 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:30221 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbYCCRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:51:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mV0A4TVZTXF9zjjQ47ctvAXhwy/CQIMSSrOphSYsQOk1GHIxZw/QtBPsr5/Qm2v0/DPnHIMdEIs6xyken5sLbfd0dAztoX8R0E2EE3t0oMR/AtVKwH/QFf/JpVkv+QCDcJ5etaEk/KjnE3UNyT3o7aCVOy+Sww3cNaSpOMhyv58=
Message-ID: <29495f1d0803030951i151c6373oe1839705983795ee@mail.gmail.com>
Date: Mon, 3 Mar 2008 09:51:09 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Cc: "Arjan van de Ven" <arjan@linux.intel.com>, torvalds@linux-foundation.org,
       hans.rosenfeld@amd.com, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080303174009.GA19131@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080301105646.2c8620d9@laptopd505.fenrus.org>
	 <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu>
	 <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/08, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Arjan van de Ven <arjan@linux.intel.com> wrote:
>
>
> > ------------[ cut here ]------------
>  > WARNING: at arch/x86/mm/pgtable_32.c:387 pmd_bad+0x44/0x53()
>  > Modules linked in:
>  > Pid: 1, comm: swapper Not tainted 2.6.25-rc3 #14
>  >  [<c0424ba5>] warn_on_slowpath+0x41/0x67
>  >  [<c0408c5c>] ? native_sched_clock+0x94/0xa6
>  >  [<c043f432>] ? lock_release_holdtime+0x1a/0x115
>  >  [<c04702d4>] ? handle_mm_fault+0x297/0x7e2
>  >  [<c063eee6>] ? _spin_unlock+0x1d/0x20
>  >  [<c04707f0>] ? handle_mm_fault+0x7b3/0x7e2
>  >  [<c04851c1>] ? do_sync_read+0xab/0xe9
>  >  [<c0417223>] pmd_bad+0x44/0x53
>  >  [<c046f37f>] follow_page+0x8b/0x1f2
>  >  [<c0470aa0>] get_user_pages+0x281/0x2ef
>
>
> hm. I suspect some gcc related difference related to the handling of
>  this masking:
>
>
>    pmd_val(x) & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)
>
>
> versus:
>
>
>    pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)
>
>
> perhaps it will work if you change it to:
>
>
>    pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER & ~_PAGE_PSE & ~_PAGE_NX)
>
>
> ?
>
>  in any case, the commit has to be reverted as it clearly isnt a NOP on
>  your box as it was intended to be. (it should only have made a
>  difference in a rare hugetlbfs case)

On x86/{,_64}, _PAGE_PSE and _PAGE_PROTNONE are the same bit. Would
that have any effect here? We encountered that collision when adding
mprotect() support for hugepages.

Thanks,
Nish
