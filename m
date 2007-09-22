Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbXIVUu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbXIVUu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbXIVUuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:50:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53651 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXIVUuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:50:50 -0400
Date: Sat, 22 Sep 2007 22:52:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unfortunate infinite make recursion
Message-ID: <20070922205216.GB31873@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0709221319440.15712@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709221319440.15712@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 01:24:32PM +0200, Jan Engelhardt wrote:
> Hi,
> 
> 
> You can cause a recursion in kbuild/make with the following:
> 
> make O=$PWD kernel/time.o
> make mrproper
> 
> Of course no one would use O=$PWD (that's just the testcase),
> but this happened too often:
> 
> /ws/linux/linux-2.6.23$ make O=/ws/linux/linux-2.6.23 kernel/time.o
> (Oops - should have been O=/ws/linux/obj-2.6.23!)
> 
> The make O=$PWD truncates the Makefile, making it necessary to run `git 
> checkout Makefile` - should you have git; or reextract the tarball 
> (should you /still/ have it). Well, can we catch this case somehow?

Does the following patch fix it at your end?
Seems to work for me.

	Sam

diff --git a/Makefile b/Makefile
index 6708e41..f787b05 100644
--- a/Makefile
+++ b/Makefile
@@ -115,7 +115,9 @@ saved-output := $(KBUILD_OUTPUT)
 KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
 $(if $(KBUILD_OUTPUT),, \
      $(error output directory "$(saved-output)" does not exist))
-
+# Check the OUTPUT directory is not the same as where we have kernel src
+$(if $(filter-out $(KBUILD_OUTPUT),$(shell /bin/pwd)),, \
+     $(error Output directory (O=...) specify kernel src dir))
 PHONY += $(MAKECMDGOALS)
 
 $(filter-out _all,$(MAKECMDGOALS)) _all:

