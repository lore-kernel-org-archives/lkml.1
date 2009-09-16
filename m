Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZIPFJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZIPFJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 01:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZIPFJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 01:09:00 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33335 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZIPFI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 01:08:59 -0400
Date: Wed, 16 Sep 2009 14:08:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] kallsyms: Fix segfault in prefix_underscores_count().
Message-ID: <20090916050845.GA5805@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I'm not sure who exactly this should go to, so I've attempted to get all of
  the interested parties in the Cc. ]

This is a re-send of a problem that I reported on August 7th, both Sam and Lai
have been unresponsive, so hopefully someone else can take a look at this.

Commit b478b782e110fdb4135caa3062b6d687e989d994 "kallsyms, tracing:
output more proper symbol name" introduces a "bugfix" that introduces
a segfault in kallsyms in my configurations.

The cause is the introduction of prefix_underscores_count() which
attempts to count underscores, even in symbols that do not have them.
As a result, it just uselessly runs past the end of the buffer until it
crashes:

  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
/bin/sh: line 1: 16934 Done                    sh-linux-gnu-nm -n .tmp_vmlinux1
     16935 Segmentation fault      | scripts/kallsyms > .tmp_kallsyms1.S
make: *** [.tmp_kallsyms1.S] Error 139

This adds a strlen iterator that bails out if nothing is found in the
string, which fixes up the observed segfaults.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

I've uploaded a sample problematic symbol list to:

	http://userweb.kernel.org/~lethal/symbol-list.gz

that one can pipe in to scripts/kallsyms to reproduce the fault, incase someone
wants to make a better fix. I'm at a loss as to why no one else has reported
this yet.

 scripts/kallsyms.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 64343cc..f1d44b2 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -584,9 +538,14 @@ static int may_be_linker_script_provide_symbol(const struct sym_entry *se)
 static int prefix_underscores_count(const char *str)
 {
 	const char *tail = str;
+	size_t len = strlen(str);
+
+	while (*tail != '_') {
+		if (!len--)
+			return 0;
 
-	while (*tail != '_')
 		tail++;
+	}
 
 	return tail - str;
 }
