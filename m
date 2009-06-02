Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbZFBGDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbZFBGDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758917AbZFBGDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:03:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757896AbZFBGDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:03:40 -0400
Date: Mon, 1 Jun 2009 23:02:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroups: forbid noprefix if mounting more than just
 cpuset subsystem
Message-Id: <20090601230251.57411c83.akpm@linux-foundation.org>
In-Reply-To: <4A24911F.4070601@cn.fujitsu.com>
References: <4A24911F.4070601@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Jun 2009 10:40:31 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> The 'noprefix' option was introduced for backwards-compatibility of
> cpuset, but actually it can be used when mounting other subsystems.
> 
> This results in possibility of name collision, and now the collision
> can really happen, because we have 'stat' file in both memory and
> cpuacct subsystem:
> 
> 	# mount -t cgroup -o noprefix,memory,cpuacct xxx /mnt
> 
> Cgroup will happily mount the 2 subsystems, but only 'stat' file of
> memory subsys can be seen.
> 
> We don't want users to use nopreifx, and also want to avoid name
> collision, so we change to allow noprefix only if mounting just
> the cpuset subsystem.
> 
> ...
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index a7267bf..ad17f9d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -842,6 +842,11 @@ static int parse_cgroupfs_options(char *data,
>  				     struct cgroup_sb_opts *opts)
>  {
>  	char *token, *o = data ?: "all";
> +	unsigned long mask = (unsigned long)-1;
> +
> +#ifdef CONFIG_CPUSETS
> +	mask = ~(1 << cpuset_subsys_id);
> +#endif

This will actually produce the wrong result if cpuset_subsys_id >= 32. 
You want 1UL here.


>  	opts->subsys_bits = 0;
>  	opts->flags = 0;
> @@ -886,6 +891,11 @@ static int parse_cgroupfs_options(char *data,
>  		}
>  	}
>  
> +	/* We allow noprefix only if mounting just the cpuset subsystem */
> +	if (test_bit(ROOT_NOPREFIX, &opts->flags) &&
> +	    (opts->subsys_bits & mask))
> +		return -EINVAL;
> +

uh, OK.  I hope that comment is clear enough for anyone who wants to
understand it.   It doesn't explain _why_ this is done..
