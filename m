Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0BVSW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:22:58 -0500
Received: from mail.vyatta.com ([76.74.103.46]:54299 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab0BVSW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:22:56 -0500
Date: Mon, 22 Feb 2010 10:22:29 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: rostedt@goodmis.org
Cc: Arjan van de Ven <arjan@linux.intel.com>, Cong Wang <amwang@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Uwe =?UTF-8?B?S2xlaW5lLUvDg8K2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Arnd Bergmann <arnd@arndb.de>, Hui Zhu <teawater@gmail.com>,
       Ozan =?UTF-8?B?w4NhZ2xheWFu?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: improve checkstack
Message-ID: <20100222102229.78e3c0e2@nehalam>
In-Reply-To: <1266861540.24271.4609.camel@gandalf.stny.rr.com>
References: <20100219175217.385580142@vyatta.com>
	<20100219175429.611463369@vyatta.com>
	<4B7F5128.70501@redhat.com>
	<20100219222554.17d4bae6@nehalam>
	<4B7F90AA.8050306@redhat.com>
	<20100222084339.1367cfe6@nehalam>
	<4B82B7B0.7040203@linux.intel.com>
	<1266861540.24271.4609.camel@gandalf.stny.rr.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup checkstack script:
  * Turn on strict checking
  * Fix resulting error message because the declaration syntax
    was incorrect.
  * Remove incorrect and misleading use of prototype
     - prototype not required for this type of sort function
       because $a and $b are being used in this contex
     - if prototype was being used it should be for both arguments
  * Use closure for sort function

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/scripts/checkstack.pl	2010-02-22 10:15:08.120323236 -0800
+++ b/scripts/checkstack.pl	2010-02-22 10:17:49.878421919 -0800
@@ -21,6 +21,8 @@
 #
 #	TODO :	Port to all architectures (one regex per arch)
 
+use strict;
+
 # check for arch
 #
 # $re is used for two matches:
@@ -104,19 +106,11 @@ my (@stack, $re, $dre, $x, $xs);
 	}
 }
 
-sub bysize($) {
-	my ($asize, $bsize);
-	($asize = $a) =~ s/.*:	*(.*)$/$1/;
-	($bsize = $b) =~ s/.*:	*(.*)$/$1/;
-	$bsize <=> $asize
-}
-
 #
 # main()
 #
 my $funcre = qr/^$x* <(.*)>:$/;
-my $func;
-my $file, $lastslash;
+my ($func, $file, $lastslash);
 
 while (my $line = <STDIN>) {
 	if ($line =~ m/$funcre/) {
@@ -173,4 +167,6 @@ while (my $line = <STDIN>) {
 	}
 }
 
-print sort bysize @stack;
+# Sort output by size (last field)
+print sort { ($b =~ /:\t*(\d+)$/)[0] <=> ($a =~ /:\t*(\d+)$/)[0] } @stack;
+
