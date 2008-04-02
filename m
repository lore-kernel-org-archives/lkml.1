Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbYDBW4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbYDBW4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbYDBW4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:56:03 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37069 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017AbYDBW4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:56:00 -0400
Date: Wed, 2 Apr 2008 15:55:56 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Nish Aravamudan <nish.aravamudan@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: HugeTLB vs. SH3 cpu
Message-ID: <20080402225556.GI21524@us.ibm.com>
References: <20080401225809.GC32269@cs181133002.pp.htv.fi> <29495f1d0804011626n2399d69aj7566df7f78953458@mail.gmail.com> <20080402080448.GA4171@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402080448.GA4171@linux-sh.org>
X-Operating-System: Linux 2.6.24-12-generic (i686)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.04.2008 [17:04:48 +0900], Paul Mundt wrote:
> On Tue, Apr 01, 2008 at 04:26:14PM -0700, Nish Aravamudan wrote:
> > On 4/1/08, Adrian Bunk <bunk@kernel.org> wrote:
> > > fs/Kconfig says:
> > >
> > >  config HUGETLBFS
> > >         bool "HugeTLB file system support"
> > >         depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || BROKEN
> > >
> > >
> > >  arch/sh/mm/Kconfig says:
> > >
> > >  choice
> > >         prompt "HugeTLB page size"
> > >         depends on HUGETLB_PAGE && (CPU_SH4 || CPU_SH5) && MMU
> > 
> > So the problem is that SH3 is allowed to enable
> > HUGETLB_PAGE/HUGETLBFS, but only SH4/5 define the HPAGE_SHIFT macro,
> > due to some #ifdeffery on the hugepage size. So either the choice
> > needs to be extended to include CPU_SH3 (which builds here, when
> > changed) or the HUGETLBFS conditional needs to depend more
> > specifically on SH4/5 and not just SUPERH. I think the arch maintainer
> > has to make that call, as I don't know the hardware to say if SH3
> > actually supports multiple hugepage sizes.
> > 
> The problem is that the hugetlb Kconfig stuff is a complete mess. There's
> a semi-decoupling between HUGETLBFS and HUGETLB_PAGE, though they both
> depend on each other.
> 
> Sorting out the mess noted by Adrian is pretty trivial with a
> HAVE_HUGETLB_PAGE. How about this?

I'm confused, isn't the following simpler fix equivalent?

Fix sh3 build with HUGETLBFS=y. Only SH4 and SH5 actually support
HUGETLB_PAGE (which HUGETLBFS depends on).

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

diff --git a/fs/Kconfig b/fs/Kconfig
index d731282..1981f8e 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -978,7 +978,7 @@ config TMPFS_POSIX_ACL
 
 config HUGETLBFS
 	bool "HugeTLB file system support"
-	depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || BROKEN
+	depends on X86 || IA64 || PPC64 || SPARC64 || ((CPU_SH4 || CPU_SH5) && MMU) || BROKEN
 	help
 	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
 	  ramfs. For architectures that support it, say Y here and read
