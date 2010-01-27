Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493Ab0A0LS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0A0LS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304Ab0A0LS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:18:57 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:42246 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0A0LS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:18:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ScVYYUbzvUcZX3B7TmJGJhMGJ3zlpHAVYYXWnwZU4NcU9nK4dFbNDjaDFR9w+JaMxB
         0mauTMWHZBbT30DXPrOLBoRk7n+jb5r4v4sUAS96E/E2aJlE8U6RK5WlBkYkJoSWDoWq
         gBc2oza4hiybVyKT5htAz8FsZ/1KIVp9g17Yg=
MIME-Version: 1.0
Date: Wed, 27 Jan 2010 19:18:55 +0800
Message-ID: <a0e7fce51001270318q6f16aea1j765849bb09df8640@mail.gmail.com>
Subject: [PATCH] cyclictest: Set tracing_thresh optionally
From: yi li <liyi.dev@gmail.com>
To: williams@redhat.com, tglx@linutronix.de
Cc: LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In cyclictest, by default "tracing_thresh" will be set to "tracelimit"
(given to cyclictest with option "-b tracelimit").
If the maximum latency of the tracer currently used is less than
"tracelimit", no trace will be recorded.

e.g:
./cyclictest -p 80 -t 1 -n -l 10000 -i 10000 -b 8000 -I -f
If the "irqsoff" maximum latency is less than 8000,
"/sys/kernel/debug/tracing/trace" will no contain valid "irqsoff"
trace.

This is not expected sometimes if e.g, the maximum latency of
cyclictest is caused by wakeup, but I want to see the irqsoff latency.
So I think it may be better to allow user set "tracing_thresh"
optionally, by adding a "--tracing_thresh=THRESH" option.

Here is a simple patch to show the idea:

Signed-off-by: yi.li@analog.com

diff --git a/src/cyclictest/cyclictest.c b/src/cyclictest/cyclictest.c
index ce4d911..c2f1c07 100644
--- a/src/cyclictest/cyclictest.c
+++ b/src/cyclictest/cyclictest.c
@@ -144,6 +144,7 @@ struct thread_stat {

 static int shutdown;
 static int tracelimit = 0;
+static int tracing_thresh = 0;
 static int ftrace = 0;
 static int kernelversion;
 static int verbose = 0;
@@ -384,9 +385,11 @@ static void setup_tracer(void)
 	if (kernelversion == KV_26_CURR) {
 		char buffer[32];
 		int ret;
-
-		sprintf(buffer, "%d", tracelimit);
-		setkernvar("tracing_thresh", buffer);
+		
+		if (tracing_thresh > 0 && tracing_thresh <= tracelimit) {
+			sprintf(buffer, "%d", tracing_thresh);
+			setkernvar("tracing_thresh", buffer);
+		}

 		/* ftrace_enabled is a sysctl variable */
 		fileprefix = procfileprefix;
@@ -766,6 +769,7 @@ static void display_help(int error)
 	       "                           without -t default = 1\n"
 	       "-T TRACE --tracer=TRACER   set tracing function\n"
 	       "    configured tracers: %s\n"
+	       "--tracing_thresh=THRESH    set tracing_thresh of current
tracer to THRESH\n"
 	       "-u       --unbuffered      force unbuffered output for live
processing\n"
 	       "-v       --verbose         output values on stdout for statistics\n"
 	       "                           format: n:c:v n=tasknum c=count
v=value in us\n"
@@ -896,6 +900,7 @@ static void process_options (int argc, char *argv[])
 			{"help", no_argument, NULL, '?'},
 			{"tracer", required_argument, NULL, 'T'},
 			{"traceopt", required_argument, NULL, 'O'},
+			{"tracing_thresh", required_argument, NULL, 1},
 			{"smp", no_argument, NULL, 'S'},
 			{NULL, 0, NULL, 0}
 		};
@@ -972,6 +977,7 @@ static void process_options (int argc, char *argv[])
 			use_nanosleep = MODE_CLOCK_NANOSLEEP;
 			break;
 		case '?': display_help(0); break;
+		case 1 : tracing_thresh = atoi(optarg); break;
 		}
 	}
