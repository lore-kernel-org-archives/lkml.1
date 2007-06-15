Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbXFONph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbXFONph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXFONpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:45:18 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55729 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbXFONpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:45:15 -0400
Date: Fri, 15 Jun 2007 07:45:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Message-ID: <20070615134512.GG8154@parisc-linux.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <200706151131.38429.arnd@arndb.de> <20070615121133.GF8154@parisc-linux.org> <200706151442.23939.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706151442.23939.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 02:42:23PM +0200, Arnd Bergmann wrote:
> That's what I thought as well at first, since this is how the gcc 
> documentation seems to describe it. However, recent version of gcc
> complain about this:
> 
> gcc-4.1 -Wall -O2 test.c  -c
> test.c:1: warning: 'packed' attribute ignored
> 
> I have tested versions 2.95, 3.3 and 4.1, an they all ignore do the
> right thing when you do not specify the packed attribute.

...

> We might ask the gcc developers to clarify the documentation, which as of 4.1
> states:
> 
>      The `aligned' attribute can only increase the alignment; but you
>      can decrease it by specifying `packed' as well.  See below.
> 
> My understanding is that this only applies to statically allocated variables,
> but not to automatic stack variables and to usage of the type inside of
> a data structure.

Here's a program which illustrates the source of confusion:

#include <stdio.h>
#include <stddef.h>

typedef unsigned long long __attribute__((aligned(4))) compat_u64;

struct foo {
        int y;
        unsigned long long __attribute__((aligned(4))) x;
};

struct bar {
        int y;
        compat_u64 x;
};

int main(void)
{
        printf("offset of foo->x is %lu\n", offsetof(struct foo, x));
        printf("offset of bar->x is %lu\n", offsetof(struct bar, x));
        return 0;
}

output (on ia64, and I'm told other 64-bit platforms) is:

$ ./test 
offset of foo->x is 8
offset of bar->x is 4

I'll try and come up with some wording that works for the GCC manual.
