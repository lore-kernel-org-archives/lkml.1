Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663Ab0AFJYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab0AFJYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584Ab0AFJYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:24:05 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:60888 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab0AFJYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:24:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=SANhoCZbmGd5zuMIwQBs5SF5ITGdB3KSW+GPVzIHTH7O3oDeMfZF4LcBDtxUepAIUr
         qelEcHTMIXgEvbz4DCCwZogWvA2B4461mTVHOw9GqIsazGKzmdzK5v1ejJwy5wTRMWAx
         JCofI+RnJdHvj/CVAH5y+JzgJDeuHN+e8+M4E=
MIME-Version: 1.0
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 6 Jan 2010 17:23:41 +0800
Message-ID: <daef60381001060123vbb09aecy7943d72fcb8278a@mail.gmail.com>
Subject: [PATCH] Fix markup_oops.pl get error in x86
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-1?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I try to use markup_oops.pl in x86, I always get:
cat 1 | perl markup_oops.pl ./vmlinux
objdump: --start-address: bad number: NaN
No matching code found
This is because in line:
	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}
$func_offset will get a number like "0x2"
But in follow code:
my $decodestart = Math::BigInt->from_hex("0x$target") -
Math::BigInt->from_hex("0x$func_offset");
It add other ox to ox2.
Then this value will be set to NaN.

So I make a small patch to fix it.

Best regards,
Hui

---
 scripts/markup_oops.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -154,7 +154,7 @@ while (<STDIN>) {
 	if ($line =~ /RIP: 0010:\[\<([a-z0-9]+)\>\]/) {
 		$target = $1;
 	}
-	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
+	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}
