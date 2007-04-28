Return-Path: <linux-kernel-owner+w=401wt.eu-S1030856AbXD1VY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030856AbXD1VY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030848AbXD1VY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:24:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33552 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030726AbXD1VY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:24:56 -0400
Date: Sat, 28 Apr 2007 14:12:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: arjan@linux.intel.com
cc: akpm@osdl.org, linux-kernel@vger.kernel
Subject: Please revert [PATCH] user of the jiffies rounding patch: Slab
Message-ID: <Pine.LNX.4.64.0704281403140.12122@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The slab reaper takes global locks. If one makes all cache reapers fire at 
the same time as this patch does then there will be a lot of contention 
that may result lots of interrupt holdoffs since some locks are taken
with interrupts disabled. The vm statistics counters are updated
and will content for global cachelines if this is done.

The approach is fine up to 2 cpus. With 2 cpus we can schedule one cache 
reaper on each cpu each second. So I guess that this was not noticed.

For 16 cpus we are already scheduling 8 parallel cache reapers every 
second. In a 512 cpu system desaster strikes with 256 cache reapers being 
fired off at the same time each second

Git commit 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2b2842146cb4105877c2be51d3857ec61ebd4ff9

This is in 2.6.20 / 2.6.21.

I'd suggest to use a staggered per cpu approach instead that runs multiple 
per cpu timers at once. But every batch of these timers must be run at an 
offset from each other. Not at the same time please.

