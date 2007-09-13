Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbXIMHwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbXIMHwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXIMHwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:52:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34212 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbXIMHwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:52:32 -0400
Message-Id: <200709130752.l8D7qAUA005911@owlet.beaverton.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Bad hotplug/scheduler interaction?
Date: Thu, 13 Sep 2007 00:52:10 -0700
From: Rick Lindsley <ricklind@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm concerned that we don't have adequate protection for the scheduler
during cpu hotplug events, but I'm willing to believe I simply don't
understand the mechanism well enough.  We had a crash in (comparatively
ancient) 2.6.16.* but I think the relevant code is basically unchanged
since then.

First we introduced some cpu-intensive workloads.  Then we added two cpus.
System quickly crashed.  The crash was in find_busiest_group(), when
the kernel tried to access "this", which was NULL.  If we don't find a
localgroup, we won't set this, and when we try to calculate *imbalance,
we'll dereference a NULL "this" and crash.

As I looked over the code, though, I couldn't tell if the fault was with
find_busiest_group() for not covering this case, or if the problem was
that the method the hotplug code is using to reconstruct the sched_domains
really doesn't protect find_busiest_group (and find_idlest_group) at all.
Can anybody explain how synchronize_sched() is really syncing?  It looks
like a half-implemented RCU setup.  I fear we really don't have any way
to protect the two functions above from hotplug's desire to twiddle
with the sched_domains.

Do we?

Rick
