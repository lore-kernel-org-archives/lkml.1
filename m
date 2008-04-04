Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYDDSLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYDDSLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYDDSLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:11:14 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1077 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYDDSLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:11:13 -0400
Date: Fri, 4 Apr 2008 19:11:23 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>,
       Gurudas Pai <gurudas.pai@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlbpage.txt: correct overcommit caveat [Was Re: [BUG]:2.6.25-rc7 memory leak with hugepages.]
Message-ID: <20080404181123.GB17915@shadowen.org>
References: <47EB4E2A.1040507@oracle.com> <20080327083849.GF15626@elte.hu> <47EB75C5.20207@oracle.com> <29495f1d0804032040h56f39051lcd5f707660d3c06c@mail.gmail.com> <20080404171638.GA17915@shadowen.org> <20080404173125.GE30117@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404173125.GE30117@us.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 10:31:25AM -0700, Nishanth Aravamudan wrote:
> On 04.04.2008 [18:16:38 +0100], Andy Whitcroft wrote:
> > On Thu, Apr 03, 2008 at 08:40:41PM -0700, Nish Aravamudan wrote:
> > 
> > > Hrm, fio is using SHM_HUGETLB. Does ipcs indicate maybe fio is not
> > > cleaning up the shared memory segment? FWIW, it seems like each run is
> > > using 400 hugepages in the SHM_HUGETLB segment, and then when you try
> > > to force the pool to shrink, it converts those 800 (since you ran fio
> > > twice) hugepages from static pool pages to dynamic (or overcommit)
> > > pages.
> > > 
> > > On another note, it is odd that we're using the dynamic pool, when it
> > > is initially disabled...I'll have to think about that.
> > > 
> > > I'll try and look at this later this evening or early tomorrow.
> > 
> > Yes that is an expected result.  We have no way to force the pool to
> > shrink when pages are in-use.  When a request is made to redoce the pool
> > below the number of in-use pages, we move the pages to surplus.  While
> > this does temporarily violate the overcommit cap, it does provide the
> > most utility as those pages will be returned to the buddy at the
> > earliest oppotunity.
> > 
> > I suspect the documenation could do with a little clarification.
> 
> 
> As shown by Gurudas Pai recently, we can put hugepages into the surplus
> state (by echo 0 > /proc/sys/vm/nr_hugepages), even when
> /proc/sys/vm/nr_overcommit_hugepages is 0. This is actually correct, to
> allow the original goal (shrink the static pool to 0) to succeed when it
> is possible for it two (we are converting hugepages to surplus because
> they are in use). However, the documentation does not accurately reflect
> this case. Update it.
>     
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> 
> diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
> index f962d01..3102b81 100644
> --- a/Documentation/vm/hugetlbpage.txt
> +++ b/Documentation/vm/hugetlbpage.txt
> @@ -88,10 +88,9 @@ hugepages from the buddy allocator, if the normal pool is exhausted. As
>  these surplus hugepages go out of use, they are freed back to the buddy
>  allocator.
>  
> -Caveat: Shrinking the pool via nr_hugepages while a surplus is in effect
> -will allow the number of surplus huge pages to exceed the overcommit
> -value, as the pool hugepages (which must have been in use for a surplus
> -hugepages to be allocated) will become surplus hugepages.  As long as
> +Caveat: Shrinking the pool via nr_hugepages such that it becomes less
> +than the number of hugepages in use will convert the balance to surplus
> +huge pages even if it would exceed the overcommit value.  As long as
>  this condition holds, however, no more surplus huge pages will be
>  allowed on the system until one of the two sysctls are increased
>  sufficiently, or the surplus huge pages go out of use and are freed.

Yep, thats more like reality.

Acked-by: Andy Whitcroft <apw@shadowen.org>

-apw
