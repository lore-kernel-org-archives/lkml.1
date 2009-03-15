Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbZCOK1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbZCOK1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbZCOK07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:26:59 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38818 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503AbZCOK06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:26:58 -0400
Date: Sun, 15 Mar 2009 11:28:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] kconfig: improve seed in randconfig
Message-ID: <20090315102856.GB6292@uranus.ravnborg.org>
References: <20090315102341.GA6051@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315102341.GA6051@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'make randconfig' uses glibc's rand function, and the seed of
that PRNG is set via:

			srand(time(NULL));

But 'time()' only increases once every second - freezing the
randconfig result within a single second.

My Nehalem testbox does randconfig much faster than 1 second
 and i have a few scripts that do 'randconfig until condition X'
loops.

Those scripts currently waste a lot of CPU time due to randconfig
changing its seed only once per second currently.

Change the seed to be micrseconds based. (I checked the statistical
spread of the seed - the now.tv_sec*now.tv_usec multiplication
there further improves it.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/conf.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 3e1057f..4f1b488 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -11,6 +11,7 @@
 #include <time.h>
 #include <unistd.h>
 #include <sys/stat.h>
+#include <sys/time.h>
 
 #define LKC_DIRECT_LINK
 #include "lkc.h"
@@ -464,9 +465,21 @@ int main(int ac, char **av)
 			input_mode = set_yes;
 			break;
 		case 'r':
+		{
+			struct timeval now;
+			unsigned int seed;
+
+			/*
+			 * Use microseconds derived seed:
+			 */
+			gettimeofday(&now, NULL);
+
+			seed = (unsigned int)(now.tv_sec*now.tv_usec);
+			srand(seed);
+
 			input_mode = set_random;
-			srand(time(NULL));
 			break;
+		}
 		case 'h':
 			printf(_("See README for usage info\n"));
 			exit(0);
-- 
1.6.0.2.GIT

