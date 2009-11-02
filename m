Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbZKBIlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbZKBIlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 03:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZKBIlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 03:41:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56089 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZKBIln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 03:41:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Nov 2009 17:39:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       aarcange@redhat.com, akpm@linux-foundation.org, minchan.kim@gmail.com,
       rientjes@google.com, vedran.furac@gmail.com,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 4/6] oom-killer: fork bomb detector
Message-Id: <20091102173912.601790b0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091102162716.e7803741.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
	<20091102162716.e7803741.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 16:27:16 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> -
> -	/* Try to kill a child first */
> +	if (fork_bomb) {
> +		printk(KERN_ERR "possible fork-bomb is detected. kill them\n");
> +		/* We need to kill the youngest one, at least */
> +		rcu_read_lock();
> +		for_each_process_reverse(c) {
> +			if (c == p)
> +				break;
> +			if (is_forkbomb_family(c, p)) {
> +				oom_kill_task(c);
> +				break;
> +			}
> +		}
> +		rcu_read_unlock();
> +	}

Kosaki said we should kill all under tree and "break" is unnecessay here.
I nearly agree with him..after some experiments.

But it seems the biggest problem is latecy by swap-out...before deciding OOM
....

Thanks,
-Kame

