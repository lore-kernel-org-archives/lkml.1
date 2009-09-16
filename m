Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbZIPMLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbZIPMLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758754AbZIPMLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:11:33 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:57811 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbZIPMLc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fd7QGFEOruW6l4h4CJBu2yI8+yaTBIioKlCeUqNDal4Fw/aN3EV5+P8PeoMg53LYuP
         6bRsnUv78B96KmWMrOBFQudWCGdidpTXEOKiDuYUQQa7wrXfbgUO2xfZwV/10c84rhKx
         eVhoSvQZVeTK1rviC56Zz4rCSIQ2p0qMBKzHE=
MIME-Version: 1.0
In-Reply-To: <20090915121456.GB31840@csn.ul.ie>
References: <202cde0e0909132216l79aae251ya3a6685587c7692c@mail.gmail.com>
	 <20090915121456.GB31840@csn.ul.ie>
Date: Thu, 17 Sep 2009 00:11:33 +1200
Message-ID: <202cde0e0909160511y6f4542d1p38f9a8818c2a454d@mail.gmail.com>
Subject: Re: [PATCH 1/3] Identification of huge pages mapping (Take 3)
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Eric Munson <linux-mm@mgebm.net>, Alexey Korolev <akorolev@infradead.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel,

> I suggest a subject change to
>
> "Identify huge page mappings from address_space->flags instead of file_operations comparison"
>
> for the purposes of having an easier-to-understand changelog.
>
Yes. It is a bit longer but it is definitely clear. Will be corrected.

> On Mon, Sep 14, 2009 at 05:16:13PM +1200, Alexey Korolev wrote:
>> This patch changes a little bit the procedures of huge pages file
>> identification. We need this because we may have huge page mapping for
>> files which are not on hugetlbfs (the same case in ipc/shm.c).
>
> Is this strictly-speaking true as there is still a file on hugetlbfs for
> the driver? Maybe something like
>
> This patch identifies whether a mapping uses huge pages based on the
> address_space flags instead of the file operations. A later patch allows
> a driver to manage an underlying hugetlbfs file while exposing it via a
> different file_operations structure.
>
> I haven't read the rest of the series yet so take the suggestion with a
> grain of salt.

You understood properly. Thanks for the comments. I need to work on
the description more, it seems not to be completely clear.

>> Just file operations check will not work as drivers should have own
>> file operations. So if we need to identify if file has huge pages
>> mapping, we need to check the file mapping flags.
>> New identification procedure obsoletes existing workaround for hugetlb
>> file identification in ipc/shm.c
>> Also having huge page mapping for files which are not on hugetlbfs do
>> not allow us to get hstate based on file dentry, we need to be based
>> on file mapping instead.
>
> Can you clarify this a bit more? I think the reasoning is as follows but
> confirmation would be nice.
>
> "As part of this, the hstate for a given file as implemented by hstate_file()
> must be based on file mapping instead of dentry. Even if a driver is
> maintaining an underlying hugetlbfs file, the mmap() operation is still
> taking place on a device-specific file. That dentry is unlikely to be on
> a hugetlbfs file. A device driver must ensure that file->f_mapping->host
> resolves correctly."
>
> If this is accurate, a comment in hstate_file() wouldn't hurt in case
> someone later decides that dentry really was the way to go.
>
Right. Getting hstate via mapping instead of dentry is important here, so it is
necessary to add a comment in order to prevent people breaking this.
A comment will be added.

>>
>>  static inline int is_file_hugepages(struct file *file)
>>  {
>> -     if (file->f_op == &hugetlbfs_file_operations)
>> -             return 1;
>> -     if (is_file_shm_hugepages(file))
>> -             return 1;
>> -
>> -     return 0;
>> -}
>> -
>> -static inline void set_file_hugepages(struct file *file)
>> -{
>> -     file->f_op = &hugetlbfs_file_operations;
>> +     return mapping_hugetlb(file->f_mapping);
>>  }
>>  #else /* !CONFIG_HUGETLBFS */
>>
>>  #define is_file_hugepages(file)                      0
>> -#define set_file_hugepages(file)             BUG()
>>  #define hugetlb_file_setup(name,size,acct,user,creat)        ERR_PTR(-ENOSYS)
>>
>
> Why do you remove this BUG()? It still seems to be a valid check.
I removed this function - because it has not been called since 2.6.15 and
it is confusing the user a bit after applying new changes. I think it
was necessary to write about this little change in description, sorry
about that.
>>
>> +static inline void mapping_set_hugetlb(struct address_space *mapping)
>> +{
>> +     set_bit(AS_HUGETLB, &mapping->flags);
>> +}
>> +
>> +static inline int mapping_hugetlb(struct address_space *mapping)
>> +{
>> +     if (likely(mapping))
>> +             return test_bit(AS_HUGETLB, &mapping->flags);
>> +     return 0;
>> +}
>
> Is mapping_hugetlb necessary? Why not just make that the implementation
> of is_file_hugepages()
No. It is not necessary. The reason I wrote these functions is just
there are the
similar function for other mapping flags. I see no problem to have
only: is_file_hugepages and
set_file_huge_pages in hugetlb.h instead of mapping_set_hugetlb and
mapping_hugetlb.

>> -     if (file->f_op == &shm_file_operations) {
>> -             struct shm_file_data *sfd;
>> -             sfd = shm_file_data(file);
>> -             ret = is_file_hugepages(sfd->file);
>> -     }
>> -     return ret;
>> -}
>
> What about the declarations and definitions in include/linux/shm.h?

Ahh. Thank you! Will be fixed.

Thanks,
Alexey
