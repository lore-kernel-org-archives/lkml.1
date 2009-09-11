Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbZIKF0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbZIKF0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 01:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZIKF0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 01:26:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbZIKF0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 01:26:11 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/8] vfs: introduce FMODE_NONOTIFY
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
Cc: davem@davemloft.net, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
Date: Fri, 11 Sep 2009 01:26:06 -0400
Message-ID: <20090911052605.32359.13248.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com>
References: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com>
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
index 02e111c..433db62 100644
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

