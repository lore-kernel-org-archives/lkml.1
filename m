Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696Ab0AYO2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0AYO2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659Ab0AYO17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:27:59 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38428 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0AYO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:27:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=SRSXtEAhbkXITAu1ta9ovfYLBxjx9ztAyze+5hogmqIJViYVhwQBjcQVzlh9pZQUJy
         sBfif2vwe+/VVjbc0IgcDfLgWPOUOb9l1ldz9xhfqHN5aCQPKD30+AS7bgSVIKiKaSrN
         Ri/Y+D6U6nD0bsAMmn7AgCKugZfXVwPzEki2I=
Message-ID: <4B5DAA68.4060300@gmail.com>
Date: Mon, 25 Jan 2010 22:27:52 +0800
From: Hui Zhu <teawater@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       =?GB2312?B?Ik96YW4g77+Bf4F/Z2xheWFuIg==?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       teawater@gmail.com
Subject: [PATCH] Fix markup_oops.pl get $func_offset error in x8664
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I use markup_oops.pl parse a x8664 oops, I got:
objdump: --start-address: bad number: NaN
No matching code found
This is because:
main::(./m.pl:228):	open(FILE, "objdump -dS --adjust-vma=$vmaoffset --start-address=$decodestart --stop-address=$decodestop $filename |") || die "Cannot start objdump";
  DB<3> p $decodestart
NaN
This NaN is get from:
main::(./m.pl:176):	my $decodestart = Math::BigInt->from_hex("0x$target") - Math::BigInt->from_hex("0x$func_offset");
  DB<2> p $func_offset
0x175
There already a "0x" in $func_offset, another 0x make it to be NaN.
The $func_offset is from line:
	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\] ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
		$function = $1;
		$func_offset = $2;
	}
I make a patch to change "(0x[0-9a-f]+)\/0x[a-f0-9]/)" to "0x([0-9a-f]+)\/0x[a-f0-9]/)".

Thanks,
Hui

Signed-off-by: Hui Zhu <teawater@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Ozan ÔøÅÅglayan <ozan@pardus.org.tr>
Cc: Matthew Wilcox <willy@linux.intel.com>
---
 scripts/markup_oops.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/markup_oops.pl
+++ b/scripts/markup_oops.pl
@@ -158,7 +158,7 @@ while (<STDIN>) {
 		$function = $1;
 		$func_offset = $2;
 	}
-	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\] ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
+	if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\] ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/0x[a-f0-9]/) {
 		$function = $1;
 		$func_offset = $2;
 	}
