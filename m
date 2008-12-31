Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbYLaPgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbYLaPgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 10:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYLaPft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 10:35:49 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:25397 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752777AbYLaPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 10:35:48 -0500
Message-ID: <495B9150.6010501@panasas.com>
Date: Wed, 31 Dec 2008 17:35:44 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] exofs: address_space_operations
References: <4947BFAA.4030208@panasas.com>	<4947C7BD.2050407@panasas.com> <20081229124514.71d29ae0.akpm@linux-foundation.org>
In-Reply-To: <20081229124514.71d29ae0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Dec 2008 15:35:42.0547 (UTC) FILETIME=[70CE5230:01C96B5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> +
>> +	kaddr = page_address(page);
>> +
>> +	req = prepare_osd_write(sbi->s_dev, sbi->s_pid,
>> +			      inode->i_ino + EXOFS_OBJ_OFF, len, start, 0,
>> +			      kaddr);
> 
> Does prepare_osd_write() modify the memory at *kaddr?  If so, does it
> do the needed flush_dcache_page()?
> 

kaddr is not modified by CPU. This is just a very BAD API left from the old
osd-initiator days.The address is used for preparing a BIO and submitted
to HW later. I will change all these places to receive a page* directly.
(It was meant to be changed in the future where I want to support read/write 
 page* array).

<snip>
>> +	} else if (ret == -EFAULT) {
>> +		char *kaddr;
>> +
>> +		/* In this case we were trying to read something that wasn't on
>> +		 * disk yet - return a page full of zeroes.  This should be OK,
>> +		 * because the object should be empty (if there was a write
>> +		 * before this read, the read would be waiting with the page
>> +		 * locked */
>> +		kaddr = page_address(page);
>> +		memset(kaddr, 0, PAGE_CACHE_SIZE);
> 
> There is I think a missing flsh_dcache_page() here.  Use of the
> (somewhat misnamed) zero_user() would be an appropriate fix and
> cleanup.
> 

What happened here is that the HW actually never touched the page in question,
and it is returned to CPU, do I need to flsh_dcache_page anyway?

But this is not relevant since I will use zero_user() as you suggested.
Should I use clear_highpage as this is a clear of a full page?

<snip>
>> +
>> +	/* this will be out of bounds, or doesn't exist yet */
>> +	if ((page->index >= end_index + 1) || !ObjCreated(oi) || !amount
>> +	    /*|| (i_start >= oi->i_commit_size)*/) {
>> +		kaddr = kmap_atomic(page, KM_USER0);
>> +		memset(kaddr, 0, PAGE_CACHE_SIZE);
>> +		flush_dcache_page(page);
>> +		kunmap_atomic(page, KM_USER0);
> 
> There's a flush_dcache_page() ;)
> 
> Could use clear_highpage() here.
> 

Thanks, sounds much better.

>> +		SetPageUptodate(page);
>> +		if (PageError(page))
>> +			ClearPageError(page);
>> +		if (is_async_unlock)
>> +			unlock_page(page);
>> +		goto out;
>> +	}
>> +
>> +	if (amount != PAGE_CACHE_SIZE) {
>> +		kaddr = kmap_atomic(page, KM_USER0);
>> +		memset(kaddr + amount, 0, PAGE_CACHE_SIZE - amount);
>> +		flush_dcache_page(page);
>> +		kunmap_atomic(page, KM_USER0);
> 
> Use zero_user()?
> 

Will change

Thanks
Boaz
