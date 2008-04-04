Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYDDDkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYDDDkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 23:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYDDDkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 23:40:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:39705 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYDDDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 23:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fXwsSv5lTsHOloLWUxwlyt37Tb7hLzubQemoM/JGXO6k+pflDglFVhRKRUfmAtx0UkosU8GhL5wjeKGJUBSRJBsvBxMQ/Mpe3rV07SeQO2PLE3ZegGPuDqbkrUO8mNoZqwosWnWM+ghhlsiQKPjU6HXa0hXjR7X+NMhT7MokUVM=
Message-ID: <29495f1d0804032040h56f39051lcd5f707660d3c06c@mail.gmail.com>
Date: Thu, 3 Apr 2008 20:40:41 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Gurudas Pai" <gurudas.pai@oracle.com>
Subject: Re: [BUG]:2.6.25-rc7 memory leak with hugepages.
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <47EB75C5.20207@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47EB4E2A.1040507@oracle.com> <20080327083849.GF15626@elte.hu>
	 <47EB75C5.20207@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/08, Gurudas Pai <gurudas.pai@oracle.com> wrote:
>
>
>  Ingo Molnar wrote:
>  > * Gurudas Pai <gurudas.pai@oracle.com> wrote:
>  >
>  >> Hi,
>  >>
>  >> On 2.6.25-rc7 allocate hugepages and run a fio test with following
>  >> jobfile,
>  >
>  > could you try x86.git/latest:
>  >
>  >   http://people.redhat.com/mingo/x86.git/README
>  >
>  > it has a fix that could fix such a leak.
>  >
>  >       Ingo
>
>
> Applied latest two patches and re-ran the test,
>
>  hugetlb: fix potential livelock in return_unused_surplus_hugepages()
>  hugetlb: indicate surplus huge page counts in per-node meminfo
>
>  Still same result,

Ingo was referring to the x86.git tree, not linus.git (to which those
two patches have been applied). I'm not sure if there is something
x86.git that hasn't been pushed to LInus yet?

>  >cat /proc/meminfo | grep Huge
>  HugePages_Total:  1000
>
> HugePages_Free:    551
>
> HugePages_Rsvd:      1
>  HugePages_Surp:      0
>  Hugepagesize:     2048 kB
>
>  >echo 0 > /proc/sys/vm/nr_hugepages
>  >cat /proc/meminfo | grep Huge
>
> HugePages_Total:   450
>  HugePages_Free:      1
>  HugePages_Rsvd:      1
>  HugePages_Surp:    450
>  Hugepagesize:     2048 kB

Hrm, fio is using SHM_HUGETLB. Does ipcs indicate maybe fio is not
cleaning up the shared memory segment? FWIW, it seems like each run is
using 400 hugepages in the SHM_HUGETLB segment, and then when you try
to force the pool to shrink, it converts those 800 (since you ran fio
twice) hugepages from static pool pages to dynamic (or overcommit)
pages.

On another note, it is odd that we're using the dynamic pool, when it
is initially disabled...I'll have to think about that.

I'll try and look at this later this evening or early tomorrow.

Thanks,
Nish
