Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZBOKfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZBOKfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZBOKfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:35:09 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:44901 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbZBOKfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:35:07 -0500
Date: Sun, 15 Feb 2009 11:36:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KBUILD: Create the source symlink earlier in the objdir
Message-ID: <20090215103659.GC31088@uranus.ravnborg.org>
References: <20090110035613.GA7225@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110035613.GA7225@basil.nowhere.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 04:56:13AM +0100, Andi Kleen wrote:
> KBUILD: Create the source symlink earlier in the objdir
> 
> It's useful to already have the source symlink in a 
> objdir when one just runs make *config. Then one
> can do 
> 
> mkdir obj-allyes
> cd obj-allyes
> make -C ../sourcedir O=$(pwd) allyesconfig
> ./source/scripts/config --disable debug_info
> make CC=icecc -j18
> 
> without having to interrupt the make first just to
> get the source symlink.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  Makefile |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> Index: linux-2.6.28-kbuild/Makefile
> ===================================================================
> --- linux-2.6.28-kbuild.orig/Makefile	2009-01-07 22:16:49.000000000 +0100
> +++ linux-2.6.28-kbuild/Makefile	2009-01-10 04:50:53.000000000 +0100
> @@ -383,6 +383,7 @@
>  # output directory.
>  outputmakefile:
>  ifneq ($(KBUILD_SRC),)
> +	@ln -fsn $(srctree) $(objtree)/source
>  	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
>  	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
>  endif

But we do not want to create this symlink in two places.
So the following is better:

	Sam

diff --git a/Makefile b/Makefile
index 22d7584..76ee131 100644
--- a/Makefile
+++ b/Makefile
@@ -388,6 +388,7 @@ PHONY += outputmakefile
 # separate output directory. This allows convenient use of make in the
 # output directory.
 outputmakefile:
+	$(Q)ln -fsn $(srctree) source
 ifneq ($(KBUILD_SRC),)
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
 	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
@@ -946,7 +947,6 @@ ifneq ($(KBUILD_SRC),)
 	    mkdir -p include2;                                          \
 	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
 	fi
-	ln -fsn $(srctree) source
 endif
 
 # prepare2 creates a makefile if using a separate output directory
