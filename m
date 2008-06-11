Return-Path: <linux-kernel-owner+w=401wt.eu-S1759775AbYFKUbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775AbYFKUbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbYFKUax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:30:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45671 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316AbYFKUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:30:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=cRkrAVwjrnfL20NpAJM6mbhTjLWBWymRvIL4dEZFK7YYFTJOGD9hRuxHMRgfYl+cR
	ra/cu+ms4KvDauXxcxGSA==
Message-ID: <485035E7.3000103@google.com>
Date: Wed, 11 Jun 2008 13:30:31 -0700
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080502)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] Fix 32-bit truncation of segment sizes in /proc/sysvipc/shm
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysvipc_shm_proc_show() picks between format strings (based on the
expected maximum length of a SHM segment) in a way that prevents 
gcc from performing format checks on the seq_printf() parameters. This
hid two format errors - shp->shm_segsz and shp->shm_nattach are both
unsigned long, but were being printed as unsigned int and signed int
respectively. This leads to 32-bit truncation of SHM segment sizes 
reported in /proc/sysvipc/shm. (And for nattach, but that's less of a
problem for most users).

This patch makes the format string directly visible to gcc's format
specifier checker, and fixes the two broken format specifiers.

Signed-off-by: Paul Menage <menage@google.com>

---


 ipc/shm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: shm-2.6.26-rc5-mm2/ipc/shm.c
===================================================================
--- shm-2.6.26-rc5-mm2.orig/ipc/shm.c
+++ shm-2.6.26-rc5-mm2/ipc/shm.c
@@ -1062,16 +1062,16 @@ asmlinkage long sys_shmdt(char __user *s
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it)
 {
 	struct shmid_kernel *shp = it;
-	char *format;
 
-#define SMALL_STRING "%10d %10d  %4o %10u %5u %5u  %5d %5u %5u %5u %5u %10lu %10lu %10lu\n"
-#define BIG_STRING   "%10d %10d  %4o %21u %5u %5u  %5d %5u %5u %5u %5u %10lu %10lu %10lu\n"
+#if BITS_PER_LONG <= 32
+#define SIZE_SPEC "%10lu"
+#else
+#define SIZE_SPEC "%21lu"
+#endif
 
-	if (sizeof(size_t) <= sizeof(int))
-		format = SMALL_STRING;
-	else
-		format = BIG_STRING;
-	return seq_printf(s, format,
+	return seq_printf(s,
+			  "%10d %10d  %4o " SIZE_SPEC " %5u %5u  "
+			  "%5lu %5u %5u %5u %5u %10lu %10lu %10lu\n",
 			  shp->shm_perm.key,
 			  shp->shm_perm.id,
 			  shp->shm_perm.mode,
