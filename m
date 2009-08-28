Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbZH1QWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbZH1QWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZH1QWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:22:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:40168 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZH1QWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=QkOVQjQKE4wn69nD5JaCd3uEBdJNyIvIopTeg0KC/oo5VW/lzqarY3XZXrDiZASAT/
         k/cyIez83DSMirDEUoenIe+Gu2Qbd+EDVxaDyLw6iOhg5T+JDq1OINnL1+vvPAMdSZKe
         D0sYDHxcOFO29bdcLYBkDOc119S0e1x4VHUqc=
Date: Sat, 29 Aug 2009 00:21:51 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Eric Paris <eparis@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Linux-2.6.31-rc8 inotify hangs samba clients [UPDATED]
Message-ID: <Pine.LNX.4.64.0908290014470.19623@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sorry, corrected patch below. Previous one was bad ... I was 
messing with.

The first part of commit 0db501bd0610ee0c0aca84d927f90bcccd09e2bd hangs 
WinXP clients browsing Linux samba folders ... trying to add a terminating 
byte to name_len. Reverting this solves the problem.

The second part of adding zeros is fine.

If we don't revert here, then Samba 3.3.7 will have to change to work with 
Linux 2.6.31-rc8, and perhaps other codes as well.

Thanks,
Jeff


Here the patch to revert.


commit 0db501bd0610ee0c0aca84d927f90bcccd09e2bd
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Thu Aug 27 03:20:04 2009 -0700

     inotify: Ensure we alwasy write the terminating NULL.

     Before the rewrite copy_event_to_user always wrote a terqminating '\0'
     byte to user space after the filename.  Since the rewrite that
     terminating byte was skipped if your filename is exactly a multiple of
     event_size.  Ouch!

     So add one byte to name_size before we round up and use clear_user to
     set userspace to zero like /dev/zero does instead of copying the
     strange nul_inotify_event.

     Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
     Signed-off-by: Eric Paris <eparis@redhat.com>

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index ce1f582..0e781bc 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
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
