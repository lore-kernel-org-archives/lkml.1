Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbYAAMqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbYAAMqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 07:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYAAMpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 07:45:55 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35546 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbYAAMpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 07:45:54 -0500
Date: Tue, 1 Jan 2008 13:45:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] [KBUILD] fix external module install path
Message-ID: <20080101124554.GA29753@uranus.ravnborg.org>
References: <463F9C3B.4080004@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463F9C3B.4080004@sandeen.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 04:38:03PM -0500, Eric Sandeen wrote:
> Installing external modules is supposed to put them in some path
> under /lib/modules/<version>/extra/subdir/, but this change:
> http://linux.bkbits.net:8080/linux-2.6/?PAGE=cset&REV=1.1982.9.23
> makes them go under /lib/modules/<version>/extrasubdir
> 
> (for example, make M=fs/ext3 modules_install puts ext3.ko in 
> /lib/modules/<version>/extrafs/ext3.ko)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Index: linux-2.6.21/scripts/Makefile.modinst
> ===================================================================
> --- linux-2.6.21.orig/scripts/Makefile.modinst
> +++ linux-2.6.21/scripts/Makefile.modinst
> @@ -21,7 +21,7 @@ quiet_cmd_modules_install = INSTALL $@
>  
>  # Modules built outside the kernel source tree go into extra by default
>  INSTALL_MOD_DIR ?= extra
> -ext-mod-dir = $(INSTALL_MOD_DIR)$(subst $(KBUILD_EXTMOD),,$(@D))
> +ext-mod-dir = $(INSTALL_MOD_DIR)/$(subst $(KBUILD_EXTMOD),,$(@D))
>  
>  modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))

Hi Eric.

Took a look at this now and fixed it like this.
Let me know if you see other issues.

[I know this is more than 6 months ago you reported it - sorry]

	Sam

>From 9af97c5f91e7dd4996b501a19b5a128b1600d511 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 1 Jan 2008 13:40:28 +0100
Subject: [PATCH] kbuild: fix installing external modules

Eric Sandeen <sandeen@redhat.com> reported:
  Installing external modules is supposed to put them in some path
  under /lib/modules/<version>/extra/subdir/, but this change:
  http://linux.bkbits.net:8080/linux-2.6/?PAGE=cset&REV=1.1982.9.23
  makes them go under /lib/modules/<version>/extrasubdir

 (for example, make M=fs/ext3 modules_install puts ext3.ko in
 /lib/modules/<version>/extrafs/ext3.ko)

This was the case only when specifying a trailing slash to M=..

Fixed by removing trailing slash if present so
we correctly match dir part of target.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Eric Sandeen <sandeen@redhat.com>
---
 scripts/Makefile.modinst |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index f0ff248..efa5d94 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -21,7 +21,7 @@ quiet_cmd_modules_install = INSTALL $@
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
-ext-mod-dir = $(INSTALL_MOD_DIR)$(subst $(KBUILD_EXTMOD),,$(@D))
+ext-mod-dir = $(INSTALL_MOD_DIR)$(subst $(patsubst %/,%,$(KBUILD_EXTMOD)),,$(@D))
 
 modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))
 
-- 
1.5.3.7.1112.g9758e

