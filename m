Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbZAGUF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbZAGUF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZAGUFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:05:09 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:39656 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZAGUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:05:08 -0500
Date: Wed, 7 Jan 2009 21:06:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: ccache@lists.samba.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090107200646.GF4647@uranus.ravnborg.org>
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <496386EF.76E4.0078.0@novell.com> <20090106173300.GA10903@mit.edu> <49647B00.76E4.0078.0@novell.com> <20090107113138.GA29730@uranus.ravnborg.org> <4964AF8D.76E4.0078.0@novell.com> <20090107132337.GA2289@uranus.ravnborg.org> <4964C0A3.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4964C0A3.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 01:48:03PM +0000, Jan Beulich wrote:
> >>> Sam Ravnborg <sam@ravnborg.org> 07.01.09 14:23 >>>
> >On Wed, Jan 07, 2009 at 12:35:09PM +0000, Jan Beulich wrote:
> >> >>> Sam Ravnborg <sam@ravnborg.org> 07.01.09 12:31 >>>
> >> >What is the gain/pain ratio here?
> >> 
> >> Certainly depends on the pov - it reduces the kernel module (disk) image
> >> sizes quite a bit, so from a distro perspective its a move against the ever
> >> growing package sizes (and the disk space) hundreds or even thousands
> >> of modules require.
> >
> >The kernel modules seldom export anything so the benefit is minimal here.
> 
> Not really, for highly modular distro kernels.
> 
> >I did a 15 minutes hack to try ripping the .c -> .s -> .o stuff out.
> 
> Looks good to me. In case you decide to revert the stuff for .29, I'll
> merge this into my patch.
As it stand now it:
1) breaks sparc32 build
2) causes regression with distcc/ccache use when MODVERSIONS are enabled
3) the concept is under discussion

So I will have to revert it somehow.
I will look into during a partial revert though as your patches had some stuff
in them I like to keep or which does not harm (genksyms change for instance).

> 
> >Jan - I need some hard numbers to convince me that stripping the
> >__crc symbols is worth it.
> 
> The on-disk size of the modules in my builds is reduced by about 5% with
> this patch (but I can't immediately tell how much of this is due to __crc_*
> vs. other symbol stripping).

But if only on-disk size is your primary concern then another patch
of Jan Engelhardt would be a bigger win:

build: install modules compressed
---
scripts/Makefile.modinst |    2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index efa5d94..c3421a1 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -17,7 +17,7 @@ __modinst: $(modules)
 @:

quiet_cmd_modules_install = INSTALL $@
-      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) \
			     $(2)/$(notdir $@) 
+      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; \
		$(mod_strip_cmd) $(2)/$(notdir $@); gzip -9f $(2)/$(notdir $@)
# Modules built outside the kernel source tree go into extra by default
INSTALL_MOD_DIR ?= extra


(cut'n'paste so will not apply direct)

It does not decrease the size of vmlinux but the > 1000 modules are compressed.

The patch will in some form be present in kbuild-next.git when I open up
for that.

	Sam
