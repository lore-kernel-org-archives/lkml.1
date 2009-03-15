Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbZCOWBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbZCOWBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 18:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbZCOWBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 18:01:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59013 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbZCOWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 18:01:32 -0400
Date: Sun, 15 Mar 2009 23:03:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 2/2] kconfig: improve seed in randconfig
Message-ID: <20090315220328.GA10923@uranus.ravnborg.org>
References: <20090315102341.GA6051@uranus.ravnborg.org> <20090315102856.GB6292@uranus.ravnborg.org> <10f740e80903150353i233d0da5rabde6e97607e3435@mail.gmail.com> <20090315130930.GA7146@uranus.ravnborg.org> <20090315185406.GA19737@elte.hu> <1237153649.32747.1305532855@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1237153649.32747.1305532855@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> >          seed = (unsigned int)((now.tv_sec+1)*(now.tv_usec+1));
> > 
> > ought to settle any practical doubts.
> 
> Or maybe (and I think better...)
> 
>     seed = (unsigned int)(now.tv_sec ^ now.tv_usec);

Maybe better - but the one suggested by Ingo is more intuitive,
and is what I implmented already.

I have pushed out the following patch.

[And I know it breaks the 80 char limit].

	Sam

commit b0fe551000179c868d46266278a890eab878baca
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Mar 12 15:15:31 2009 +0100

    kconfig: improve seed in randconfig
    
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
    Cc: Roman Zippel <zippel@linux-m68k.org>
    [sam: fix for systems where usec is zero - noticed by Geert Uytterhoeven]
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

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
