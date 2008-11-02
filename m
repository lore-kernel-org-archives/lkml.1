Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYKBVS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYKBVS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYKBVSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:18:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:41743 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbYKBVST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:18:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=qdcIRgcrIfh8OiUf04kpG5p15d5tTwRQWuQBrwqrDdgBOLTK5bZhH4by1i8QTCkK5f
         hd0u/Vz7aoXpZnUB4I2qooZwktAMyUeivZ1tA4jHxi5a5R0J1KOT1eVVbQJBjfpOJuqF
         p/KAkbcQNa2swZBatyuYKzKPfaqABqnIIr2tA=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu
Cc: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, edwintorok@gmail.com
Subject: Add support for userspace stacktraces in tracing/iter_ctrl [v2]
Date: Sun,  2 Nov 2008 23:18:12 +0200
Message-Id: <1225660694-19765-1-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series adds support for userstack tracing to ftrace.
I've tested it on x86_64.

Example usage:
mount -t debugfs nodev /sys/kernel/debug
cd /sys/kernel/debug/tracing
echo userstacktrace >iter_ctrl
echo sym-userobj >iter_ctrl
echo sched_switch >current_tracer
echo 1 >tracing_enabled
cat trace_pipe >/tmp/trace&
.... run application ...
echo 0 >tracing_enabled
cat /tmp/trace

		a.out-1623  [000] 40874.465068: /root/a.out[+0x480] <-/root/a.out[+0
+x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]

If you just want the addresses don't use sym-userobj, but you should resolve the
address to an object before the process exits, otherwise you can't know which
object it belonged to, due to Address Space Layout Randomization (for libraries
at least).

To get meaningful results you'll need your app and
libs compiled with frame-pointers. This usually means rebuilding libc with
frame-pointers (your own app should have frame pointers by default, unless you
used -fomit-frame-pointer).

Another approach would be to use dwarf unwind info that works without frame
pointers (as userspace does it). There was a kernel/unwind.c around 2.6.19, but
it got removed, so I didn't look further at this possibility.

 arch/x86/kernel/stacktrace.c |   57 +++++++++++++++++
 Documentation/ftrace.txt   |   16 ++++
 kernel/trace/trace.c       |  142 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h       |   10 +++
 include/linux/stacktrace.h   |    8 ++
