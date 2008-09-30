Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYI3RLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYI3RLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYI3RLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:11:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbYI3RLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:11:15 -0400
Date: Tue, 30 Sep 2008 10:10:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in
 quirk_system_pci_resources()
In-Reply-To: <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org>
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org>
 <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl> <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Linus Torvalds wrote:
> 
> It's a scary change right now, and I wouldn't commit it as is (I think 
> that for 2.6.27 the thing to do is to just do the minimal "zero means 
> disabled" thing), but having some random driver level initialize before 
> the core architecture-specific PCI code does smell. So something like this 
> sounds conceptually right anyway.

A clearer (and more flexible) solution might be this patch. It's more 
explicit about the fact that it simply makes it clear that any drivers 
that are added by the architecture Makefile will be _first_ in the list of 
drivers.

I suspect we should do the same with 'libs' and 'core' too, for that 
matter, but we don't really use '*.a' libraries any more so link order 
doesn't matter apart from initcall ordering. And libraries should hopfully 
never have that issue. And 'core' is at least right now just the 
initramfs thing. So in practice, it's probably only drivers/ that coul 
have issues like this.

Sam added to Cc, since this is a build issue. What do people think? 

Background: We are very careful to add 'drivers/pci' _before_ 
'drivers/{acpi,pnp}' in the drivers/Makefile, but what happens now is that 
since the arch Makefile adds it's own drivers to the very end, the really 
core PCI initcalls actually get ordered at the end, not the beginning. 

		Linus

---
 Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 1d03c16..642b9b9 100644
--- a/Makefile
+++ b/Makefile
@@ -458,7 +458,6 @@ scripts: scripts_basic include/config/auto.conf
 
 # Objects we will link into vmlinux / subdirs we need to visit
 init-y		:= init/
-drivers-y	:= drivers/ sound/ firmware/
 net-y		:= net/
 libs-y		:= lib/
 core-y		:= usr/
@@ -517,6 +516,9 @@ endif
 
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
+# Do this _after_ the architecture may have added its own core drivers
+drivers-y	+= drivers/ sound/ firmware/
+
 ifneq (CONFIG_FRAME_WARN,0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
