Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZBTQuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZBTQuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZBTQuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:50:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:50915 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbZBTQuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=kQvQk1zHrTIzheUU33oOkiCBvKuzARBFJLtXGMMrewUC6fGuHi8Bx8QiuuMkdC9F/J
         aKrv+5xRCYzRdeDmbaGdME6K5C3V8Sewc0iTu3Fr5vMfeqXOrl+iST+0aTp8WGFXadWl
         iq47quxN6Ks/0OjNEhzZc/itXofoKmtMc2SUw=
Message-ID: <499edf47.1818d00a.060b.2b8d@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Date: Fri, 20 Feb 2009 17:34:06 +0100
Subject: [PATCH] tracing/markers: make markers select tracepoints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it happens that KConfig dependencies are not handled
like in the following scenario:

- config A
   bool

- config B
   bool
   depends on A

-config C
   bool
   select B

If one selects C, then it will select B without checking its dependency to A, if A
hasn't been selected elsewhere, it will result in a build crash.

This is what happens on the following build error:

kernel/built-in.o: In function `marker_update_probe_range':
(.text+0x52f64): undefined reference to `tracepoint_probe_register_noupdate'
kernel/built-in.o: In function `marker_update_probe_range':
(.text+0x52f74): undefined reference to `tracepoint_probe_unregister_noupdate'
kernel/built-in.o: In function `marker_update_probe_range':
(.text+0x52fb9): undefined reference to `tracepoint_probe_unregister_noupdate'
kernel/built-in.o: In function `marker_update_probes':
marker.c:(.text+0x530ba): undefined reference to `tracepoint_probe_update_all'

CONFIG_KVM_TRACE will select CONFIG_MARKER, but the latter depends on CONFIG_TRACEPOINTS
which will not be selected.

A temporary fix is to make CONFIG_MARKER select CONFIG_TRACEPOINTS, though it doesn't
fix the source KConfig dependency handling problem.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index b6400a5..a93f957 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -975,7 +975,7 @@ config TRACEPOINTS
 
 config MARKERS
 	bool "Activate markers"
-	depends on TRACEPOINTS
+	select TRACEPOINTS
 	help
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
-- 
1.6.1


