Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0CKIMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:12:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab0CKIMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:12:48 -0500
Date: Thu, 11 Mar 2010 09:12:46 +0100
From: Michal Marek <mmarek@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kbuild@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Do not unnecessarily regenerate modules.builtin
Message-ID: <20100311081246.GA13932@sepie.suse.cz>
References: <1268047222-13218-1-git-send-email-mmarek@suse.cz>
 <20100311160326.bad1500e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311160326.bad1500e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Mar 11, 2010 at 04:03:26PM +1100, Stephen Rothwell wrote:
> This breaks a "make modules modules_install" type build:
[...]
> $ make O=../ntest.obj INSTALL_MOD_PATH=../ -s modules modules_install
> cp: cannot stat `/home/sfr/kernels/ntest.obj/modules.builtin': No such file or directory

Andrew reported this yesterday, too. The followin patch should fix it
(added to the for-next branch):

>From 73d1393eb8507ed5fd7f8e696f6b1ecc18035ebe Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.cz>
Date: Wed, 10 Mar 2010 12:28:58 +0100
Subject: [PATCH] kbuild: Generate modules.builtin in make modules_install

The previous approach didn't work if one did
make modules && make modules_install
Add modules.builtin as dependency of _modinst_, which is the target that
actually needs the file.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 160cada..b98943a 100644
--- a/Makefile
+++ b/Makefile
@@ -1086,7 +1086,7 @@ ifdef CONFIG_MODULES
 
 # By default, build modules as well
 
-all: modules modules.builtin
+all: modules
 
 #	Build modules
 #
@@ -1104,7 +1104,7 @@ modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
 modules.builtin: $(vmlinux-dirs:%=%/modules.builtin)
 	$(Q)$(AWK) '!x[$$0]++' $^ > $(objtree)/modules.builtin
 
-%/modules.builtin: include/config/auto.conf | modules
+%/modules.builtin: include/config/auto.conf
 	$(Q)$(MAKE) $(modbuiltin)=$*
 
 
@@ -1117,7 +1117,7 @@ PHONY += modules_install
 modules_install: _modinst_ _modinst_post
 
 PHONY += _modinst_
-_modinst_:
+_modinst_: modules.builtin
 	@if [ -z "`$(DEPMOD) -V 2>/dev/null | grep module-init-tools`" ]; then \
 		echo "Warning: you may need to install module-init-tools"; \
 		echo "See http://www.codemonkey.org.uk/docs/post-halloween-2.6.txt";\
-- 
1.6.6.1

