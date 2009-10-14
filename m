Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbZJMM6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbZJMM6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZJMM6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:58:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54267 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZJMM6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:58:11 -0400
Message-ID: <4AD5C9EB.50300@cn.fujitsu.com>
Date: Wed, 14 Oct 2009 20:54:03 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] inotify: fix coalesce duplicate events into a single event
 in special case
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we do rename a dir entry, like this:

  rename("/tmp/ino7UrgoJ.rename1", "/tmp/ino7UrgoJ.rename2")
  rename("/tmp/ino7UrgoJ.rename2", "/tmp/ino7UrgoJ")

The duplicate events should be coalesced into a single event. But those two
events do not be coalesced into a single event, due to some bad check in
event_compare(). It can not match the two NULL inodes as the same event.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 fs/notify/notification.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 3816d57..b8bf53b 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -143,7 +143,7 @@ static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new
 			/* remember, after old was put on the wait_q we aren't
 			 * allowed to look at the inode any more, only thing
 			 * left to check was if the file_name is the same */
-			if (old->name_len &&
+			if (!old->name_len ||
 			    !strcmp(old->file_name, new->file_name))
 				return true;
 			break;
-- 
1.6.2.2


