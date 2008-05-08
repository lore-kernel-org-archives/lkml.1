Return-Path: <linux-kernel-owner+w=401wt.eu-S1765343AbYEHRRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765343AbYEHRRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760371AbYEHRRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:17:07 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58174 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760128AbYEHRRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:17:04 -0400
Date: Thu, 8 May 2008 10:16:57 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Hugh Dickins <hugh@veritas.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
Message-ID: <20080508171657.GO23990@us.ibm.com>
References: <Pine.LNX.4.64.0805062043580.11647@blonde.site> <20080506202201.GB12654@escobedo.amd.com> <1210106579.4747.51.camel@nimitz.home.sr71.net> <20080508143453.GE12654@escobedo.amd.com> <1210258350.7905.45.camel@nimitz.home.sr71.net> <20080508151145.GG12654@escobedo.amd.com> <1210261882.7905.49.camel@nimitz.home.sr71.net> <20080508161925.GH12654@escobedo.amd.com> <20080508163352.GN23990@us.ibm.com> <20080508165111.GI12654@escobedo.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508165111.GI12654@escobedo.amd.com>
X-Operating-System: Linux 2.6.25-mm1-00024-g164d446 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.05.2008 [18:51:11 +0200], Hans Rosenfeld wrote:
> On Thu, May 08, 2008 at 09:33:52AM -0700, Nishanth Aravamudan wrote:
> > So this seems to lend credence to Dave's hypothesis. Without, as you
> > were trying before, teaching pagemap all about hugepages, what are our
> > options?
> > 
> > Can we just skip over the current iteration of the PMD loop (would we
> > need something similar for the PTE loop for power?) if pmd_huge(pmd)?
> 
> Allowing huge pages in the page walker would affect both walk_pmd_range
> and walk_pud_range. Then either the users of the page walker need to
> know how to handle huge pages themselves (in the pmd_entry and pud_entry
> callback functions), or the page walker treats huge pages as any other
> pages (calling the pte_entry callback function).

Right, I agree *if* we allow huge pages in the walker. But AIUI, things
are broken now with hugepages in the process' address space. This is a
bug upstream and leads to hugepages leaking out of the kernel when
/proc/pid/pagemap is read. Why not, instead (as a short-term fix), skip
hugepage mappings altogether in the page-walker code?

Hrm, upon further investigation, this seems to be a pretty clear
limitation of walk_page_range(). One that is avoided in the other two
callers, i.e.

static int show_smap(struct seq_file *m, void *v)
{
...
	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
		walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
				&smaps_walk, &mss);
...
}

static ssize_t clear_refs_write(struct file *file, const char __user *buf,
				size_t count, loff_t *ppos)
{
...
		for (vma = mm->mmap; vma; vma = vma->vm_next)
			if (!is_vm_hugetlb_page(vma))
				walk_page_range(mm, vma->vm_start, vma->vm_end,
						&clear_refs_walk, vma);
...
}

No such protection exists for

static ssize_t pagemap_read(struct file *file, char __user *buf,
			    size_t count, loff_t *ppos);

So, is there any way to either add a is_vm_hugetlb_page(vma) check into
pagemap_read()? Or can we modify walk_page_range to take the a vma and
skip the walking if is_vm_hugetlb_page(vma) is set [to avoid
complications down the road until hugepage walking is fixed]. I guess
the latter isn't possible for pagemap_read(), since we are just looking
at arbitrary addresses in the process space?

Dunno, seems quite clear that the bug is in pagemap_read(), not any
hugepage code, and that the simplest fix is to make pagemap_read() do
what the other walker-callers do, and skip hugepage regions.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
