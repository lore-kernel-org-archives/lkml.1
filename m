Return-Path: <linux-kernel-owner+w=401wt.eu-S1751670AbYJRIXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbYJRIXQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 04:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYJRIXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 04:23:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57282 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYJRIXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 04:23:00 -0400
Date: Sat, 18 Oct 2008 10:22:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
Message-ID: <20081018082209.GA24220@elte.hu>
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com> <20081017180523.GA11590@elte.hu> <adatzbbrrcf.fsf@cisco.com> <20081017191202.GA5396@elte.hu> <adaiqrrrp2h.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaiqrrrp2h.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland Dreier <rdreier@cisco.com> wrote:

>  > i certainly have a found a couple of such cases, see tip/warnings/ugly - 
>  > for example see the one below where gcc is not able to see through type 
>  > width.
> 
> Yes, the uninitialized variable warnings are obnoxious too.  By the way,
> I think this:
> 
> @@ -72,7 +72,7 @@ static __always_inline void *__constant_memcpy(void *to, const void *from,
>  		return to;
>  	case 5:
>  		*(int *)to = *(int *)from;
> -		*((char *)to + 4) = *((char *)from + 4);
> +		*((short *)to + 3) = *((short *)from + 3);
>  		return to;
>  	case 6:
>  		*(int *)to = *(int *)from;
> 
> is actually *wrong*, because the cast operator binds tighter than
> addition -- so
> 
> +		*((short *)to + 3) = *((short *)from + 3);
> 
> actually copies bytes at offset 6 and 7; I think what you intended was:
> 
> +		*((short *)(to + 3)) = *((short *)(from + 3));

thx, you are right - fixed it via the patch below.

> which illustrates the risks in fixing warnings.

yeah. Note that this was not a routine case at all, i did the commit in 
the early stages when i didnt even know how much effort it all would be 
to keep the whole kernel warning-free, in all configs. It looked odd and 
ugly and was in tip/warnings/ugly rightfully.

It would be nice if you could find an outright incorrect change in 
tip/warnings/simple. The ones flagged 'simple' are the ones that have 
the highest risk of not being reviewed much beyond their initial 
addition.

	Ingo

--------------->
>From 9d8f9578ca252bf26474ed77fde7ea30e9dee595 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 18 Oct 2008 10:17:36 +0200
Subject: [PATCH] hack, workaround for warning drivers/acpi/tables/tbfadt.c, fix

Fix commit fbf03326a16b29f8d34a5a3883a267bac4d38fc2, pointed
out by Roland Dreier.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/string_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index 419ab10..be82619 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -72,7 +72,7 @@ static __always_inline void *__constant_memcpy(void *to, const void *from,
 		return to;
 	case 5:
 		*(int *)to = *(int *)from;
-		*((short *)to + 3) = *((short *)from + 3);
+		*((char *)(to + 3)) = *((char *)(from + 3));
 		return to;
 	case 6:
 		*(int *)to = *(int *)from;
