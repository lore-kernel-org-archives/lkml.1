Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZCaKY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZCaKY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZCaKYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:24:45 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:15993 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857AbZCaKYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:24:44 -0400
Message-ID: <49D1EEF4.60404@panasas.com>
Date: Tue, 31 Mar 2009 13:22:44 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 5/8] exofs: dir_inode and directory operations
References: <49C1331D.1080805@panasas.com>	<1237399729-29465-1-git-send-email-bharrosh@panasas.com> <20090331010423.930883a0.akpm@linux-foundation.org>
In-Reply-To: <20090331010423.930883a0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 10:24:41.0669 (UTC) FILETIME=[E73BCF50:01C9B1EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2009 11:04 AM, Andrew Morton wrote:
> On Wed, 18 Mar 2009 20:08:49 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> implementation of directory and inode operations.
>>
>> * A directory is treated as a file, and essentially contains a list
>>   of <file name, inode #> pairs for files that are found in that
>>   directory. The object IDs correspond to the files' inode numbers
>>   and are allocated using a 64bit incrementing global counter.
>> * Each file's control block (AKA on-disk inode) is stored in its
>>   object's attributes. This applies to both regular files and other
>>   types (directories, device files, symlinks, etc.).
>>
>>
>> ...
>>
>> +static inline unsigned long dir_pages(struct inode *inode)
>> +{
>> +	return (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>> +}
> 
> Do we need i_size_read() here?  Probably not if it's always called
> under i_mutex.  Needs checking and commenting please.
> 

Don't know, I'll have a look

>> +static unsigned exofs_last_byte(struct inode *inode, unsigned long page_nr)
>> +{
>> +	unsigned last_byte = inode->i_size;
>> +
>> +	last_byte -= page_nr << PAGE_CACHE_SHIFT;
> 
> hm.  Strange to left-shift an unsigned long and then copy it to a
> smaller type.
> 

wrong type, thanks!

> Are the types here appropriately chosen?
> 
>> +	if (last_byte > PAGE_CACHE_SIZE)
>> +		last_byte = PAGE_CACHE_SIZE;
>> +	return last_byte;
>> +}
>> +
>> +static int exofs_commit_chunk(struct page *page, loff_t pos, unsigned len)
>>
>> ...
>>
> 
> This all looks vaguely familiar :)

Yep ;). Don't forget that all this started with a cp ...

Boaz
