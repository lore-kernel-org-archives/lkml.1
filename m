Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab0BXVkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:40:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182Ab0BXVkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:40:15 -0500
Date: Wed, 24 Feb 2010 13:39:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: mm: used-once mapped file page detection
Message-Id: <20100224133946.a5092804.akpm@linux-foundation.org>
In-Reply-To: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org>
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010 20:49:07 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:

> this is the second submission of the used-once mapped file page
> detection patch.
> 
> It is meant to help workloads with large amounts of shortly used file
> mappings, like rtorrent hashing a file or git when dealing with loose
> objects (git gc on a bigger site?).
> 
> Right now, the VM activates referenced mapped file pages on first
> encounter on the inactive list and it takes a full memory cycle to
> reclaim them again.  When those pages dominate memory, the system
> no longer has a meaningful notion of 'working set' and is required
> to give up the active list to make reclaim progress.  Obviously,
> this results in rather bad scanning latencies and the wrong pages
> being reclaimed.
> 
> This patch makes the VM be more careful about activating mapped file
> pages in the first place.  The minimum granted lifetime without
> another memory access becomes an inactive list cycle instead of the
> full memory cycle, which is more natural given the mentioned loads.

iirc from a long time ago, the insta-activation of mapped pages was
done because people were getting peeved about having their interactive
applications (X, browser, etc) getting paged out, and bumping the pages
immediately was found to help with this subjective problem.

So it was a latency issue more than a throughput issue.  I wouldn't be
surprised if we get some complaints from people for the same reasons as
a result of this patch.

I guess that during the evaluation period of this change, it would be
useful to have a /proc knob which people can toggle to revert to the
old behaviour.  So they can verify that this patchset was indeed the
cause of the deterioration, and so they can easily quantify any
deterioration?
