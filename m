Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZJBBch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZJBBch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbZJBBcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:36 -0400
Received: from kroah.org ([198.145.64.141]:32915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbZJBBcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:07 2009
Message-Id: <20091002012407.846950905@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mundt <lethal@linux-sh.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Sam Ravnborg <sam@ravnborg.org>, Paulo Marques <pmarques@grupopie.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [014/136] kallsyms: fix segfault in prefix_underscores_count()
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=kallsyms-fix-segfault-in-prefix_underscores_count.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Paul Mundt <lethal@linux-sh.org>

commit a9ece53c4089ef23d4002d34c4c7148d94622a40 upstream.

Commit b478b782e110fdb4135caa3062b6d687e989d994 "kallsyms, tracing: output
more proper symbol name" introduces a "bugfix" that introduces a segfault
in kallsyms in my configurations.

The cause is the introduction of prefix_underscores_count() which attempts
to count underscores, even in symbols that do not have them.  As a result,
it just uselessly runs past the end of the buffer until it crashes:

  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
/bin/sh: line 1: 16934 Done                    sh-linux-gnu-nm -n .tmp_vmlinux1
     16935 Segmentation fault      | scripts/kallsyms > .tmp_kallsyms1.S
make: *** [.tmp_kallsyms1.S] Error 139

This simplifies the logic and just does a straightforward count.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Paulo Marques <pmarques@grupopie.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/kallsyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -585,7 +585,7 @@ static int prefix_underscores_count(cons
 {
 	const char *tail = str;
 
-	while (*tail != '_')
+	while (*tail == '_')
 		tail++;
 
 	return tail - str;


