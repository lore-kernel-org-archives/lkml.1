Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZIPMVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZIPMVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbZIPMVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:21:41 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:46760 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZIPMVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tcGsiHOk3iq4JfT7Dh9YIvxuS1g3J52nzPI+8y4qGwJ6pItUuoui/nbJ/o5QzYFweE
         dSXgvsmXfkPSICSTGQoxLbWRSmM5Ab/FQ6ap0m/NqC5NEC5UmNFG47v8a+wuIDm6jAsF
         XTfZ4T84KhZkU7te4rB/o06UUxJ/1ldjTSJGg=
MIME-Version: 1.0
In-Reply-To: <20090915122632.GC31840@csn.ul.ie>
References: <202cde0e0909132218k70c31a5u922636914e603ad4@mail.gmail.com>
	 <20090915122632.GC31840@csn.ul.ie>
Date: Thu, 17 Sep 2009 00:21:42 +1200
Message-ID: <202cde0e0909160521v41a0d9f2wb1e4fe1e379e8971@mail.gmail.com>
Subject: Re: [PATCH 2/3] Helper which returns the huge page at a given address 
	(Take 3)
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Eric Munson <linux-mm@mgebm.net>, Alexey Korolev <akorolev@infradead.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 12:26 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Mon, Sep 14, 2009 at 05:18:53PM +1200, Alexey Korolev wrote:
>> This patch provides helper function which returns the huge page at a
>> given address for population before the page has been faulted.
>> It is possible to call hugetlb_get_user_page function in file mmap
>> procedure to get pages before they have been requested by user level.
>>
>
> Worth spelling out that this is similar in principal to get_user_pages()
> but not as painful to use in this specific context.
>

Right. I'll do this. Seems it is important to clearly mention that
this function do not introduce new functionality.

>> include/linux/hugetlb.h |    3 +++
>> mm/hugetlb.c            |   23 +++++++++++++++++++++++
>> 2 files changed, 26 insertions(+)
>>
>> ---
>> Signed-off-by: Alexey Korolev <akorolev@infradead.org>
>
> Patch formatting nit.
>
> diffstat goes below the --- and signed-off-bys go above it.
>
Right. To be fixed.

>>
>> +/*
>> + * hugetlb_get_user_page returns the page at a given address for population
>> + * before the page has been faulted.
>> + */
>> +struct page *hugetlb_get_user_page(struct vm_area_struct *vma,
>> +                                 unsigned long address)
>> +{
>
> Your leader and comments say that the function can be used before the pages
> have been faulted. It would presumably require that this function be called
> from within a mmap() handler.
>
> What is happening because you call follow_hugetlb_page() is that the pages
> get faulted as part of your mmap() operation. This might make the overall
> operation more expensive than you expected. I don't know if what you really
> intended was to allocate the huge page, insert it into the page cache and
> have it faulted later if the process actually references the page.
>
> Similarly the leader and comments imply that you expect this to be
> called as part of the mmap() operation. However, nothing would appear to
> prevent the driver calling this function once the page is already
> faulted. Is this intentional?

The implication was not intende. You are correct, the function can be
called later. The leader and comment can be rewritten to make this
clear.

>> +     int ret;
>> +     int cnt = 1;
>> +     struct page *pg;
>> +     struct hstate *h = hstate_vma(vma);
>> +
>> +     address = address & huge_page_mask(h);
>> +     ret = follow_hugetlb_page(vma->vm_mm, vma, &pg,
>> +                             NULL, &address, &cnt, 0, 0);
>> +     if (ret < 0)
>> +             return ERR_PTR(ret);
>> +     put_page(pg);
>> +
>> +     return pg;
>> +}
>
> I think the caller should be responsible for calling put_page().  Otherwise
> there is an outside chance that the page would disappear from you unexpectedly
> depending on exactly how the driver was implemented. It would also
> behave slightly more like get_user_pages().
>
Correct. Lets have behaviour similar to get_user_pages in order to prevent
misunderstanding. Put_page will be removed.

Thank you very much for review. Now I am about to clear out the
mistakes and will pay a lot more attention to patch descriptions and
comments.

Thanks,
Alexey
