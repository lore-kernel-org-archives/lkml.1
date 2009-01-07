Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbZAGNWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbZAGNWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZAGNV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:21:57 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:52168 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZAGNV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:21:56 -0500
Date: Wed, 7 Jan 2009 14:23:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: ccache@lists.samba.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090107132337.GA2289@uranus.ravnborg.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <496386EF.76E4.0078.0@novell.com> <20090106173300.GA10903@mit.edu> <49647B00.76E4.0078.0@novell.com> <20090107113138.GA29730@uranus.ravnborg.org> <4964AF8D.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4964AF8D.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 12:35:09PM +0000, Jan Beulich wrote:
> >>> Sam Ravnborg <sam@ravnborg.org> 07.01.09 12:31 >>>
> >What is the gain/pain ratio here?
> 
> Certainly depends on the pov - it reduces the kernel module (disk) image
> sizes quite a bit, so from a distro perspective its a move against the ever
> growing package sizes (and the disk space) hundreds or even thousands
> of modules require.

The kernel modules seldom export anything so the benefit is minimal here.

I really think we are on a wrong track here.

I did a 15 minutes hack to try ripping the .c -> .s -> .o stuff out.

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5d90030..8c93dc3 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -153,7 +153,7 @@ $(obj)/%.i: $(src)/%.c FORCE
 
 cmd_genksyms =                                                              \
     $(CPP) -D__GENKSYMS__ $(c_flags) $< |                                   \
-    $(GENKSYMS) -T $@ -A -a $(ARCH)                                         \
+    $(GENKSYMS) -T $@ $(if $(CONFIG_KBUILD_STRIP_CRC), -A) -a $(ARCH)       \
      $(if $(KBUILD_PRESERVE),-p)                                            \
      $(if $(1),-r $(firstword $(wildcard $(@:.symtypes=.symref) /dev/null)))
 
@@ -192,6 +192,7 @@ v_file = $(@D)/.tmp_$(@F:.o=.v)
 tmp_o_file = $(@D)/.tmp_$(@F)
 no_g_c_flags = $(filter-out -g%,$(c_flags))
 
+ifdef CONFIG_KBUILD_STRIP_CRC
 cmd_cc_o_c = $(CC) $(c_flags) -S -o $(s_file) $<
 
 cmd_modversions =							\
@@ -208,8 +209,20 @@ cmd_modversions =							\
 		fi;							\
 	else								\
 		rm -f $(v_file);					\
-		$(CC) $(no_g_c_flags) -c -o $@ $(s_file);		\
+		$(CC) $(no_g_c_flags) -c -o $@ $< ;			\
 	fi;
+else
+cmd_cc_o_c = $(CC) $(c_flags) -c -o $(tmp_o_file) $<
+
+cmd_modversions =							\
+	if $(OBJDUMP) -h $(tmp_o_file) | grep -q __ksymtab; then	\
+		$(call cmd_genksyms, $(KBUILD_SYMTYPES)) > $(v_file);	\
+		$(LD) $(LDFLAGS) -r -o $@ $(tmp_o_file)	-T $(v_file);	\
+	else								\
+		rm -f $(v_file);					\
+	fi;
+
+endif
 endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD


Jan - I need some hard numbers to convince me that stripping the
__crc symbols is worth it.

We can make it a configuration option as I showed above but we should
at least know what we are gaining for this.

I am very positive about stripping of the modules in general,
but the __crc_ symbols seems to trigger a few things:
1) ccahce, distcc issues in the MODVERSION case (that is allmodconfig builds)
2) It does not increase readability of the Makefile machinery and I like more
   people to be able to hack on this - not less.

Thanks,
	Sam
