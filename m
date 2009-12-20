Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZLTKFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZLTKFH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 05:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZLTKFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 05:05:05 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:56739 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZLTKFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 05:05:04 -0500
Date: Sun, 20 Dec 2009 11:03:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, Michael Guntsche <mike@it-loops.com>
Cc: Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, mjt@tls.msk.ru
Subject: [PATCH] kbuild: correct size calculation of bzImgae / fix x86 boot
Message-ID: <20091220100344.GA6614@merkur.ravnborg.org>
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091138.GA1793@trillian.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220091138.GA1793@trillian.comsick.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use ... printf \x ... when calculating the size of the
compressed kernel.
Unfortunately dash built-in printf does not support this notation
resulting in a non-bootable kernel.

Fix this by always using the external version of printf.

The commit that introduced this bug was:
4a2ff67c88211026afcbdbc190c13f705dae1b59: "kbuild: fix bzImage
build for x86"

Reported-by: Michael Guntsche <mike@it-loops.com>
Cc: Oliver Hartkopp <oliver@hartkopp.net>
Cc: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

This should fix it but it would be great if it is tested.
Michal Marek, I think this needs to go upstream pretty quickly.

	Sam

 scripts/Makefile.lib |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index cd815ac..bd201d9 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -213,13 +213,14 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
 
 # Bzip2 and LZMA do not include size in file... so we have to fake that;
 # append the size as a 32-bit littleendian number as gzip does.
+# Note: dash built-in printf does not support \x so use /usr/bin version
 size_append = printf $(shell						\
 dec_size=0;								\
 for F in $1; do								\
 	fsize=$$(stat -c "%s" $$F);					\
 	dec_size=$$(expr $$dec_size + $$fsize);				\
 done;									\
-printf "%08x" $$dec_size |						\
+/usr/bin/printf "%08x" $$dec_size |						\
 	sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'	\
 )
 
-- 
1.6.0.6

