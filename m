Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbXLXFHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbXLXFHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 00:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXLXFHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 00:07:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbXLXFHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 00:07:31 -0500
Message-ID: <476F3E89.4070208@redhat.com>
Date: Sun, 23 Dec 2007 23:07:21 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] UPDATED: hfs: handle more on-disk corruptions without
 oopsing
References: <47699C29.4010706@redhat.com> <476A8F36.2050007@redhat.com> <200712240316.43308.zippel@linux-m68k.org>
In-Reply-To: <200712240316.43308.zippel@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:
> Hi,
> 
> On Thursday 20 December 2007, Eric Sandeen wrote:
> 
>> Index: linux-2.6.24-rc3/fs/hfs/brec.c
>> ===================================================================
>> --- linux-2.6.24-rc3.orig/fs/hfs/brec.c
>> +++ linux-2.6.24-rc3/fs/hfs/brec.c
>> @@ -44,10 +44,21 @@ u16 hfs_brec_keylen(struct hfs_bnode *no
>>  		recoff = hfs_bnode_read_u16(node, node->tree->node_size - (rec + 1) *
>> 2); if (!recoff)
>>  			return 0;
>> -		if (node->tree->attributes & HFS_TREE_BIGKEYS)
>> +		if (node->tree->attributes & HFS_TREE_BIGKEYS) {
>>  			retval = hfs_bnode_read_u16(node, recoff) + 2;
>> -		else
>> +			if (retval > node->tree->max_key_len + 2) {
>> +				printk(KERN_ERR "hfs: keylen %d too large\n",
>> +					retval);
>> +				retval = HFS_BAD_KEYLEN;
>> +			}
>> +		} else {
>>  			retval = (hfs_bnode_read_u8(node, recoff) | 1) + 1;
>> +			if (retval > node->tree->max_key_len + 1) {
>> +				printk(KERN_ERR "hfs: keylen %d too large\n",
>> +					retval);
>> +				retval = HFS_BAD_KEYLEN;
>> +			}
>> +		}
>>  	}
>>  	return retval;
>>  }
> 
> You can reuse 0 as failure value, a key has to be of nonzero size.

Ok.  Based on the other 0 returns I wasn't sure if they were considered
real errors or not... but also ISTR I ran into problems with a simple 0
return; I probably just to be sure need the callers check for it.

>> Index: linux-2.6.24-rc3/fs/hfs/btree.c
>> ===================================================================
>> --- linux-2.6.24-rc3.orig/fs/hfs/btree.c
>> +++ linux-2.6.24-rc3/fs/hfs/btree.c
>> @@ -81,6 +81,17 @@ struct hfs_btree *hfs_btree_open(struct
>>  		goto fail_page;
>>  	if (!tree->node_count)
>>  		goto fail_page;
>> +	if ((id == HFS_EXT_CNID) && (tree->max_key_len != HFS_MAX_EXT_KEYLEN)) {
>> +		printk(KERN_ERR "hfs: invalid extent max_key_len %d\n",
>> +			tree->max_key_len);
>> +		goto fail_page;
>> +	}
>> +	if ((id == HFS_CAT_CNID) && (tree->max_key_len != HFS_MAX_CAT_KEYLEN)) {
>> +		printk(KERN_ERR "hfs: invalid catalog max_key_len %d\n",
>> +			tree->max_key_len);
>> +		goto fail_page;
>> +	}
>> +
>>  	tree->node_size_shift = ffs(size) - 1;
>>  	tree->pages_per_bnode = (tree->node_size + PAGE_CACHE_SIZE - 1) >>
>> PAGE_CACHE_SHIFT;
>>
> 
> I'd prefer a switch statement here.

Ok, I'd thought about doing it that way... :)

> It would be nice if you could do the same changes for hfsplus, so both stay in 
> sync.

Yep, wanted to first see if it'd fly for HFS...

Thanks for the feedback,
-Eric

> Thanks.
> 
> bye, Roman

