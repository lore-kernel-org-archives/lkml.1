Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZJYKD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZJYKD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 06:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZJYKD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 06:03:26 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:47790 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZJYKDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 06:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Adshh6tdvuslbM8D+Y6X5Uoc82QruyTnfySTMkeZTBjCl9eRZzo+5h9IuxCKDOk2op
         5BgFy0AFB3MP9pa3auGc9y/Id89l+jp7qAZn1mZq490ozXMkomwGO7k1ZrWEfyo+iOM4
         c9IXownsn6oUCAtP9Gm6EZPkuD3T5tHoSvJ+A=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH] lib/checksum.c: lib/checksum: fix one more thinko
Date: Sun, 25 Oct 2009 11:03:22 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Matt Fleming <matt@console-pimps.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1253888440-14111-1-git-send-email-matt@console-pimps.org> <20091024115933.GA6999@console-pimps.org> <8bd0f97a0910241551x7216c2b4sb8518e1a12ff346e@mail.gmail.com>
In-Reply-To: <8bd0f97a0910241551x7216c2b4sb8518e1a12ff346e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910251103.22996.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When do_csum gets unaligned data, we really need to treat
the first byte as an even byte, not an odd byte, because
we swap the two halves later.

Found by Mike's checksum-selftest module.

Reported-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

On Sunday 25 October 2009, Mike Frysinger wrote:

> > Andrew, Arnd, could one of you pick this up?
> 
> we've been using the generic checksum code with this fix on Blackfin
> boards for the last month and havent noticed any regressions so far

Mike,

sorry for my unresponsiveness on this one. I kept procrastinating
because I knew I need some to look at the whole logic again to make sure
I really get it right this time.

Andrew,

can you pick this one up to make sure we don't lose it again?
I could also put it into the asm-generic tree, but it feels out
of place there.

	Arnd <><


diff --git a/lib/checksum.c b/lib/checksum.c
index b2e2fd4..45c9c93 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -56,9 +56,9 @@ static unsigned int do_csum(const unsigned char *buff, int len)
 	odd = 1 & (unsigned long) buff;
 	if (odd) {
 #ifdef __LITTLE_ENDIAN
-		result = *buff;
-#else
 		result += (*buff << 8);
+#else
+		result = *buff;
 #endif
 		len--;
 		buff++;
