Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbZJ0HDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbZJ0HDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbZJ0HD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:03:29 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61526 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447AbZJ0HD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:03:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :x-operating-system:user-agent;
        b=RtrMXPZ31msFJpEEo2FuRtEoRP8ddYDozonb0kvCLOoz8tXlywNUHNH74T098g/I0t
         7JVccb4DSuLCH/D3aF6eJL572PMcJ/EEUvMneI6XJPIKxGLBm6PgSsh/A3RnUBORieo5
         4IWE/rSqO2UQTQNXWklV7efUGLLmDuJ/1Uz6c=
Date: Tue, 27 Oct 2009 15:03:22 +0800
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] tracing: recordmcount.pl Combine the condition
	validation in update_funcs 
Message-ID: <20091027070322.GG22032@uhli>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <20091027065421.GA22032@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027065421.GA22032@uhli>
X-Operating-System: Linux uhli 2.6.28-11-generic 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d0aa9b99e4ffd13fada96bfe1651055b459e9988 Mon Sep 17 00:00:00 2001
From: Li Hong <lihong.hi@gmail.com>
Date: Tue, 27 Oct 2009 13:20:48 +0800
Subject: [PATCH] tracing: recordmcount.pl Combine the condition validation in update_funcs

Move all the condition validation into function update_funcs. Also
update_funcs shouldn't die if $ref_func is undefined for there may be
more than one valid sections in an object file.

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index d750da8..490b4cd 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -350,9 +350,7 @@ my $offset = 0;		# offset of ref_func to section beginning
 #
 sub update_funcs
 {
-    return if ($#offsets < 0);
-
-    defined($ref_func) || die "No function to reference";
+    return unless ($ref_func and @offsets);
 
     # A section only had a weak function, to represent it.
     # Unfortunately, a weak function may be overwritten by another
@@ -426,7 +424,7 @@ while (<IN>) {
 	    $read_function = 0;
 	}
 	# print out any recorded offsets
-	update_funcs() if (defined($ref_func));
+	update_funcs();
 
 	# reset all markers and arrays
 	$text_found = 0;
@@ -463,7 +461,7 @@ while (<IN>) {
 }
 
 # dump out anymore offsets that may have been found
-update_funcs() if (defined($ref_func));
+update_funcs();
 
 # If we did not find any mcount callers, we are done (do nothing).
 if (!$opened) {
-- 
1.6.0.4

