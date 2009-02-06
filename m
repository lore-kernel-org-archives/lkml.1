Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbZBFBjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbZBFBjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZBFBi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:38:56 -0500
Received: from cmpxchg.org ([85.214.51.133]:33740 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbZBFBiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:38:55 -0500
Message-Id: <E1LVFiv-00032p-HX@cmpxchg.org>
From: hannes@cmpxchg.org
Date: Fri, 06 Feb 2009 02:41:41 +0100
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From hannes@cmpxchg.org Fri Feb  6 02:28:54 2009
Message-Id: <20090206012605.378214179@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Fri, 06 Feb 2009 02:26:05 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
 Rik van Riel <riel@redhat.com>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: [PATCH 0/3] swsusp: shrink file cache first

Hello!

here are three patches that adjust the memory shrinking code used for
suspend-to-disk.

The first two patches are cleanups only and can probably go in
regardless of the third one.

The third patch changes the shrink_all_memory() logic to drop the file
cache first before touching any mapped files and only then goes for
anon pages.

The reason is that everything not shrunk before suspension has to go
into the image and will be 'prefaulted' before the processes can
resume and the system is usable again, so the image should be small
and contain only pages that are likely to be used right after resume
again.  And this in turn means that the inactive file cache is the
best point to start decimating used memory.

Also, right now, subsequent faults of contiguously mapped files are
likely to perform better than swapin (see
http://kernelnewbies.org/KernelProjects/SwapoutClustering), so not
only file cache is preferred over other pages, but file pages over
anon pages in general.

Testing up to this point shows that the patch does what is intended,
shrinking file cache in favor of anon pages.  But whether the idea is
correct to begin with is a bit hard to quantify and I am still working
on it, so RFC only.

	Hannes

