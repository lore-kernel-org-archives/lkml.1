Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZGMNoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZGMNoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbZGMNoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:44:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50053 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938AbZGMNoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:44:06 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] fsnotify: fix inotify tail drop check with path entries
To: linux-kernel@vger.kernel.org
Cc: scott@ubuntu.com, viro@ZenIV.linux.org.uk
Date: Mon, 13 Jul 2009 09:44:04 -0400
Message-ID: <20090713134404.14487.61847.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090713134353.14487.93035.stgit@paris.rdu.redhat.com>
References: <20090713134353.14487.93035.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify drops new events when they are the same as the tail event on the
queue to be sent to userspace.  The problem is that if the event comes with
a path we forget to break out of the switch statement and fall into the
code path which matches on events that do not have any type of file backed
information (things like IN_UNMOUNT and IN_Q_OVERFLOW).  The problem is
that this code thinks all such events should be dropped.  Fix is to add a
break.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/notification.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index d1fbbea..99d840b 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -150,6 +150,7 @@ static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new
 			if ((old->path.mnt == new->path.mnt) &&
 			    (old->path.dentry == new->path.dentry))
 				return true;
+			break;
 		case (FSNOTIFY_EVENT_NONE):
 			return true;
 		};

