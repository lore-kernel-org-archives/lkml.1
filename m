Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYCCRYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYCCRYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758957AbYCCRPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:35 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:60251 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920AbYCCRPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b7k7JJQzalypsyypb3sNeML05Z0iKwKqlP+zjckxedcC2wLKPIn6wrDHiEEV56FFyf4WWcNHoaPf16xUA4csfTVDySIE394dQGXBa8fkrmk0DwaEyQjTngamfhzH6gbxni6a4OdN7UI73xnNffUocv0gRGo3Bg86AUbHZb6kPEY=
Message-ID: <29495f1d0803030915u19d99fc0nb4a706a9c8e85b59@mail.gmail.com>
Date: Mon, 3 Mar 2008 09:15:22 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
Cc: mingo@elte.hu, torvalds@linux-foundation.org, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080301105646.2c8620d9@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080301105646.2c8620d9@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/08, Arjan van de Ven <arjan@linux.intel.com> wrote:
> Hi Linus, Ingo, Hans,
>
>  Please revert commit cded932b75ab0a5f9181ee3da34a0a488d1a14fd
>  ( x86: fix pmd_bad and pud_bad to support huge pages )
>  since it prevents the kernel to finish booting on my (Penryn based)
>  laptop. The boot stops right after freeing the init memory.
>  Took a while to bisect (due to it touching page*.h, which forces a
>  full recompile), but it definitely is caused by this commit...
>
>  Please revert.
>
>
>
>  [arjan@localhost linux.trees.git]$ git-bisect good
>  cded932b75ab0a5f9181ee3da34a0a488d1a14fd is first bad commit
>  commit cded932b75ab0a5f9181ee3da34a0a488d1a14fd
>  Author: Hans Rosenfeld <hans.rosenfeld@amd.com>
>  Date:   Mon Feb 18 18:10:47 2008 +0100
>
>     x86: fix pmd_bad and pud_bad to support huge pages
>
>     I recently stumbled upon a problem in the support for huge pages. If a
>     program using huge pages does not explicitly unmap them, they remain
>     mapped (and therefore, are lost) after the program exits.
>
>     I observed that the free huge page count in /proc/meminfo decreased when
>     running my program, and it did not increase after the program exited.
>     After running the program a few times, no more huge pages could be
>     allocated.
>
>     The reason for this seems to be that the x86 pmd_bad and pud_bad
>     consider pmd/pud entries having the PSE bit set invalid. I think there
>     is nothing wrong with this bit being set, it just indicates that the
>     lowest level of translation has been reached. This bit has to be (and
>     is) checked after the basic validity of the entry has been checked, like
>     in this fragment from follow_page() in mm/memory.c:
>
>       if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
>               goto no_page_table;
>
>       if (pmd_huge(*pmd)) {
>               BUG_ON(flags & FOLL_GET);
>               page = follow_huge_pmd(mm, address, pmd, flags & FOLL_WRITE);
>               goto out;
>       }
>
>     Note that this code currently doesn't work as intended if the pmd refers
>     to a huge page, the pmd_huge() check can not be reached if the page is
>     huge.
>
>     Extending pmd_bad() (and, for future 1GB page support, pud_bad()) to
>     allow for the PSE bit being set fixes this. For similar reasons,
>     allowing the NX bit being set is necessary, too. I have seen huge pages
>     having the NX bit set in their pmd entry, which would cause the same
>     problem.
>
>     Signed-Off-By: Hans Rosenfeld <hans.rosenfeld@amd.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Hrm, not that I necessarily have the right to ask for this, but
shouldn't hugepage related patches at least be cc'd to linux-mm? it
seems this went via LKML to the x86 tree? There are a few of us that
work on hugepages that would have seen this there, but it got lost in
the noise (for me) on LKML.

Thanks,
Nish
