Return-Path: <linux-kernel-owner+w=401wt.eu-S1764879AbXGQVXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764879AbXGQVXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbXGQVXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:23:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:57455 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbXGQVXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:23:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:
	subject:content-type:content-transfer-encoding;
	b=YGt2qzLrnXwdtb/Z3F26Wq0bw83NWozk1Tpr9Kbbd350DsKn5ewLbH9lqk7VAQy/1
	BCuWx/clEqopIDTdTXeFQ==
Message-ID: <469D3342.3080405@google.com>
Date: Tue, 17 Jul 2007 14:23:14 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@google.com>, Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 0/6] cpuset aware writeback
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Perform writeback and dirty throttling with awareness of cpuset mem_allowed.

The theory of operation has two primary elements:

1. Add a nodemask per mapping which indicates the nodes
   which have set PageDirty on any page of the mappings.

2. Add a nodemask argument to wakeup_pdflush() which is
   propagated down to sync_sb_inodes.

This leaves sync_sb_inodes() with two nodemasks. One is passed to it and
specifies the nodes the caller is interested in syncing, and will either
be null (i.e. all nodes) or will be cpuset_current_mems_allowed in the
caller's context.

The second nodemask is attached to the inode's mapping and shows who has
modified data in the inode. sync_sb_inodes() will then skip syncing of
inodes if the nodemask argument does not intersect with the mapping
nodemask.

cpuset_current_mems_allowed will be passed in to pdflush
background_writeout by try_to_free_pages and balance_dirty_pages.
balance_dirty_pages also passes the nodemask in to writeback_inodes
directly when doing active reclaim.

Other callers do not limit inode writeback, passing in a NULL nodemask
pointer.

A final change is to get_dirty_limits. It takes a nodemask argument, and
when it is null there is no change in behavior. If the nodemask is set,
page statistics are accumulated only for specified nodes, and the
background and throttle dirty ratios will be read from a new per-cpuset
ratio feature.

These patches are mostly unchanged from Chris Lameter's original
changelist posted previously to linux-mm.
