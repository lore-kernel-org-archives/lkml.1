Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbZEEP1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbZEEP1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZEEP1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:27:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbZEEP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:27:14 -0400
Date: Tue, 5 May 2009 08:17:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       Roland McGrath <roland@redhat.com>, Matt Mackall <mpm@selenic.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged
 processes
In-Reply-To: <m1r5z40yyr.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.01.0905050755310.4983@localhost.localdomain>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
 <alpine.LFD.2.01.0905041646240.4983@localhost.localdomain> <m1r5z40yyr.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 May 2009, Eric W. Biederman wrote:
> 
> Yes, not mixing the result back (which would give us some kind of
> pseudo random number generator) is the problem.

Guys, so how about this?

It's a really simple patch that basically just open-codes the current 
"secure_ip_id()" call, but when open-coding it we now use a _static_ 
hashing area, so that it gets updated every time.

And to make sure somebody can't just start from the same original seed of 
all-zeroes, and then do the "half_md4_transform()" over and over until 
they get the same sequence as the kernel has, each iteration also mixes in 
the same old "current->pid + jiffies" we used - so we should now have a 
regular strong pseudo-number generator, but we also have one that doesn't 
have a single seed.

Note: the "pid + jiffies" is just meant to be a tiny tiny bit of noise. It 
has no real meaning. It could be anything. I just picked the previous 
seed, it's just that now we keep the state in between calls and that will 
feed into the next result, and that should make all the difference.

I made that hash be a per-cpu data just to avoid cache-line ping-pong: 
having multiple CPU's write to the same data would be fine for randomness, 
and add yet another layer of chaos to it, but since get_random_int() is 
supposed to be a fast interface I did it that way instead. I considered 
using "__raw_get_cpu_var()" to avoid any preemption overhead while still 
getting the hash be _mostly_ ping-pong free, but in the end good taste won 
out.

I have _not_ tested this. Somebody obviously should, and I'm not checking 
it in without ack's and somebody testing it.

		Linus
---
 drivers/char/random.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index f824ef8..9f8fd5b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1665,15 +1665,20 @@ EXPORT_SYMBOL(secure_dccp_sequence_number);
  * value is not cryptographically secure but for several uses the cost of
  * depleting entropy is too high
  */
+DEFINE_PER_CPU(__u32 [4], get_random_int_hash);
 unsigned int get_random_int(void)
 {
-	/*
-	 * Use IP's RNG. It suits our purpose perfectly: it re-keys itself
-	 * every second, from the entropy pool (and thus creates a limited
-	 * drain on it), and uses halfMD4Transform within the second. We
-	 * also mix it with jiffies and the PID:
-	 */
-	return secure_ip_id((__force __be32)(current->pid + jiffies));
+	struct keydata *keyptr;
+	__u32 *hash = get_cpu_var(get_random_int_hash);
+	int ret;
+
+	keyptr = get_keyptr();
+	hash[0] += current->pid + jiffies;
+
+	ret = half_md4_transform(hash, keyptr->secret);
+	put_cpu_var(get_random_int_hash);
+
+	return ret;
 }
 
 /*
