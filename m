Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbXIQUWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbXIQUWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757120AbXIQUWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:22:18 -0400
Received: from rune.sasl.smtp.pobox.com ([208.210.124.37]:40860 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbXIQUWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:22:17 -0400
From: Junio C Hamano <gitster@pobox.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: git-send-email creates duplicate Message-Id's
References: <11900179463203-git-send-email-avi@qumranet.com>
	<20070917155901.GP18232@stusta.de>
Date: Mon, 17 Sep 2007 13:22:05 -0700
In-Reply-To: <20070917155901.GP18232@stusta.de> (Adrian Bunk's message of
	"Mon, 17 Sep 2007 17:59:01 +0200")
Message-ID: <7vejgxyrde.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> The following might be a bug in git-send-email (git maintainers Cc'ed
> and KVM list removed from Cc): 
>
> Patch 54 got the same Message-Id as patch 61 and patch 89 got the same 
> Message-Id as patch 104.
> ...
> The emails are:
> http://marc.info/?l=linux-kernel&m=119002061330270&w=2
> http://marc.info/?l=linux-kernel&m=119002059626434&w=2
> http://marc.info/?l=linux-kernel&m=119002060011801&w=2
> http://marc.info/?l=linux-kernel&m=119002060318915&w=2

The old code generated rand(4200) for each message and appended
it to the timestamp.  I do not know where the original author
got 4200 from, but I think if you send many messages within a
single second it is possible to get collisions.

I guess something like this patch is an improvement?  It
generates a single prefix from timestamp and random, and appends
a number that is incremented for each message.

---
diff --git a/git-send-email.perl b/git-send-email.perl
index dd7560b..e250732 100755
--- a/git-send-email.perl
+++ b/git-send-email.perl
@@ -477,10 +477,18 @@ sub extract_valid_address {
 
 # We'll setup a template for the message id, using the "from" address:
 
+my ($message_id_stamp, $message_id_serial);
 sub make_message_id
 {
-	my $date = time;
-	my $pseudo_rand = int (rand(4200));
+	my $uniq;
+	if (!defined $message_id_stamp) {
+		$message_id_stamp = sprintf("%s-%s", time, int(rand(4200)));
+		$message_id_serial = 0;
+	}
+	$message_id_serial++;
+
+	$uniq = "$message_id_stamp-$message_id_serial";
+
 	my $du_part;
 	for ($sender, $repocommitter, $repoauthor) {
 		$du_part = extract_valid_address(sanitize_address($_));
@@ -490,8 +498,8 @@ sub make_message_id
 		use Sys::Hostname qw();
 		$du_part = 'user@' . Sys::Hostname::hostname();
 	}
-	my $message_id_template = "<%s-git-send-email-$du_part>";
-	$message_id = sprintf $message_id_template, "$date$pseudo_rand";
+	my $message_id_template = "<%s-git-send-email-%s>";
+	$message_id = sprintf($message_id_template, $uniq, $du_part);
 	#print "new message id = $message_id\n"; # Was useful for debugging
 }
 
