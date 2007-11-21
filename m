Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbXKULPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbXKULPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXKULOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:14:42 -0500
Received: from sacred.ru ([62.205.161.221]:42093 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757150AbXKULOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:14:40 -0500
Message-ID: <47441302.6070300@openvz.org>
Date: Wed, 21 Nov 2007 14:14:10 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: [PATCH (resend)][DOCUMENTATION] The namespaces compatibility list
 doc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 21 Nov 2007 14:14:10 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From time to time people begin discussions about how the
namespaces are working/going-to-work together.

Ted T'so proposed to create some document that describes what
problems user may have when he/she creates some new namespace,
but keeps others shared. I liked this idea, so here's the 
initial version of such a document with the problems I currently 
have in mind and can describe somewhat audibly - the "namespaces 
compatibility list".

The Documentation/namespaces/ directory is about to contain more
docs about the namespaces stuff.

Thanks to Cedirc for notes and spell checks on the doc, to Daniel
for additional info about IPC and User namespaces interaction
and to Randy, who alluded me to using a spell checker before
sending the documentation :)

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 0a2b12e..b4a0908 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -265,6 +265,8 @@ mtrr.txt
 	- how to use PPro Memory Type Range Registers to increase performance.
 mutex-design.txt
 	- info on the generic mutex subsystem.
+namespaces/
+	- directory with various information about namespaces
 nbd.txt
 	- info on a TCP implementation of a network block device.
 netlabel/
diff --git a/Documentation/namespaces/compatibility-list.txt b/Documentation/namespaces/compatibility-list.txt
new file mode 100644
index 0000000..d0e8cc3
--- /dev/null
+++ b/Documentation/namespaces/compatibility-list.txt
@@ -0,0 +1,39 @@
+	Namespaces compatibility list
+
+This document contains the information about the problems user
+may have when creating tasks living in different namespaces.
+
+Here's the summary. This matrix shows the known problems, that
+occur when tasks share some namespace (the columns) while living
+in different other namespaces (the rows):
+
+	UTS	IPC	VFS	PID	User	Net
+UTS	 X
+IPC		 X	 1
+VFS			 X
+PID		 1	 1	 X
+User		 2	 2		 X
+Net						 X
+
+1. Both the IPC and the PID namespaces provide IDs to address
+   object inside the kernel. E.g. semaphore with IPCID or
+   process group with pid.
+
+   In both cases, tasks shouldn't try exposing this ID to some
+   other task living in a different namespace via a shared filesystem
+   or IPC shmem/message. The fact is that this ID is only valid
+   within the namespace it was obtained in and may refer to some
+   other object in another namespace.
+
+2. Intentionally, two equal user IDs in different user namespaces
+   should not be equal from the VFS point of view. In other
+   words, user 10 in one user namespace shouldn't have the same
+   access permissions to files, belonging to user 10 in another
+   namespace.
+
+   The same is true for the IPC namespaces being shared - two users
+   from different user namespaces should not access the same IPC objects
+   even having equal UIDs.
+
+   But currently this is not so.
+
