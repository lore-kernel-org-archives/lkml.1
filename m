Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbYK3TzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbYK3TzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 14:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYK3TzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 14:55:04 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:13808 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYK3TzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 14:55:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pyns8TdzwgVNd88bKq+pD4mHMmL77C4x/m38enPBfshfvabVGid+STMfL0eHp95CwF
         eDQm5HqARu5Q3dPQQREO3GpcpZ9sS7O8BtYHuThSU0vqjWdF/75/dTK4zEp+DE9KY4FO
         pIIYx9fDvE9XphUTT6QDgGgOVHW0II/BIwbR4=
Message-ID: <4932EF90.9070601@gmail.com>
Date: Sun, 30 Nov 2008 21:54:56 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Nick Piggin <npiggin@suse.de>, Ying Han <yinghan@google.com>,
       Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rohit Seth <rohitseth@google.com>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com> <20081123091843.GK30453@elte.hu> <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com> <20081126123246.GB23649@wotan.suse.de> <492DAA24.8040100@google.com> <20081127085554.GD28285@wotan.suse.de> <492E6849.6090205@google.com> <20081127130817.GP28285@wotan.suse.de> <492EEF0C.9040607@google.com> <20081128093713.GB1818@wotan.suse.de> <49307893.4030708@google.com>
In-Reply-To: <49307893.4030708@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-29 01:02, Mike Waychison wrote:
> Nick Piggin wrote:
>> On Thu, Nov 27, 2008 at 11:03:40AM -0800, Mike Waychison wrote:
>>> Nick Piggin wrote:
>>>> On Thu, Nov 27, 2008 at 01:28:41AM -0800, Mike Waychison wrote:
>>>>> Török however identified mmap taking on the order of several
>>>>> milliseconds due to this exact problem:
>>>>>
>>>>> http://lkml.org/lkml/2008/9/12/185
>>>> Turns out to be a different problem.
>>>>
>>> What do you mean?
>>
>> His is just contending on the write side. The retry patch doesn't help.
>>
>
> I disagree.  How do you get 'write contention' from the following
> paragraph:
>
> "Just to confirm that the problem is with pagefaults and mmap, I dropped
> the mmap_sem in filemap_fault, and then
> I got same performance in my testprogram for mmap and read. Of course
> this is totally unsafe, because the mapping could change at any time."
>
> It reads to me that the writers were held off by the readers sleeping
> in IO.

It is true that I have a write/write contention too, but do_page_fault
shows up too on lock_stat.

This is my guess at what happens:
* filemap_fault used to sleep with mmap_sem held while waiting for the
page lock.
* the google patch avoids that, which is fine: if page lock can't be
taken, it drops mmap_sem, waits, then retries the fault once
* however after we acquired the page lock, mapping->a_ops->readpage is
invoked, mmap_sem is NOT dropped here:

    error = mapping->a_ops->readpage(file, page);
    if (!error) {
        wait_on_page_locked(page);

If my understanding is correct ->readpage does the actual disk I/O, and
it keeps the page locked, when the lock is released we know it has finished.
So wait_on_page_locked(page)  holds mmap_sem locked for read during the
disk I/O, preventing sys_mmap/sys_munmap from making progress.

I don't know how to prove/disprove my guess above, suggestions welcome.

Could the patch be changed to also release the mmap_sem after readpage,
and before wait_on_page_locked?

Best regards,
--Edwin
