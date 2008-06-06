Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbYFFPWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbYFFPWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761968AbYFFPVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:21:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761339AbYFFPVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:21:48 -0400
Date: Fri, 6 Jun 2008 11:21:45 -0400
From: Jeff Layton <jlayton@redhat.com>
To: bfields@fieldses.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 2/3] sunrpc: have pooled services make NUMA-friendly
 allocations
Message-ID: <20080606112145.6a23afca@tleilax.poochiereds.net>
In-Reply-To: <20080603111802.8769.22921.stgit@dantu.usersys.redhat.com>
References: <20080603111757.8769.69366.stgit@dantu.usersys.redhat.com>
	<20080603111802.8769.22921.stgit@dantu.usersys.redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 07:18:02 -0400
Jeff Layton <jlayton@redhat.com> wrote:

> Currently, svc_prepare_thread allocates memory using plain kmalloc()
> and alloc_page() calls, even for threads that are destined to run on
> different CPUs or NUMA nodes than the current one. Add a function to
> translate a poolid into a NUMA node, and have svc_prepare_thread and
> svc_init_buffer allocate memory on those nodes instead.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---


--------[snip]--------
>  
> -	rqstp = kzalloc(sizeof(*rqstp), GFP_KERNEL);
> +	rqstp = kzalloc_node(sizeof(*rqstp), GFP_KERNEL, node);

Bruce,
  It looks like AKPM has taken the kzalloc_node patch into -mm. I'd
like to have you take this set into your tree at some point, but don't
want you to have to carry that VM patch too. Would you be amenable to me
changing the above to something like:

	/* FIXME: change to kzalloc_node when/if it makes it to mainline */
	rqstp = kmalloc_node(sizeof(*rqstp), GFP_KERNEL | __GFP_ZERO, node);

...and then we can make the FIXME change when mainline has the new inline?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
