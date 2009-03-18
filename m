Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbZCRTd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbZCRTd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZCRTdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:33:15 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45625 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZCRTdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:33:14 -0400
Date: Wed, 18 Mar 2009 20:35:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT] kbuild
Message-ID: <20090318193511.GA14621@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following issues:

o 'make randconfig' failed to generate random values for choices
  thus letting several build-time bugs slip through the randconfig
  based testing in tip - and likely for others doing builds based
  on randconfig too

  This fix is not a minimal fix - some effort were put into making
  the code more strightforward and a few comments was added in the
  process.

o Use seed for random with a resolution higher than 1 second.
  Now that 'make randconfig' is much faster we can generate more
  than one randconfig on a decent box within one second.

Please pull,
	Sam

The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

Ingo Molnar (1):
      kconfig: improve seed in randconfig

Sam Ravnborg (1):
      kconfig: fix randconfig for choice blocks

Full diff of the two changes:

 scripts/kconfig/conf.c     |   16 +++++++++++++-
 scripts/kconfig/confdata.c |   51 +++++++++++++++++++++++++++++++-------------
 2 files changed, 51 insertions(+), 16 deletions(-)
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 3e1057f..d190092 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -11,6 +11,7 @@
 #include <time.h>
 #include <unistd.h>
 #include <sys/stat.h>
+#include <sys/time.h>
 
 #define LKC_DIRECT_LINK
 #include "lkc.h"
@@ -464,9 +465,22 @@ int main(int ac, char **av)
 			input_mode = set_yes;
 			break;
 		case 'r':
+		{
+			struct timeval now;
+			unsigned int seed;
+
+			/*
+			 * Use microseconds derived seed,
+			 * compensate for systems where it may be zero
+			 */
+			gettimeofday(&now, NULL);
+
+			seed = (unsigned int)((now.tv_sec + 1) * (now.tv_usec + 1));
+			srand(seed);
+
 			input_mode = set_random;
-			srand(time(NULL));
 			break;
+		}
 		case 'h':
 			printf(_("See README for usage info\n"));
 			exit(0);
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 830d9ea..273d738 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -843,7 +843,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 			default:
 				continue;
 			}
-			if (!sym_is_choice(sym) || mode != def_random)
+			if (!(sym_is_choice(sym) && mode == def_random))
 				sym->flags |= SYMBOL_DEF_USER;
 			break;
 		default:
@@ -856,28 +856,49 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 
 	if (mode != def_random)
 		return;
-
+	/*
+	 * We have different type of choice blocks.
+	 * If curr.tri equal to mod then we can select several
+	 * choice symbols in one block.
+	 * In this case we do nothing.
+	 * If curr.tri equal yes then only one symbol can be
+	 * selected in a choice block and we set it to yes,
+	 * and the rest to no.
+	 */
 	for_all_symbols(i, csym) {
 		if (sym_has_value(csym) || !sym_is_choice(csym))
 			continue;
 
 		sym_calc_value(csym);
+
+		if (csym->curr.tri != yes)
+			continue;
+
 		prop = sym_get_choice_prop(csym);
-		def = -1;
-		while (1) {
-			cnt = 0;
-			expr_list_for_each_sym(prop->expr, e, sym) {
-				if (sym->visible == no)
-					continue;
-				if (def == cnt++) {
-					csym->def[S_DEF_USER].val = sym;
-					break;
-				}
+
+		/* count entries in choice block */
+		cnt = 0;
+		expr_list_for_each_sym(prop->expr, e, sym)
+			cnt++;
+
+		/*
+		 * find a random value and set it to yes,
+		 * set the rest to no so we have only one set
+		 */
+		def = (rand() % cnt);
+
+		cnt = 0;
+		expr_list_for_each_sym(prop->expr, e, sym) {
+			if (def == cnt++) {
+				sym->def[S_DEF_USER].tri = yes;
+				csym->def[S_DEF_USER].val = sym;
+			}
+			else {
+				sym->def[S_DEF_USER].tri = no;
 			}
-			if (def >= 0 || cnt < 2)
-				break;
-			def = (rand() % cnt) + 1;
 		}
 		csym->flags |= SYMBOL_DEF_USER;
+		/* clear VALID to get value calculated */
+		csym->flags &= ~(SYMBOL_VALID);
 	}
 }
