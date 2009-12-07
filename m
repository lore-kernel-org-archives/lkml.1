Return-Path: <linux-kernel-owner+w=401wt.eu-S934444AbZLGClu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934444AbZLGClu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 21:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934341AbZLGClt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 21:41:49 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38002 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934331AbZLGCls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 21:41:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SF+c+iR9LKdEr9w408w1Q4zibYtMyQcSJL4Ed8pQhaX6hFvA1VwI7cwnc+BzhdMDEn
         t4xMtRxClE6MxWtxjGHjbjhuYUah5CPpmMHNqq/SXLN5fh5D9HtQwM+O/W6DYKS/OiQ7
         zQORc3IQl64OzupYm37baUsuLICxyeVF2fKj8=
Subject: Re: perf DEBUG=1 build fails due to perl bindings
From: Tom Zanussi <tzanussi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091206134203.GA4337@ghostprotocols.net>
References: <20091206134203.GA4337@ghostprotocols.net>
Content-Type: text/plain
Date: Sun, 06 Dec 2009 20:41:52 -0600
Message-Id: <1260153712.6564.4.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 11:42 -0200, Arnaldo Carvalho de Melo wrote:
> [acme@ana linux-2.6-tip]$ make DEBUG=1 -j3 -C tools/perf/ install
> make: Entering directory `/home/acme/git/linux-2.6-tip/tools/perf'
>     LINK perf
> libperf.a(trace-event-perl.o): In function `xs_init':
> /home/acme/git/linux-2.6-tip/tools/perf/util/trace-event-perl.c:43: undefined reference to `boot_Perf__Trace__Context'
> /home/acme/git/linux-2.6-tip/tools/perf/util/trace-event-perl.c:45: undefined reference to `boot_DynaLoader'
> collect2: ld returned 1 exit status
> make: *** [perf] Error 1
> make: Leaving directory `/home/acme/git/linux-2.6-tip/tools/perf'
> [acme@ana linux-2.6-tip]$

Hi,

This patch should fix it.

Thanks,

Tom

[PATCH] perf trace/scripting: Fix compile err when libperl not installed

When I added the xs callbacks into perf, I forgot to re-check the
no-libperl case.  This patch fixes the undefined reference error for
that.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-perl.c |    3 ---
 tools/perf/util/trace-event-perl.h |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 51e833f..59564b2 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -32,9 +32,6 @@
 
 void xs_init(pTHX);
 
-void boot_Perf__Trace__Context(pTHX_ CV *cv);
-void boot_DynaLoader(pTHX_ CV *cv);
-
 void xs_init(pTHX)
 {
 	const char *file = __FILE__;
diff --git a/tools/perf/util/trace-event-perl.h b/tools/perf/util/trace-event-perl.h
index 8fe0d86..e88fb26 100644
--- a/tools/perf/util/trace-event-perl.h
+++ b/tools/perf/util/trace-event-perl.h
@@ -34,9 +34,13 @@ typedef int INTERP;
 #define dXSUB_SYS
 #define pTHX_
 static inline void newXS(const char *a, void *b, const char *c) {}
+static void boot_Perf__Trace__Context(pTHX_ CV *cv) {}
+static void boot_DynaLoader(pTHX_ CV *cv) {}
 #else
 #include <EXTERN.h>
 #include <perl.h>
+void boot_Perf__Trace__Context(pTHX_ CV *cv);
+void boot_DynaLoader(pTHX_ CV *cv);
 typedef PerlInterpreter * INTERP;
 #endif
 
-- 
1.6.4.GIT



