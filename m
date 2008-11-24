Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYKXSCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYKXSCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYKXSCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:02:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37379 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYKXSCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:02:25 -0500
Date: Mon, 24 Nov 2008 19:00:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] getrusage: fill ru_maxrss value
Message-ID: <20081124180031.GA20155@redhat.com>
References: <20081124170253.741d2e6e@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081124170253.741d2e6e@psychotron.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Jiri Pirko wrote:
>
> @@ -1588,6 +1589,13 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
>  				accumulate_thread_rusage(t, r);
>  				t = next_thread(t);
>  			} while (t != p);
> +			if (p->mm) {
> +				update_hiwater_rss(p->mm);
> +				if (r->ru_maxrss < p->mm->hiwater_rss)
> +					r->ru_maxrss = p->mm->hiwater_rss;

The task can free its ->mm right after the check. You need get_task_mm(),
but you can't do this under ->siglock because it takes task_lock().

I think you can move this code outside of lock_task_sighand().

Oleg.

