Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbZELGok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbZELGok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 02:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZELGob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 02:44:31 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:48418 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbZELGoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 02:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=DMw8Ok86qg7374PRMLWgdk5ncnk+wJ1CWYFIr/3rQmzQ9fyJ0fW00tUl6f2rJcMvMj
         MKS2M82vUEaeF9far3qAWaK9SIvMW2C9kSMv3IGyf51fSJ8/spj1YDjpW1WmCO4IbRpL
         w7cKkTKDUp6RrUyTzR7gPN5yeC1/zK/s+xuTQ=
Date: Tue, 12 May 2009 15:44:13 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: report vm_flags in page_referenced()
Message-Id: <20090512154413.ca39795e.minchan.kim@barrios-desktop>
In-Reply-To: <1242109389.11251.310.camel@twins>
References: <20090430195439.e02edc26.akpm@linux-foundation.org>
	<49FB01C1.6050204@redhat.com>
	<20090501123541.7983a8ae.akpm@linux-foundation.org>
	<20090503031539.GC5702@localhost>
	<1241432635.7620.4732.camel@twins>
	<20090507121101.GB20934@localhost>
	<20090507151039.GA2413@cmpxchg.org>
	<20090507134410.0618b308.akpm@linux-foundation.org>
	<20090508081608.GA25117@localhost>
	<20090508125859.210a2a25.akpm@linux-foundation.org>
	<20090512025153.GB7518@localhost>
	<1242109389.11251.310.camel@twins>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 08:23:09 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-05-12 at 10:51 +0800, Wu Fengguang wrote:
> > @@ -406,6 +408,7 @@ static int page_referenced_anon(struct p
> >                 if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
> >                         continue;
> >                 referenced += page_referenced_one(page, vma, &mapcount);
> > +               *vm_flags |= vma->vm_flags;
> >                 if (!mapcount)
> >                         break;
> >         }
> 
> Shouldn't that read:
> 
>   if (page_referenced_on(page, vma, &mapcount)) {
>     referenced++;
>     *vm_flags |= vma->vm_flags;
>   }
> 
> So that we only add the vma-flags of those vmas that actually have a
> young bit set?
> 
> In which case it'd be more at home in page_referenced_one():
> 
> @@ -381,6 +381,8 @@ out_unmap:
>  	(*mapcount)--;
>  	pte_unmap_unlock(pte, ptl);
>  out:
> +	if (referenced)
> +		*vm_flags |= vma->vm_flags;
>  	return referenced;
>  }

Good. I am ACK for peter's suggestion.
It can prevent setting vm_flag for worng vma which don't have the page.

-- 
Kinds Regards
Minchan Kim
