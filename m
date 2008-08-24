Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYHXP0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYHXP0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYHXP0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:26:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46970 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYHXP0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:26:42 -0400
Message-ID: <48B17CF3.1040602@cs.helsinki.fi>
Date: Sun, 24 Aug 2008 18:23:31 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Eric Sesterhenn <snakebyte@gmx.de>
CC: zippel@linux-m68k.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Fix Buffer overflow in hfsplus with a corrupted image
References: <20080824130736.GA27742@alice> <84144f020808240814l41be03a6x53d4c521d7d95eb6@mail.gmail.com> <20080824152454.GA27964@alice>
In-Reply-To: <20080824152454.GA27964@alice>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sesterhenn wrote:
> * Pekka Enberg (penberg@cs.helsinki.fi) wrote:
>> Hi Eric,
>>
>> On Sun, Aug 24, 2008 at 4:07 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
>>> when an hfsplus image gets corrupted it might happen that the catalog
>>> namelength field gets b0rked. If we mount such an image
>>> the memcpy() in hfsplus_cat_build_key_uni() writes more than the 255
>>> that fit in the name field. Depending on the size of the overwritten
>>> data, we either only get memory corruption or also trigger an oops like
>>> this:
>>>
>>> --- linux/fs/hfsplus/catalog.c.orig     2008-08-24 14:52:03.000000000 +0200
>>> +++ linux/fs/hfsplus/catalog.c  2008-08-24 14:54:15.000000000 +0200
>>> @@ -168,6 +168,11 @@ int hfsplus_find_cat(struct super_block
>>>                return -EIO;
>>>        }
>>>
>>> +       if (be16_to_cpu(tmp.thread.nodeName.length) >= 127) {
>>> +               printk(KERN_ERR "hfs: catalog name length corrupted\n");
>>> +               return -EIO;
>>> +       }
>> So, where does this 127 come from? I can only find reference to a
>> maximum length of 255 unicode characters (16 bits per character) in
>> the following technical note for HFS+ (see sections "HFS Plus Names"
>> and "Catalog Thread Records"):
>>
>>   http://developer.apple.com/technotes/tn/tn1150.html
>>
>> Hmm?
> 
> Ah, i missed that the name array is __be16, i somehow assumed it was a
> char array, and tried to account for the multiplication by 2 in 
> hfsplus_cat_build_key_uni(). here is an updated fix.
> 
> Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
> 
> --- linux/fs/hfsplus/catalog.c.orig	2008-08-24 14:52:03.000000000 +0200
> +++ linux/fs/hfsplus/catalog.c	2008-08-24 14:54:15.000000000 +0200
> @@ -168,6 +168,11 @@ int hfsplus_find_cat(struct super_block 
>  		return -EIO;
>  	}
>  
> +	if (be16_to_cpu(tmp.thread.nodeName.length) > 255) {
> +		printk(KERN_ERR "hfs: catalog name length corrupted\n");
> +		return -EIO;
> +	}
> +
>  	hfsplus_cat_build_key_uni(fd->search_key, be32_to_cpu(tmp.thread.parentID),
>  				 &tmp.thread.nodeName);
>  	return hfs_brec_find(fd);

Looks good to me.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
