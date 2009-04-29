Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbZD2LHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbZD2LHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760159AbZD2LHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:07:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:49895 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760160AbZD2LG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:06:58 -0400
Date: Wed, 29 Apr 2009 11:05:13 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090429105056.GA28720@uranus.ravnborg.org>
References: <20090429105056.GA28720@uranus.ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: fix relocatable symbols
Message-ID: <tip-fd0731944333db6e9e91b6954c6ef95f4b71ab04@git.kernel.org>
Git-Commit-ID: fd0731944333db6e9e91b6954c6ef95f4b71ab04
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 11:05:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd0731944333db6e9e91b6954c6ef95f4b71ab04
Gitweb:     http://git.kernel.org/tip/fd0731944333db6e9e91b6954c6ef95f4b71ab04
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 29 Apr 2009 12:56:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 13:01:18 +0200

x86, vmlinux.lds: fix relocatable symbols

__init_begin/_end symbols should be inside sections as well,
otherwise the relocatable kernel gets confused when freeing
init sections in the wrong place.

[ Impact: fix bootup crash ]

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20090429105056.GA28720@uranus.ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0bdbaa5..4c85b2e 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -255,8 +255,8 @@ SECTIONS
 
 	/* Init code and data - will be freed after init */
 	. = ALIGN(PAGE_SIZE);
-	__init_begin = .; /* paired with __init_end */
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
+		__init_begin = .; /* paired with __init_end */
 		_sinittext = .;
 		INIT_TEXT
 		_einittext = .;
@@ -346,8 +346,11 @@ SECTIONS
 #endif
 
 	. = ALIGN(PAGE_SIZE);
+
 	/* freed after init ends here */
-	__init_end = .;
+	.init.end : AT(ADDR(.init.end) - LOAD_OFFSET) {
+		__init_end = .;
+	}
 
 #ifdef CONFIG_X86_64
 	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
