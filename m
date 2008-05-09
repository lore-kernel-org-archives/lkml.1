Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbYEIGYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbYEIGYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYEIGY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:24:26 -0400
Received: from ozlabs.org ([203.10.76.45]:42803 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbYEIGYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:24:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] module: be more picky about allowing missing module versions
Date: Fri, 9 May 2008 16:24:21 +1000
User-Agent: KMail/1.9.9
Cc: Jon Masters <jonathan@jonmasters.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200805091623.18127.rusty@rustcorp.com.au>
In-Reply-To: <200805091623.18127.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805091624.21659.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allow missing __versions sections, because modprobe --force strips
it.  It makes less sense to allow sections where there's no version
for a specific symbol the module uses, so disallow that.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -r cf690cb1ffad kernel/module.c
--- a/kernel/module.c	Thu May 08 21:51:23 2008 +1000
+++ b/kernel/module.c	Thu May 08 21:51:48 2008 +1000
@@ -917,6 +917,10 @@ static int check_version(Elf_Shdr *sechd
 	if (!crc)
 		return 1;
 
+	/* No versions at all?  modprobe --force does this. */
+	if (versindex == 0)
+		return try_to_force_load(mod, symname) == 0;
+
 	versions = (void *) sechdrs[versindex].sh_addr;
 	num_versions = sechdrs[versindex].sh_size
 		/ sizeof(struct modversion_info);
@@ -932,8 +936,9 @@ static int check_version(Elf_Shdr *sechd
 		goto bad_version;
 	}
 
-	if (!try_to_force_load(mod, symname))
-		return 1;
+	printk(KERN_WARNING "%s: no symbol version for %s\n",
+	       mod->name, symname);
+	return 0;
 
 bad_version:
 	printk("%s: disagrees about version of symbol %s\n",
