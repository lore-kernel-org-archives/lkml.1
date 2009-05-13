Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbZEMTAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbZEMTAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbZEMTAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:00:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662AbZEMTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:00:05 -0400
Date: Wed, 13 May 2009 11:56:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com,
       nishimura@mxp.nes.nec.co.jp, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] memcg: fix deadlock between lock_page_cgroup
 and mapping tree_lock
Message-Id: <20090513115626.57844f28.akpm@linux-foundation.org>
In-Reply-To: <20090513133031.f4be15a8.nishimura@mxp.nes.nec.co.jp>
References: <20090513133031.f4be15a8.nishimura@mxp.nes.nec.co.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 13:30:31 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> mapping->tree_lock can be aquired from interrupt context.
> Then, following dead lock can occur.
> 
> Assume "A" as a page.
> 
>  CPU0:
>        lock_page_cgroup(A)
> 		interrupted
> 			-> take mapping->tree_lock.
>  CPU1:
>        take mapping->tree_lock
> 		-> lock_page_cgroup(A)

And we didn't find out about this because lock_page_cgroup() uses
bit_spin_lock(), and lockdep doesn't handle bit_spin_lock().

It would perhaps be useful if one of you guys were to add a spinlock to
struct page, convert lock_page_cgroup() to use that spinlock then run a
full set of tests under lockdep, see if it can shake out any other bugs.

