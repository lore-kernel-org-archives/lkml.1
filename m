Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYAJCZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYAJCZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbYAJCZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:25:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43292 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411AbYAJCZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:25:47 -0500
Date: Thu, 10 Jan 2008 11:28:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-Id: <20080110112849.d54721ac.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080108210002.638347207@redhat.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jan 2008 15:59:44 -0500
Rik van Riel <riel@redhat.com> wrote:

> +	rotate_sum = zone->recent_rotated_file + zone->recent_rotated_anon;
> +
> +	/* Keep a floating average of RECENT references. */
> +	if (unlikely(rotate_sum > min(anon, file))) {
> +		spin_lock_irq(&zone->lru_lock);
> +		zone->recent_rotated_file /= 2;
> +		zone->recent_rotated_anon /= 2;
> +		spin_unlock_irq(&zone->lru_lock);
> +		rotate_sum /= 2;
> +	}
> +
> +	/*
> +	 * With swappiness at 100, anonymous and file have the same priority.
> +	 * This scanning priority is essentially the inverse of IO cost.
> +	 */
> +	anon_prio = sc->swappiness;
> +	file_prio = 200 - sc->swappiness;
> +
> +	/*
> +	 *                  anon       recent_rotated_anon
> +	 * %anon = 100 * ----------- / ------------------- * IO cost
> +	 *               anon + file       rotate_sum
> +	 */
> +	ap = (anon_prio * anon) / (anon + file + 1);
> +	ap *= rotate_sum / (zone->recent_rotated_anon + 1);
> +	if (ap == 0)
> +		ap = 1;
> +	else if (ap > 100)
> +		ap = 100;
> +	percent[0] = ap;
> +

Hmm, it seems..

When a program copies large amount of files, recent_rotated_file increases
rapidly and 

    rotate_sum
    ----------
recent_rotated_anon

will be very big.

And %ap will be big regardless of vm_swappiness  if it's not 0.

I think # of recent_successful_pageout(anon/file) should be took into account...

I'm sorry if I miss something.

Thanks,
-Kame

