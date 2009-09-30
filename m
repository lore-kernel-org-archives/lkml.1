Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZI3WVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZI3WVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZI3WVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:21:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbZI3WVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:21:02 -0400
Date: Wed, 30 Sep 2009 15:20:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 8/9] Add explicit bound checks in mm/migrate.c
Message-Id: <20090930152011.18c2cf82.akpm@linux-foundation.org>
In-Reply-To: <20090926205406.30d55b08@infradead.org>
References: <20090926204951.424e567e@infradead.org>
	<20090926205406.30d55b08@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009 20:54:06 +0200
Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH 8/9] Add explicit bound checks in mm/migrate.c
> CC: akpm@linux-foundation.org
> 
> The memory migration code has some curious copy_from_user bounds,
> that are likely ok, but are not immediately obvious to me or to GCC.
> 
> This patch adds a simple explicit bound check; this allows GCC
> and me to be more assured that the copy_from_user will never overwrite
> its destination buffer.

I don't really see what's being fixed here.  The original code seems
straightforward and safe enough?

The identifier `chunk_nr' is a bit ambiguous.  Is it "number of chunks" or
is it "index of this chunk"?

> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 1a4bf48..5b9ebc5 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1044,11 +1044,15 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
>  	int err;
>  
>  	for (i = 0; i < nr_pages; i += chunk_nr) {
> +		unsigned int copy;
>  		if (chunk_nr + i > nr_pages)
>  			chunk_nr = nr_pages - i;

A newline after end-of-locals is conventional.

`i' and `chunk_nr' have type `unsigned long' and you're mixing that up
with `unsigned int'.

> -		err = copy_from_user(chunk_pages, &pages[i],
> -				     chunk_nr * sizeof(*chunk_pages));

And we mix it up with size_t as well.

The type choices are a bit confused and sloppy.  Converting it all to
`unsigned int' should be OK.

> +		copy = chunk_nr * sizeof(*chunk_pages);
> +		if (copy > DO_PAGES_STAT_CHUNK_NR)
> +			return -EFAULT;
> +
> +		err = copy_from_user(chunk_pages, &pages[i], copy);
>  		if (err) {
>  			err = -EFAULT;
>  			goto out;


