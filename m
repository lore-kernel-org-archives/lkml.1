Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab0AOBmw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023Ab0AOBmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:42:51 -0500
Received: from mail.perches.com ([173.55.12.10]:1223 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab0AOBmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:42:51 -0500
Subject: [PATCH V2 (changelog update only)] scripts/get_maintainer.pl: Add
 --sections, print entire matched subsystem
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100114151254.72b57501.akpm@linux-foundation.org>
References: <1263408063.8011.116.camel@Joe-Laptop.home>
	 <20100114151254.72b57501.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 17:42:50 -0800
Message-ID: <1263519770.1903.49.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 15:12 -0800, Andrew Morton wrote:
> On Wed, 13 Jan 2010 10:41:03 -0800
> Joe Perches <joe@perches.com> wrote:
> > Print the complete contents of the matched subsystem in pattern
> > match depth order.
> It would be much easier for us to understand the proposed change if the
> changelog contained some example output, please.

Print the complete contents of the matched subsystems
in pattern match depth order.

Sample output:

$ ./scripts/get_maintainer.pl --sections -f drivers/net/usb/smsc95xx.c
USB SMSC95XX ETHERNET DRIVER
M:Steve Glendinning <steve.glendinning@smsc.com>
L:netdev@vger.kernel.org
S:Supported
F:drivers/net/usb/smsc95xx.*
USB SUBSYSTEM
M:Greg Kroah-Hartman <gregkh@suse.de>
L:linux-usb@vger.kernel.org
W:http://www.linux-usb.org
T:quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
S:Supported
F:Documentation/usb/
F:drivers/net/usb/
F:drivers/usb/
F:include/linux/usb.h
F:include/linux/usb/
NETWORKING DRIVERS
L:netdev@vger.kernel.org
W:http://www.linuxfoundation.org/en/Net
T:git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
S:Odd Fixes
F:drivers/net/
F:include/linux/if_*
F:include/linux/*device.h
THE REST
M:Linus Torvalds <torvalds@linux-foundation.org>
L:linux-kernel@vger.kernel.org
Q:http://patchwork.kernel.org/project/LKML/list/
T:git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
S:Buried alive in reporters
F:*
F:*/

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 1762e6b..16846ce 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -41,6 +41,7 @@ my $web = 0;
 my $subsystem = 0;
 my $status = 0;
 my $keywords = 1;
+my $sections = 0;
 my $file_emails = 0;
 my $from_filename = 0;
 my $pattern_depth = 0;
@@ -121,6 +122,7 @@ if (!GetOptions(
 		'web!' => \$web,
 		'pattern-depth=i' => \$pattern_depth,
 		'k|keywords!' => \$keywords,
+		'sections!' => \$sections,
 		'fe|file-emails!' => \$file_emails,
 		'f|file' => \$from_filename,
 		'v|version' => \$version,
@@ -152,10 +154,20 @@ if ($output_rolestats) {
     $output_roles = 1;
 }
 
-my $selections = $email + $scm + $status + $subsystem + $web;
-if ($selections == 0) {
-    usage();
-    die "$P:  Missing required option: email, scm, status, subsystem or web\n";
+if ($sections) {
+    $email = 0;
+    $email_list = 0;
+    $scm = 0;
+    $status = 0;
+    $subsystem = 0;
+    $web = 0;
+    $keywords = 0;
+} else {
+    my $selections = $email + $scm + $status + $subsystem + $web;
+    if ($selections == 0) {
+	usage();
+	die "$P:  Missing required option: email, scm, status, subsystem or web\n";
+    }
 }
 
 if ($email &&
@@ -346,6 +358,21 @@ foreach my $file (@files) {
 	}
 	foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
 	    add_categories($line);
+	    if ($sections) {
+		my $i;
+		my $start = find_starting_index($line);
+		my $end = find_ending_index($line);
+		for ($i = $start; $i < $end; $i++) {
+		    my $line = $typevalue[$i];
+		    if ($line =~ /^[FX]:/) {		##Restore file patterns
+			$line =~ s/([^\\])\.([^\*])/$1\?$2/g;
+			$line =~ s/([^\\])\.$/$1\?/g;	##Convert . back to ?
+			$line =~ s/\\\./\./g;       	##Convert \. to .
+			$line =~ s/\.\*/\*/g;       	##Convert .* to *
+		    }
+		    print("$line\n");
+		}
+	    }
 	}
     }
 
@@ -476,6 +503,7 @@ Output type options:
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
   --keywords => scan patch for keywords (default: 1 (on))
+  --sections => print the entire subsystem sections with pattern matches
   --version => show version
   --help => show this help information
 



