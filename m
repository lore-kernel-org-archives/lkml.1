Return-Path: <linux-kernel-owner+w=401wt.eu-S2992710AbXCBXCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992710AbXCBXCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992712AbXCBXCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:02:00 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37075 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992710AbXCBXB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:01:59 -0500
Date: Sat, 3 Mar 2007 00:02:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH,RFC] pci: do not mark exported functions as __devinit
Message-ID: <20070302230214.GC22555@uranus.ravnborg.org>
References: <20070227092702.GA21337@uranus.ravnborg.org> <20070302204752.GA24716@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302204752.GA24716@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Yes, we allow them to be exported globally, as other init code might
> need to call them, like these functions.
> 
> So yes, I think we need to find a way to fix the warning tools, as the
> code is correct here.

This was the patch that I made to ignore these.
It is on top of other pending changes to modpost so it will not
apply.
I had to check for _ksymtab* because we have various
section names for ksymtab. (_gpl, _future etc.)

	Sam

---
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 9042039..9e80dc5 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -625,6 +625,13 @@ static int strrcmp(const char *s, const char *sub)
  *  tosec      = .init.data
  *  fromsec    = .text*
  *  refsymname = logo_
+ *
+ * Pattern 8:
+ *  Symbols exported may be marked __init because we need to
+ *  export functions that are only used by init function.
+ *  The pattern is:
+ *  tosec    = .init.text
+ *  fromsec  = __ksymtab*
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -702,6 +709,10 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	    (strncmp(fromsec, ".text", strlen(".text")) == 0) &&
 	    (strncmp(refsymname, "logo_", strlen("logo_")) == 0))
 		return 1;
+	/* Check for pattern 8 */
+	if ((strcmp(tosec, ".init.text") == 0) &&
+	    (strncmp(fromsec, "__ksymtab", strlen("__ksymtab")) == 0))
+		return 1;
 	return 0;
 }
 
