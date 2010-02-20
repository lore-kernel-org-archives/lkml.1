Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0BTG0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 01:26:17 -0500
Received: from mail.vyatta.com ([76.74.103.46]:55341 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab0BTG0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 01:26:16 -0500
Date: Fri, 19 Feb 2010 22:25:54 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Cong Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Uwe =?UTF-8?B?S2xlaW5lLUvDg8K2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Arnd Bergmann <arnd@arndb.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Hui Zhu <teawater@gmail.com>,
       Ozan =?UTF-8?B?w4NhZ2xheWFu?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts: improve checkstack
Message-ID: <20100219222554.17d4bae6@nehalam>
In-Reply-To: <4B7F5128.70501@redhat.com>
References: <20100219175217.385580142@vyatta.com>
	<20100219175429.611463369@vyatta.com>
	<4B7F5128.70501@redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn on strict checking, and get rid of annoying use of prototype.
Fix syntax error in declaration

Use efficient sort algorithm by using schwartzian transform.
  http://en.wikipedia.org/wiki/Schwartzian_transform

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/scripts/checkstack.pl	2010-02-19 21:57:57.609178016 -0800
+++ b/scripts/checkstack.pl	2010-02-19 22:23:16.038241212 -0800
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
@@ -173,4 +167,7 @@ while (my $line = <STDIN>) {
 	}
 }
 
-print sort bysize @stack;
+# Use Schwartzian transform to sort by last field (size)
+print map { $_->[0] }
+      sort { $b->[1] <=> $a->[1] }
+      map { [$_, /:\t*(\d+)$/] } @stack;
