Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZIPCw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZIPCw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 22:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZIPCwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 22:52:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47761 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbZIPCwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 22:52:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Sep 2009 11:50:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/3] devmem: check vmalloc address on kmem read/write
Message-Id: <20090916115015.0aeddc01.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090916014958.836124324@intel.com>
References: <20090916013939.656308742@intel.com>
	<20090916014958.836124324@intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 09:39:41 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Otherwise vmalloc_to_page() will BUG().
> 
> This also makes the kmem read/write implementation aligned with mem(4):
> "References to nonexistent locations cause errors to be returned." Here
> we return -ENXIO (inspired by Hugh) if no bytes have been transfered
> to/from user space, otherwise return partial read/write results.
> 
seems reasonable.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  drivers/char/mem.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- linux-mm.orig/drivers/char/mem.c	2009-09-16 08:52:17.000000000 +0800
> +++ linux-mm/drivers/char/mem.c	2009-09-16 09:15:03.000000000 +0800
> @@ -443,6 +443,10 @@ static ssize_t read_kmem(struct file *fi
>  			return -ENOMEM;
>  		while (count > 0) {
>  			sz = size_inside_page(p, count);
> +			if (!is_vmalloc_or_module_addr((void *)p)) {
> +				err = -ENXIO;
> +				break;
> +			}
>  			err = vread(kbuf, (char *)p, sz);
>  			if (err)
>  				break;
> @@ -543,6 +547,10 @@ static ssize_t write_kmem(struct file * 
>  			unsigned long sz = size_inside_page(p, count);
>  			unsigned long n;
>  
> +			if (!is_vmalloc_or_module_addr((void *)p)) {
> +				err = -ENXIO;
> +				break;
> +			}
>  			n = copy_from_user(kbuf, buf, sz);
>  			if (n) {
>  				err = -EFAULT;
> 
> -- 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

