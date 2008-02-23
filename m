Return-Path: <linux-kernel-owner+w=401wt.eu-S1765593AbYBWIHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765593AbYBWIHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763933AbYBWIEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:04:51 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759507AbYBWIEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:47 -0500
Date: Sat, 23 Feb 2008 00:04:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, yamamoto@valinux.co.jp,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org
Subject: Re: [PATCH 2/2] cgroup map files: Use cgroup map for memcontrol
 stats file
Message-Id: <20080223000422.e937ad7e.akpm@linux-foundation.org>
In-Reply-To: <20080221213445.074889000@menage.corp.google.com>
References: <20080221212854.408662000@menage.corp.google.com>
	<20080221213445.074889000@menage.corp.google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 13:28:56 -0800 menage@google.com wrote:

> Remove the seq_file boilerplate used to construct the memcontrol stats
> map, and instead use the new map representation for cgroup control
> files
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
>  mm/memcontrol.c |   30 ++++++------------------------
>  1 file changed, 6 insertions(+), 24 deletions(-)
> 
> Index: cgroupmap-2.6.25-rc2-mm1/mm/memcontrol.c
> ===================================================================
> --- cgroupmap-2.6.25-rc2-mm1.orig/mm/memcontrol.c
> +++ cgroupmap-2.6.25-rc2-mm1/mm/memcontrol.c
> @@ -974,9 +974,9 @@ static const struct mem_cgroup_stat_desc
>  	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
>  };
>  
> -static int mem_control_stat_show(struct seq_file *m, void *arg)
> +static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
> +				 struct cgroup_map_cb *cb)
>  {
> -	struct cgroup *cont = m->private;
>  	struct mem_cgroup *mem_cont = mem_cgroup_from_cont(cont);
>  	struct mem_cgroup_stat *stat = &mem_cont->stat;
>  	int i;
> @@ -986,8 +986,7 @@ static int mem_control_stat_show(struct 
>  
>  		val = mem_cgroup_read_stat(stat, i);
>  		val *= mem_cgroup_stat_desc[i].unit;
> -		seq_printf(m, "%s %lld\n", mem_cgroup_stat_desc[i].msg,
> -				(long long)val);
> +		cb->fill(cb, mem_cgroup_stat_desc[i].msg, val);
>  	}
>  	/* showing # of active pages */
>  	{
> @@ -997,29 +996,12 @@ static int mem_control_stat_show(struct 
>  						MEM_CGROUP_ZSTAT_INACTIVE);
>  		active = mem_cgroup_get_all_zonestat(mem_cont,
>  						MEM_CGROUP_ZSTAT_ACTIVE);
> -		seq_printf(m, "active %ld\n", (active) * PAGE_SIZE);
> -		seq_printf(m, "inactive %ld\n", (inactive) * PAGE_SIZE);
> +		cb->fill(cb, "active", (active) * PAGE_SIZE);
> +		cb->fill(cb, "inactive", (inactive) * PAGE_SIZE);

umm, afacit this might be a prior bug in mem_control_stat_show().  On a
32-bit machine can [in]active*PAGE_SIZE overflow 32-bits?


>  	}
>  	return 0;
>  }
>  
> -static const struct file_operations mem_control_stat_file_operations = {
> -	.read = seq_read,
> -	.llseek = seq_lseek,
> -	.release = single_release,
> -};
> -
> -static int mem_control_stat_open(struct inode *unused, struct file *file)
> -{
> -	/* XXX __d_cont */
> -	struct cgroup *cont = file->f_dentry->d_parent->d_fsdata;
> -
> -	file->f_op = &mem_control_stat_file_operations;
> -	return single_open(file, mem_control_stat_show, cont);
> -}
> -
> -
> -
>  static struct cftype mem_cgroup_files[] = {
>  	{
>  		.name = "usage_in_bytes",
> @@ -1044,7 +1026,7 @@ static struct cftype mem_cgroup_files[] 
>  	},
>  	{
>  		.name = "stat",
> -		.open = mem_control_stat_open,
> +		.read_map = mem_control_stat_show,
>  	},
>  };
>  
> 
> --
