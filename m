Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbZCXPt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbZCXPt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760337AbZCXPtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:49:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762065AbZCXPtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:49:41 -0400
Date: Tue, 24 Mar 2009 11:49:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] blktrace: print human-readable act_mask
In-Reply-To: <49C89488.4030604@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0903241148240.22830@gandalf.stny.rr.com>
References: <49C893FC.9080905@cn.fujitsu.com> <49C89488.4030604@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Mar 2009, Li Zefan wrote:
>  
> +static ssize_t blk_trace_mask2str(char *buf, int mask)
> +{
> +	int i;
> +	char *p = buf;
> +
> +	for (i = 0; i < ARRAY_SIZE(mask_maps); i++) {
> +		if (mask & mask_maps[i].mask) {
> +			p += sprintf(p, "%s%s",
> +				    (p == buf) ? "" : ",", mask_maps[i].str);
> +		}
> +	}
> +	*p++ = '\n';
> +
> +	return (p - buf);
> +}
> +
>  static struct request_queue *blk_trace_get_queue(struct block_device *bdev)
>  {
>  	if (bdev->bd_disk == NULL)
> @@ -1399,7 +1423,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
>  	if (q->blk_trace == NULL)
>  		ret = sprintf(buf, "disabled\n");
>  	else if (attr == &dev_attr_act_mask)
> -		ret = sprintf(buf, "%#x\n", q->blk_trace->act_mask);
> +		ret = blk_trace_mask2str(buf, q->blk_trace->act_mask);
>  	else if (attr == &dev_attr_pid)
>  		ret = sprintf(buf, "%u\n", q->blk_trace->pid);
>  	else if (attr == &dev_attr_start_lba)
> @@ -1432,9 +1456,11 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
>  	if (attr == &dev_attr_act_mask) {
>  		if (sscanf(buf, "%llx", &value) != 1) {
>  			/* Assume it is a list of trace category names */
> -			value = blk_str2act_mask(buf);
> -			if (value < 0)
> +			value = blk_trace_str2mask(buf);

Hmm, does this compile? Doesn't blk_trace_str2mask need two parameters?

-- Steve

> +			if (value < 0) {
> +				ret = value;
>  				goto out;
> +			}
>  		}
>  	} else if (sscanf(buf, "%llu", &value) != 1)
>  		goto out;
> -- 
> 1.5.4.rc3
> 
> 
