Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbZIXBlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbZIXBlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 21:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZIXBld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 21:41:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47367 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbZIXBld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 21:41:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Sep 2009 10:39:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Subject: Re: [PATCH 2/4] send callback when swap slot is freed
Message-Id: <20090924103919.9397ac87.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1253227412-24342-3-git-send-email-ngupta@vflare.org>
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org>
	<1253227412-24342-3-git-send-email-ngupta@vflare.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 04:13:30 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> @@ -585,6 +617,8 @@ static int swap_entry_free(struct swap_info_struct *p,
>  			swap_list.next = p - swap_info;
>  		nr_swap_pages++;
>  		p->inuse_pages--;
> +		if (p->swap_free_notify_fn)
> +			p->swap_free_notify_fn(p->bdev, offset);
>  	}
>  	if (!swap_count(count))
>  		mem_cgroup_uncharge_swap(ent);

A nitpick but I feel I have to explain why mem_cgroup_ucharge_swap() is called
here. (difference with p->swap_free_notify_fn)

if (!swap_count(count))

means "It seems no users for this swap entry but we're not sure there are
       SwapCache for this entry or not."

In mem_cgroup_uncharge_swap(), swap_cgroup is checked and if there is
a record (which means the SwapCache is not mapped anywhere), swap usage
is uncharged.

This is for race window at freeing swap entry via
zap_pte_range() => free_swap_and_cache().
(swap entry is not freed if the page is locked.)

I'll add some explanation in next series of memcg-cleanup patches.

Thanks,
-Kame

