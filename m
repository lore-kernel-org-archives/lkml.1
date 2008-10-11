Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbYJKUlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbYJKUlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYJKUlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:41:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58687 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752646AbYJKUlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:41:00 -0400
Date: Sat, 11 Oct 2008 21:40:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: mingo@elte.hu, torvalds@linux-foundation.org
Subject: Looks broken to me: x86, cyrix: debug
Message-ID: <20081011214043.283a3330@lxorguk.ukuu.org.uk>
In-Reply-To: <200810112003.m9BK3Wwu025556@hera.kernel.org>
References: <200810112003.m9BK3Wwu025556@hera.kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Oct 2008 20:03:32 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=026e2c05ef58ef413e2d52696f125d5ea1aa8bce
> Commit:     026e2c05ef58ef413e2d52696f125d5ea1aa8bce
> Parent:     93ded9b8fd42abe2c3607097963d8de6ad9117eb
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Tue Jul 22 11:58:14 2008 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue Jul 22 12:24:00 2008 +0200
> 
>     x86, cyrix: debug

Looks broken to me:

>  	/* Load/Store Serialize to mem access disable (=reorder it) */
> -	setCx86(CX86_PCR0, getCx86(CX86_PCR0) & ~0x80);
> +	setCx86_old(CX86_PCR0, getCx86_old(CX86_PCR0) & ~0x80);

Three problems:

1.

> +#define getCx86_old(reg) ({ outb((reg), 0x22); inb(0x23); })

Doesn't expand to any kind of returned value.

 +#define setCx86_old(reg, data) do { \
> +	outb((reg), 0x22); \
> +	outb((data), 0x23); \
> +} while (0)

2. 
And even if it did it would seem to expand to

	outb reg, 0x22
	outb reg, 0x22
	inb 0x23
	outb something, 0x23

which doesn't in fact work as the outb/inb or outb/outb to 0x22/0x23 must
be paired.

3.

What exactly does fiddling with stuff like the memory access ordering
(which is rather important!) have to do with a single oneliner "cyrix:
debug" title and no changelog.


Alan


