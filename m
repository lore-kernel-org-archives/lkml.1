Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbXLQR4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbXLQR4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXLQR4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:56:02 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:41527 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbXLQR4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:56:00 -0500
Date: Mon, 17 Dec 2007 18:55:57 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       John Reiser <jreiser@BitWagon.com>,
       Andrew Morton <akpm@linux-foundation.org>, security@kernel.org,
       tytso@mit.edu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mpm@selenic.com, linux-sparse@vger.kernel.org
Subject: Re: Signed divides vs shifts (Re: [Security] /dev/urandom uses
 uninit bytes, leaks user data)
Message-Id: <20071217185557.0b501e23.dada1@cosmosbay.com>
In-Reply-To: <alpine.LFD.0.9999.0712170856050.21557@woody.linux-foundation.org>
References: <E1J3RD5-0006yU-00@gondolin.me.apana.org.au>
	<alpine.LFD.0.9999.0712170856050.21557@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 09:28:57 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sat, 15 Dec 2007, Herbert Xu wrote:
> > 
> > There ought to be a warning about this sort of thing.
> 
> We could add it to sparse. The appended (untested) patch seems to say 
> there's a lot of those signed divides-by-power-of-twos.
> 
> However, the problem with such warnings is that it encourages people to do 
> the simple fix that may be *wrong*. For example, you fixed it with patches 
> like
> 
> > -		int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
> > +		int rsvd = r->limit ? 0 : random_read_wakeup_thresh / 4u;
> 
> which is really quite dangerous for several reasons:
> 
>  - it depends intimately on the type of the thing being divided (try it: 
>    it will do nothing at all if the thing you divide is larger than 
>    "unsigned int", since then the "4u" will be turned into a _signed_ 
>    larger type by the C type expansion).
> 

I was looking at lib/extable.c which does emit a signed divide on i386 but not on x86_64:

mid = (last - first) / 2 + first;

So I tried to compiled this on x86_64 :

long *mid(long *a, long *b)
{
	return ((a - b) / 2 + a);
}

It gave :
mid:
        movq    %rdi, %rdx
        subq    %rsi, %rdx
        sarq    $3, %rdx
        movq    %rdx, %rax
        shrq    $63, %rax
        addq    %rdx, %rax
        sarq    %rax
        leaq    (%rdi,%rax,8), %rax
        ret

while 

long *mid(long *a, long *b)
{
	return ((a - b) / 2u + a);
}

gave :
mid:
        movq    %rdi, %rdx
        subq    %rsi, %rdx
        sarq    $3, %rdx
        movq    %rdx, %rax
        shrq    $63, %rax
        addq    %rdx, %rax
        sarq    %rax
        leaq    (%rdi,%rax,8), %rax
        ret

and while :

long *mid(long *a, long *b)
{
	return (((unsigned long)(a - b)) / 2 + a);
}

gave :
mid:
        movq    %rdi, %rax
        subq    %rsi, %rax
        sarq    %rax
        andq    $-8, %rax
        addq    %rdi, %rax
        ret


But I found this cast ugly so I cooked this patch.

[PATCH] Avoid signed arithmetics in search_extable()

On i386 and gcc-4.2.{1|2}, search_extable() currently does integer divides (by 2 !!!), while
we can certainly use a right shift. This looks more a typical bsearch() implementation.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

diff --git a/lib/extable.c b/lib/extable.c
index 463f456..03a81bd 100644
--- a/lib/extable.c
+++ b/lib/extable.c
@@ -54,20 +54,20 @@ search_extable(const struct exception_table_entry *first,
 	       const struct exception_table_entry *last,
 	       unsigned long value)
 {
-	while (first <= last) {
-		const struct exception_table_entry *mid;
+	unsigned long mid, low = 0, high = (last - first);
 
-		mid = (last - first) / 2 + first;
+	while (low <= high) {
+		mid = (low + high) / 2;
 		/*
 		 * careful, the distance between entries can be
-		 * larger than 2GB:
+		 * larger than MAX_LONG:
 		 */
-		if (mid->insn < value)
-			first = mid + 1;
-		else if (mid->insn > value)
-			last = mid - 1;
+		if (first[mid].insn < value)
+			low = mid + 1;
+		else if (first[mid].insn > value)
+			high = mid - 1;
 		else
-			return mid;
+			return first + mid;
         }
         return NULL;
 }
