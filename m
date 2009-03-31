Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZCaJGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZCaJGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZCaJGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:06:38 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:10001 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754439AbZCaJGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:06:37 -0400
Message-ID: <49D1DCA4.6010306@panasas.com>
Date: Tue, 31 Mar 2009 12:04:36 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/8 ver5] exofs: address_space_operations
References: <49C1331D.1080805@panasas.com>	<1237399473-29344-1-git-send-email-bharrosh@panasas.com>	<49C64416.4060801@panasas.com> <20090331010420.8a12810e.akpm@linux-foundation.org>
In-Reply-To: <20090331010420.8a12810e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 09:06:34.0876 (UTC) FILETIME=[FDAFF3C0:01C9B1DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2009 11:04 AM, Andrew Morton wrote:
> On Sun, 22 Mar 2009 15:58:46 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> OK Now we start to read and write from osd-objects. We try to
>> collect at most contiguous pages as possible in a single write/read.
>> The first page index is the object's offset.
>>
>> TODO:
>>    In 64-bit a single bio can carry at most 128 pages.
>>    Add support of chaining multiple bios
>>
>>
>> ...
>>
>> +static int write_exec(struct page_collect *pcol)
>> +{
>> +	struct exofs_i_info *oi = exofs_i(pcol->inode);
>> +	struct osd_obj_id obj = {pcol->sbi->s_pid,
>> +					pcol->inode->i_ino + EXOFS_OBJ_OFF};
>> +	struct osd_request *or = NULL;
>> +	struct page_collect *pcol_copy = NULL;
>> +	loff_t i_start = pcol->pg_first << PAGE_CACHE_SHIFT;
> 
> bug.  On 32-bit this shift will overflow prior to getting promoted to
> 64-bit.  Do:
> 
> 	loff_t i_start = (loff_t)pcol->pg_first << PAGE_CACHE_SHIFT;
> 

In that case I might make pcol->pg_first loff_t.

Why is inode->i_index not an loff_t then?
Page-index <=> byte-offset, is done all the time 12 bits does not
make a difference.

>> ...
>>
>> +static int writepage_strip(struct page *page,
>> +			   struct writeback_control *wbc_unused, void *data)
> 
> Some of these functions could do with some comments explaining why they exist.
> 
>> +	struct page_collect *pcol = data;
>> +	struct inode *inode = pcol->inode;
>> +	struct exofs_i_info *oi = exofs_i(inode);
>> +	loff_t i_size = i_size_read(inode);
>> +	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
>> +	size_t len;
>> +	int ret;
>> +
>>
>> ...
>>
> 

Thanks
Boaz
