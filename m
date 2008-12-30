Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYL3Klh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYL3Klh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 05:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbYL3Kl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 05:41:29 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:37551 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYL3Kl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 05:41:28 -0500
Date: Tue, 30 Dec 2008 11:43:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: warn about headers using __[us]{8,16,32,64} types w/out linux/types.h
Message-ID: <20081230104303.GA486@uranus.ravnborg.org>
References: <1230553127-953-1-git-send-email-vapier@gentoo.org> <20081229132456.GA6938@uranus.ravnborg.org> <200812291527.53317.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812291527.53317.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 03:27:51PM -0500, Mike Frysinger wrote:
> >
> > We do not need to warn for each line in a file. Only once is enough.
> 
> i wasnt sure about that ... got pretty noisy the way i posted it :)
> 
> > Also I assume that include <asm/types.h> is also ok.
> 
> i dont think so ... does it really make sense for headers to be hitting 
> asm/types.h anyways ?  shouldnt they all be going through linux/types.h ?  
> checkpatch would certainly warn about it ...

I added following patch which I have pushed out.

	Sam

>From 1f71c478dadbe1425eeaa704e50c7030ab011c5b Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 30 Dec 2008 11:34:58 +0100
Subject: [PATCH] kbuild: add checks for include of linux/types in userspace headers

If we see __[us](8|16|32|64) then we must include <linux/types.h>
If wee see include of <asm/types.h> then we recommend <linux/types.h>

Original script from Mike but modified by me.

Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/headers_check.pl |   47 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 72924a7..b62c319 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -34,9 +34,11 @@ foreach my $file (@files) {
 	$lineno = 0;
 	while ($line = <FH>) {
 		$lineno++;
-		check_include();
-		check_prototypes();
-		check_config();
+		&check_include();
+		&check_asm_types();
+		&check_sizetypes();
+		&check_prototypes();
+		&check_config();
 	}
 	close FH;
 }
@@ -73,3 +75,42 @@ sub check_config
 	}
 }
 
+my $linux_asm_types;
+sub check_asm_types()
+{
+	if ($lineno == 1) {
+		$linux_asm_types = 0;
+	} elsif ($linux_asm_types >= 1) {
+		return;
+	}
+	if ($line =~ m/^\s*#\s*include\s+<asm\/types.h>/) {
+		$linux_asm_types = 1;
+		printf STDERR "$filename:$lineno: " .
+		"include of <linux/types.h> is preferred over <asm/types.h>\n"
+		# Warn until headers are all fixed
+		#$ret = 1;
+	}
+}
+
+my $linux_types;
+sub check_sizetypes
+{
+	if ($lineno == 1) {
+		$linux_types = 0;
+	} elsif ($linux_types >= 1) {
+		return;
+	}
+	if ($line =~ m/^\s*#\s*include\s+<linux\/types.h>/) {
+		$linux_types = 1;
+		return;
+	}
+	if ($line =~ m/__[us](8|16|32|64)\b/) {
+		printf STDERR "$filename:$lineno: " .
+		              "found __[us]{8,16,32,64} type " .
+		              "without #include <linux/types.h>\n";
+		$linux_types = 2;
+		# Warn until headers are all fixed
+		#$ret = 1;
+	}
+}
+
-- 
1.6.0.2.GIT

