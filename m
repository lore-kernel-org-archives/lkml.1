Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbYH1Hkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbYH1Hkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 03:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYH1Hki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 03:40:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51696
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbYH1Hkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 03:40:37 -0400
Date: Thu, 28 Aug 2008 00:40:32 -0700 (PDT)
Message-Id: <20080828.004032.234293354.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: mingo@elte.hu, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080825212833.38550575.sfr@canb.auug.org.au>
References: <20080825212833.38550575.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 25 Aug 2008 21:28:33 +1000

> Hi Ingo,
> 
> Today's linux-next build (sparc64 defconfig) failed like this:
> 
> ERROR: "__BUILD_BUG_ON_non_constant" [drivers/net/sunvnet.ko] undefined!
> ERROR: "__BUILD_BUG_ON_non_constant" [drivers/block/sunvdc.ko] undefined!
> 
> Probably intorduced by commit f5b5d41dd51a31fe70e3a04fb80a3b90b84c6a4e
> ("debug: fix BUILD_BUG_ON() for non-constant expressions").

I think __builtin_constant_p() is not seeing something it
should here.

It isn't accepting:

--------------------
static inline __attribute__((const))
bool is_power_of_2(unsigned long n)
{
	return (n != 0 && ((n & (n - 1)) == 0));
}
--------------------

and thus is_power_of_2(256) as being a constant.

If a 'const' inline function being passed a const argument isn't
constant, what is! :-)

I bet the problem is the fact that is_power_of_2() is a function.

I did some tests and I can only trigger this problem with gcc-3.4 on
sparc, gcc-4.1 and gcc-4.2 worked fine.

It triggers with both -O2 and -Os for the following simple test case:

static inline __attribute__((const))
int is_power_of_2(unsigned long n)
{
	return (n != 0 && ((n & (n - 1)) == 0));
}

extern int bar;

int main(void)
{
	if (!__builtin_constant_p(is_power_of_2(256)))
		bar++;
	return 0;
}

davem@sunset:~/src/GIT/linux-2.6$ gcc-3.4  -Os -o x x.c
/tmp/ccy8FzD8.o: In function `main':
x.c:(.text+0x0): undefined reference to `bar'
x.c:(.text+0x4): undefined reference to `bar'
x.c:(.text+0xc): undefined reference to `bar'
collect2: ld returned 1 exit status
davem@sunset:~/src/GIT/linux-2.6$ gcc-3.4  -O2 -o x x.c
/tmp/ccQNzZuj.o: In function `main':
x.c:(.text+0x0): undefined reference to `bar'
x.c:(.text+0x4): undefined reference to `bar'
x.c:(.text+0xc): undefined reference to `bar'
collect2: ld returned 1 exit status
davem@sunset:~/src/GIT/linux-2.6$ 
