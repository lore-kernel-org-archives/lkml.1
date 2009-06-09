Return-Path: <linux-kernel-owner+w=401wt.eu-S1761878AbZFIK36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761878AbZFIK36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760753AbZFIKU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:29 -0400
Received: from kroah.org ([198.145.64.141]:55132 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760790AbZFIKU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:28 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:04 2009
Message-Id: <20090609094104.496693358@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 53/87] random: make get_random_int() more random
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=random-make-get_random_int-more-random.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 8a0a9bd4db63bc45e3017bedeafbd88d0eb84d02 upstream.

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

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jake Edge <jake@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/random.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1660,15 +1660,20 @@ EXPORT_SYMBOL(secure_dccp_sequence_numbe
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
+	hash[0] += current->pid + jiffies + get_cycles() + (int)(long)&ret;
+
+	ret = half_md4_transform(hash, keyptr->secret);
+	put_cpu_var(get_random_int_hash);
+
+	return ret;
 }
 
 /*


