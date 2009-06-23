Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZFWSek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZFWSek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZFWSeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:34:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878AbZFWSea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:34:30 -0400
Date: Tue, 23 Jun 2009 11:33:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier@gentoo.org>, Paul Mundt <lethal@linux-sh.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [GIT PULL] asm-generic fixes
In-Reply-To: <200906231720.38105.arnd@arndb.de>
Message-ID: <alpine.LFD.2.01.0906231126460.3240@localhost.localdomain>
References: <200906231720.38105.arnd@arndb.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Jun 2009, Arnd Bergmann wrote:
> @@ -71,7 +75,7 @@ static unsigned int do_csum(const unsigned char *buff, int len)
>  		if (count) {
>  			unsigned long carry = 0;
>  			do {
> -				unsigned long w = *(unsigned long *) buff;
> +				unsigned long w = *(unsigned int *) buff;
>  				count--;
>  				buff += 4;
>  				result += carry;

I don't think this is sufficient.

You might need to make 'result', 'carry', and 'w' be 'unsigned int' too.

Why? Because the final folding is only doen from 32-bit to 16 bit, we 
don't do the whole 64-bit to 32-bit to 16-bit chain.

Now, it's possible (even likely) that even with a 64-bit word, we'll never 
actually do large enough areas that 'result' would ever have very many 
bits set in the 32+ bit region, and since we do end up folding to 16 bits 
twice (once after the loop and once at the end), it _probably_ gets things 
right in most cases. But I doubt "probably" is strong enough. Somebody 
should check.

Or just see arch/alpha/lib/checksum.c, which does the whole 64-bit case.
Maybe lib/checksum.c should be lib/checksum_{32,64}.c.

		Linus
