Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbZH0KUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbZH0KUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 06:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZH0KUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 06:20:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53967 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZH0KUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 06:20:08 -0400
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] inotify:  Ensure we alwasy write the terminating NULL.
References: <m1skffj64t.fsf@fess.ebiederm.org>
	<1251299483.2308.32.camel@dhcp231-106.rdu.redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 27 Aug 2009 03:20:04 -0700
In-Reply-To: <1251299483.2308.32.camel@dhcp231-106.rdu.redhat.com> (Eric Paris's message of "Wed\, 26 Aug 2009 11\:11\:23 -0400")
Message-ID: <m1iqg9k17v.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: eparis@redhat.com, rjw@sisk.pl, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Before the rewrite copy_event_to_user always wrote a terqminating '\0'
byte to user space after the filename.  Since the rewrite that
terminating byte was skipped if your filename is exactly a multiple of
event_size.  Ouch!

So add one byte to name_size before we round up and use clear_user to
set userspace to zero like /dev/zero does instead of copying the
strange nul_inotify_event.  I can't quite convince myself len_to_zero
will never exceed 16 and even if it doesn't clear_user should be more
efficient and a more accurate reflection of what the code is trying to
do.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/notify/inotify/inotify_user.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index f30d9bb..90ae8ad 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -47,9 +47,6 @@
 
 static struct vfsmount *inotify_mnt __read_mostly;
 
-/* this just sits here and wastes global memory.  used to just pad userspace messages with zeros */
-static struct inotify_event nul_inotify_event;
-
 /* these are configurable via /proc/sys/fs/inotify/ */
 static int inotify_max_user_instances __read_mostly;
 static int inotify_max_queued_events __read_mostly;
@@ -199,8 +196,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 		inotify_free_event_priv(fsn_priv);
 	}
 
-	/* round up event->name_len so it is a multiple of event_size */
-	name_len = roundup(event->name_len, event_size);
+	/* round up event->name_len so it is a multiple of event_size
+	 * plus an extra byte for the terminating '\0'.
+	 */
+	name_len = roundup(event->name_len + 1, event_size);
 	inotify_event.len = name_len;
 
 	inotify_event.mask = inotify_mask_to_arg(event->mask);
@@ -224,8 +223,8 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 			return -EFAULT;
 		buf += event->name_len;
 
-		/* fill userspace with 0's from nul_inotify_event */
-		if (copy_to_user(buf, &nul_inotify_event, len_to_zero))
+		/* fill userspace with 0's */
+		if (clear_user(buf, len_to_zero))
 			return -EFAULT;
 		buf += len_to_zero;
 		event_size += name_len;
-- 
1.6.2.5

