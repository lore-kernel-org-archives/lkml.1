Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbXCHBJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbXCHBJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932945AbXCHBJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:09:55 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37718 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881AbXCHBJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:09:53 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Adam Litke <agl@us.ibm.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix get_unmapped_area and fsync for hugetlb shm segments
References: <20070301234608.29532.66932.stgit@localhost.localdomain>
	<20070302002818.GF10643@holomorphy.com>
	<m1hcswbqru.fsf@ebiederm.dsl.xmission.com>
	<20070307234048.GR18774@holomorphy.com>
Date: Wed, 07 Mar 2007 18:09:07 -0700
In-Reply-To: <20070307234048.GR18774@holomorphy.com> (Bill Irwin's message of
	"Wed, 7 Mar 2007 15:40:48 -0800")
Message-ID: <m1k5xsa6do.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin <bill.irwin@oracle.com> writes:

> On Wed, Mar 07, 2007 at 04:03:17PM -0700, Eric W. Biederman wrote:
>> I think the right answer is most likely to add an extra file method or
>> two so we can remove the need for is_file_hugepages.
>> There are still 4 calls to is_file_hugepages in ipc/shm.c and
>> 2 calls in mm/mmap.c not counting the one in is_file_shm_hugepages.
>> The special cases make it difficult to properly wrap hugetlbfs files
>> with another file, which is why we have the weird special case above.
>
> It's not clear to me that the core can be insulated from hugetlb's
> distinct pagecache and memory mapping granularities in a Linux-native
> manner, but if you come up with something new or manage to get the
> known methods past Linus, akpm, et al, more power to you.

I will agree with that there are limits on what can be achieved.
However looking at where we have tests for is_file_hugepages most of
those tests don't appear to be inherently anything to do with huge
pages, so it wouldn't surprise me if we couldn't generalize things a
little more.

> I'm not entirely sure what you're up to, but I'm mostly here to sanction
> others' design notions since my own are far too extreme, and, of course,
> review and ack patches, take bugreports and write fixes (not that I've
> managed to get to any of them first in a long while, if ever), and so on.
> I say killing the is_whatever_hugepages() checks with whatever abstraction
> is good, since I don't like them myself, provided it's sane. Go for it.

Mostly I had reference counting and consistency problems with
ipc/shm.c that had horrible leak potential when I exited a ipc
namespace.  Implementing everything as stacked files made the code
simpler and more maintainable. (shm_nattach stopped being a special
case yea!)

I'm happy to stop here but if someone cares to proceed with removing
is_file_hugepages I want to encourage that.  I don't see any other
cleanups short of that are really worth doing.

Everything in ipc/shm.c could be considered a weird special case, so
I'm not going to worry about it too much.  Although removing those
special cases is good.

There is some odd accounting logic in mm/mmap.c based on
is_file_hugepages and there is the get_unmapped_area case.  For
get_unmapped_area I see no reason to presume that the only kind of
file that must live at a specific address are huge pages (even if that
is the only kind of file where we have that case today).  So
generalizing that check should be relatively straight forward.

Eric
