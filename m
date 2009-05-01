Return-Path: <linux-kernel-owner+w=401wt.eu-S1761359AbZEAOG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761359AbZEAOG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbZEAOGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:06:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41539 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713AbZEAOGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:06:49 -0400
Message-ID: <49FB01C1.6050204@redhat.com>
Date: Fri, 01 May 2009 10:05:53 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: elladan@eskimo.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       tytso@mit.edu, kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
References: <20090428044426.GA5035@eskimo.com>	<20090428192907.556f3a34@bree.surriel.com>	<1240987349.4512.18.camel@laptop>	<20090429114708.66114c03@cuia.bos.redhat.com>	<20090430072057.GA4663@eskimo.com>	<20090430174536.d0f438dd.akpm@linux-foundation.org>	<20090430205936.0f8b29fc@riellaptop.surriel.com>	<20090430181340.6f07421d.akpm@linux-foundation.org>	<20090430215034.4748e615@riellaptop.surriel.com> <20090430195439.e02edc26.akpm@linux-foundation.org>
In-Reply-To: <20090430195439.e02edc26.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>> When we implement working set protection, we might as well
>> do it for frequently accessed unmapped pages too.  There is
>> no reason to restrict this protection to mapped pages.
> 
> Well.  Except for empirical observation, which tells us that biasing
> reclaim to prefer to retain mapped memory produces a better result.

That used to be the case because file-backed and
swap-backed pages shared the same set of LRUs,
while each following a different page reclaim
heuristic!

Today:
1) file-backed and swap-backed pages are separated,
2) the majority of mapped pages are on the swap-backed LRUs
3) the accessed bit on active pages no longer means much,
    for good scalability reasons, and
4) because of (3), we cannot really provide special treatment
    to any individual page any more, however

This means we need to provide our working set protection
on a per-list basis, by tweaking the scan rate or avoiding
scanning of the active file list alltogether under certain
conditions.

As a side effect, this will help protect frequently accessed
file pages (good for ftp and nfs servers), indirect blocks,
inode buffers and other frequently used metadata.

-- 
All rights reversed.
