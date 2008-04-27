Return-Path: <linux-kernel-owner+w=401wt.eu-S1764134AbYD0Tkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764134AbYD0Tkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761192AbYD0Tkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:40:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:60846 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbYD0Tkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=NHFGTNj8ap2bxHmEih+Ay72xcYshfZV0KdfbV3hJurzFGM34Orx0yEKvF7yqNUrgjTzhsf27hevSRNdX+omD2LRBlSJLzDoJznIA9T6cW7t/ckQSOyQOSsjO6fqyeJkaxb8zaM4b9VyuymZODKjBF5XS/FD6/5DxBGx2zfRK+vQ=
Date: Sun, 27 Apr 2008 22:40:27 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Pavel Roskin <proski@gnu.org>
Subject: [PATCH 5/5] doc: update mmiotrace doc to current status
Message-ID: <20080427224027.1593edda@daedalus.pq.iki.fi>
In-Reply-To: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
References: <20080427222925.02b2b27b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bfcf6727d3cf8f5411f1927cf7d490428656ec13 Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 27 Apr 2008 21:15:37 +0300
Subject: [PATCH] doc: update mmiotrace doc to current status

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 Documentation/tracers/mmiotrace.txt |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/tracers/mmiotrace.txt
index 84246f7..a4afb56 100644
--- a/Documentation/tracers/mmiotrace.txt
+++ b/Documentation/tracers/mmiotrace.txt
@@ -25,7 +25,8 @@ Mmiotrace feature is compiled in by the CONFIG_MMIOTRACE option. Tracing is
 disabled by default, so it is safe to have this set to yes. SMP systems are
 supported, but tracing is unreliable and may miss events if more than one CPU
 is on-line, therefore mmiotrace takes all but one CPU off-line during run-time
-activation [not implemented].
+activation. You can re-enable CPUs by hand, but you have been warned, there
+is no way to automatically detect if you are losing events due to CPUs racing.
 
 
 Usage Quick Reference
@@ -37,7 +38,7 @@ $ cat /debug/tracing/trace_pipe > mydump.txt &
 Start X or whatever.
 $ echo "X is up" > /debug/tracing/marker
 $ echo none > /debug/tracing/current_tracer
-Check kernel log.
+Check for lost events.
 
 
 Usage
@@ -67,12 +68,22 @@ do.
 
 Shut down mmiotrace (requires root privileges):
 $ echo none > /debug/tracing/current_tracer
-The 'cat' process exits. If it does not, kill it by 'fg' and pressing ctrl+c.
-
-[This feature is not implemented yet!]
-Check your kernel log. If there are messages about mmiotrace losing events,
-this is due to buffer overrun, and the trace is incomplete. You should enlarge
-the buffers and try again. [How?]
+The 'cat' process exits. If it does not, kill it by issuing 'fg' command and
+pressing ctrl+c.
+
+Check that mmiotrace did not lose events due to a buffer filling up. Either
+$ grep -i lost mydump.txt
+which tells you exactly how many events were lost, or use
+$ dmesg
+to view your kernel log and look for "mmiotrace has lost events" warning. If
+events were lost, the trace is incomplete. You should enlarge the buffers and
+try again. Buffers are enlarged by first seeing how large the current buffers
+are:
+$ cat /debug/tracing/trace_entries
+gives you a number. Approximately double this number and write it back, for
+instance:
+$ echo 128000 > /debug/tracing/trace_entries
+Then start again from the top.
 
 If you are doing a trace for a driver project, e.g. Nouveau, you should also
 do the following before sending your results:
-- 
1.5.3.7

