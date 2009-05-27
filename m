Return-Path: <linux-kernel-owner+w=401wt.eu-S1764486AbZE0Hoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764486AbZE0Hoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764170AbZE0Hkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:40:55 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:50626 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764162AbZE0Hky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rllcQmwuF1f0Xupuf8SVZJv5knTV24zqqnabiC7HrzIbf01o8fyOsXiVDuMRDfX10w
         E6ofVxqzHSGdwVXSHpSjZIBZVVZDlrmO0c9/+TuCkLN7oOGB09xm+U+rMAXEJQnQ9PZl
         /TRvUDYlnRBOLEZmt2woNP4QsKJZ9/16/CEdo=
Message-ID: <4A1CEE3F.6030504@gmail.com>
Date: Wed, 27 May 2009 15:39:43 +0800
From: Huang Shijie <shijie8@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib : provide a more precise radix_tree_gang_lookup_slot
References: <1243223635-3449-1-git-send-email-shijie8@gmail.com> <20090526143058.c59e6dc1.akpm@linux-foundation.org>
In-Reply-To: <20090526143058.c59e6dc1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
>> index 355f6e8..03e25f4 100644
>> --- a/include/linux/radix-tree.h
>> +++ b/include/linux/radix-tree.h
>> @@ -164,7 +164,8 @@ radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
>>  			unsigned long first_index, unsigned int max_items);
>>  unsigned int
>>  radix_tree_gang_lookup_slot(struct radix_tree_root *root, void ***results,
>> -			unsigned long first_index, unsigned int max_items);
>> +			unsigned long first_index, unsigned int max_items,
>> +			int contig);
>>     
>
> Variable `contig' could have the type `bool'.  Did you consider and
> reject that option, or just didn't think of it?
>
>
>   
Yes, type `bool' is better.
>> ...
>> +			if (contig)
>> +				goto out;
>> +
>> +		} else if (contig) {
>> +			index--;
>> +			goto out;
>> +
>> +		if (contig) {
>> +			if (slots_found == 0)
>> +				break;
>> +			if (next_index & RADIX_TREE_MAP_MASK)
>> +				break;
>> +		}
>> -				(void ***)pages, start, nr_pages);
>> +				(void ***)pages, start, nr_pages, 0);
>> -				(void ***)pages, index, nr_pages);
>> +				(void ***)pages, index, nr_pages, 1);
>>     
>
> The patch adds cycles in some cases and saves them in others.
>
> Does the saving exceed the adding?  How do we know that the patch is a
> net benefit?
>
>   

Assume that:
    f0 = called frequency of find_get_pages() (contig == 0)
    f1 = called frequency of find_get_pages_contig() (contig == 1)

The primary user of find_get_pages() is ->writepage[s] of some file 
systems such as ext4.
( I think the shmem_lock() ,truncate() run occasionally which also call it.)

The primary user of find_get_pages_contig()  is also the ->writepage[s] 
of some filesystem
such as afs.( I am not sure whether btrfs is also the main user of it )

   So if (f0 nearly equal f1)
         cycles saving >> cycles adding

  __lookup() saves much cycles when there are holes and the contig==1.
     



