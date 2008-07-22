Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYGVCgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYGVCgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYGVCg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:36:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYGVCg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:36:27 -0400
Date: Mon, 21 Jul 2008 22:36:09 -0400
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Johannes Weiner" <hannes@saeurebad.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       Nossum <vegard.nossum@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] mm: more likely reclaim MADV_SEQUENTIAL mappings
Message-ID: <20080721223609.70e93725@bree.surriel.com>
In-Reply-To: <200807221202.27169.nickpiggin@yahoo.com.au>
References: <87y73x4w6y.fsf@saeurebad.de>
	<200807211549.00770.nickpiggin@yahoo.com.au>
	<20080721111412.0bfcd09b@bree.surriel.com>
	<200807221202.27169.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 12:02:26 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> I don't actually care what the man page or posix says if it is obviously
> silly behaviour. If you want to dispute the technical points of my post,
> that would be helpful.

Application writers read the man page and expect MADV_SEQUENTIAL
to do roughly what the name and description imply.

If you think that the kernel should not bother implementing
what the application writers expect, and the application writers
should implement special drop-behind magic for Linux, your
expectations may not be entirely realistic.

> Consider this: if the app already has dedicated knowledge and
> syscalls to know about this big sequential copy, then it should
> go about doing it the *right* way and really get performance
> improvement. Automatic unmap-behind even if it was perfect still
> needs to scan LRU lists to reclaim.

Doing nothing _also_ ends up with the kernel scanning the
LRU lists, once memory fills up.

Scanning the LRU lists is a given.

All that the patch by Johannes does is make sure the kernel
does the right thing when it runs into an MADV_SEQUENTIAL
page on the inactive_file list: evict the page immediately,
instead of having it pass through the active list and the
inactive list again.  

This reduces the number of times that MADV_SEQUENTIAL pages
get scanned from 3 to 1, while protecting the working set
from MADV_SEQUENTIAL pages.

-- 
All rights reversed.
