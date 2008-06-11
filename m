Return-Path: <linux-kernel-owner+w=401wt.eu-S1761708AbYFKTQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761708AbYFKTQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYFKTP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:15:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbYFKTP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:15:57 -0400
Date: Wed, 11 Jun 2008 12:15:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: righi.andrea@gmail.com
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org, skumar@linux.vnet.ibm.com,
       yamamoto@valinux.co.jp, menage@google.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
Message-Id: <20080611121510.d91841a3.akpm@linux-foundation.org>
In-Reply-To: <4850070F.6060305@gmail.com>
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>
	<20080521152948.15001.39361.sendpatchset@localhost.localdomain>
	<4850070F.6060305@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 19:10:40 +0200 (MEST)
Andrea Righi <righi.andrea@gmail.com> wrote:

> Balbir Singh wrote:
> > +static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
> > +{
> > +	*tmp = memparse(buf, &buf);
> > +	if (*buf != '\0')
> > +		return -EINVAL;
> > +
> > +	*tmp = PAGE_ALIGN(*tmp);
> > +	return 0;
> > +}
> 
> We shouldn't use PAGE_ALIGN() here, otherwise we limit the address space
> to 4GB on 32-bit architectures (that could be reasonable, because this
> is a per-cgroup limit and not per-process).
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  mm/memrlimitcgroup.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memrlimitcgroup.c b/mm/memrlimitcgroup.c
> index 9a03d7d..2d42ff3 100644
> --- a/mm/memrlimitcgroup.c
> +++ b/mm/memrlimitcgroup.c
> @@ -29,6 +29,8 @@
>  #include <linux/res_counter.h>
>  #include <linux/memrlimitcgroup.h>
>  
> +#define PAGE_ALIGN64(addr) (((((addr)+PAGE_SIZE-1))>>PAGE_SHIFT)<<PAGE_SHIFT)
> +
>  struct cgroup_subsys memrlimit_cgroup_subsys;
>  
>  struct memrlimit_cgroup {
> @@ -124,7 +126,7 @@ static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
>  	if (*buf != '\0')
>  		return -EINVAL;
>  
> -	*tmp = PAGE_ALIGN(*tmp);
> +	*tmp = PAGE_ALIGN64(*tmp);
>  	return 0;
>  }
>  

I don't beleive the change is needed.

#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)

that implementation will behaved as desired when passed a 64-bit addr?
