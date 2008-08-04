Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYHDQq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYHDQq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbYHDQqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:46:15 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:45685 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbYHDQqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:46:13 -0400
Date: Mon, 4 Aug 2008 18:45:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Ungerer <gerg@snapgear.com>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
Message-ID: <20080804164558.GA26622@uranus.ravnborg.org>
References: <20080728200500.GA14284@uranus.ravnborg.org> <4892A719.5090302@snapgear.com> <Pine.LNX.4.64.0808032205120.23329@anakin> <200808041635.11854.arnd@arndb.de> <Pine.LNX.4.64.0808041750110.16461@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808041750110.16461@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 06:00:53PM +0200, Geert Uytterhoeven wrote:
> On Mon, 4 Aug 2008, Arnd Bergmann wrote:
> > On Sunday 03 August 2008, Geert Uytterhoeven wrote:
> > > There seem to be 3 classes of m68knommu header files:
> > > ? 1. Plain files (some of them may be (nearly) identical copies of the
> > > ? ? ?m68k variants,
> > 
> > For reference, I found the files auxvec.h, device.h, emergency-restart.h,
> > futex.h, ioctl.h, irq_regs.h, kdebug.h, mutex.h and topology.h to be
> > entirely identical, so you may remove the m68knommu variants with your
> > approach.
> 
> Thanks for the list!
> 
> > > ? 2. Files that just include the m68k variant,
> > > ? 3. Files that include the m68k variant and do something more (pci.h and
> > > ? ? ?setup.h).
> > >
> > > Since I don't think we want to do the m68k/m68knommu merge right now
> > > (Sorry Arnd, I'll keep your script in mind anyway!), the simplest way is to:
> > >  - Remove all files from class 2, and add to the Makefile:
> > 
> > Does this work with the exported headers? I guess it should if you
> > always use the m68k exports for m68knommu as well, but if that's
> > possible is is a question you haven't answered yet.
> 
> Oops, forgot about the exported headers... Don't know. Sam?

For sparc I has a similar issue and in the end I decided
to put the extra effort in and merged the header files
for sparc and sparc64. In this way we then had only a single
source to export from and despite the number of files named
foo_32.h / foo_64.h it was a net win because David long term anyway
plan to merge the two.

So to me the obvious solution for m68k / m68knommu is to
put in the additional effort required to merge the header files
for the two architectures.

In the top-level Makefile you will need this trivial patch to make it work:
diff --git a/Makefile b/Makefile
index f156f40..491ce6b 100644
--- a/Makefile
+++ b/Makefile
@@ -206,10 +206,12 @@ ifeq ($(ARCH),x86_64)
 endif

 # Where to locate arch specific headers
+hdr-arch  := $(SRCARCH)
 ifeq ($(ARCH),sparc64)
        hdr-arch  := sparc
-else
-       hdr-arch  := $(SRCARCH)
+endif
+ifeq ($(ARCH),m68knommu)
+        hdr-arch := m68k
 endif

So we have a script to help us. We know what files are identical and
kbuild support is ready.

And if we avoid it we have issues with exported headers.

So let's merge the two now - there is no reason to wait.
And do so in the git tree to make it obvious what happens.

	Sam
