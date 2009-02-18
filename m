Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZBRAZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZBRAZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZBRAZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:25:31 -0500
Received: from mail.zelnet.ru ([80.92.97.13]:60284 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbZBRAZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:25:30 -0500
Message-ID: <499B55A8.50103@gmail.com>
Date: Wed, 18 Feb 2009 03:26:16 +0300
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: peterz@infradead.org, npiggin@suse.de, rmh3093@gmail.com,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org
Subject: Re: [patch 2/4] vfs: add set_page_dirty_notag
References: <18837.24581.181196.569183@edward.zelnet.ru>	<1234530519.6519.46.camel@twins>	<49957C43.7050701@gmail.com>	<1234534150.6519.101.camel@twins>	<18838.49922.215481.399653@edward.zelnet.ru>	<1234645893.4695.8.camel@laptop>	<18841.60432.329341.514726@edward.zelnet.ru> <20090217143506.f6899342.akpm@linux-foundation.org>
In-Reply-To: <20090217143506.f6899342.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 17 Feb 2009 01:43:28 +0300
> Edward Shishkin <edward.shishkin@gmail.com> wrote:
>
>   
>> + */
>> +int set_page_dirty_notag(struct page *page)
>> +{
>> +	struct address_space *mapping = page->mapping;
>> +
>> +	if (!TestSetPageDirty(page)) {
>> +		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
>> +		if (mapping_cap_account_dirty(mapping)) {
>> +		        /*
>> +			 * The accounting functions rely on
>> +			 * being atomic wrt interrupts.
>> +			 */
>> +		        unsigned long flags;
>> +			local_irq_save(flags);
>> +			__inc_zone_page_state(page, NR_FILE_DIRTY);
>> +			__inc_bdi_stat(mapping->backing_dev_info,
>> +				       BDI_RECLAIMABLE);
>> +			task_dirty_inc(current);
>> +			task_io_account_write(PAGE_CACHE_SIZE);
>> +			local_irq_restore(flags);
>> +		}
>> +		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>> +		return 1;
>> +	}
>> +	return 0;
>> +}
>>     
>
> I'll maintain this in -mm, alongside the resier4 patches which need it.
>
> Of course, this rather obviates the purpose - if someone changes, say,
> __set_page_dirty_nobuffers() then they won't similarly update
> set_page_dirty_notag().  Oh well.
>
> This problem would fix itself if those two functions were to
> substantially share code.

It will fix the problem only partially:
there is one more friend __set_page_dirty() in buffer.c

Maybe it makes sense to add comments with warnings
in all such places, or create a header file with a static inline
function update_page_accounting() ?

>   And I think we can do that - something like
>
> static void
> update_page_accounting(struct page *page, struct address_space *mapping)
> {
> 	__inc_zone_page_state(page, NR_FILE_DIRTY);
> 	__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
> 	task_dirty_inc(current);
> 	task_io_account_write(PAGE_CACHE_SIZE);
> }
>
> maybe?
>
> We could do that as a separate patch and merge it into mainline - it
> should have zero impact on code generation if gcc does the right thing
> (please check this).
>
>
>   

