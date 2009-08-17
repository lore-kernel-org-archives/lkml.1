Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZHQBwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZHQBwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 21:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbZHQBwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 21:52:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43798 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbZHQBwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 21:52:08 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/3] inotify: tail drop inotify q_overflow events
To: linux-kernel@vger.kernel.org, fs-devel@vger.kernel.org
Cc: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk
Date: Sun, 16 Aug 2009 21:51:49 -0400
Message-ID: <20090817015149.15099.12171.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090817015143.15099.80614.stgit@paris.rdu.redhat.com>
References: <20090817015143.15099.80614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In f44aebcc the tail drop logic of events with no file backing
(q_overflow and in_ignored) was reversed so IN_IGNORED events would never
be tail dropped.  This now means that Q_OVERFLOW events are NOT tail
dropped.  The fix is to not tail drop IN_IGNORED, but to tail drop
Q_OVERFLOW.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/notification.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 74b3cf3..3816d57 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -153,6 +153,10 @@ static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new
 				return true;
 			break;
 		case (FSNOTIFY_EVENT_NONE):
+			if (old->mask & FS_Q_OVERFLOW)
+				return true;
+			else if (old->mask & FS_IN_IGNORED)
+				return false;
 			return false;
 		};
 	}

