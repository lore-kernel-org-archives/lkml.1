Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815Ab0A0UYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0A0UYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690Ab0A0UYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:24:47 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35046 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab0A0UYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:24:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=b7IvmNMmKveqaV/qc1bzajZKJzfdyTl30rZTmRfChy9Qzr3izqdGJj/zBOlyfAaXQn
         X3S2hMPleYraTEamQip9t53xXLn0aW5Wq9y6xn6hX9AlzuglciRw+PhUbwXS5+h3g6o/
         U/6C5hUofj5PxBtnAsee0jHnO8T9Ln0cDSA0A=
From: John Kacur <jkacur@redhat.com>
To: Clark Williams <williams@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Carsten Emde <C.Emde@osadl.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 5/5] rt-tests: Automatically generate dependencies.
Date: Wed, 27 Jan 2010 21:24:28 +0100
Message-Id: <1264623868-23595-6-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264623868-23595-1-git-send-email-jkacur@redhat.com>
References: <1264623868-23595-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automatically generate dependencies. This will tell the make file that
cyclictest is dependent on rt_numa.h for example, and that if a change
is made there, then cyclictest needs to be remade.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 Makefile |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 6156c03..4be0838 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,10 @@
 VERSION_STRING = 0.63
 
-TARGETS	= cyclictest signaltest pi_stress \
-	  rt-migrate-test ptsematest sigwaittest svsematest \
-	  sendme pip
+sources = cyclictest.c signaltest.c pi_stress.c rt-migrate-test.c	\
+	  ptsematest.c sigwaittest.c svsematest.c sendme.c pip.c
+
+TARGETS = $(sources:.c=)
+
 LIBS 	= -lrt -lpthread
 EXTRA_LIBS ?= -ldl	# for get_cpu
 DESTDIR	?=
@@ -39,9 +41,19 @@ VPATH	+= src/lib
 %.o: %.c
 	$(CC) -D VERSION_STRING=$(VERSION_STRING) -c $< $(CFLAGS)
 
+# Pattern rule to generate dependency files from .c files
+%.d: %.c
+	@set -e; rm -f $@; \
+	$(CC) -MM $(CFLAGS) $< > $@.$$$$; \
+	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
+	rm -f $@.$$$$
+
 .PHONY: all
 all: $(TARGETS) hwlatdetect
 
+# Include dependency files, automatically generate them if needed.
+-include $(sources:.c=.d)
+
 cyclictest: cyclictest.o rt-utils.o
 	$(CC) $(CFLAGS) -o $@ $^ $(LIBS) $(NUMA_LIBS)
 
@@ -73,7 +85,7 @@ sendme: sendme.o rt-utils.o rt-get_cpu.o
 pip: pip.o error.o rt-utils.o
 	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)
 
-CLEANUP  = $(TARGETS) *.o .depend *.*~ *.orig *.rej rt-tests.spec
+CLEANUP  = $(TARGETS) *.o .depend *.*~ *.orig *.rej rt-tests.spec *.d
 CLEANUP += $(if $(wildcard .git), ChangeLog)
 
 .PHONY: clean
-- 
1.6.6

