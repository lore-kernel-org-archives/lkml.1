Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZDGHw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZDGHw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZDGHws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:52:48 -0400
Received: from ozlabs.org ([203.10.76.45]:55267 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZDGHwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:52:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Galbraith <efault@gmx.de>
Subject: [PULL] module bogus patch revert
Date: Tue, 7 Apr 2009 17:22:39 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.27-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1239008928.5812.6.camel@marge.simson.net>
In-Reply-To: <1239008928.5812.6.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904071722.40781.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009 18:38:48 Mike Galbraith wrote:
> Hi Rusty,
> 
> The below rendered modules unloadable, and my bog standard opensuse 11.0
> x86_64 box became a doorstop.
...
> (nobody else has griped yet and it's already 11:08.  hm)

Needs MODVERSIONS=y + MODULE_FORCE_UNLOAD=n.

Thanks for report!
Rusty.
---

The following changes since commit d508afb437daee7cf07da085b635c44a4ebf9b38:
  Trond Myklebust (1):
        NFS: Fix a double free in nfs_parse_mount_options()

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-module-and-param.git master

Rusty Russell (1):
      Revert "module: remove the SHF_ALLOC flag on the __versions section."

 kernel/module.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)


commit 2e45e77787c9d0720b046eb69856edf43b17e33e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Tue Apr 7 17:12:43 2009 +0930

    Revert "module: remove the SHF_ALLOC flag on the __versions section."
    
    This reverts commit 9cb610d8e35fe3ec95a2fe2030b02f85aeea83c1.
    
    This was an impressively stupid patch.  Firstly, we reset the SHF_ALLOC
    flag lower down in the same function, so the patch was useless.  Even
    better, find_sec() ignores sections with SHF_ALLOC not set, so
    it breaks CONFIG_MODVERSIONS=y with CONFIG_MODULE_FORCE_LOAD=n, which
    refuses to load the module since it can't find the __versions section.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index c268a77..05f014e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1952,9 +1952,6 @@ static noinline struct module *load_module(void __user *umod,
 		if (strstarts(secstrings+sechdrs[i].sh_name, ".exit"))
 			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 #endif
-		/* Don't keep __versions around; it's just for loading. */
-		if (strcmp(secstrings + sechdrs[i].sh_name, "__versions") == 0)
-			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
 
 	modindex = find_sec(hdr, sechdrs, secstrings,
