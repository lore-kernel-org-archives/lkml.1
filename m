Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbZEKUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbZEKUJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbZEKUJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:09:13 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:60823 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZEKUJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <1241804120.4843.7.camel@dyn9002018117.watson.ibm.com>
References: <1240943534.4143.55.camel@dyn9002018117.watson.ibm.com>
	 <20090429141837.beaa5d59.akpm@linux-foundation.org>
	 <1241804120.4843.7.camel@dyn9002018117.watson.ibm.com>
Date: Mon, 11 May 2009 16:09:12 -0400
Message-ID: <7e0fb38c0905111309s38bb5031q3661cb16203e402b@mail.gmail.com>
Subject: Re: integrity: nfsd imbalance bug fix
From: Eric Paris <eparis@parisplace.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hooanon05@yahoo.co.jp, jmorris@namei.org, safford@watson.ibm.com,
       "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
       Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 1:35 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Wed, 2009-04-29 at 14:18 -0700, Andrew Morton wrote:
>> On Tue, 28 Apr 2009 14:32:14 -0400
>> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

>> > Index: security-testing-2.6/mm/shmem.c
>> > ===================================================================
>> > --- security-testing-2.6.orig/mm/shmem.c
>> > +++ security-testing-2.6/mm/shmem.c
>> > @@ -2680,7 +2680,7 @@ int shmem_zero_setup(struct vm_area_stru
>> >     if (IS_ERR(file))
>> >             return PTR_ERR(file);
>> >
>> > -   ima_shm_check(file);
>> > +   ima_opencount_get(file);
>> >     if (vma->vm_file)
>> >             fput(vma->vm_file);
>> >     vma->vm_file = file;
>>
>> Maybe do the IMA operations in (or under) shmem_file_setup() and
>> hugetlb_file_setup()?
>
> Again, that would hide the real issue of not having done integrity
> (permission) checking.

Where are we doing integrity or permission checks on hugetlb or shm
files?   Andrew's right, another example of this problem would be
drivers/gpu/drm/drm_gem.c::drm_get_object_alloc() (at least in
linux-next) which uses shmem_file_setup().  If we aren't doing
integrity checks on shmem already, why do we care about kernel vs.
non-kernel users?

moving the ima_opencount_get() from newseg down a layer into
*_file_setup() would, I think, have taken care of the drm case as
well.....

-Eric
