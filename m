Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbXCPT0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbXCPT0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbXCPT0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:26:37 -0400
Received: from gw.goop.org ([64.81.55.164]:59703 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbXCPT0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:26:36 -0400
Message-ID: <45FAEF63.5080308@goop.org>
Date: Fri, 16 Mar 2007 12:26:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/26] Xen-paravirt_ops: Xen guest implementation for
 paravirt_ops interface
References: <20070301232443.195603797@goop.org> <20070316092137.GL23174@elte.hu> <45FAD35F.8040404@goop.org> <20070316185923.GA15209@infradead.org>
In-Reply-To: <20070316185923.GA15209@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Mar 16, 2007 at 10:26:55AM -0700, Jeremy Fitzhardinge wrote:
>   
>> +#ifdef CONFIG_HIGHPTE
>> +	.kmap_atomic_pte = native_kmap_atomic_pte,
>> +#else
>> +	.kmap_atomic_pte = paravirt_nop,
>> +#endif
>>     
>
> This is ifdefing is quite ugly.  Shouldn't native_kmap_atomic_pte
> just be a noop in the !CONFIG_HIGHPTE case?
>   

Yes, but the trouble is that asm/highmem.h simply isn't included in the
!HIGHMEM case, so I can't put anything in there, and putting anything
pv_ops related into linux/highmem.h isn't appropriate either.

>> -void *kmap_atomic(struct page *page, enum km_type type)
>> +void *_kmap_atomic(struct page *page, enum km_type type, pgprot_t prot)
>>     
>
> We normally call our "secial" function __foo, not _foo.  But in this
> case it really should have a more meaningfull name like
> kmap_atomic_prot anyway.
>   

OK.

>> +void *kmap_atomic(struct page *page, enum km_type type)
>> +{
>> +	return _kmap_atomic(page, type, kmap_prot);
>>     
>
> And this one should probably be an inline.
>   

OK, if you think it makes a difference.

>> +static inline void *native_kmap_atomic_pte(struct page *page, enum km_type type)
>> +{
>> +	return kmap_atomic(page, type);
>> +}
>> +
>> +#ifndef CONFIG_PARAVIRT
>> +#define kmap_atomic_pte(page, type)	kmap_atomic(page, type)
>> +#endif
>>     
>
> This is all getting rather ugly just for your pagetable hackery.
>   

Well, I could promote kmap_atomic_pte to a first-class interface, but it
seems like overkill.

    J
