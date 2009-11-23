Return-Path: <linux-kernel-owner+w=401wt.eu-S1755107AbZKWPB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbZKWPB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZKWPB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:01:26 -0500
Received: from smtp.nokia.com ([192.100.105.134]:17055 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbZKWPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:01:25 -0500
Subject: Re: [PATCH 4/7] nandsim: Don't use PF_MEMALLOC
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       linux-mtd@lists.infradead.org, Adrian Hunter <adrian.hunter@nokia.com>
In-Reply-To: <20091117161843.3DE0.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
	 <20091117161843.3DE0.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 23 Nov 2009 17:00:17 +0200
Message-Id: <1258988417.18407.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Nov 2009 15:00:22.0949 (UTC) FILETIME=[AE819550:01CA6C4D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 16:19 +0900, KOSAKI Motohiro wrote:
> Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> memory, anyone must not prevent it. Otherwise the system cause
> mysterious hang-up and/or OOM Killer invokation.
> 
> Cc: David Woodhouse <David.Woodhouse@intel.com>
> Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: linux-mtd@lists.infradead.org
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  drivers/mtd/nand/nandsim.c |   22 ++--------------------
>  1 files changed, 2 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
> index cd0711b..97a8bbb 100644
> --- a/drivers/mtd/nand/nandsim.c
> +++ b/drivers/mtd/nand/nandsim.c
> @@ -1322,34 +1322,18 @@ static int get_pages(struct nandsim *ns, struct file *file, size_t count, loff_t
>  	return 0;
>  }
>  
> -static int set_memalloc(void)
> -{
> -	if (current->flags & PF_MEMALLOC)
> -		return 0;
> -	current->flags |= PF_MEMALLOC;
> -	return 1;
> -}
> -
> -static void clear_memalloc(int memalloc)
> -{
> -	if (memalloc)
> -		current->flags &= ~PF_MEMALLOC;
> -}
> -
>  static ssize_t read_file(struct nandsim *ns, struct file *file, void *buf, size_t count, loff_t *pos)
>  {
>  	mm_segment_t old_fs;
>  	ssize_t tx;
> -	int err, memalloc;
> +	int err;
>  
>  	err = get_pages(ns, file, count, *pos);
>  	if (err)
>  		return err;
>  	old_fs = get_fs();
>  	set_fs(get_ds());
> -	memalloc = set_memalloc();
>  	tx = vfs_read(file, (char __user *)buf, count, pos);
> -	clear_memalloc(memalloc);
>  	set_fs(old_fs);
>  	put_pages(ns);
>  	return tx;
> @@ -1359,16 +1343,14 @@ static ssize_t write_file(struct nandsim *ns, struct file *file, void *buf, size
>  {
>  	mm_segment_t old_fs;
>  	ssize_t tx;
> -	int err, memalloc;
> +	int err;
>  
>  	err = get_pages(ns, file, count, *pos);
>  	if (err)
>  		return err;
>  	old_fs = get_fs();
>  	set_fs(get_ds());
> -	memalloc = set_memalloc();
>  	tx = vfs_write(file, (char __user *)buf, count, pos);
> -	clear_memalloc(memalloc);
>  	set_fs(old_fs);
>  	put_pages(ns);
>  	return tx;

I vaguely remember Adrian (CCed) did this on purpose. This is for the
case when nandsim emulates NAND flash on top of a file. So there are 2
file-systems involved: one sits on top of nandsim (e.g. UBIFS) and the
other owns the file which nandsim uses (e.g., ext3).

And I really cannot remember off the top of my head why he needed
PF_MEMALLOC, but I think Adrian wanted to prevent the direct reclaim
path to re-enter, say UBIFS, and cause deadlock. But I'd thing that all
the allocations in vfs_read()/vfs_write() should be GFP_NOFS, so that
should not be a probelm?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

