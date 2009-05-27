Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZE0LOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZE0LOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbZE0LMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:17 -0400
Received: from smtp.nokia.com ([192.100.122.230]:54583 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759802AbZE0LMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:12 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:05:03 +0300
Message-Id: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/19] periodic write-back timer optimization
X-OriginalArrivalTime: 27 May 2009 11:11:06.0588 (UTC) FILETIME=[D4B879C0:01C9DEBB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second attempt. The first one was here:
http://marc.info/?l=linux-fsdevel&m=124301072305588&w=2
It was very hacky and got no comments.

Here is a cleaner set of patches. They attempt to optimize
the periodic write-back and stop it when there are no
dirty data. At the moment "pdflush" thread wakes up every
5 seconds (by default). Even if there are no dirty data,
it still wakes up. In the embedded world this means that
power consumption is higher, because the pdflush makes
the CPU to leave low power consumption/retention mode
every 5 seconds.

The patch set consists of 2 parts. Patches 01-17 are rather
mechanical. They simply introduce 3 VFS helpers which
encapsulate the 'sb->s_dirt' handling, so file-systems do
not manipulate it directly, but rather use VFS helpers
for this.

Patch 18 is just a simple preparation for patch 19.

Patch 19 introduces a global 'periodic_wb_enabled' flag.
Then it adds few code to the 'mark_sb_dirty()' and the
'__mark_inode_dirty(); function. This code enables the
periodic write-back if it is disabled. I tried to make
this additional code light-weight.

The periodic WB function, in turn, checks whether there
is dirt. If there is, it sets the 'wb_timer' for itself.
Otherwise, it just deletes the timer. Should something
become dirty, it will be woken up again.

This is still RFC.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
