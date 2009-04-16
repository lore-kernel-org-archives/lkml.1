Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZDPAnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZDPAnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZDPAnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:43:08 -0400
Received: from gw.goop.org ([64.81.55.164]:52386 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbZDPAnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:43:07 -0400
Message-ID: <49E67F17.1070805@goop.org>
Date: Wed, 15 Apr 2009 17:43:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       aarcange@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com>	<1239249521-5013-2-git-send-email-ieidus@redhat.com>	<1239249521-5013-3-git-send-email-ieidus@redhat.com>	<1239249521-5013-4-git-send-email-ieidus@redhat.com>	<1239249521-5013-5-git-send-email-ieidus@redhat.com> <20090414150929.174a9b25.akpm@linux-foundation.org>
In-Reply-To: <20090414150929.174a9b25.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> +static pte_t *get_pte(struct mm_struct *mm, unsigned long addr)
>> +{
>> +	pgd_t *pgd;
>> +	pud_t *pud;
>> +	pmd_t *pmd;
>> +	pte_t *ptep = NULL;
>> +
>> +	pgd = pgd_offset(mm, addr);
>> +	if (!pgd_present(*pgd))
>> +		goto out;
>> +
>> +	pud = pud_offset(pgd, addr);
>> +	if (!pud_present(*pud))
>> +		goto out;
>> +
>> +	pmd = pmd_offset(pud, addr);
>> +	if (!pmd_present(*pmd))
>> +		goto out;
>> +
>> +	ptep = pte_offset_map(pmd, addr);
>> +out:
>> +	return ptep;
>> +}
>>     
>
> hm, this looks very generic.  Does it duplicate anything which core
> kernel already provides?  If not, perhaps core kernel should provide
> this (perhaps after some reorganisation).
>   

It is lookup_address() which works on user addresses, and as such is 
very useful.  But it would need to deal with returning a level so it can 
deal with large pages in usermode, and have some well-defined semantics 
on whether the caller is responsible for unmapping the returned thing 
(ie, only if its a pte).

I implemented this myself a couple of months ago, but I can't find it 
anywhere...

>> +static int memcmp_pages(struct page *page1, struct page *page2)
>> +{
>> +	char *addr1, *addr2;
>> +	int r;
>> +
>> +	addr1 = kmap_atomic(page1, KM_USER0);
>> +	addr2 = kmap_atomic(page2, KM_USER1);
>> +	r = memcmp(addr1, addr2, PAGE_SIZE);
>> +	kunmap_atomic(addr1, KM_USER0);
>> +	kunmap_atomic(addr2, KM_USER1);
>> +	return r;
>> +}
>>     
>
> I wonder if this code all does enough cpu cache flushing to be able to
> guarantee that it's looking at valid data.  Not my area, and presumably
> not an issue on x86.
>   

Shouldn't that be kmap_atomic's job anyway?  Otherwise it would be hard 
to use on any virtual-tag/indexed cache machine.

    J
