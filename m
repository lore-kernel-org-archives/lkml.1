Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZFJFzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZFJFzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZFJFz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:55:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbZFJFz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:55:27 -0400
Date: Tue, 9 Jun 2009 22:54:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] Reintroduce zone_reclaim_interval for when
 zone_reclaim() scans and fails to avoid CPU spinning at 100% on NUMA
Message-Id: <20090609225425.b0820ce5.akpm@linux-foundation.org>
In-Reply-To: <1244566904-31470-5-git-send-email-mel@csn.ul.ie>
References: <1244566904-31470-1-git-send-email-mel@csn.ul.ie>
	<1244566904-31470-5-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Jun 2009 18:01:44 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> On NUMA machines, the administrator can configure zone_reclaim_mode that is a
> more targetted form of direct reclaim. On machines with large NUMA distances,
> zone_reclaim_mode defaults to 1 meaning that clean unmapped pages will be
> reclaimed if the zone watermarks are not being met. The problem is that
> zone_reclaim() may get into a situation where it scans excessively without
> making progress.
> 
> One such situation occured where a large tmpfs mount occupied a
> large percentage of memory overall. The pages did not get reclaimed by
> zone_reclaim(), but the lists are uselessly scanned frequencly making the
> CPU spin at 100%. The observation in the field was that malloc() stalled
> for a long time (minutes in some cases) when this situation occurs. This
> situation should be resolved now and there are counters in place that
> detect when the scan-avoidance heuristics break but the heuristics might
> still not be bullet proof. If they fail again, the kernel should respond
> in some fashion other than scanning uselessly chewing up CPU time.
> 
> This patch reintroduces zone_reclaim_interval which was removed by commit
> 34aa1330f9b3c5783d269851d467326525207422 [zoned vm counters: zone_reclaim:
> remove /proc/sys/vm/zone_reclaim_interval. In the event the scan-avoidance
> heuristics fail, the event is counted and zone_reclaim_interval avoids
> excessive scanning.

More distressed fretting!

Pages can be allocated and freed and reclaimed at rates anywhere
between zero per second to one million per second or more.  So what
sense does it make to pace MM activity by wall-time??

A better clock for pacing MM activity is page-allocation-attempts, or
pages-scanned, etc.

