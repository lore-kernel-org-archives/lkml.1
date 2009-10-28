Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbZJ1NxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbZJ1NxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZJ1NxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:53:22 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:56760 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbZJ1NxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=cdFWVhgkkp0Ii7KXdMlOe5tATzQuVug7yvRMruooiB/Yhaep8JrHeKiu6uO+g+1ld/
         9qtEfDgmKNoOr57lmioS91jPVpSNvyqFQvwDB80sHfIGrweP6j7aROco/hw4R579K5JJ
         rh+wONa4mxRXeIIajbbxb13bnhHZZnjYURJIc=
Message-ID: <4AE84F57.9030902@gmail.com>
Date: Wed, 28 Oct 2009 15:04:07 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: joe@perches.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] scripts/get_maintainer.pl: display frequently used tags
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the flag --tags, show frequently used tags.

$ ./scripts/get_maintainer.pl --tags -f ./sound/core/
71 times observed tag ALSA:

[maintainer and list email addresses]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
What do you think of this?

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 4673873..89c237d 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -37,6 +37,7 @@ my $scm = 0;
 my $web = 0;
 my $subsystem = 0;
 my $status = 0;
+my $show_tags = 0;
 my $from_filename = 0;
 my $pattern_depth = 0;
 my $version = 0;
@@ -81,6 +82,7 @@ if (!GetOptions(
 		'separator=s' => \$output_separator,
 		'subsystem!' => \$subsystem,
 		'status!' => \$status,
+		'tags!' => \$show_tags,
 		'scm!' => \$scm,
 		'web!' => \$web,
 		'pattern-depth=i' => \$pattern_depth,
@@ -381,6 +383,7 @@ Output type options:
   --separator [, ] => separator for multiple entries on 1 line
     using --separator also sets --nomultiline if --separator is not [, ]
   --multiline => print 1 entry per line
+  --tags display frequently used tags
 
 Other options:
   --pattern-depth => Number of pattern directory traversals (default: 0 (all))
@@ -661,6 +664,38 @@ sub mailmap {
     return @lines;
 }
 
+sub show_tag_counts {
+    my @lines = @_;
+    my @tags;
+    my %hash;
+    my $tot_count = 0;
+    my $tag_count = "";
+    my $i;
+    for ($i=0; $i <= $#lines; $i++) {
+    	# tag is below `Date:.*'
+	if ((grep(/^Date:\s+/, $lines[$i])) && ++$i <= $#lines) {
+    	    if ((grep(/^(\[[^]]*\]\s*)*((([^:[:space:]]+\s+){0,2}[^:[:space:]]+:)+)/, $lines[$i]))) {
+		push(@tags, $lines[$i]);
+		$tot_count++;
+	    }
+	}
+    }
+    if ($tot_count == 0) {
+	return;
+    }
+    # cut -d":" -f1
+    s/^([^:]*:).*$/$1/ for (@tags);
+
+    @tags = sort(@tags);
+    $hash{$_}++ for @tags;
+    foreach my $tag (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
+	my $tag_count = $hash{$tag};
+	last if (100 * $tag_count/$tot_count < 50);
+	printf("$tag_count times observed tag $tag\n");
+    }
+    printf("\n");
+}
+
 sub recent_git_signoffs {
     my ($file) = @_;
 
@@ -689,6 +724,10 @@ sub recent_git_signoffs {
 
     @lines = split("\n", $output);
 
+    if ($show_tags) {
+	show_tag_counts(@lines);
+    }
+
     @lines = grep(/^[-_ 	a-z]+by:.*\@.*$/i, @lines);
     if (!$email_git_penguin_chiefs) {
 	@lines = grep(!/${penguin_chiefs}/i, @lines);
