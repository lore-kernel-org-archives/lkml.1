Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZGWGqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZGWGqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZGWGqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:46:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63896 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZGWGqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:46:14 -0400
Message-ID: <4A6806D9.8020004@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 14:44:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Add a back-pointer from struct cg_cgroup_link to
 struct	cgroup
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com> <20090722195040.7481.44939.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090722195040.7481.44939.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Add a back-pointer from struct cg_cgroup_link to struct cgroup
> 
> Currently the cgroups code makes the assumption that the subsystem
> pointers in a struct css_set uniquely identify the hierarchy->cgroup
> mappings associated with the css_set; and there's no way to directly
> identify the associated set of cgroups other than by indirecting
> through the appropriate subsystem state pointers.
> 
> This patch removes the need for that assumption by adding a
> back-pointer from struct cg_cgroup_link object to its associated
> cgroup; this allows the set of cgroups to be determined by traversing
> the cg_links list in the struct css_set.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

...

> +#define MAX_TASKS_SHOWN_PER_CSS 25
> +static int cgroup_css_links_read(struct cgroup *cont,
> +				 struct cftype *cft,
> +				 struct seq_file *seq)
> +{
> +	struct cg_cgroup_link *link;
> +

I think we need to cgroup_enable_task_cg_lists():

	if (!use_task_css_set_links)
		cgroup_enable_task_cg_lists();

Otherwise we'll see no tasks when reading this debug file
if use_task_css_set_links == 0.

> +	read_lock(&css_set_lock);
> +	list_for_each_entry(link, &cont->css_sets, cgrp_link_list) {
> +		struct css_set *cg = link->cg;
> +		struct task_struct *task;
> +		int count = 0;
> +		seq_printf(seq, "css_set %p\n", cg);
> +		list_for_each_entry(task, &cg->tasks, cg_list) {
> +			if (count++ > MAX_TASKS_SHOWN_PER_CSS) {
> +				seq_puts(seq, "  ...\n");
> +				break;
> +			} else {
> +				seq_printf(seq, "  task %d\n",
> +					   task_pid_vnr(task));
> +			}
> +		}
> +	}
> +	read_unlock(&css_set_lock);
> +	return 0;
> +}
