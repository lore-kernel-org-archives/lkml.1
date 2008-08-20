Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYHTSfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYHTSfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYHTSfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:35:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYHTSfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:35:24 -0400
Date: Wed, 20 Aug 2008 11:31:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, tokunaga.keiich@jp.fujitsu.com,
       stable@kernel.org
Subject: Re: [RFC][PATCH 0/2] Quicklist is slighly problematic.
Message-Id: <20080820113131.f032c8a2.akpm@linux-foundation.org>
In-Reply-To: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 20:05:51 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Cristoph,
> 
> Thank you for explain your quicklist plan at OLS.
> 
> So, I made summary to issue of quicklist.
> if you have a bit time, Could you please read this mail and patches?
> And, if possible, Could you please tell me your feeling?
> 
> 
> --------------------------------------------------------------------
> 
> Now, Quicklist store some page in each CPU as cache.
> (Each CPU has node_free_pages/16 pages)
> 
> and it is used for page table cache.
> Then, exit() increase cache, the other hand fork() spent it.
> 
> So, if apache type (one parent and many child model) middleware run,
> One CPU process fork(), Other CPU process the middleware work and exit().
> 
> At that time, One CPU don't have page table cache at all,
> Others have maximum caches.
> 
> 	QList_max = (#ofCPUs - 1) x Free / 16
> 	=> QList_max / (Free + QList_max) = (#ofCPUs - 1) / (16 + #ofCPUs - 1)
> 
> So, How much quicklist spent memory at maximum case?
> That is #CPUs proposional because it is per CPU cache but cache amount calculation doesn't use #ofCPUs.
> 
> 	Above calculation mean
> 
> 	 Number of CPUs per node            2    4    8   16
> 	 ==============================  ====================
> 	 QList_max / (Free + QList_max)   5.8%  16%  30%  48%
> 
> 
> Wow! Quicklist can spent about 50% memory at worst case.
> More unfortunately, it doesn't have any cache shrinking mechanism.
> So it cause some wrong thing.
> 
> 1. End user misunderstand to memory leak happend.
> 	=> /proc/meminfo should display amount quicklist
> 
> 2. It can cause OOM killer
> 	=> Amount of quicklists shouldn't be proposional to #ofCPUs.
> 

OK, that's a fatal bug and it's present in 2.6.25.x and 2.6.26.x.  A
serious issue.

The patches do apply to both stable kernels and I have tagged them for
backporting into them.  They're nice and small, but I didn't get a
really solid yes-this-is-what-we-should-do from Christoph?


This (from [patch 2/2]): "(Although its patch applied, quicklist can
waste 64GB on 1TB server (= 1TB / 16), it is still too much??)" is a
bit of a worry.  Yes, 64GB is too much!  But at least this is now only
a performance issue rather than a stability issue, yes?
