Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZC2Qhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZC2Qhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZC2Qha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:37:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:52656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbZC2Qh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:37:29 -0400
Message-Id: <20090329155539.275927173@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 30 Mar 2009 02:55:39 +1100
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [rfc] scale dcache locking
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my sketch for improving dcache locking scalability. So far I've
only really been looking at core code to get an idea of how it might look,
so most configurable functionality is broken (and unfortunately it might
well be something in there which will cause a fundamental problem for me).

But there is a *lot* of stuff to go through, so I like to just get some
early opinions of this.

I have tried to split it as nicely as possible. Patch splitting still
needs a bit more work, but it is not too bad hopefully to review.

It seems to break naturally into 3 phases:
- First phase is to add new locks and rules to protect specific data
  structures and dentry fields. This attempts to be as simple and dumb
  replacement as possible, to make review easier.

- Second phase is to remove dcache_lock after it is not protecting
  anything itself.

- Last phase is to improve existing locking schemes, and improve the
  scalability of the newly added locks.

It's nowhere near complete, but it is running and relatively stable
on configs where it compiles. As far as core locking changes go for
this project, I still need to make nr_dentry into a per-cpu counter,
and break up the LRU lock (which is the last remaining global lock
broken out of dcache_lock). LRU lock currently naturally splits into
per-sb locking, but that's not satisfying because we also want really
good scalability within a single sb. I think per-memory-zone LRU lists
and locking might be a good idea because it scales with socket count
and also makes better NUMA targetted dcache reclaim possible. Making
LRU more lazy might also be a good idea to reduce locking.

