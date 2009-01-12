Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZALLOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZALLOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZALLOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:14:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbZALLOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:14:40 -0500
Date: Mon, 12 Jan 2009 06:14:36 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: xfs@oss.sgi.com
cc: linux-kernel@vger.kernel.org
Subject: spurious -ENOSPC on XFS
Message-ID: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I discovered a bug in XFS in delayed allocation.

When you take a small partition (52MB in my case) and copy many small 
files on it (source code) that barely fits there, you get -ENOSPC. Then 
sync the partition, some free space pops up, click "retry" in MC an the 
copy continues. They you get again -ENOSPC, you must sync, click "retry" 
and go on. And so on few times until the source code finally fits on the 
XFS partition.

This misbehavior is apparently caused by delayed allocation, delayed 
allocation does not exactly know how much space will be occupied by data, 
so it makes some upper bound guess. Because free space count is only a 
guess, not the actual data being consumed, XFS should not return -ENOSPC 
on behalf of it. When the free space overflows, XFS should sync itself, 
retry allocation and only return -ENOSPC if it fails the second time, 
after the sync.

Mikulas
