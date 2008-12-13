Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbYLMTdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbYLMTdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 14:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYLMTdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 14:33:38 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60371 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYLMTdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 14:33:38 -0500
Date: Sat, 13 Dec 2008 20:35:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Airlie <airlied@linux.ie>,
       dri-devel <dri-devel@lists.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: BUG: via_drmclient.h is referenced but does not exist
Message-ID: <20081213193506.GA22969@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David et al.

After improving the headers_check.pl script to do a
check for files included with:

	#include "foo.h"

it reported the following error:

/home/sam/kernel/knext.git/usr/include/drm/via_drm.h:34: included file '/home/sam/kernel/knext.git/usr/include/drm/via_drmclient.h' is not exported

And indeed the file via_drmclient.h does not exist in the kernel source.
We do not see any issue in the kernel as the include is guarded by:

#ifndef __KERNEL__
#include "via_drmclient.h"
#endif

But referring to a non-existing file is not the right thing to to.

We need this check as we have several places where we do:

	#include "foo.h"

in our exported headers.

So we need to fix drm somehow.

The headers_check.pl patch is included for reference.

	Sam

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 488a3b1..b97341e 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -32,7 +32,7 @@ foreach my $file (@files) {
 	$lineno = 0;
 	while ($line = <FH>) {
 		$lineno++;
-		check_include();
+		check_include($filename);
 	}
 	close FH;
 }
@@ -40,7 +40,8 @@ exit $ret;
 
 sub check_include
 {
-	if ($line =~ m/^\s*#\s*include\s+<((asm|linux).*)>/) {
+	my ($filename) = @_;
+	if ($line =~ m/^\s*#\s*include\s+<((asm|linux)[_a-zA-Z0-9\/.]+)>/) {
 		my $inc = $1;
 		my $found;
 		$found = stat($dir . "/" . $inc);
@@ -52,5 +53,18 @@ sub check_include
 			printf STDERR "$filename:$lineno: included file '$inc' is not exported\n";
 			$ret = 1;
 		}
+	} elsif ($line =~ m/^\s*#\s*include\s+"([_a-zA-Z0-9.]+)"/) {
+		my $inc = $1;
+		my $filedir = $filename;
+		my $found;
+
+		# drop filename part so we have only the dir part
+		$filedir =~ s/\/[_a-zA-Z0-9.]+$//;
+
+		$found = stat($filedir . "/" . $inc);
+		if (!$found) {
+			printf STDERR "$filename:$lineno: included file '$filedir/$inc' is not exported\n";
+			$ret = 1;
+		}
 	}
 }
