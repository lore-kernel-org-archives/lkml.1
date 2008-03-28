Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYC1Jlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYC1Jlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYC1Jln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:41:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:36207 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYC1Jlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EeQnwjwCe2iad+q5gJ7lsvcHssBt3y2+mSUAuyw+dEk0TZ17gF72lpmicO5bSEbPSPEywZ4R3civxVjOmn8HxlG0/fKZXHMvXl4Nj1gAyZajmigZHlyYCmQd+UXsPShjbCm62SB9pAgztZa2uSlkGFSgPswF9DpIMLuMc3xkU54=
Message-ID: <47ECBD4A.8080908@gmail.com>
Date: Fri, 28 Mar 2008 10:41:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v2)
References: <20080328082316.6961.29044.sendpatchset@localhost.localdomain>
In-Reply-To: <20080328082316.6961.29044.sendpatchset@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2008 09:23 AM, Balbir Singh wrote:
> This patch removes the mem_cgroup member from mm_struct and instead adds
> an owner. This approach was suggested by Paul Menage. The advantage of
> this approach is that, once the mm->owner is known, using the subsystem
> id, the cgroup can be determined. It also allows several control groups
> that are virtually grouped by mm_struct, to exist independent of the memory
> controller i.e., without adding mem_cgroup's for each controller,
> to mm_struct.
> 
> The code initially assigns mm->owner to the task and then after the
> thread group leader is identified. The mm->owner is changed to the thread
> group leader of the task later at the end of copy_process.
> 
> A new config option CONFIG_MM_OWNER is added and the memory resource
> controller now depends on this config option.
> 
> NOTE: This patch was developed on top of 2.6.25-rc5-mm1 and is applied on top
> of the memory-controller-move-to-own-slab patch (which is already present
> in the Andrew's patchset).
> 
> These patches have been tested on a powerpc 64 bit box and on x86_64 box with
> several microbenchmarks and some simple memory controller testing.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  include/linux/memcontrol.h |   14 ++++++++-
>  include/linux/mm_types.h   |    6 ++--
>  include/linux/sched.h      |   19 ++++++++++++
>  init/Kconfig               |   13 ++++++++
>  kernel/exit.c              |   66 +++++++++++++++++++++++++++++++++++++++++++++
>  kernel/fork.c              |   26 +++++++++++++++++
>  mm/memcontrol.c            |   19 +++++++-----
>  7 files changed, 151 insertions(+), 12 deletions(-)
> 
> diff -puN include/linux/mm_types.h~memory-controller-add-mm-owner include/linux/mm_types.h
> --- linux-2.6.25-rc5/include/linux/mm_types.h~memory-controller-add-mm-owner	2008-03-28 09:30:47.000000000 +0530
> +++ linux-2.6.25-rc5-balbir/include/linux/mm_types.h	2008-03-28 12:26:59.000000000 +0530
> @@ -227,8 +227,10 @@ struct mm_struct {
>  	/* aio bits */
>  	rwlock_t		ioctx_list_lock;
>  	struct kioctx		*ioctx_list;
> -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
> -	struct mem_cgroup *mem_cgroup;
> +#ifdef CONFIG_MM_OWNER
> +	spinlock_t owner_lock;
> +	struct task_struct *owner;	/* The thread group leader that */

Doesn't make sense to switch them (spinlock is unsigned int on x86, what's 
sizeof between and after?)?
