Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470Ab0AFWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab0AFWdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458Ab0AFWdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:33:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab0AFWdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:33:36 -0500
Date: Wed, 6 Jan 2010 23:33:23 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Michal Marek <mmarek@suse.cz>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Don't mkdir -p include/config in the sourcetree when 
 using O=outputdir option
In-Reply-To: <520f0cf11001061430l2b363d90qce43bf94a384cf13@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1001062332220.3744@localhost.localdomain>
References: <alpine.LFD.2.00.1001061705140.3744@localhost.localdomain>  <4B44E5C8.2050006@suse.cz>  <520f0cf11001061210w4d33fca6y98f091c4260577c0@mail.gmail.com>  <4B44F665.6050008@suse.cz> <520f0cf11001061430l2b363d90qce43bf94a384cf13@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1073958386-1262817211=:3744"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1073958386-1262817211=:3744
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Wed, 6 Jan 2010, John Kacur wrote:

> On Wed, Jan 6, 2010 at 9:45 PM, Michal Marek <mmarek@suse.cz> wrote:
> > John Kacur napsal(a):
> >> Yes, I doubled checked that the problem exists, and it is quite easy for me to
> >> reproduce. However, my proposed solution is also broken, please don't
> >> apply, I'm still investigating.
> >>
> >> I am surprised that you are not able to reproduce the problem though.
> >> Did you follow the steps I that I outlined?
> >
> > I did
> >
> > $ git checkout v2.6.33-rc3
> > $ mkdir /bld/2.6.33-rc3
> > $ zcat /proc/config.gz >/bld/2.6.33-rc3/.config
> > $ make O=/bld/2.6.33-rc3/ oldconfig
> > ...
> > hit Enter several times
> > ...
> > $ ls -ld include/config /bld/2.6.33-rc3/include/config/
> > ls: cannot access include/config: No such file or directory
> > drwxr-xr-x 2 mmarek users 4096 2010-01-06 21:35
> > /bld/2.6.33-rc3/include/config//
> > $ make O=/bld/2.6.33-rc3/
> >  GEN     /bld/2.6.33-rc3/Makefile
> > scripts/kconfig/conf -s arch/x86/Kconfig
> >  Using /home/mmarek/linux-2.6 as source for kernel
> >  GEN     /bld/2.6.33-rc3/Makefile
> >  CHK     include/linux/version.h
> >  UPD     include/linux/version.h
> >  CHK     include/generated/utsrelease.h
> >  UPD     include/generated/utsrelease.h
> >  CC      kernel/bounds.s
> > ... continues building ...
> >
> >
> > The mkdir command has been in the Makefile since 2006 (c955cca), so I
> > think that your problem is caused by something else. Try a make V=1
> > build with a read-only source tree to see which mkdir command fails.
> >
> 
> Michal: The length of time that a bug exists in a piece of code is no
> argument for
> it's correctness!
> 
> I tried to debug this using
> make -d V=1 O=/bld/2.6.33-rc3
> and discovered that the bug did not always occur, but did sometimes.
> This leads me to think that it is timing sensitive, and indeed the
> problem shows up
> more easily on a machine with multiple processors.
> 
> Is it possible that the step with mkdir -p can sometimes occur in a
> Makefile parallel process
> before the cd KBUILD_OUTPUT occurs? That would explain why it doesn't
> reliably reproduce.
> 
> In any case, the idea behind my original patch is good, just specify
> the full path
> using the objtree variable and the problem goes away. The first round of my
> implementation was simply lacking.
> 
> Following up this note with a patch.
> 
> John
> 

>From b9db45e49b36e589de410f1c34fe77087fa36796 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 6 Jan 2010 23:16:38 +0100
Subject: [PATCH] Kbuild: Use $(objtree) for mkdir -p include/linux include/config

This fixes a problem where make sometimes creates the directories
include/linux include/config
in the local source tree, even though O=/outputdir was specified.

The solution is to give an absolute path using $(objtree)

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1231094..2f3ba92 100644
--- a/Makefile
+++ b/Makefile
@@ -454,11 +454,11 @@ include $(srctree)/arch/$(SRCARCH)/Makefile
 export KBUILD_DEFCONFIG KBUILD_KCONFIG
 
 config: scripts_basic outputmakefile FORCE
-	$(Q)mkdir -p include/linux include/config
+	$(Q)mkdir -p $(objtree)/include/linux $(objtree)/include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
 
 %config: scripts_basic outputmakefile FORCE
-	$(Q)mkdir -p include/linux include/config
+	$(Q)mkdir -p $(objtree)/include/linux $(objtree)/include/config
 	$(Q)$(MAKE) $(build)=scripts/kconfig $@
 
 else
-- 
1.6.0.6

--8323328-1073958386-1262817211=:3744--
