Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbZGNIqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbZGNIqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 04:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbZGNIqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 04:46:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbZGNIqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 04:46:33 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Document /proc/TGID /proc/TID readdir weirdness
Date: Tue, 14 Jul 2009 14:18:12 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907141418.12484.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readdir() on /proc returns only one directory per TGID, i.e., /proc/<TGID>
But if you, try to read a directory /proc/<TID>/ where there is no TGID == TID,
it would succeed.

For example,
$ ls /proc
There is no directory by name /proc/6375

$ ls /proc/6373/task
6373  6375

$ ls /proc/6375/
attr        cmdline          environ  io        maps ...
/proc/6375/ exists!

I tried changing this behaviour to disallow reads using /proc/<TID>/, but it
breaks, a lot of user-space applications and scripts that depend on this
behaviour. So let us make this a documented behaviour.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index fad18f9..ae79898 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -137,8 +137,14 @@ Table 1-1: Process specific entries in /proc
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
  smaps		a extension based on maps, showing the memory consumption of
 		each mapping
+ task		Contains directories for each thread in this thread group. Each
+		of those directory contain similar information specific for
+		those threads. /proc/<TGID>/task/<TID>
 ..............................................................................
 
+NOTE: Even though readdir() on /proc returns only one directory per TGID it is
+possible to open and read /proc/<TID>/ directly, using any TID as well.
+
 For example, to get the status information of a process, all you have to do is
 read the file /proc/PID/status:
 



