Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbXFPWAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbXFPWAn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 18:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbXFPWAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 18:00:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:8416 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbXFPWAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 18:00:31 -0400
Date: Sun, 17 Jun 2007 00:00:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.05
In-Reply-To: <c0970fee9a3802d4930b2a9ac96fdd57@pinky>
Message-ID: <Pine.LNX.4.64.0706162353390.32724@fbirervta.pbzchgretzou.qr>
References: <c0970fee9a3802d4930b2a9ac96fdd57@pinky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 16 2007 22:42, Andy Whitcroft wrote:
>@@ -180,12 +182,17 @@ sub ctx_block_get {
> sub ctx_block_outer {
> 	my ($linenr, $remain) = @_;
> 
>-	return ctx_block_get($linenr, $remain, 1);
>+	return ctx_block_get($linenr, $remain, 1, '\{', '\}');

'\\{'.

Or, if it works, directly use
	return &ctx_block_get($linenr, $remain, 1, qr/\{/, qr/\}/);

>+sub ctx_statement {
>+	my ($linenr, $remain) = @_;
>+
>+	return ctx_block_get($linenr, $remain, 0, '\(', '\)');

^^

>+	my $ident	= '[A-Za-z\d_]+';

Oh yes, use the qr operator here. (qr{}, qr//, choose anything like you
would do with m//)

>+	my $storage	= '(?:extern|static)';
>+	my $sparse	= '(?:__user|__kernel|__force|__iomem)';
>+	my $type	= '(?:unsigned\s+)?' .
>+			  '(?:void|char|short|int|long|unsigned|float|double|' .
>+			  'long\s+long|' .
>+			  "struct\\s+${ident}|" .
>+			  "union\\s+${ident}|" .
>+			  "${ident}_t)" .
>+			  "(?:\\s+$sparse)*" .
>+			  '(?:\s*\*+)?';
>+	my $attribute	= '(?:__read_mostly|__init|__initdata)';
>+
>+	my $Ident	= $ident;
>+	my $Type	= $type;
>+	my $Storage	= $storage;
>+	my $Declare	= "(?:$storage\\s+)?$type";
>+	my $Attribute	= $attribute;
>+

> #trailing whitespace
>-		if ($line=~/\+.*\S\s+$/) {
>+		if ($line=~/^\+.*\S\s+$/) {
                if ($line =~ /^\+.*\S\s+$/) {
> 			my $herevet = "$here\n" . cat_vet($line) . "\n\n";
> 			print "trailing whitespace\n";
> 			print "$herevet";
>@@ -392,17 +420,20 @@ sub process {
> 		#
> 		next if ($in_comment);
> 
>-		# Remove comments from the line before processing.
>+# Remove comments from the line before processing.
> 		$line =~ s@/\*.*\*/@@g;
> 		$line =~ s@/\*.*@@;

C being a wonderful language, has this nice pitfall for parsers

	foo = number /*pointer_to_int;

> 		$line =~ s@.*\*/@@;
> 
>-		#
>-		# Checks which may be anchored in the context.
>-		#
>+# Standardise the strings and chars within the input to simplify matching.
>+		$line = sanitise_line($line);
>+
>+#
>+# Checks which may be anchored in the context.
>+#
> 
>-		# Check for switch () and associated case and default
>-		# statements should be at the same indent.
>+# Check for switch () and associated case and default
>+# statements should be at the same indent.
> 		if ($line=~/\bswitch\s*\(.*\)/) {

Codingstyle warrants \bswitch\s+  :)

> # * goes on variable not on type
>-		my $type = '(?:char|short|int|long|unsigned|float|double|' .
>-			   'struct\s+[A-Za-z\d_]+|' .
>-			   'union\s+[A-Za-z\d_]+)';
>-

qr. (I don't know what it is good for - compare qr/xyz/ with 'xyz'...,
but there's a reason to its existence, so let's use it :-)




	Jan
-- 
