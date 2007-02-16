Return-Path: <linux-kernel-owner+w=401wt.eu-S965240AbXBPHtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965240AbXBPHtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964811AbXBPHtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:49:05 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:34005 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965240AbXBPHtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:49:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=X+w+NbgLRmdpp9iXjn5qA7yte88SBXeTY95XwDzaRFaFqcjoDTkKSrzHmPidG1A45PTka3aXqR8CuHvbUs++Pd18JtmnRoDcl/gKsovlO6T+YGA7BBrSzKxIG7FJGcKWstNSMs4i/OfOq4ubtkZbhK7ynyeeJgEitCdGq/LuVjg=  ;
X-YMail-OSG: RHA3wIgVM1mPIpuijQ1VBOLaN4HtMpajnu9NHPnADOl_mGkq1SpStjMcCM1S0UuW0RYyuq5bsvhx3FUR0pK_tXdCpDIsxRssnHVnLyyKQUWoNfhttE6tC4MV22OIWzzE.ESK2OXdOcL1_.w-
Message-ID: <45D561CA.3080609@yahoo.com.au>
Date: Fri, 16 Feb 2007 18:48:26 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: [patch 12/21] Xen-paravirt: Allocate and free vmalloc areas
References: <20070216022449.739760547@goop.org>	<20070216022531.417300365@goop.org>	<20070215224322.5c73d8e9.akpm@linux-foundation.org>	<45D55852.9000103@goop.org> <20070215232447.5ee67f50.akpm@linux-foundation.org>
In-Reply-To: <20070215232447.5ee67f50.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 23:08:02 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> 
>>Andrew Morton wrote:
>>
>>>This won't work when CONFIG_PREEMPT=y.  The pagefault handler will see
>>>in_atomic() and will scram.
>>>  
>>
>>Is there some other way to get the pagetable populated for the address
>>range?
>>
> 
> 
> If you really need to run atomically, that gets ugly.  Even of one were to
> run handle_mm_fault() by hand, it still needs to allocate memory.
> 
> Two ugly options might be:
> 
> a) touch all the pages, then go atomic, then touch them all again.  If
>    one of them faults (ie: you raced with swapout) then go back and try
>    again.  Obviously susceptible to livelocking.
> 
> b) Do get_user_pages() against all the pages, then go atomic, then do
>    put_page() against them all.  Of course, they can immediately get
>    swapped out.
> 
> But that function's already racy against swapout and I guess it works OK. 
> I don't have clue what it is actually trying to do, so I'm guessing madly
> here.

Well its only operating on kernel pages, and against a vmalloc region.
So it would be immune to any sort of unmapping or swapout.

Andrew's option a) should work. What's this for, and how is it not Xen
specific if nothing else in the tree needs such a weird hack?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
