Return-Path: <linux-kernel-owner+w=401wt.eu-S1762268AbXEJWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762268AbXEJWDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758836AbXEJWDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:03:34 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2832 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776AbXEJWDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:03:33 -0400
Date: Thu, 10 May 2007 23:03:25 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>, sam@ravnborg.org, cw@f00f.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make modpost section warnings clearer
Message-ID: <20070510220325.GI29713@flint.arm.linux.org.uk>
Mail-Followup-To: David Miller <davem@davemloft.net>, sam@ravnborg.org,
	cw@f00f.org, linux-kernel@vger.kernel.org
References: <20070510203417.GA23019@tuatara.stupidest.org> <20070510.135147.55726615.davem@davemloft.net> <20070510205427.GF29713@flint.arm.linux.org.uk> <20070510.140725.99616053.davem@davemloft.net> <20070510215920.GH29713@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510215920.GH29713@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change modpost section mismatch warnings to be less confusing;
model them on the binutils linker warnings which we all know how
to interpret.

Also, fix the wrong ordering of arguments for the final case -
fromsec and refsymname were reversed.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
Yes, I build-tested the last patch but it didn't throw any warnings.
Here's a corrected patch.

 scripts/mod/modpost.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 113dc77..acd28ab 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -885,29 +885,28 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 		return;
 
 	if (before && after) {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
-		     "between '%s' (at offset 0x%llx) and '%s'\n",
-		     modname, secname, refsymname, fromsec,
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
+		     "(between '%s' and '%s')\n",
+		     modname, fromsec, (long long)r.r_offset,
+		     secname, refsymname,
 		     elf->strtab + before->st_name,
-		     (long long)r.r_offset,
 		     elf->strtab + after->st_name);
 	} else if (before) {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
-		     "after '%s' (at offset 0x%llx)\n",
-		     modname, secname, refsymname, fromsec,
-		     elf->strtab + before->st_name,
-		     (long long)r.r_offset);
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
+		     "(after '%s')\n",
+		     modname, fromsec, (long long)r.r_offset,
+		     secname, refsymname,
+		     elf->strtab + before->st_name);
 	} else if (after) {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "before '%s' (at offset -0x%llx)\n",
-		     modname, secname, refsymname, fromsec,
-		     elf->strtab + after->st_name,
-		     (long long)r.r_offset);
+		     modname, fromsec, (long long)r.r_offset,
+		     secname, refsymname,
+		     elf->strtab + after->st_name);
 	} else {
-		warn("%s - Section mismatch: reference to %s:%s from %s "
-		     "(offset 0x%llx)\n",
-		     modname, secname, fromsec, refsymname,
-		     (long long)r.r_offset);
+		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s\n",
+		     modname, fromsec, (long long)r.r_offset,
+		     secname, refsymname);
 	}
 }
 
-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
