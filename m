Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbYEEVv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbYEEVv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbYEEVvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:51:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757688AbYEEVvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:51:50 -0400
Date: Mon, 5 May 2008 17:51:42 -0400
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [-mm][PATCH 4/5] core of reclaim throttle
Message-ID: <20080505175142.7de3f27b@cuia.bos.redhat.com>
In-Reply-To: <20080504221043.8F64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080504215819.8F5E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080504221043.8F64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 May 2008 22:12:12 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> +	throttle_on = 1;
> +	current->flags |= PF_RECLAIMING;
> +	wait_event(zone->reclaim_throttle_waitq,
> +		 atomic_add_unless(&zone->nr_reclaimers, 1, MAX_RECLAIM_TASKS));

This is a problem.  Processes without __GFP_FS or __GFP_IO cannot wait on
processes that have those flags set in their gfp_mask, and tasks that do
not have __GFP_IO set cannot wait for tasks with it.  This is because the
tasks that have those flags set may grab locks that the tasks without the
flag are holding, causing a deadlock.

The easiest fix would be to only make tasks with both __GFP_FS and __GFP_IO
sleep.  Tasks that call try_to_free_pages without those flags are relatively
rare and should hopefully not cause any issues.

-- 
All Rights Reversed
