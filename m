Return-Path: <linux-kernel-owner+w=401wt.eu-S1751126AbZLIFEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbZLIFEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZLIFEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:04:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51437 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZLIFEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:04:25 -0500
Message-ID: <4B1F2FC6.7040406@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 13:04:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: kosaki.motohiro@jp.fujitsu.com, hugh.dickins@tiscali.co.uk,
       nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, npiggin@suse.de,
       fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [23/31] HWPOISON: add memory cgroup filter
References: <200912081016.198135742@firstfloor.org> <20091208211639.8499FB151F@basil.firstfloor.org>
In-Reply-To: <20091208211639.8499FB151F@basil.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef	CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> +u64 hwpoison_filter_memcg;
> +EXPORT_SYMBOL_GPL(hwpoison_filter_memcg);
> +static int hwpoison_filter_task(struct page *p)
> +{
> +	struct mem_cgroup *mem;
> +	struct cgroup_subsys_state *css;
> +	unsigned long ino;
> +
> +	if (!hwpoison_filter_memcg)
> +		return 0;
> +
> +	mem = try_get_mem_cgroup_from_page(p);
> +	if (!mem)
> +		return -EINVAL;
> +
> +	css = mem_cgroup_css(mem);
> +	ino = css->cgroup->dentry->d_inode->i_ino;

I have a question, can try_get_mem_cgroup_from_page() return
root_mem_cgroup?

if it can, then css->cgroup->dentry is NULL, if memcg is
not mounted and there is no subdir in memcg. Because the root
cgroup of an inactive subsystem has no dentry.

> +	css_put(css);
> +
> +	if (ino != hwpoison_filter_memcg)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +#else
> +static int hwpoison_filter_task(struct page *p) { return 0; }
> +#endif
