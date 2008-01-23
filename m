Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYAWRkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYAWRkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbYAWRi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:38:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291AbYAWRiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:38:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qWUEsJON4kaYYk5D6jFdajbEd4DcDIXoTGW3RWrBew3TikRWkqz141O0OR6pr4x2hP4Q/0kfXGsRsYtM6n82FsF46kIxOxr8qqDpBOWASBpD5FsZSKB5Cy/jQE4RSGHZshbUztBaRf0zj813/w0946ij//n2WL3lcxBohndzlgg=
Date: Wed, 23 Jan 2008 20:38:32 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/6] POWERPC: use KSYM_NAME_LEN
Message-ID: <20080123173832.GA12877@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use KSYM_NAME_LEN instead of numeric value.
Actually because of too small 'tmp' there is
a potential buffer overflow.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/powerpc/xmon/xmon.c
===================================================================
--- linux-2.6.git.orig/arch/powerpc/xmon/xmon.c	2008-01-23 19:04:42.000000000 +0300
+++ linux-2.6.git/arch/powerpc/xmon/xmon.c	2008-01-23 19:12:45.000000000 +0300
@@ -69,7 +69,7 @@ static unsigned long ndump = 64;
 static unsigned long nidump = 16;
 static unsigned long ncsum = 4096;
 static int termch;
-static char tmpstr[128];
+static char tmpstr[KSYM_NAME_LEN];
 
 #define JMP_BUF_LEN	23
 static long bus_error_jmp[JMP_BUF_LEN];
@@ -2354,7 +2354,7 @@ scanhex(unsigned long *vp)
 		}
 	} else if (c == '$') {
 		int i;
-		for (i=0; i<63; i++) {
+		for (i = 0; i < sizeof(tmpstr) / 2; i++) {
 			c = inchar();
 			if (isspace(c)) {
 				termch = c;
@@ -2467,7 +2467,7 @@ symbol_lookup(void)
 {
 	int type = inchar();
 	unsigned long addr;
-	static char tmp[64];
+	static char tmp[KSYM_NAME_LEN];
 
 	switch (type) {
 	case 'a':
@@ -2476,7 +2476,7 @@ symbol_lookup(void)
 		termch = 0;
 		break;
 	case 's':
-		getstring(tmp, 64);
+		getstring(tmp, sizeof(tmp));
 		if (setjmp(bus_error_jmp) == 0) {
 			catch_memory_errors = 1;
 			sync();
