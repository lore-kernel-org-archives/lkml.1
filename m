Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbYHKH1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbYHKH1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 03:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYHKH04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 03:26:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYHKH04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 03:26:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: powerpc/cell/oprofile: avoid double free of profile buffer
Date: Mon, 11 Aug 2008 09:25:43 +0200
User-Agent: KMail/1.9.9
Cc: cbe-oss-dev@ozlabs.org, Robert Richter <robert.richter@amd.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>,
       cel <cel@linux.vnet.ibm.com>
References: <1217620879.15667.145.camel@carll-linux-desktop> <18591.30474.127939.243247@cargo.ozlabs.ibm.com> <200808110918.57293.arnd@arndb.de>
In-Reply-To: <200808110918.57293.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808110925.44243.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18uo2qDGH/A6J7fBE6CgPNC1g/1YYy9vzlMrup
 Lrof6BC1AxteSDBfGk8wfoqfKBkc/NHUO4JC9uvI8fiiw2tETn
 9Lllvj+ZLomK5w5/NsBhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carl Love <cel@us.ibm.com>

If an error occurs on opcontrol start, the event and per cpu buffers
are released.  If later opcontrol shutdown is called then the free
function will be called again to free buffers that no longer
exist.  This results in a kernel oops.  The following changes
prevent the call to delete buffers that don't exist.

Signed-off-by: Carl Love <carll@us.ibm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/oprofile/cpu_buffer.c   |    4 +++-
 drivers/oprofile/event_buffer.c |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index b8601dc..366b5d2 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -38,8 +38,10 @@ void free_cpu_buffers(void)
 {
 	int i;
 
-	for_each_online_cpu(i)
+	for_each_online_cpu(i) {
 		vfree(per_cpu(cpu_buffer, i).buffer);
+		per_cpu(cpu_buffer, i).buffer = NULL;
+	}
 }
 
 unsigned long oprofile_get_cpu_buffer_size(void)
diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index e7fbac5..8d692a5 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -93,6 +93,8 @@ out:
 void free_event_buffer(void)
 {
 	vfree(event_buffer);
+
+	event_buffer = NULL;
 }
 
  
-- 
1.5.4.3


