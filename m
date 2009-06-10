Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbZFJDlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbZFJDlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbZFJDe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:34:59 -0400
Received: from kroah.org ([198.145.64.141]:57003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbZFJDe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:34:58 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:46 2009
Message-Id: <20090610002346.175106184@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:56 -0700
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
       alan@lxorguk.ukuu.org.uk, Matt Mackall <mpm@selenic.com>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 28/60] Avoid ICE in get_random_int() with gcc-3.4.5
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=avoid-ice-in-get_random_int-with-gcc-3.4.5.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 26a9a418237c0b06528941bca693c49c8d97edbe upstream.

Martin Knoblauch reports that trying to build 2.6.30-rc6-git3 with
RHEL4.3 userspace (gcc (GCC) 3.4.5 20051201 (Red Hat 3.4.5-2)) causes an
internal compiler error (ICE):

    drivers/char/random.c: In function `get_random_int':
    drivers/char/random.c:1672: error: unrecognizable insn:
    (insn 202 148 150 0 /scratch/build/linux-2.6.30-rc6-git3/arch/x86/include/asm/tsc.h:23 (set (reg:SI 0 ax [91])
            (subreg:SI (plus:DI (plus:DI (reg:DI 0 ax [88])
                        (subreg:DI (reg:SI 6 bp) 0))
                    (const_int -4 [0xfffffffffffffffc])) 0)) -1 (nil)
        (nil))
    drivers/char/random.c:1672: internal compiler error: in extract_insn, at recog.c:2083

and after some debugging it turns out that it's due to the code trying
to figure out the rough value of the current stack pointer by taking an
address of an uninitialized variable and casting that to an integer.

This is clearly a compiler bug, but it's not worth fighting - while the
current stack kernel pointer might be somewhat hard to predict in user
space, it's also not generally going to change for a lot of the call
chains for a particular process.

So just drop it, and mumble some incoherent curses at the compiler.

Tested-by: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1634,7 +1634,7 @@ unsigned int get_random_int(void)
 	int ret;
 
 	keyptr = get_keyptr();
-	hash[0] += current->pid + jiffies + get_cycles() + (int)(long)&ret;
+	hash[0] += current->pid + jiffies + get_cycles();
 
 	ret = half_md4_transform(hash, keyptr->secret);
 	put_cpu_var(get_random_int_hash);


