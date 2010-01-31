Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066Ab0AaS4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab0AaS4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 13:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164Ab0AaS4d
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 13:56:33 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:48632 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0AaS4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 13:56:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FlWZPHWwpF4js8FF59wBDid4kfM/aV6PzNhq0WODcVnlV5nMTTe14WUS1K2O9NdlCN
         gW+Q4/kAGaLhBOLc/sCVry+duoniXU8ug5UctIoYfZB2Fu+WA3bgElP16W8yYXpV/HO1
         ggviCzotYNqQoVfcIBfNDR1XTr0knVdyqdbw8=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1001311616590.5897@sister.anvils>
References: <6cafb0f01001291657q4ccbee86rce3143a4be7a1433@mail.gmail.com>
	 <201001301929.47659.rjw@sisk.pl>
	 <alpine.LSU.2.00.1001311616590.5897@sister.anvils>
Date: Sun, 31 Jan 2010 10:56:31 -0800
Message-ID: <6cafb0f01001311056k3c6a882fla42b714256bb1e6d@mail.gmail.com>
Subject: Re: Bug in find_vma_prev - mmap.c
From: Tony Perkins <da.perk@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 8:25 AM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> On Sat, 30 Jan 2010, Rafael J. Wysocki wrote:
>
>> [Adding CCs]
>>
>> On Saturday 30 January 2010, Tony Perkins wrote:
>> > This code returns vma (mm->mmap) if it sees that addr is lower than first VMA.
>> > However, I think it falsely returns vma (mm->mmap) on the case where
>> > addr is in the first VMA.
>> >
>> > If it is the first VMA region:
>> > - *pprev should be set to NULL
>> > - implying prev is NULL
>> > - and should therefore return vma (so in this case, I just added if
>> > it's the first VMA and it's within range)
>> >
>> > /* Same as find_vma, but also return a pointer to the previous VMA in *pprev. */
>> > struct vm_area_struct *
>> > find_vma_prev(struct mm_struct *mm, unsigned long addr,
>> >             struct vm_area_struct **pprev)
>> > {
>> >     struct vm_area_struct *vma = NULL, *prev = NULL;
>> >     struct rb_node *rb_node;
>> >     if (!mm)
>> >         goto out;
>> >
>> >     /* Guard against addr being lower than the first VMA */
>> >     vma = mm->mmap;
>> >
>> >     /* Go through the RB tree quickly. */
>> >     rb_node = mm->mm_rb.rb_node;
>> >
>> >     while (rb_node) {
>> >         struct vm_area_struct *vma_tmp;
>> >         vma_tmp = rb_entry(rb_node, struct vm_area_struct, vm_rb);
>> >
>> >         if (addr < vma_tmp->vm_end) {
>> >             // TONY: if (vma_tmp->vm_start <= addr) vma = vma_tmp; //
>> > this returns the correct 'vma' when vma is the first node (i.e., no
>> > prev)
>> >             rb_node = rb_node->rb_left;
>> >         } else {
>> >             prev = vma_tmp;
>> >             if (!prev->vm_next || (addr < prev->vm_next->vm_end))
>> >                 break;
>> >             rb_node = rb_node->rb_right;
>> >         }
>> >     }
>> >
>> > out:
>> >     *pprev = prev;
>> >     return prev ? prev->vm_next : vma;
>> > }
>> >
>> > Is this a known issue and/or has this problem been addressed?
>> > Also, please CC my email address with responses.
>>
>> Well, I guess you should let the mm people know (CCs added).
>
> Sorry, I don't see what the problem is: I may be misunderstanding.
> Why do you think it is wrong to return the vma which addr is in
> (whether or not that's the first vma)?
>
> find_vma_prev() is supposed to return the same vma as find_vma()
> does, but additionally fill in *pprev.  And find_vma() is supposed
> to return the vma containing or the next vma above the addr supplied.
>
> Hugh
>


Right Hugh,

Say for instance, that addr is not in the list (but is greater than
the last element).
find_vma_prev will return the last node in the list, whereas find_vma
will return NULL.

It seems that it is just inconsistent, in what it should return
regarding the two.
For instance, find_vma_prev will never return NULL, if there's at
least one node within the tree, whereas find_vma would.
find_extend_vma uses find_vma_prev and checks to see if it returns
NULL and is less than the return address (which would always be the
case).

Thanks!

-- 
Aim for Perfection!
