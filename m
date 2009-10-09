Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbZJIKfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbZJIKfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760512AbZJIKfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:35:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36336 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760389AbZJIKfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:35:05 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, devicetree-discuss@ozlabs.org,
       Wolfram Sang <w.sang@pengutronix.de>, Joe Perches <joe@perches.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Date: Fri,  9 Oct 2009 12:32:59 +0200
Message-Id: <1255084379-12954-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [RFC] scripts/get_maintainer: add emails based on keywords in the patch
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make get_maintainer.pl scan the modifying lines of a patch for a list of
keywords and add an associated email if found. The first user is the
devicetree-discuss mailing list which should always be cc'ed if a device tree
property is inserted/removed (keyword 'of_get_property'). This patch is the
result from commit 1965d30356c1c65660ba3330927671cfe81acdd5 entering mainline
which seems to have been missed by all parties interested in the device tree
(and at least had the documentation missing). As adding properties can happen
anywhere and so there is no fitting fileglob, this keyword based approach is
proposed.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Joe Perches <joe@perches.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 scripts/get_maintainer.pl |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index cdb44b6..e1150ea 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -44,6 +44,11 @@ my $help = 0;
 
 my $exit = 0;
 
+my %keywords_to_mail = (
+	'of_get_property' => 'L: devicetree-discuss@lists.ozlabs.org',
+);
+my $keywords_to_mail_match = join('|', keys %keywords_to_mail);
+
 my @penguin_chief = ();
 push(@penguin_chief,"Linus Torvalds:torvalds\@linux-foundation.org");
 #Andrew wants in on most everything - 2009/01/14
@@ -188,6 +193,12 @@ if ($email_remove_duplicates) {
 
 my @files = ();
 my @range = ();
+my @email_to = ();
+my @list_to = ();
+my @scm = ();
+my @web = ();
+my @subsystem = ();
+my @status = ();
 
 foreach my $file (@ARGV) {
     ##if $file is a directory and it lacks a trailing slash, add one
@@ -213,7 +224,11 @@ foreach my $file (@ARGV) {
 		if ($email_git_blame) {
 		    push(@range, "$lastfile:$1:$2");
 		}
-	    }
+	    # Check the lines which a patch modifies for keywords; add mail if found.
+	    } elsif (m/^[+-].*($keywords_to_mail_match)/o) {
+		(my $keyword_mail = $keywords_to_mail{$1}) =~ s/^([LM]): //;
+		push( @{ ($1 eq 'L') ? \@list_to : \@email_to }, $keyword_mail );
+	   }
 	}
 	close(PATCH);
 	if ($file_cnt == @files) {
@@ -224,13 +239,6 @@ foreach my $file (@ARGV) {
     }
 }
 
-my @email_to = ();
-my @list_to = ();
-my @scm = ();
-my @web = ();
-my @subsystem = ();
-my @status = ();
-
 # Find responsible parties
 
 foreach my $file (@files) {
-- 
1.6.3.3

