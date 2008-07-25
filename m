Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYGYQln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYGYQln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYGYQlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:41:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38086 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbYGYQlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:41:35 -0400
Date: Fri, 25 Jul 2008 09:37:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ben Dooks <ben-linux@fluff.org>
cc: David Miller <davem@davemloft.net>, bzolnier@gmail.com,
       harvey.harrison@gmail.com, linux-ide@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: recent IDE regression
In-Reply-To: <20080725083448.GE8301@fluff.org.uk>
Message-ID: <alpine.LFD.1.10.0807250930190.5249@nehalem.linux-foundation.org>
References: <20080724.233831.193691312.davem@davemloft.net> <20080725083448.GE8301@fluff.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Jul 2008, Ben Dooks wrote:
> 
> personally, i would much prefer to see the loop being less evil
> like:
> 
> 	for (p = s; p < end; p += 2)
> 		be16_to_cpus((u16 *)p);

Well, in this case, the code actually depends on 'p' being back at the 
start of the buffer by the end of it all, so it would need some more 
changes than that. 

But yes, I applied David's patch, but I _also_ suspect that we would be 
better off without code that does horrid things like casts and assignments 
inside the function arguments.

So it would be nice to re-code that loop to be more readable. But due to 
the reliance of 'p' being 's' after the loop, the minimal patch would be 
something like the appended.

Bartlomiej - take this or not, I'm not going to commit it - I haven't 
tested it, nor do I even have any machines that would trigger it. So this 
is more a "maybe something like this" than anything else.

		Linus

---
 drivers/ide/ide-iops.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 8aae917..ae03151 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -506,14 +506,16 @@ void ide_fix_driveid (struct hd_driveid *id)
 
 void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
 {
-	u8 *p = s, *end = &s[bytecount & ~1]; /* bytecount must be even */
+	u8 *p, *end = &s[bytecount & ~1]; /* bytecount must be even */
 
 	if (byteswap) {
 		/* convert from big-endian to host byte order */
-		for (p = end ; p != s;)
-			be16_to_cpus((u16 *)(p -= 2));
+		for (p = s ; p != end ; p += 2)
+			be16_to_cpus((u16 *) p);
 	}
+
 	/* strip leading blanks */
+	p = s;
 	while (s != end && *s == ' ')
 		++s;
 	/* compress internal blanks and strip trailing blanks */
