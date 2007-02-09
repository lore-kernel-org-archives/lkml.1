Return-Path: <linux-kernel-owner+w=401wt.eu-S1946235AbXBIJBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946235AbXBIJBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946237AbXBIJBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:01:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36611 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946235AbXBIJBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:01:21 -0500
Date: Fri, 9 Feb 2007 01:00:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@openvz.org>
Cc: viro@ftp.linux.org.uk, linux-kernel@vger.kernel.org,
       duncan.sands@math.u-psud.fr
Subject: Re: [PATCH v3] Fix rmmod/read/write races in /proc entries
Message-Id: <20070209010037.7f4393c5.akpm@linux-foundation.org>
In-Reply-To: <20070208132012.GA6041@localhost.sw.ru>
References: <20070208132012.GA6041@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 16:20:12 +0300 Alexey Dobriyan <adobriyan@openvz.org> wrote:

> +again:
>  	spin_lock(&proc_subdir_lock);
>  	for (p = &parent->subdir; *p; p=&(*p)->next ) {
>  		if (!proc_match(len, fn, *p))
>  			continue;
>  		de = *p;
> +
> +		/*
> +		 * Stop accepting new readers/writers. If you're dynamically
> +		 * allocating ->proc_fops, save a pointer somewhere.
> +		 */
> +		spin_lock(&de->pde_unload_lock);
> +		de->proc_fops = NULL;
> +		/* Wait until all readers/writers are done. */
> +		if (de->pde_users > 0) {
> +			spin_unlock(&de->pde_unload_lock);
> +			spin_unlock(&proc_subdir_lock);
> +			schedule();
> +			goto again;
> +		}
> +		spin_unlock(&de->pde_unload_lock);

aergh.  This will devolve into busy-wait-until-we-expire-our-timeslice.

Would be nicer to do this with a wait_for_completion().

I guess it doesn't happen very often - if another process happens to
be in the middle or a read or write syscall to that /proc file.
