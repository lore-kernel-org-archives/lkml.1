Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbYD2OeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbYD2OeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYD2OeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:34:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbYD2OeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:34:11 -0400
Date: Tue, 29 Apr 2008 16:33:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Henry Nestler <Henry.Ne@Arcor.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux
	2.6
Message-ID: <20080429143314.GG26461@elte.hu>
References: <480E6BB4.5080902@henry.nestler.gmail.com> <480E8069.20502@henry.ne.arcor.de> <20080428164634.GC18210@elte.hu> <48164E29.4080409@henry.ne.arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48164E29.4080409@henry.ne.arcor.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Henry Nestler <Henry.Ne@Arcor.de> wrote:

> I'm not shure with the VFS fix. The change only has effect for x86 and 
> x86_64. I'm afraid. Mostly other architectures no need to change. I 
> would only public the base of the problem. Perhaps no need to change 
> here.

btw., i have a kmemcheck-reported bug fixed in this same area with the 
patch below. I dont remember the details anymore, but the root mount 
code did something really, really weird here.

	Ingo

------------>
Subject: init: root mount fix
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 29 16:31:50 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/do_mounts.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/init/do_mounts.c
===================================================================
--- linux.orig/init/do_mounts.c
+++ linux/init/do_mounts.c
@@ -201,9 +201,13 @@ static int __init do_mount_root(char *na
 	return 0;
 }
 
+#if PAGE_SIZE < PATH_MAX
+# error increase the fs_names allocation size here
+#endif
+
 void __init mount_block_root(char *name, int flags)
 {
-	char *fs_names = __getname();
+	char *fs_names = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
 	char *p;
 #ifdef CONFIG_BLOCK
 	char b[BDEVNAME_SIZE];
@@ -251,7 +255,7 @@ retry:
 #endif
 	panic("VFS: Unable to mount root fs on %s", b);
 out:
-	putname(fs_names);
+	free_pages((unsigned long)fs_names, 1);
 }
  
 #ifdef CONFIG_ROOT_NFS
