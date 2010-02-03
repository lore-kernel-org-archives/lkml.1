Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0BCSwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:52:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:53439 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab0BCSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:52:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/9] perf symbols: Fixup vsyscall maps
Date: Wed,  3 Feb 2010 16:52:01 -0200
Message-Id: <1265223128-11786-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1265223128-11786-1-git-send-email-acme@infradead.org>
References: <1265223128-11786-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

While debugging a problem reported by Pekka Enberg by printing the IP
and all the maps for a thread when we don't find a map for an IP I
noticed that dso__load_sym needs to fixup these extra maps it creates to
hold symbols in different ELF sections than the main kernel one.

Now we're back showing things like:

[root@doppio linux-2.6-tip]# perf report | grep vsyscall
     0.02%             mutt  [kernel.kallsyms].vsyscall_fn  [.] vread_hpet
     0.01%            named  [kernel.kallsyms].vsyscall_fn  [.] vread_hpet
     0.01%   NetworkManager  [kernel.kallsyms].vsyscall_fn  [.] vread_hpet
     0.01%         gconfd-2  [kernel.kallsyms].vsyscall_0   [.] vgettimeofday
     0.01%  hald-addon-rfki  [kernel.kallsyms].vsyscall_fn  [.] vread_hpet
     0.00%      dbus-daemon  [kernel.kallsyms].vsyscall_fn  [.] vread_hpet
[root@doppio linux-2.6-tip]#

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 6138742..051d71b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1011,7 +1011,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				if (curr_dso == NULL)
 					goto out_elf_end;
 				curr_map = map__new2(start, curr_dso,
-						     MAP__FUNCTION);
+						     map->type);
 				if (curr_map == NULL) {
 					dso__delete(curr_dso);
 					goto out_elf_end;
@@ -1021,6 +1021,7 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 				curr_dso->origin = DSO__ORIG_KERNEL;
 				map_groups__insert(kmap->kmaps, curr_map);
 				dsos__add(&dsos__kernel, curr_dso);
+				dso__set_loaded(curr_dso, map->type);
 			} else
 				curr_dso = curr_map->dso;
 
@@ -1058,8 +1059,16 @@ new_symbol:
 	/*
 	 * For misannotated, zeroed, ASM function sizes.
 	 */
-	if (nr > 0)
+	if (nr > 0) {
 		symbols__fixup_end(&self->symbols[map->type]);
+		if (kmap) {
+			/*
+			 * We need to fixup this here too because we create new
+			 * maps here, for things like vsyscall sections.
+			 */
+			__map_groups__fixup_end(kmap->kmaps, map->type);
+		}
+	}
 	err = nr;
 out_elf_end:
 	elf_end(elf);
-- 
1.6.2.5

