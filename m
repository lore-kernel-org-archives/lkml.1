Return-Path: <linux-kernel-owner+w=401wt.eu-S1760387AbYFLW6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760387AbYFLW6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbYFLW6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:58:16 -0400
Received: from as4.cineca.com ([130.186.84.251]:34513 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935AbYFLW6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:58:15 -0400
Message-ID: <4851A9FA.1000104@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: tzanussi@gmail.com, penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading
 across CPUs.
References: <20080612232618.647f5cda@linux360.ro>
In-Reply-To: <20080612232618.647f5cda@linux360.ro>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jun 2008 00:58:01 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard - Gabriel Munteanu wrote:
> @@ -1028,15 +1032,19 @@ static ssize_t relay_file_read_subbufs(struct file *filp, loff_t *ppos,
>  			break;
>  
>  		avail = min(desc->count, avail);
> +		/* subbuf_actor may sleep, so release the spinlock for now */
> +		spin_unlock_irqrestore(&buf->rw_lock, flags);
>  		ret = subbuf_actor(read_start, buf, avail, desc, actor);
>  		if (desc->error < 0)
>  			break;

If you just break here buf->rw_lock will be unlocked twice. Maybe a
better way is:
		if (desc->error < 0)
			goto out;
		...
  	} while (desc->count && ret);
	spin_unlock_irqrestore(&buf->rw_lock, flags);
out:
  	mutex_unlock(&filp->f_path.dentry->d_inode->i_mutex);

  	return desc->written;

> +		spin_lock_irqsave(&buf->rw_lock, flags);
>  
>  		if (ret) {
>  			relay_file_read_consume(buf, read_start, ret);
>  			*ppos = relay_file_read_end_pos(buf, read_start, ret);
>  		}
>  	} while (desc->count && ret);
> +	spin_unlock_irqrestore(&buf->rw_lock, flags);
>  	mutex_unlock(&filp->f_path.dentry->d_inode->i_mutex);
>  
>  	return desc->written;

-Andrea
