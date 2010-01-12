Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745Ab0ALDCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0ALDCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770Ab0ALDCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:02:45 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:59526 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0ALDCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:02:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AvgX/sl2M4f5W2cc4lya/KlFRCkacrcORiSjCTmiyMJqXB3n64gmMKXiK/pud4PpGb
         HPEvLcQZ+DkYtfcUG9UeTS/FIecsQ7cWVcR48/62svhvJDRMbz7m1ZT/vpnGIbWSHWJL
         Pb3a3alwyhYDSyxELKQHiwb4nNVLmbUrf3MJ4=
MIME-Version: 1.0
In-Reply-To: <daef60381001101859t43e336fr149e5a1a11c8f981@mail.gmail.com>
References: <daef60381001060123vbb09aecy7943d72fcb8278a@mail.gmail.com> 
	<4B448EE3.5060200@linux.intel.com> <daef60381001062143i67da4203rb02919b64794664c@mail.gmail.com> 
	<4B45DBB5.9070904@linux.intel.com> <daef60381001101859t43e336fr149e5a1a11c8f981@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 12 Jan 2010 11:02:22 +0800
Message-ID: <daef60381001111902q2d6c7c59p7aa935ae39c8febe@mail.gmail.com>
Subject: Re: [PATCH] Fix markup_oops.pl get error in x86
To: Arjan van de Ven <arjan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-1?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I forgot the Signed-off-by and CC in prev mail.

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
It add other 0x to 0x2.
Then this value will be set to NaN.
This patch will fix it.

Signed-off-by: Hui Zhu <teawater@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Sam Ravnborg <sam@ravnborg.org>
CC: Ozan Çaglayan <ozan@pardus.org.tr>
CC: Matthew Wilcox <willy@linux.intel.com>

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
+	if ($line =~ /EIP is at ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/0x[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}
