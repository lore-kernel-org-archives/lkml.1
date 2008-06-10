Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYFJCyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYFJCyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 22:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYFJCyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 22:54:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51591 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbYFJCyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 22:54:04 -0400
Message-ID: <484DEC71.7090607@cn.fujitsu.com>
Date: Tue, 10 Jun 2008 10:52:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rik Van Riel <riel@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re:  [PATCH -mm 23/25] Noreclaim LRU scan sysctl
References: <484DEA23.50707@cn.fujitsu.com>
In-Reply-To: <484DEA23.50707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void show_page_path(struct page *page)
> +{
> +	char buf[256];
> +	if (page_file_cache(page)) {
> +		struct address_space *mapping = page->mapping;
> +		struct dentry *dentry;
> +		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
> +
> +		spin_lock(&mapping->i_mmap_lock);
> +		dentry = d_find_alias(mapping->host);
> +		printk(KERN_INFO "rescued: %s %lu\n",
> +		       dentry_path(dentry, buf, 256), pgoff);
> +		spin_unlock(&mapping->i_mmap_lock);
> +	} else {
> +		struct anon_vma *anon_vma;
> +		struct vm_area_struct *vma;
> +
> +		anon_vma = page_lock_anon_vma(page);
> +		if (!anon_vma)
> +			return;
> +
> +		list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
> +			printk(KERN_INFO "rescued: anon %s\n",
> +			       vma->vm_mm->owner->comm);

This would cause compile failure if !CONFIG_MM_OWNER.

> +			break;
> +		}
> +		page_unlock_anon_vma(anon_vma);
> +	}
> +}
