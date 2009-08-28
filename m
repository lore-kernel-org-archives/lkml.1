Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZH1S4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZH1S4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZH1Sz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:55:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZH1Sz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:55:56 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/9] vfs: introduce FMODE_NONOTIFY
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
Cc: davem@davemloft.net, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
Date: Fri, 28 Aug 2009 14:55:50 -0400
Message-ID: <20090828185549.8014.66446.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090828185542.8014.22791.stgit@paris.rdu.redhat.com>
References: <20090828185542.8014.22791.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new f_mode which can only be set by the kernel.  It indicates
that the fd was opened by fanotify and should not cause future fanotify
events.  This is needed to prevent fanotify livelock.  An example of
obvious livelock is from fanotify close events.

Process A closes file1
This creates a close event for file1.
fanotify opens file1 for Listener X
Listener X deals with the event and closes its fd for file1.
This creates a close event for file1.
fanotify opens file1 for Listener X
Listener X deals with the event and closes its fd for file1.
This creates a close event for file1.
fanotify opens file1 for Listener X
Listener X deals with the event and closes its fd for file1.
notice a pattern?

The fix is to add the FMODE_NONOTIFY bit to the open filp done by the kernel
for fanotify.  Thus when that file is used it will not generate future
events.

This patch simply defines the bit.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fs.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6e3a32d..c3d7b8b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -87,6 +87,9 @@ struct inodes_stat_t {
  */
 #define FMODE_NOCMTIME		((__force fmode_t)2048)
 
+/* File was opened by fanotify and shouldn't generate fanotify events */
+#define FMODE_NONOTIFY		((__force fmode_t)4096)
+
 /*
  * The below are the various read and write types that we support. Some of
  * them include behavioral modifiers that send information down to the

