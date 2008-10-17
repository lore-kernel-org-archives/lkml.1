Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYJQTMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYJQTMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYJQTMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:12:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46877 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbYJQTMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:12:34 -0400
Date: Fri, 17 Oct 2008 21:12:02 +0200
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
Message-ID: <20081017191202.GA5396@elte.hu>
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com> <20081017180523.GA11590@elte.hu> <adatzbbrrcf.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adatzbbrrcf.fsf@cisco.com>
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

> However I worry about warnings produced by gcc bugs forcing us to 
> tinker with correct code.  Maybe it just makes sense to wait and see 
> if we ever hit a case where a gcc bug forces us to make too many 
> stupid changes, and figure out what to do if and when that happens.

i certainly have a found a couple of such cases, see tip/warnings/ugly - 
for example see the one below where gcc is not able to see through type 
width.

the threshold i'm using is: "does the code get worse". Another question 
is the rate of really ugly patches. Had i ended up with a lot of them 
i'd be worried - but right now they are in the low single digits, for a 
full 9 MLOC kernel - which seems manageable.

the drivers/net/mlx4/mcg.c commit you pointed out is one of the very few 
borderline cases: the code gets neither better, nor worse. If you look 
at the totality of fixes they are not common at all. (and almost by 
definition the 100-200 unfixed warnings that we have piled up in -git 
are the _problematic_ cases - clear-cut cases tend to be fixed.)

	Ingo

------------->
>From fbf03326a16b29f8d34a5a3883a267bac4d38fc2 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 27 Aug 2008 12:44:00 +0200
Subject: [PATCH] hack, workaround for warning drivers/acpi/tables/tbfadt.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

ugly workaround for this warning:

  drivers/acpi/tables/tbfadt.c: In function ‘acpi_tb_create_local_fadt’:
  include/asm/string_32.h:75: warning: array subscript is above array bounds

gcc 4.3.1 20080801 (Red Hat 4.3.1-6)

its array checks are borked. Switch the string_32.h code to short instead.

NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/string_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/string_32.h b/include/asm-x86/string_32.h
index 487843e..419ab10 100644
--- a/include/asm-x86/string_32.h
+++ b/include/asm-x86/string_32.h
@@ -72,7 +72,7 @@ static __always_inline void *__constant_memcpy(void *to, const void *from,
 		return to;
 	case 5:
 		*(int *)to = *(int *)from;
-		*((char *)to + 4) = *((char *)from + 4);
+		*((short *)to + 3) = *((short *)from + 3);
 		return to;
 	case 6:
 		*(int *)to = *(int *)from;
