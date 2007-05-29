Return-Path: <linux-kernel-owner+w=401wt.eu-S1764492AbXE2VGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764492AbXE2VGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbXE2VGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:06:48 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56945 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbXE2VGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:06:48 -0400
Date: Tue, 29 May 2007 23:07:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Tell modpost that any reference from .note* is OK
Message-ID: <20070529210748.GC7738@uranus.ravnborg.org>
References: <465C8E10.8040608@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465C8E10.8040608@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 01:33:20PM -0700, Jeremy Fitzhardinge wrote:
> .note* sections are ELF notes, which are typically used by external
> tools to examine the kernel image.  Since this is removed from any
> runtime consideration, it's OK to reference any section from a .note*
> section.
> 
> As a side-effect, this changes secref_whitelist to accept a NULL "atsym"
> pointer, allowing it to be called when "before" is NULL.  This is
> needed for .note sections since they don't necessarily have any
> symbols, and it also allows the .got2 check to to be folded into the
> normal whitelist checks.

I did it a bit different. Adding .note to init_section_ref_ok +
exit_section_ref_ok is much simpler.
Next patch will move .got2 there too.

	Sam

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 662deba..b824198 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1139,6 +1139,7 @@ static int init_section_ref_ok(const char *name)
 		".debug",
 		".parainstructions",
 		".rodata",
+		".note",		/* ignore ELF notes - may contain anything */
 		NULL
 	};
 	/* part of section name */
@@ -1214,6 +1215,7 @@ static int exit_section_ref_ok(const char *name)
 	/* Start of section names */
 	const char *namelist2[] = {
 		".debug",
+		".note",		/* ignore ELF notes - may contain anything */
 		NULL
 	};
 	/* part of section name */
