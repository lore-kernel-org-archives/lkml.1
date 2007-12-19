Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbXLSAZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbXLSAZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753930AbXLSAZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:25:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbXLSAZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:25:49 -0500
Date: Tue, 18 Dec 2007 16:24:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/sys.c : Get rid of expensive divides in
 groups_sort()
Message-Id: <20071218162453.e0156041.akpm@linux-foundation.org>
In-Reply-To: <47686269.2090103@cosmosbay.com>
References: <47686269.2090103@cosmosbay.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 01:14:33 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> groups_sort() can be quite long if user loads a large gid table.
> 
> This is because GROUP_AT(group_info, some_integer) uses an integer divide.
> So having to do XXX thousand divides during one syscall can lead to very high 
> latencies. (NGROUPS_MAX=65536)
> 
> In the past (25 Mar 2006), an analog problem was found in groups_search()
> (commit d74beb9f33a5f16d2965f11b275e401f225c949d ) and at that time I changed 
> some variables to unsigned int.
> 
> I believe that a more generic fix is to make sure NGROUPS_PER_BLOCK is unsigned.
> 

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ac3d496..725a491 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -775,7 +775,7 @@ static inline int above_background_load(void)
>  
>  struct io_context;			/* See blkdev.h */
>  #define NGROUPS_SMALL		32
> -#define NGROUPS_PER_BLOCK	((int)(PAGE_SIZE / sizeof(gid_t)))

That was a dopey thing to do.  Both PAGE_SIZE and sizeof() are unsigned and
we went and cast it to a signed thing, even though it is a nonsense to ever
consider a negative value of this.

> +#define NGROUPS_PER_BLOCK	((unsigned int)(PAGE_SIZE / sizeof(gid_t)))
>  struct group_info {
>  	int ngroups;
>  	atomic_t usage;
> diff --git a/kernel/sys.c b/kernel/sys.c
> index d1fe71e..091e58f 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1148,7 +1148,7 @@ static int groups_to_user(gid_t __user *grouplist,
>  	int count = group_info->ngroups;
>  
>  	for (i = 0; i < group_info->nblocks; i++) {
> -		int cp_count = min(NGROUPS_PER_BLOCK, count);
> +		int cp_count = min_t(int, NGROUPS_PER_BLOCK, count);
>  		int off = i * NGROUPS_PER_BLOCK;
>  		int len = cp_count * sizeof(*grouplist);
>  
> @@ -1168,7 +1168,7 @@ static int groups_from_user(struct group_info *group_info,
>  	int count = group_info->ngroups;
>  
>  	for (i = 0; i < group_info->nblocks; i++) {
> -		int cp_count = min(NGROUPS_PER_BLOCK, count);
> +		int cp_count = min_t(int, NGROUPS_PER_BLOCK, count);
>  		int off = i * NGROUPS_PER_BLOCK;
>  		int len = cp_count * sizeof(*grouplist);
>  

We now have a jumble of signed and unsigned, stuck together with min_t
sticky tape.

Please, take a closer look in there and see if there's anything which
*needs* to be signed: is there anything which can actually, sensibly have a
negative quantity?  I bet there isn't, and I bet the code would be cleaner,
faster and more obviously correct if it was converted to unsigned throughout.

I blame C.  Negative quantities are rare, and C's default of treating
scalars as signed was a mistake.  Oh well.
