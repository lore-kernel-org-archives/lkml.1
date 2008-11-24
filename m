Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYKXXjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYKXXjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYKXXjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:39:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593AbYKXXjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:39:02 -0500
Date: Mon, 24 Nov 2008 15:38:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: peterz@infradead.org, david@fromorbit.com, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: add dirty_background_bytes and dirty_bytes
 sysctls
Message-Id: <20081124153843.d3c4782c.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2008 10:55:16 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> This change introduces two new sysctls to /proc/sys/vm:
> dirty_background_bytes and dirty_bytes.
> 
>
> ...
>
> @@ -365,23 +429,29 @@ void
>  get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
>  		 unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
>  {
> -	int background_ratio;		/* Percentages */
> -	int dirty_ratio;
>  	unsigned long background;
>  	unsigned long dirty;
>  	unsigned long available_memory = determine_dirtyable_memory();
>  	struct task_struct *tsk;
>  
> -	dirty_ratio = vm_dirty_ratio;
> -	if (dirty_ratio < 5)
> -		dirty_ratio = 5;
> +	if (vm_dirty_bytes)
> +		dirty = (vm_dirty_bytes + PAGE_SIZE) / PAGE_SIZE;

It would be conventional to use DIV_ROUND_UP() here.

> +	else {
> +		int dirty_ratio;

hm, I wonder why vm_dirty_ratio has a signed type.  

> -	background_ratio = dirty_background_ratio;
> -	if (background_ratio >= dirty_ratio)
> -		background_ratio = dirty_ratio / 2;
> +		dirty_ratio = vm_dirty_ratio;
> +		if (dirty_ratio < 5)
> +			dirty_ratio = 5;
> +		dirty = (dirty_ratio * available_memory) / 100;
> +	}
> +
> +	if (dirty_background_bytes)
> +		background = (dirty_background_bytes + PAGE_SIZE) / PAGE_SIZE;

DIV_ROUND_UP()?

> +	else
> +		background = (dirty_background_ratio * available_memory) / 100;
>  
> -	background = (background_ratio * available_memory) / 100;
> -	dirty = (dirty_ratio * available_memory) / 100;
> +	if (background >= dirty)
> +		background = dirty / 2;
>  	tsk = current;
>  	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
>  		background += background / 4;
