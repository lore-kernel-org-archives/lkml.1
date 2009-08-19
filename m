Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZHSDDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZHSDDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZHSDDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:03:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61016 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZHSDAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:00:37 -0400
Message-Id: <20090819030038.113273609@goodmis.org>
References: <20090819025634.987354707@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 18 Aug 2009 22:56:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 08/14] kconfig: have extract-ikconfig read ELF files
Content-Disposition: inline; filename=0008-kconfig-have-extract-ikconfig-read-ELF-files.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

It would be nice to use extract-ikconfig to find the congfig.gz
in either vmlinux (not vmlinuz) or configs.ko.

This patch changes the script to also be able to read ELF files directly.

[ Impact: find config.gz in vmlinux and configs.ko ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/extract-ikconfig |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/scripts/extract-ikconfig b/scripts/extract-ikconfig
index 42d6bce..de233ff 100755
--- a/scripts/extract-ikconfig
+++ b/scripts/extract-ikconfig
@@ -59,6 +59,8 @@ dump_config "$image"
 GZHDR1="0x1f 0x8b 0x08 0x00"
 GZHDR2="0x1f 0x8b 0x08 0x08"
 
+ELFHDR="0x7f 0x45 0x4c 0x46"
+
 # vmlinux.gz: Check for a compressed images
 off=`$binoffset "$image" $GZHDR1 2>/dev/null`
 [ "$?" != "0" ] && off="-1"
@@ -73,6 +75,14 @@ elif [ "$off" -ne "-1" ]; then
 	(dd ibs="$off" skip=1 count=0 && dd bs=512k) <"$image" 2>/dev/null | \
 		zcat >"$TMPFILE"
 	dump_config "$TMPFILE"
+
+# check if this is simply an ELF file
+else
+	off=`$binoffset "$image" $ELFHDR 2>/dev/null`
+	[ "$?" != "0" ] && off="-1"
+	if [ "$off" -eq "0" ]; then
+		dump_config "$image"
+	fi
 fi
 
 echo "ERROR: Unable to extract kernel configuration information."
-- 
1.6.3.3

-- 
