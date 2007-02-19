Return-Path: <linux-kernel-owner+w=401wt.eu-S1750730AbXBSJFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750730AbXBSJFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 04:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbXBSJFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 04:05:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46231 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbXBSJFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 04:05:09 -0500
Date: Mon, 19 Feb 2007 00:54:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, xemul@sw.ru, linux-mm@kvack.org,
       menage@google.com, svaidy@linux.vnet.ibm.com, devel@openvz.org
Subject: Re: [RFC][PATCH][0/4] Memory controller (RSS Control)
Message-Id: <20070219005441.7fa0eccc.akpm@linux-foundation.org>
In-Reply-To: <20070219065019.3626.33947.sendpatchset@balbir-laptop>
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007 12:20:19 +0530 Balbir Singh <balbir@in.ibm.com> wrote:

> This patch applies on top of Paul Menage's container patches (V7) posted at
> 
> 	http://lkml.org/lkml/2007/2/12/88
> 
> It implements a controller within the containers framework for limiting
> memory usage (RSS usage).

It's good to see someone building on someone else's work for once, rather
than everyone going off in different directions.  It makes one hope that we
might actually achieve something at last.


The key part of this patchset is the reclaim algorithm:

> @@ -636,6 +642,15 @@ static unsigned long isolate_lru_pages(u
>  
>  		list_del(&page->lru);
>  		target = src;
> +		/*
> + 		 * For containers, do not scan the page unless it
> + 		 * belongs to the container we are reclaiming for
> + 		 */
> +		if (container && !page_in_container(page, zone, container)) {
> +			scan--;
> +			goto done;
> +		}

Alas, I fear this might have quite bad worst-case behaviour.  One small
container which is under constant memory pressure will churn the
system-wide LRUs like mad, and will consume rather a lot of system time. 
So it's a point at which container A can deleteriously affect things which
are running in other containers, which is exactly what we're supposed to
not do.

