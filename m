Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZGGS7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZGGS7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 14:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZGGS7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 14:59:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36519 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbZGGS7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 14:59:37 -0400
Message-ID: <4A539B11.5020803@redhat.com>
Date: Tue, 07 Jul 2009 14:59:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC PATCH 1/2] vmscan don't isolate too many pages
References: <20090707182947.0C6D.A69D9226@jp.fujitsu.com> <20090707184034.0C70.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090707184034.0C70.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> FAQ
> -------
> Q: Why do you compared zone accumulate pages, not individual zone pages?
> A: If we check individual zone, #-of-reclaimer is restricted by smallest zone.
>    it mean decreasing the performance of the system having small dma zone.

That is a clever solution!  I was playing around a bit with
doing it on a per-zone basis.  Your idea is much nicer.

However, I can see one potential problem with your patch:

+		nr_inactive += zone_page_state(zone, NR_INACTIVE_ANON);
+		nr_inactive += zone_page_state(zone, NR_INACTIVE_FILE);
+		nr_isolated += zone_page_state(zone, NR_ISOLATED_ANON);
+		nr_isolated += zone_page_state(zone, NR_ISOLATED_FILE);
+	}
+
+	return nr_isolated > nr_inactive;

What if we ran out of swap space, or are not scanning the
anon list at all for some reason?

It is possible that there are no inactive_file pages left,
with all file pages already isolated, and your function
still letting reclaimers through.

This means you could still get a spurious OOM.

I guess I should mail out my (ugly) approach, so we can
compare the two :)
