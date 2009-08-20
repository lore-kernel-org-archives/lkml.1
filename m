Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZHTCi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZHTCi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZHTCi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:38:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53041 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbZHTCi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:38:56 -0400
Message-ID: <4A8CB6F0.1020308@cn.fujitsu.com>
Date: Thu, 20 Aug 2009 10:37:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 4/8] Use vmalloc for large cgroups pidlist allocations
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235827.22531.60306.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090818235827.22531.60306.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> From: Ben Blum <bblum@google.com>
> 
> 
> Use vmalloc for large cgroups pidlist allocations
> 
> Separates all pidlist allocation requests to a separate function that judges
> based on the requested size whether or not the array needs to be vmalloced or
> can be gotten via kmalloc, and similar for kfree/vfree.
> 
> Signed-off-by: Ben Blum <bblum@google.com>
> Signed-off-by: Paul Menage <menage@google.com>
> 

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
> 
>  kernel/cgroup.c |   47 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index d207871..7e2b285 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -50,6 +50,7 @@
>  #include <linux/smp_lock.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/idr.h>
> +#include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
>  
>  #include <asm/atomic.h>
>  
> @@ -2351,6 +2352,42 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
>   */
>  
>  /*
> + * The following two functions "fix" the issue where there are more pids
> + * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
> + * TODO: replace with a kernel-wide solution to this problem
> + */

I come to realize the "procs" file will make it much harder to convert
vmalloc/kmalloc with a different solution..
