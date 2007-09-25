Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbXIYQ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbXIYQ4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXIYQ4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:56:44 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42503 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbXIYQ4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:56:43 -0400
Date: Tue, 25 Sep 2007 12:56:29 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 2/2] locks: add warning about mandatory locking races
Message-ID: <20070925165629.GH30845@fieldses.org>
References: <1190037331.6700.14.camel@heimdal.trondhjem.org> <46EE8C52.80503@openvz.org> <1190044850.6700.81.camel@heimdal.trondhjem.org> <46EF7136.7080308@openvz.org> <20070918151957.GA18476@fieldses.org> <1190132095.6656.12.camel@heimdal.trondhjem.org> <20070918165220.GE18476@fieldses.org> <1190134496.6656.22.camel@heimdal.trondhjem.org> <20070918174016.GF18476@fieldses.org> <20070925165551.GG30845@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925165551.GG30845@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The mandatory file locking implementation has long-standing races that
probably render it useless.  I know of no plans to fix them.  Till we
do, we should at least warn people.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 Documentation/filesystems/mandatory-locking.txt |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/mandatory-locking.txt b/Documentation/filesystems/mandatory-locking.txt
index bc449d4..8ac5cfb 100644
--- a/Documentation/filesystems/mandatory-locking.txt
+++ b/Documentation/filesystems/mandatory-locking.txt
@@ -3,7 +3,26 @@
 		Andy Walker <andy@lysaker.kvaerner.no>
 
 			   15 April 1996
-
+		     (Updated September 2007)
+
+0. Why should I avoid mandatory locking?
+----------------------------------------
+
+The Linux implementation is prey to a number of difficult-to-fix race
+conditions which in practice make it not dependable:
+
+	- The write system call checks for a mandatory lock only once
+	  at its start.  It is therefore possible for a lock request to
+	  be granted after this check but before the data is modified.
+	  A process may then see file data change even while a mandatory
+	  lock was held.
+	- Similarly, an exclusive lock may be granted on a file after
+	  the kernel has decided to proceed with a read, but before the
+	  read has actually completed, and the reading process may see
+	  the file data in a state which should not have been visible
+	  to it.
+	- Similar races make the claimed mutual exclusion between lock
+	  and mmap similarly unreliable.
 
 1. What is  mandatory locking?
 ------------------------------
-- 
1.5.3.1.139.g9346b

