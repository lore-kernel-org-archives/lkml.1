Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbZIRTeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbZIRTeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZIRTeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:34:14 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38486 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbZIRTeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:34:09 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: [RFC PATCH 0/3] Hatchet job for SLQB on memoryless configurations
Date: Fri, 18 Sep 2009 20:34:08 +0100
Message-Id: <1253302451-27740-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently SLQB is not allowed to be configured on PPC and S390 machines as
CPUs can belong to memoryless nodes. SLQB does not deal with this very well
and crashes reliably.

This patch partially fixes the problem on at least one machine and allows
SLQB to boot although I'm not sure if it's actually stable. It's doubtful
this is the solution even in the short-term. This is a hatchet job due to
my lack of familiarity with SLQB. While SLQB is handy to get to grips with,
someone more familiar may be able to identify a proper fix faster assuming
this helps point the direction of the real problem.

Patch 1 statically defines some per-node structures instead of using a fun
	hack with DEFINE_PER_CPU. The problem was that the per-node structures
	appeared to be getting corrupted (different values each boot on
	struct fields, particularly the lock), possibly because the active
	node IDs are higher than the highest CPU id. It's not known why
	this is a problem at the moment and could do with further explanation.

Patch 2 noticed that on memoryless nodes, slab objects always gets freed to
	the remote list while the allocation side always looked at the per-cpu
	lists. Lists grew in an unbounded fashion and the machine OOM'd. This
	patch checks if the remote page is being freed to a memoryless node
	and if so, the page is treated as if it's local. This needs further
	thinking from someone familiar with SLQB.

Patch 3 allows SLQB to be configured on PPC and S390 again.

This patchset is not intended for merging. It's to help point out where the
real problems might be so a proper fix can be hashed out.

 init/Kconfig |    1 -
 mm/slqb.c    |   23 +++++++++++++----------
 2 files changed, 13 insertions(+), 11 deletions(-)

