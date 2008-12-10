Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbYLJV1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbYLJV1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYLJV0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:26:53 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:58429 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbYLJV0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:26:52 -0500
Date: Wed, 10 Dec 2008 22:28:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Better way to force a rebuild
Message-ID: <20081210212821.GA18348@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com> <20081210200242.GA15692@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210200242.GA15692@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 09:02:42PM +0100, Sam Ravnborg wrote:
> On Wed, Dec 10, 2008 at 02:48:35PM -0500, Steven Rostedt wrote:
> > 
> > Hi,
> > 
> > In include/linux/kernel.h I currently have the following lines at the 
> > bottom of the file:
> > 
> > /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
> > #ifdef CONFIG_FTRACE_MCOUNT_RECORD
> > # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
> > #endif
> > 
> > 
> > This is only there to force a rebuild of all files when 
> > CONFIG_FTRACE_MCOUNT_RECORD is modified. Since the modification of that 
> > config causes the build to act different, we need to rebuild all C 
> > objects. I added the #ifdef in kernel.h as a hack to force the rebuild by 
> > the config dependencies used in kbuild.
> > 
> > My question is, is there a better way to force a full rebuild on a 
> > modification of a config?
> 
> Why is that hack required in the first place?
> We rebuild if:
> - target file is missing (not the case here)
> - any prerequisite files are newer than target (not the case here)
> - any CONFIG_* options used by any prerequisite has changed (not the case here)
>   [It is due to your hack]
> - gcc changed (not the case here)
> - options are added/deleted to gcc (this should be the case for relevant files)
> 
> 
> Looking a bit deeper into this.
> I see that we have in Makefile.build:
> 
> define rule_cc_o_c
>         $(call echo-cmd,checksrc) $(cmd_checksrc)                         \
>         $(call echo-cmd,cc_o_c) $(cmd_cc_o_c);                            \
>         $(cmd_modversions)                                                \
>         $(cmd_record_mcount)   
> 
> So you want everyting to be rebuild if the command above changes.
> That should be doable - and it is indeed a bug that we do not do so.
> The integration of record_mcount needs to be improved.

I made the following quick hack.
I think it should do the trick.

	Sam

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 468fbc9..8b5bf43 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -215,7 +215,8 @@ define rule_cc_o_c
 	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
 	$(cmd_modversions)						  \
 	$(cmd_record_mcount)						  \
-	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
+	scripts/basic/fixdep $(depfile) $@                                \
+	'$(call make-cmd,cc_o_c) $(call make-cmd,record_mcount)' >        \
 	                                              $(dot-target).tmp;  \
 	rm -f $(depfile);						  \
 	mv -f $(dot-target).tmp $(dot-target).cmd
