Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbZAFKv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbZAFKv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZAFKvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:51:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:14131 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZAFKvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:51:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ZrDcIV7VODvGe8tn43fob2ZA0a7+KkR6QqcXd9jz/REEhlXTUO44c1zKILVZQm2B12
         lRr4NuqisOKy4pBalK8I5VEVXNGz6OR4uIryqDKmbBGomP0nzroNSXQ1RRaBYMkzG/66
         X97BpjZV/B78oz1lg9hjNtwW+hCVmIqo1crkc=
Message-ID: <84144f020901060251l697052b9udd92a4a04f830ea7@mail.gmail.com>
Date: Tue, 6 Jan 2009 12:51:47 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow v2
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, npiggin@suse.de, riel@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
In-Reply-To: <20090105163742.08777d73.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090105103132.GD7645@localhost>
	 <20090105163742.08777d73.akpm@linux-foundation.org>
X-Google-Sender-Auth: e481dbd8e4ba1f20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Jan 6, 2009 at 2:37 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 5 Jan 2009 13:31:32 +0300
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> __nr_to_section should check for array bound overflow.
>> We should better get NULL dereference then silently
>> pass some memory snippet out of bounds to a caller.
>>
>
> Are there actually any known problems here?
>
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> ---
>>  include/linux/mmzone.h |   15 +++++++++++++--
>>  1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6.git/include/linux/mmzone.h
>> ===================================================================
>> --- linux-2.6.git.orig/include/linux/mmzone.h
>> +++ linux-2.6.git/include/linux/mmzone.h
>> @@ -935,6 +935,12 @@ static inline unsigned long early_pfn_to
>>
>>  struct page;
>>  struct page_cgroup;
>> +
>> +/*
>> + * NOTE: sizeof(struct mem_section) _must_ be power of 2
>> + * otherwise SECTION_ROOT_MASK will be broken so be
>> + * really cautious while modifying this structure
>> + */
>>  struct mem_section {
>>       /*
>>        * This is, logically, a pointer to an array of struct
>> @@ -980,9 +986,14 @@ extern struct mem_section mem_section[NR
>>
>>  static inline struct mem_section *__nr_to_section(unsigned long nr)
>>  {
>> -     if (!mem_section[SECTION_NR_TO_ROOT(nr)])
>> +     unsigned long idx = SECTION_NR_TO_ROOT(nr);
>> +
>> +     if (WARN_ON(idx >= NR_SECTION_ROOTS))
>> +             return NULL;
>> +
>> +     if (!mem_section[idx])
>>               return NULL;
>> -     return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
>> +     return &mem_section[idx][nr & SECTION_ROOT_MASK];
>>  }
>
> The patch adds nearly 300 bytes of stuff to mm/sparse.o, and for what??

I was thinking of things like commit
bead9a3abd15710b0bdfd418daef606722d86282 ("mm: sparsemem
memory_present() fix") and such but missed the fact that
__nr_to_section() inlined all over the place. So yeah, it's not worth
it.

                                            Pekka
