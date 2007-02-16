Return-Path: <linux-kernel-owner+w=401wt.eu-S1751010AbXBPHa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010AbXBPHa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXBPHa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:30:57 -0500
Received: from gw.goop.org ([64.81.55.164]:52821 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbXBPHa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:30:56 -0500
Message-ID: <45D55DB1.7040002@goop.org>
Date: Thu, 15 Feb 2007 23:30:57 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: [patch 12/21] Xen-paravirt: Allocate and free vmalloc areas
References: <20070216022449.739760547@goop.org>	<20070216022531.417300365@goop.org>	<20070215224322.5c73d8e9.akpm@linux-foundation.org>	<45D55852.9000103@goop.org> <20070215232447.5ee67f50.akpm@linux-foundation.org>
In-Reply-To: <20070215232447.5ee67f50.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 23:08:02 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Andrew Morton wrote:
>>     
>>> This won't work when CONFIG_PREEMPT=y.  The pagefault handler will see
>>> in_atomic() and will scram.
>>>   
>>>       
>> Is there some other way to get the pagetable populated for the address
>> range?
>>
>>     
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
>   

It's for populating the pagetable in a vmalloc area.  There's magic in
the fault handler to synchronize the vmalloc mappings between different
process's kernel mappings, so if the mapping isn't currently present, it
will fault and create the appropriate mapping.  It's not operating on
swappable user memory, so swapping isn't an issue; but if the fault
handler exits immediately with preempt disabled, then there's a problem.

(Even though we don't support preempt, I've been generally coding in a
preempt-safe way, just so that the code looks "normal".  And maybe we
will support preempt at some point.)

    J
