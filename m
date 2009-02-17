Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZBQWfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZBQWfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZBQWfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:35:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777AbZBQWfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:35:41 -0500
Date: Tue, 17 Feb 2009 14:35:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: peterz@infradead.org, edward.shishkin@gmail.com, npiggin@suse.de,
       rmh3093@gmail.com, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: [patch 2/4] vfs: add set_page_dirty_notag
Message-Id: <20090217143506.f6899342.akpm@linux-foundation.org>
In-Reply-To: <18841.60432.329341.514726@edward.zelnet.ru>
References: <18837.24581.181196.569183@edward.zelnet.ru>
	<1234530519.6519.46.camel@twins>
	<49957C43.7050701@gmail.com>
	<1234534150.6519.101.camel@twins>
	<18838.49922.215481.399653@edward.zelnet.ru>
	<1234645893.4695.8.camel@laptop>
	<18841.60432.329341.514726@edward.zelnet.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 01:43:28 +0300
Edward Shishkin <edward.shishkin@gmail.com> wrote:

> + */
> +int set_page_dirty_notag(struct page *page)
> +{
> +	struct address_space *mapping = page->mapping;
> +
> +	if (!TestSetPageDirty(page)) {
> +		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
> +		if (mapping_cap_account_dirty(mapping)) {
> +		        /*
> +			 * The accounting functions rely on
> +			 * being atomic wrt interrupts.
> +			 */
> +		        unsigned long flags;
> +			local_irq_save(flags);
> +			__inc_zone_page_state(page, NR_FILE_DIRTY);
> +			__inc_bdi_stat(mapping->backing_dev_info,
> +				       BDI_RECLAIMABLE);
> +			task_dirty_inc(current);
> +			task_io_account_write(PAGE_CACHE_SIZE);
> +			local_irq_restore(flags);
> +		}
> +		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> +		return 1;
> +	}
> +	return 0;
> +}

I'll maintain this in -mm, alongside the resier4 patches which need it.

Of course, this rather obviates the purpose - if someone changes, say,
__set_page_dirty_nobuffers() then they won't similarly update
set_page_dirty_notag().  Oh well.

This problem would fix itself if those two functions were to
substantially share code.  And I think we can do that - something like

static void
update_page_accounting(struct page *page, struct address_space *mapping)
{
	__inc_zone_page_state(page, NR_FILE_DIRTY);
	__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
	task_dirty_inc(current);
	task_io_account_write(PAGE_CACHE_SIZE);
}

maybe?

We could do that as a separate patch and merge it into mainline - it
should have zero impact on code generation if gcc does the right thing
(please check this).

