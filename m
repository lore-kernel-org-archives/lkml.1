Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZBARrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZBARrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZBARrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:47:33 -0500
Received: from fifo99.com ([67.223.236.141]:56252 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbZBARrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:47:33 -0500
Subject: Re: checkpatch.pl is getting too slow
From: Daniel Walker <dwalker@fifo99.com>
To: Greg KH <greg@kroah.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090201044614.GA8589@kroah.com>
References: <20090131185507.GA3280@kroah.com>
	 <20090131210220.GA25811@shadowen.org> <1233449877.5903.48.camel@desktop>
	 <20090201044614.GA8589@kroah.com>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 09:47:26 -0800
Message-Id: <1233510446.5903.87.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I found a little more on this.. It seems the problem with #define lines
only causes a few extra seconds delay .. I found another issue C99 style
comments.

On line 642 your file has this line,

// For the UART control registers, the application number need to be Or'ed

The quote in Or'ed causes checkpatch to treat the rest of the file as a
big string that never closes. Or that's my impression. The delay is
caused in the same way as the define delay. In order to check one line
in the file the rest of the file is scanned.

The fix below increased the number of errors found too.

total: 347 errors, 278 warnings, 3932 lines checked

---

This fixes the sanitation process in checkpatch.pl so that it blocks out
the text after a C99 style comment the same way it does with block style
comments. This prevents the text from getting processed as regular code.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 45eb0ae..a987972 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -355,6 +355,13 @@ sub sanitise_line {
 			$off++;
 			next;
 		}
+		if ($sanitise_quote eq '' && substr($line, $off, 2) eq '//') {
+			$sanitise_quote = '//';
+
+			substr($res, $off, 2, $sanitise_quote);
+			$off++;
+			next;
+		}
 
 		# A \ in a string means ignore the next character.
 		if (($sanitise_quote eq "'" || $sanitise_quote eq '"') &&
@@ -378,6 +385,8 @@ sub sanitise_line {
 		#print "c<$c> SQ<$sanitise_quote>\n";
 		if ($off != 0 && $sanitise_quote eq '*/' && $c ne "\t") {
 			substr($res, $off, 1, $;);
+		} elsif ($off != 0 && $sanitise_quote eq '//' && $c ne "\t") {
+			substr($res, $off, 1, $;);
 		} elsif ($off != 0 && $sanitise_quote && $c ne "\t") {
 			substr($res, $off, 1, 'X');
 		} else {
@@ -385,6 +394,10 @@ sub sanitise_line {
 		}
 	}
 
+	if ($sanitise_quote eq '//') {
+		$sanitise_quote = '';
+	}
+
 	# The pathname on a #include may be surrounded by '<' and '>'.
 	if ($res =~ /^.\s*\#\s*include\s+\<(.*)\>/) {
 		my $clean = 'X' x length($1);


