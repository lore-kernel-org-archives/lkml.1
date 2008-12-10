Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYLJUgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYLJUgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYLJUgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:36:13 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:40659 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYLJUgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:36:12 -0500
Date: Wed, 10 Dec 2008 21:37:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rostedt@goodmis.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu
Subject: Re: Better way to force a rebuild
Message-ID: <20081210203740.GA16674@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com> <20081210200242.GA15692@uranus.ravnborg.org> <20081210121048.6186eaf9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210121048.6186eaf9.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 12:10:48PM -0800, Andrew Morton wrote:
> On Wed, 10 Dec 2008 21:02:42 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Wed, Dec 10, 2008 at 02:48:35PM -0500, Steven Rostedt wrote:
> > > 
> > > Hi,
> > > 
> > > In include/linux/kernel.h I currently have the following lines at the 
> > > bottom of the file:
> > > 
> > > /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
> > > #ifdef CONFIG_FTRACE_MCOUNT_RECORD
> > > # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
> > > #endif
> > > 
> > > 
> > > This is only there to force a rebuild of all files when 
> > > CONFIG_FTRACE_MCOUNT_RECORD is modified. Since the modification of that 
> > > config causes the build to act different, we need to rebuild all C 
> > > objects. I added the #ifdef in kernel.h as a hack to force the rebuild by 
> > > the config dependencies used in kbuild.
> > > 
> > > My question is, is there a better way to force a full rebuild on a 
> > > modification of a config?
> > 
> > Why is that hack required in the first place?
> > We rebuild if:
> > 1- target file is missing (not the case here)
> > 2- any prerequisite files are newer than target (not the case here)
> > 3- any CONFIG_* options used by any prerequisite has changed (not the case here)
> >   [It is due to your hack]
> > 4- gcc changed (not the case here)
> > 5- options are added/deleted to gcc (this should be the case for relevant files)
> > 
> 
> But damn me it's hard to work out where and how this is implemented :(

The magic is to be found in Kbuild.include:

# Usage: $(call if_changed_rule,foo)
# Will check if $(cmd_foo) or any of the prerequisites changed,
# and if so will execute $(rule_foo).
if_changed_rule = $(if $(strip $(any-prereq) $(arg-check) ),                 \
        @set -e;                                                             \
        $(rule_$(1)))


This parts takes care of:
$(any-prereq) takes care of 1 and 2 in the above list
$(arg-check) takes care of 4 and 5 in the above list.

And record_mcount is part of the following definition:
define rule_cc_o_c
        $(call echo-cmd,checksrc) $(cmd_checksrc)                         \
        $(call echo-cmd,cc_o_c) $(cmd_cc_o_c);                            \
        $(cmd_modversions)                                                \
        $(cmd_record_mcount)                                              \
        scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
                                                      $(dot-target).tmp;  \
        rm -f $(depfile);                                                 \
        mv -f $(dot-target).tmp $(dot-target).cmd
endef

Here we use fixdep to create a set of prerequisites - one for each
CONFIG_ symbol that is found in the prerequisites. And fixdep reads the
list of prerequisites in the $(dep-file) that is created by gcc in the
cc_o_c command:

cmd_cc_o_c = $(CC) $(c_flags) -c -o $(@D)/.tmp_$(@F) $<


So after reading this you know almost as much about kbuild as I do.

I will fix the record_mcount stuff somehow.
But not tonight. Busy with work-work.

	Sam

