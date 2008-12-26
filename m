Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbYLZNof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbYLZNof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 08:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYLZNo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 08:44:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbYLZNoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 08:44:24 -0500
Date: Fri, 26 Dec 2008 14:42:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Yinghai Lu <yinghai@kernel.org>, David Howells <dhowells@redhat.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: [PATCH] kbuild, sparseirq: work around GCC bug with __weak aliases
Message-ID: <20081226134218.GA1054@elte.hu>
References: <20081219134636.GA11772@linux.vnet.ibm.com> <494C0BF0.3080109@kernel.org> <20081223132127.GA5450@linux.vnet.ibm.com> <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org> <20081226133354.GC29265@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081226133354.GC29265@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > I recall David Howells had a similar issue with the bootparamter patch 
> > set. The workaround he used was to add a barrier(); call in the weak 
> > function to avoid the inline.
> 
> could we add some extra attribute to __weak that would have a similar 
> effect? Something like __attribute__((noinline)), or something silly 
> like __attribute__((deprecated)) - just to keep gcc from screwing up 
> __weak functions? Perhaps adding a section attribute would have a 
> similar effect? (putting weak definitions into an extra section is 
> probably helpful anyway)

I've applied the patch below to tip/irq/sparseirq - could someone with an 
affected GCC version please check whether this solves the crash?

	Ingo

------------------->
>From 0d41e654c877a0de441448ca2f63a72ed11c5d84 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 26 Dec 2008 14:39:51 +0100
Subject: [PATCH] kbuild, sparseirq: work around GCC bug with __weak aliases

Impact: fix panic on null pointer with sparseirq

Certain versions of GCC inline the weak global functions.
Work it around by marking __weak functions as noinline.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/compiler-gcc.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 5c8351b..1ad72e6 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -41,11 +41,17 @@
 
 #define __deprecated			__attribute__((deprecated))
 #define __packed			__attribute__((packed))
-#define __weak				__attribute__((weak))
 #define __naked				__attribute__((naked))
 #define __noreturn			__attribute__((noreturn))
 
 /*
+ * Mark weak aliases also noinline, because some GCC versions
+ * incorrectly inline weak aliases (even when a non-weak variant
+ * is there) and thus cause crashes:
+ */
+#define __weak				__attribute__((weak)) noinline
+
+/*
  * From the GCC manual:
  *
  * Many functions have no effects except the return value and their
