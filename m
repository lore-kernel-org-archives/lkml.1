Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXJ3NQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXJ3NQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbXJ3NQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:16:43 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:44933 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752414AbXJ3NQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gZkMnIzPSZLsvq2vs1a5jFfeie9nW6JmKbtzx0A8xCrr9mrLMY3umnwrmkDVF8nQNB+7DpulhWA5fphl4qxeiEMA9WxYzSJhhQqs935LUFxlQrswESiniQvpR53U9kF2MWWLtK+MI70m6VKVQu9eff/9VlUOenSNfCGtub+ymnk=
Message-ID: <45a44e480710300616p34b0a159m87de78d0a4d43028@mail.gmail.com>
Date: Tue, 30 Oct 2007 09:16:40 -0400
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: vm_ops.page_mkwrite() fails with vmalloc on 2.6.23
Cc: "Andrew Morton" <akpm@linux-foundation.org>, stefani@seibold.net,
       linux-kernel@vger.kernel.org, "David Howells" <dhowells@redhat.com>,
       linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <1193738177.27652.69.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193064057.16541.1.camel@matrix>
	 <20071029004002.60c7182a.akpm@linux-foundation.org>
	 <45a44e480710290117u492dbe82ra6344baf8bb1e370@mail.gmail.com>
	 <1193677302.27652.56.camel@twins>
	 <45a44e480710291051s7ffbb582x64ea9524c197b48a@mail.gmail.com>
	 <1193681839.27652.60.camel@twins> <1193696211.5644.100.camel@lappy>
	 <45a44e480710291822w5864b3beofcf432930d3e68d3@mail.gmail.com>
	 <1193738177.27652.69.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> So page->index does what you want it to, identify which part of the
> framebuffer this particular page belongs to.

Ok. I'm attempting to walk the code sequence. Here's what I think:

- driver loads
- driver vmalloc()s its fb
- this creates the necessary pte entries
then...
- app mmap(/dev/fb0)
- vma is created
- defio mmap adds this vma to private list (equivalent of
address_space or anon_vma)
- app touches base + pixel(128,128) = base + 16k
- page fault
- defio nopage gets called
- defio nopage does vmalloc_to_page(base+16k)
- that finds the correct struct page corresponding to that vaddr.
page->index has not been set by anyone so far, right?
* ah... i see, you are suggesting that this is where I could set the
index since i know the offset i want it to represent. right?
- defio mkwrite get called. defio adds page to its list. schedules delayed work
- app keeps writing the page
- delayed work occurs
- foreach vma { foreach page { page_mkclean_one(page, vma) }
- cycle repeats...

Thanks,
jaya
