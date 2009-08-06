Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbZHFCob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbZHFCob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 22:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZHFCnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 22:43:55 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3236 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbZHFCnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 22:43:51 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
       Greg KH <greg@kroah.com>
Subject: [PATCH 3/7] scripts/get_maintainer.pl: Add --pattern-depth
Date: Wed,  5 Aug 2009 19:43:44 -0700
Message-Id: <b18ddc42b6d31d3e22f0d9ce867181f31196b792.1249525834.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1249525834.git.joe@perches.com>
References: <cover.1249525834.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pattern-depth is used to control how many levels of directory traversal
should be performed to find maintainers.  default is 0 (all directory levels).

For instance:

MAINTAINERS currently has multiple M: and F: entries that match
net/netfilter/ipvs/ip_vs_app.c

IPVS
M:	Wensong Zhang <wensong@linux-vs.org>
M:	Simon Horman <horms@verge.net.au>
M:	Julian Anastasov <ja@ssi.bg>
[...]
F:	net/netfilter/ipvs/

NETFILTER/IPTABLES/IPCHAINS
[...]
M:	Patrick McHardy <kaber@trash.net>
[...]
F:	net/netfilter/

NETWORKING [GENERAL]
M:	"David S. Miller" <davem@davemloft.net>
[...]
F:	net/

THE REST
M:	Linus Torvalds <torvalds@linux-foundation.org>
[...]
F:	*/

Using this command will return all of those maintainers:
(except Linus unless --git-chief-maintainers is specified)

$ ./scripts/get_maintainer.pl --nogit -nol \
	-f net/netfilter/ipvs/ip_vs_app.c
Julian Anastasov <ja@ssi.bg>
Simon Horman <horms@verge.net.au>
Wensong Zhang <wensong@linux-vs.org>
Patrick McHardy <kaber@trash.net>
David S. Miller <davem@davemloft.net>

Adding --pattern-depth=1 will match at the deepest level
$ ./scripts/get_maintainer.pl --nogit -nol --pattern-depth=1 \
	-f net/netfilter/ipvs/ip_vs_app.c
Julian Anastasov <ja@ssi.bg>
Simon Horman <horms@verge.net.au>
Wensong Zhang <wensong@linux-vs.org>

Adding --pattern-depth=2 will match at the deepest level and 1 higher
$ ./scripts/get_maintainer.pl --nogit -nol --pattern-depth=2 \
	-f net/netfilter/ipvs/ip_vs_app.c
Julian Anastasov <ja@ssi.bg>
Simon Horman <horms@verge.net.au>
Wensong Zhang <wensong@linux-vs.org>
Patrick McHardy <kaber@trash.net>

and so on.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index fb446e0..5132949 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -13,7 +13,7 @@
 use strict;
 
 my $P = $0;
-my $V = '0.18beta2';
+my $V = '0.19';
 
 use Getopt::Long qw(:config no_auto_abbrev);
 
@@ -37,6 +37,7 @@ my $web = 0;
 my $subsystem = 0;
 my $status = 0;
 my $from_filename = 0;
+my $pattern_depth = 0;
 my $version = 0;
 my $help = 0;
 
@@ -80,6 +81,7 @@ if (!GetOptions(
 		'status!' => \$status,
 		'scm!' => \$scm,
 		'web!' => \$web,
+		'pattern-depth=i' => \$pattern_depth,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
 		'h|help' => \$help,
@@ -226,9 +228,13 @@ foreach my $file (@files) {
 		my $value = $2;
 		if ($type eq 'F') {
 		    if (file_match_pattern($file, $value)) {
-			my $pattern_depth = ($value =~ tr@/@@);
-			$pattern_depth++ if (!(substr($value,-1,1) eq "/"));
-			$hash{$tvi} = $pattern_depth;
+			my $value_pd = ($value =~ tr@/@@);
+			my $file_pd = ($file  =~ tr@/@@);
+			$value_pd++ if (substr($value,-1,1) ne "/");
+			if ($pattern_depth == 0 ||
+			    (($file_pd - $value_pd) < $pattern_depth)) {
+			    $hash{$tvi} = $value_pd;
+			}
 		    }
 		}
 	    }
@@ -345,13 +351,14 @@ Output type options:
   --separator [, ] => separator for multiple entries on 1 line
   --multiline => print 1 entry per line
 
-Default options:
-  [--email --git --m --n --l --multiline]
-
 Other options:
+  --pattern-depth => Number of pattern directory traversals (default: 0 (all))
   --version => show version
   --help => show this help information
 
+Default options:
+  [--email --git --m --n --l --multiline --pattern-depth=0]
+
 Notes:
   Using "-f directory" may give unexpected results:
       Used with "--git", git signators for _all_ files in and below
-- 
1.6.3.1.10.g659a0.dirty

