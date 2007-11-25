Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXKYI1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXKYI1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 03:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbXKYI1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 03:27:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:37468 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbXKYI1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 03:27:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CTWlc0qvmUgBnQeTIDJgNggGpLZLApYFHo5VnJYOvANvpkhYmPgJjMJUod0NQC/PosoYxNP61NE4M6jCwiKkzaaCHPGuFGqbGY6gqdABzk8CELVIY23KKggCEAOyCMQH+JwAvFZvePulnHrASLPJ394CG6MOsiHFGH4veeKNxw0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: [RFC] Documentation about unaligned memory access
Date: Sun, 25 Nov 2007 00:27:25 -0800
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711250027.25221.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 November 2007 16:15, Daniel Drake wrote:
> In summary: if your code causes unaligned memory accesses to happen, your
> code will not work on some platforms, and will perform *very* badly on
> others.

Although understanding alignment is important, there is another
extreme - what I call "sadistic alignment". It's when data is being
aligned even if it will definitely run on an arch which doesn't require
this (arch/x86/*), or data being aligned to ridiculously large boundary.

Like gcc aligning any char array bigger that 31 byte to 32 bytes.
Bytes, not bits. Try to compile this with -O2:

static char s1[] = "12345678901234567890123456789012";
static char s2[] = "12345678901234567890123456789012";
void f(char*);
void g() {
    f(s1);
    f(s2);
}

$ hexdump -Cv t.o
00000000  7f 45 4c 46 01 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
00000010  01 00 03 00 01 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020  38 01 00 00 00 00 00 00  34 00 00 00 00 00 28 00  |8.......4.....(.|
00000030  0a 00 07 00 55 89 e5 83  ec 08 c7 04 24 40 00 00  |....U.......$@..|
00000040  00 e8 fc ff ff ff c7 04  24 00 00 00 00 e8 fc ff  |........$.......|
00000050  ff ff c9 c3 00 00 00 00  00 00 00 00 00 00 00 00  |................|  <=== HERE
00000060  31 32 33 34 35 36 37 38  39 30 31 32 33 34 35 36  |1234567890123456|
00000070  37 38 39 30 31 32 33 34  35 36 37 38 39 30 31 32  |7890123456789012|
00000080  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|  <=== HERE
00000090  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|  <=== HERE
000000a0  31 32 33 34 35 36 37 38  39 30 31 32 33 34 35 36  |1234567890123456|
000000b0  37 38 39 30 31 32 33 34  35 36 37 38 39 30 31 32  |7890123456789012|
000000c0  00 00 00 00 00 47 43 43  3a 20 28 47 4e 55 29 20  |.....GCC: (GNU) |
000000d0  34 2e 30 2e 33 20 28 55  62 75 6e 74 75 20 34 2e  |4.0.3 (Ubuntu 4.|
000000e0  30 2e 33 2d 31 75 62 75  6e 74 75 35 29 00 00 2e  |0.3-1ubuntu5)...|
000000f0  73 79 6d 74 61 62 00 2e  73 74 72 74 61 62 00 2e  |symtab..strtab..|

43 bytes wasted!

Thankfully, it is fixed in later gcc versions.

Please do not succumb to "alignment scare" in your doc.
--
vda
