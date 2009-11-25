Return-Path: <linux-kernel-owner+w=401wt.eu-S964891AbZKYO2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891AbZKYO2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934706AbZKYO2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:28:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZKYO2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:28:15 -0500
Date: Wed, 25 Nov 2009 15:28:20 +0100
From: Michal Marek <mmarek@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/14] kbuild: move autoconf.h to include/generated
Message-ID: <20091125142820.GA10565@sepie.suse.cz>
References: <20091018080635.GA13767@merkur.ravnborg.org>
 <1255853723-477-13-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255853723-477-13-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 10:15:22AM +0200, Sam Ravnborg wrote:
> diff --git a/Makefile b/Makefile
> index 6570cf1..b125cd9 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -336,7 +336,7 @@ CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
>  # Needed to be compatible with the O= option
>  LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include -Iinclude \
>                     $(if $(KBUILD_SRC), -I$(srctree)/include) \
> -                   -include include/linux/autoconf.h
> +                   -include include/generated/autoconf.h
>  
>  KBUILD_CPPFLAGS := -D__KERNEL__
>  
> @@ -491,17 +491,18 @@ $(KCONFIG_CONFIG) include/config/auto.conf.cmd: ;
>  # if auto.conf.cmd is missing then we are probably in a cleaned tree so
>  # we execute the config step to be sure to catch updated Kconfig files
>  include/config/auto.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
> +	$(Q)mkdir -p include/generated
>  	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig

This doesn't work if one runs make silentoldconfig directly. I fixed
this with the following patch in my tree (will be pushed out soon).

Michal

Subject: [PATCH] kbuild: create include/generated in silentoldconfig

The toplevel Makefile creates the directory if it runs silentoldconfig
automatically, but if run manually, it fails:

  $ make mrproper
  $ make defconfig && make silentoldconfig
  *** Default configuration is based on 'x86_64_defconfig'
  #
  # configuration written to .config
  #
  scripts/kconfig/conf -s arch/x86/Kconfig

  *** Error during update of the kernel configuration.
  ...

Move the mkdir command to the silentoldconfig target to make it work.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile                 |    1 -
 scripts/kconfig/Makefile |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 7bd2531..74ad9a9 100644
--- a/Makefile
+++ b/Makefile
@@ -491,7 +491,6 @@ $(KCONFIG_CONFIG) include/config/auto.conf.cmd: ;
 # if auto.conf.cmd is missing then we are probably in a cleaned tree so
 # we execute the config step to be sure to catch updated Kconfig files
 include/config/auto.conf: $(KCONFIG_CONFIG) include/config/auto.conf.cmd
-	$(Q)mkdir -p include/generated
 	$(Q)$(MAKE) -f $(srctree)/Makefile silentoldconfig
 else
 # external modules needs include/generated/autoconf.h and include/config/auto.conf
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 6d69c7c..ca5ce8e 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -27,6 +27,7 @@ oldconfig: $(obj)/conf
 	$< -o $(Kconfig)
 
 silentoldconfig: $(obj)/conf
+	$(Q)mkdir -p include/generated
 	$< -s $(Kconfig)
 
 localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
-- 
1.6.4.2

