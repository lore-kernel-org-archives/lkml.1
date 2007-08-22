Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXHVUXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXHVUXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763839AbXHVUXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:23:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758298AbXHVUXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:23:35 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] fix the max path calculation in radix-tree.c
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
References: <x49d4xgy8h1.fsf@segfault.boston.devel.redhat.com>
	<20070822013546.GB6799@wotan.suse.de>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Wed, 22 Aug 2007 16:23:28 -0400
In-Reply-To: <20070822013546.GB6799@wotan.suse.de> (Nick Piggin's message of "Wed\, 22 Aug 2007 03\:35\:46 +0200")
Message-ID: <x49zm0jb9of.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> On Tue, Aug 21, 2007 at 03:48:42PM -0400, Jeff Moyer wrote:
>> Hi,
>> 
>> A while back, Nick Piggin introduced a patch to reduce the node memory
>> usage for small files (commit cfd9b7df4abd3257c9e381b0e445817b26a51c0c):
>> 
>> -#define RADIX_TREE_MAP_SHIFT	6
>> +#define RADIX_TREE_MAP_SHIFT	(CONFIG_BASE_SMALL ? 4 : 6)
>> 
>> Unfortunately, he didn't take into account the fact that the
>> calculation of the maximum path was based on an assumption of having
>> to round up:
>> 
>> #define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
>> 
>> So, if CONFIG_BASE_SMALL is set, you will end up with a
>> RADIX_TREE_MAX_PATH that is one greater than necessary.  The practical
>> upshot of this is just a bit of wasted memory (one long in the
>> height_to_maxindex array, an extra pre-allocated radix tree node per
>> cpu, and extra stack usage in a couple of functions), but it seems
>> worth getting right.
>> 
>> It's also worth noting that I never build with CONFIG_BASE_SMALL.
>> What I did to test this was duplicate the code in a small user-space
>> program and check the results of the calculations for max path and the
>> contents of the height_to_maxindex array.
>> 
>> Cheers.
>> 
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>> 
>> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
>> index 514efb2..67c908f 100644
>> --- a/lib/radix-tree.c
>> +++ b/lib/radix-tree.c
>> @@ -60,7 +60,8 @@ struct radix_tree_path {
>>  };
>>  
>>  #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
>> -#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
>> +#define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
>> +					  RADIX_TREE_MAP_SHIFT) + 1)
>>  
>>  static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH] __read_mostly;
>>  
>
> OK, after you DIV_ROUND_UP, what is the extra 1 for? For paths, it is because
> they are NULL terminated paths I guess (without remembering too hard), and for

Yep.

> height_to_maxindex array it is needed for 0-height trees I think. So it would

Exactly.

> be kinda cleaner to have the _real_ MAX_PATH, and two other constants for
> this array and the paths arrays (that just happen to be identical due to
> implementation). Don't you think?

Yes.  I despise seeing these mystical '+ n' constructs in #defines.
But, I don't know what I'd name these constants.  I think it might be
better to just add a comment explaining the use of 'RADIX_TREE_MAX_PATH + 1'.

Looking at this further, it may be that the nodes[] array in the
struct radix_tree_preload only needs RADIX_TREE_MAX_PATH elements
(since you don't have to allocate the 0'th level).

That change will require some testing and further verification.  I'll
work on it.

> But that's not to nack this patch. On the contrary I think your logic is
> correct, and it should be fixed. I didn't check the maths myself but I trust
> you :)

Thanks.  ;)  I'll post more complete testing information with the next
patch, to take out the guess-work.

Thanks for the review.

-Jeff
