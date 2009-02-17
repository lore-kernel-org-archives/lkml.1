Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbZBQROh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbZBQROh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZBQROR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:14:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49321 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbZBQROQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:14:16 -0500
Message-ID: <499AF04B.9040803@redhat.com>
Date: Tue, 17 Feb 2009 12:13:47 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Nick Piggin <npiggin@suse.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: irq-disabled vs vmap vs text_poke
References: <20090213141839.GA31922@Krystal> <4995A0B7.1030705@redhat.com>	 <20090213165555.GA4684@Krystal> <4995B88C.2090900@redhat.com>	 <20090213185725.GC7124@Krystal> <4995E925.3080506@redhat.com>	 <4999808B.5080505@redhat.com> <20090216153145.GB19182@wotan.suse.de>	 <20090216172441.GA12576@Krystal> <499A1A43.6000009@redhat.com>	 <20090217030353.GA31504@wotan.suse.de> <1234859516.4744.12.camel@laptop>
In-Reply-To: <1234859516.4744.12.camel@laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 04:03 +0100, Nick Piggin wrote:
> 
>> It is not a bad idea, but I don't think it quite goes far enough.
>> IMO we should reserve 2 pages of virtual memory for each CPU, and
>> then do the mapping/unmapping without locking, and with another
>> variant of unmap_kernel_range that does not do the global TLB
>> flush.
> 
> A bit like kmap_atomic() except for 2 pages and !highmem. Should work.

Hmm, I checked up the kmap_atomic(), but all kernel text
is not on the highmem.

So, what about changing kmap_atomic_prot() implementation as below?

- If the page is !highmem *and the page's prot is same as caller specified prot*,
  just returns page_address(page).
- Add 2 continuous km_types for text_poke().

Then, text_poke() can use it.
---
vaddr = kmap_atomic_prot(page[0], KM_TEXT_POKE0, PAGE_KERNEL);
if(nr_pages > 1)
	vaddr1 = kmap_atomic_prot(page[1], KM_TEXT_POKE1, PAGE_KERNEL);
< change text >
if(nr_pages > 1)
	kunmap_atomic(vaddr1, KM_TEXT_POKE1);
kunmap_atomic(vaddr, KM_TEXT_POKE0);
---

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

