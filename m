Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbZBMN5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbZBMN5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbZBMN4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:56:54 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:43257 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbZBMN4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:56:53 -0500
Message-ID: <49957C43.7050701@gmail.com>
Date: Fri, 13 Feb 2009 16:57:23 +0300
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Ryan Hope <rmh3093@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 2/4] vfs: add set_page_dirty_notag
References: <18837.24581.181196.569183@edward.zelnet.ru> <1234530519.6519.46.camel@twins>
In-Reply-To: <1234530519.6519.46.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2009-02-13 at 14:56 +0300, Edward Shishkin wrote:
>
>   
>> ---
>>  include/linux/mm.h  |    1 +
>>  mm/page-writeback.c |   28 ++++++++++++++++++++++++++++
>>  2 files changed, 29 insertions(+)
>>
>> --- mmotm.orig/include/linux/mm.h
>> +++ mmotm/include/linux/mm.h
>> @@ -841,6 +841,7 @@ int redirty_page_for_writepage(struct wr
>>  				struct page *page);
>>  int set_page_dirty(struct page *page);
>>  int set_page_dirty_lock(struct page *page);
>> +int set_page_dirty_notag(struct page *page);
>>  int clear_page_dirty_for_io(struct page *page);
>>  
>>  extern unsigned long move_page_tables(struct vm_area_struct *vma,
>> --- mmotm.orig/mm/page-writeback.c
>> +++ mmotm/mm/page-writeback.c
>> @@ -1248,6 +1248,34 @@ int __set_page_dirty_nobuffers(struct pa
>>  EXPORT_SYMBOL(__set_page_dirty_nobuffers);
>>  
>>  /*
>> + * The same as __set_page_dirty_nobuffers, but this function
>> + * 1) doesn't tag the page in its radix tree;
>> + * 2) makes an assumption that there is no races with truncate.
>> + * 3) is not for anonymous or swap pages.
>> + */
>> +int set_page_dirty_notag(struct page *page)
>> +{
>> +	struct address_space *mapping = page->mapping;
>> +
>> +	if (!TestSetPageDirty(page)) {
>> +		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
>> +		if (mapping_cap_account_dirty(mapping)) {
>> +			preempt_disable();
>> +			__inc_zone_page_state(page, NR_FILE_DIRTY);
>> +			__inc_bdi_stat(mapping->backing_dev_info,
>> +				       BDI_RECLAIMABLE);
>> +			task_dirty_inc(current);
>> +			task_io_account_write(PAGE_CACHE_SIZE);
>> +			preempt_enable();
>> +		}
>> +		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>> +		return 1;
>> +	}
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(set_page_dirty_notag);
>> +
>>     
>
> Eew, so reiser4 will totally side-step the regular vm inode writeback
> paths -- or is this fixed by a more elaborate than usual
> a_ops->writepages() ?
>   
The second.

reiser4_writepages() catches the anonymous  (tagged)
pages, captures them mandatory, then commits all atoms
of the file.
