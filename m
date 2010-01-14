Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009Ab0ANUa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0ANUa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932321Ab0ANUaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:30:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:57692 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab0ANUaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:30:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perf symbols: Don't try to load kallsyms if doesn't match the record build-id
Date: Thu, 14 Jan 2010 18:30:05 -0200
Message-Id: <1263501006-14185-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263501006-14185-1-git-send-email-acme@infradead.org>
References: <1263501006-14185-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now a perf.data file collected on a x86_64 fedora 12 machine gets properly
parsed on a Debian testing PARISC64 machine with 32-bit userland:

  acme@parisc:~/git/linux-2.6-tip$ perf report 2> /dev/null | head -15
  # Samples: 293085637
  #
  # Overhead          Command                      Shared Object  Symbol
  # ........  ...............  .................................  ......
  #
      35.11%             find  [kernel.kallsyms]                  [k] 0xffffffff81002b5a
      18.25%             perf  [kernel.kallsyms]                  [k] 0xffffffff8102235f
       9.07%             find  find                               [.] 0x0000000000fb0e
       5.80%          swapper  [kernel.kallsyms]                  [k] 0xffffffff8102235f
       3.29%             perf  libc-2.10.2.so                     [.] __GI_strcmp
       2.70%             find  libc-2.10.2.so                     [.] __GI_memmove
       2.33%             init  [kernel.kallsyms]                  [k] 0xffffffff810091b9
       2.03%             find  libc-2.10.2.so                     [.] _int_malloc
       1.67%             find  libc-2.10.2.so                     [.] _IO_vfprintf_internal
       1.65%             sshd  libcrypto.so.0.9.8k                [.] 0x00000000105440
  acme@parisc:~/git/linux-2.6-tip$

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 381999d..71d23e1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1608,11 +1608,11 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 		u8 kallsyms_build_id[BUILD_ID_SIZE];
 
 		if (sysfs__read_build_id("/sys/kernel/notes", kallsyms_build_id,
-					 sizeof(kallsyms_build_id)) == 0)
-
-		is_kallsyms = dso__build_id_equal(self, kallsyms_build_id);
-		if (is_kallsyms)
-			goto do_kallsyms;
+					 sizeof(kallsyms_build_id)) == 0) {
+			is_kallsyms = dso__build_id_equal(self, kallsyms_build_id);
+			if (is_kallsyms)
+				goto do_kallsyms;
+		}
 		goto do_vmlinux;
 	}
 
@@ -1623,6 +1623,9 @@ static int dso__load_kernel_sym(struct dso *self, struct map *map,
 do_vmlinux:
 	err = dso__load_vmlinux(self, map, session, self->long_name, filter);
 	if (err <= 0) {
+		if (self->has_build_id)
+			return -1;
+
 		pr_info("The file %s cannot be used, "
 			"trying to use /proc/kallsyms...", self->long_name);
 do_kallsyms:
-- 
1.6.2.5

