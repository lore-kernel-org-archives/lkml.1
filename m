Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbXCWTE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbXCWTE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbXCWTE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:04:27 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33035 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbXCWTEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:04:25 -0400
Date: Fri, 23 Mar 2007 20:05:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>,
       virtualization <virtualization@lists.osdl.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lguest: clean rest of linkage warnings (bar one)
Message-ID: <20070323190502.GA8512@uranus.ravnborg.org>
References: <1174532243.2713.95.camel@localhost.localdomain> <1174558182.2713.151.camel@localhost.localdomain> <20070322114549.GC29453@uranus.ravnborg.org> <1174634740.29496.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174634740.29496.12.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 06:25:39PM +1100, Rusty Russell wrote:
> On Thu, 2007-03-22 at 12:45 +0100, Sam Ravnborg wrote:
> > On Thu, Mar 22, 2007 at 09:09:42PM +1100, Rusty Russell wrote:
> > > It also fixes the remaining warnings, except one.  The code in
> > > modpost.c which needs to be taught that it's legal to link from
> > > .paravirtprobe to .init.text is horrible, and I'm pretty sure I'd just
> > > make it worse.
> > 
> > If you drop me a sample of the exact warning I will add this one too.
> > Current kbuild.git contains a lot of fixes in this area so I refer to
> > do so on top of that tree.
> 
> WARNING: vmlinux - Section mismatch: reference to .init.text: from .paravirtprobe between '__start_paravirtprobe' (at offset 0xc0464c7c) and '__stop_paravirtprobe'
> 
> Sam, you're always so polite and damn helpful: I'm pretty sure that
> violates the core tenets of Linux etiquette.
I get this strange feeling that you are planning to ask me to do much more....

Anyway I have added following path to kbuild.git.
Two small unrelated changes sneaked in (deleting a wrong part of a 
comment and adding an empty line)

It should apply on top of latest -mm

	Sam

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 06a16ac..1e578fd 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -626,7 +626,6 @@ static int strrcmp(const char *s, const char *sub)
  *   tosec   = .init.text
  *   fromsec = .text
  *   atsym = kernel_init
- *   Some symbols belong to init section but still it is ok to reference
  *
  * Pattern 7:
  *  Logos used in drivers/video/logo reside in __initdata but the
@@ -643,6 +642,13 @@ static int strrcmp(const char *s, const char *sub)
  *  The pattern is:
  *  tosec    = .init.text
  *  fromsec  = __ksymtab*
+ *
+ * Pattern 9:
+ *  Symbols contained in .paravirtprobe amy safely reference
+ *  .init.text.
+ *  The pattern is:
+ *  tosec   = .init.text
+ *  fromsec  = .paravirtprobe
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -720,10 +726,17 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	    (strncmp(fromsec, ".text", strlen(".text")) == 0) &&
 	    (strncmp(refsymname, "logo_", strlen("logo_")) == 0))
 		return 1;
+
 	/* Check for pattern 8 */
 	if ((strcmp(tosec, ".init.text") == 0) &&
 	    (strncmp(fromsec, "__ksymtab", strlen("__ksymtab")) == 0))
 		return 1;
+
+	/* Check for pattern 9 */
+	if ((strcmp(tosec, ".init.text") == 0) &&
+	    (strcmp(fromsec, ".paravirtprobe") == 0))
+		return 1;
+
 	return 0;
 }
 
