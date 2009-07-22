Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZGVNCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZGVNCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbZGVNCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:02:42 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:41488 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZGVNCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:02:42 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:core/locking 2/3] lockdep:define preallocated "stack" for
 BFS as per cpu variable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: tom.leiming@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org
In-Reply-To: <1248267513-4934-3-git-send-email-tom.leiming@gmail.com>
References: <1248267513-4934-1-git-send-email-tom.leiming@gmail.com>
	 <1248267513-4934-2-git-send-email-tom.leiming@gmail.com>
	 <1248267513-4934-3-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 15:03:50 +0200
Message-Id: <1248267830.27058.1404.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 20:58 +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>

This patch can use a changelog.

Why is this needed, isn't all that serialized by the graph_lock anyway?
Or are there a few paths where this isn't the case and we're now racy?

> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  kernel/lockdep.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 1b1796a..1583439 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -847,7 +847,7 @@ struct circular_queue {
>  	unsigned int  front, rear;
>  };
>  
> -static struct circular_queue lock_cq;
> +static DEFINE_PER_CPU(struct circular_queue, lock_cq);
>  
>  unsigned int max_bfs_queue_depth;
>  
> @@ -937,7 +937,7 @@ static int __bfs(struct lock_list *source_entry,
>  {
>  	struct lock_list *entry;
>  	struct list_head *head;
> -	struct circular_queue *cq = &lock_cq;
> +	struct circular_queue *cq = &get_cpu_var(lock_cq);
>  	int ret = 1;
>  
>  	if (match(source_entry, data)) {
> @@ -993,6 +993,7 @@ static int __bfs(struct lock_list *source_entry,
>  		}
>  	}
>  exit:
> +	put_cpu_var(lock_cq);
>  	return ret;
>  }
>  

