Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbXLHUMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbXLHUMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbXLHUMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:12:21 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:48574 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbXLHUMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:12:20 -0500
Date: Sat, 8 Dec 2007 21:14:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Allow (O=...) from file
Message-ID: <20071208201409.GA13826@uranus.ravnborg.org>
References: <20071204210433.4d7ee66c@osprey.hogchain.net> <20071205210003.GA15366@uranus.ravnborg.org> <20071205213126.43548ccf@osprey.hogchain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205213126.43548ccf@osprey.hogchain.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 09:31:26PM -0600, Jay Cliburn wrote:
> On Wed, 5 Dec 2007 22:00:03 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Tue, Dec 04, 2007 at 09:04:33PM -0600, Jay Cliburn wrote:
> > > Sam,
> > > 
> > > This piece of the top-level Makefile in current git causes an
> > > out-of-tree driver Makefile to fail.
> > > 
> > > 101 ifdef O
> > > 102   ifeq ("$(origin O)", "command line")
> > > 103     KBUILD_OUTPUT := $(O)
> > > 104   endif
> > > 105 endif
> > > 
> > > The out-of-tree driver Makefile contains an O=... directive that
> > > (correctly) does _not_ specify the kernel source dir, and apparently
> > > isn't overridden by the command line either. If in the above
> > > Makefile snippet I change "command line" to "file", my out-of-tree
> > > make succeeds. What do you think about allowing O= to come from a
> > > file in addition to the command line?
> > 
> > When you change "command line" to "file" you actually makes kbuild
> > ignore the O=... value which is why it succeeds.
> 
> I'm puzzled by your statement.  Isn't the opposite true?  When using
> "command line", doesn't the following happen?
> 
> 1. My makefile sets O=/foo
> 2. My makefile invokes your makefile with O=/foo
> 3. Your makefile ignores my O=/foo because it requires O=/foo to
> originate from the command line
> 4. KBUILD_OUTPUT never gets set to /foo and we hit the error
> 
> OTOH, if I use "file":
> 1. My makefile sets O=/foo
> 2. My makefile invokes your makefile with O=/foo
> 3. Your makefile accepts my O=/foo because it requires O=/foo to
> originate from another makefile
> 4. KBUILD_OUTPUT gets set to /foo and my make succeeds
> 
> This all used to work the last time I tried it, which was sometime
> during 2.6.23 development, IIRC.  Isn't the current structure going to
> break just about all out-of-tree driver builds?

Jay - can I ask you to try out following patch.
If is a workaround for the root issue but this is the sort of
fix I would like to push this late in -rc.

	Sam

diff --git a/Makefile b/Makefile
index a5252f4..7fb1a2c 100644
--- a/Makefile
+++ b/Makefile
@@ -118,9 +118,6 @@ saved-output := $(KBUILD_OUTPUT)
 KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
 $(if $(KBUILD_OUTPUT),, \
      $(error output directory "$(saved-output)" does not exist))
-# Check that OUTPUT directory is not the same as where we have kernel src
-$(if $(filter-out $(KBUILD_OUTPUT),$(shell /bin/pwd)),, \
-     $(error Output directory (O=...) specifies kernel src dir))
 
 PHONY += $(MAKECMDGOALS) sub-make
 
diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index ee39fac..9ad1bd7 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -11,6 +11,12 @@
 
 
 test ! -r $2/Makefile -o -O $2/Makefile || exit 0
+# Only overwrite automatically generated Makefiles
+# (so we do not overwrite kernel Makefile)
+if ! grep -q Automatically $2/Makefile
+then
+	exit 0
+fi
 echo "  GEN     $2/Makefile"
 
 cat << EOF > $2/Makefile
