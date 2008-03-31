Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYCaTla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYCaTla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYCaTlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:41:22 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:19014 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYCaTlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:41:22 -0400
Date: Mon, 31 Mar 2008 21:38:31 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: generic versions of find_first_(zero_)bit, convert i386
Message-ID: <20080331193830.GA24156@mailshack.com>
References: <20080331171506.GA24017@mailshack.com> <20080331102240.086a93e4@extreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331102240.086a93e4@extreme>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Mon, 31 Mar 2008 21:41:19 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.78; VDF: 7.0.3.98; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 10:22:40AM -0700, Stephen Hemminger wrote:
> On Mon, 31 Mar 2008 19:15:06 +0200
> Alexander van Heukelum <heukelum@mailshack.com> wrote:
> 
> > Generic versions of __find_first_bit and __find_first_zero_bit
> > are introduced as simplified versions of __find_next_bit and
> > __find_next_zero_bit. Their compilation and use are guarded by
> > a new config variable GENERIC_FIND_FIRST_BIT.
> > 
> > The generic versions of find_first_bit and find_first_zero_bit
> > are implemented in terms of the newly introduced __find_first_bit
> > and __find_first_zero_bit.
> > 
> > This patch also converts i386 to the generic functions. The text
> > size shrinks slightly due to uninlining of the find_*_bit functions.
> > 
> >    text    data     bss     dec     hex filename
> > 4764939  480324  622592 5867855  59894f vmlinux  (i386 defconfig before)
> > 4764645  480324  622592 5867561  598829 vmlinux  (i386 defconfig after)
> > 
> > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > 
> 
> Size isn't everything, what is the performance difference?

Hi,

Performance should not change too much. Uninlining of the functions has
some impact, of course, but this should be visible only for small bitmap
sizes. Measuring the performance impact by doing artificial benchmarks
is a bit problematic too, because it is hard to guess what patterns are
important. Anyhow, I hacked together a program (in userspace) that
searches for a bit in a bitmap. In pseudo code:

bitmap <- [0...]
for bitmapsize=1 to 512
	for bitposition=0 to bitmapsize-1
		find_first_bit in bitmap
		bitmap[bitposition] <- 1
		find_first_bit in bitmap
		bitmap[bitposition] <- 0

After each find_first_bit, the result is checked against the expected result.
A similar test is done for searching zero bits. The two tests are performed
1000 times in a loop. On a 2.4GHz (P-IV-type) Xeon, I get the following
results:

$ gcc -DNEW -fomit-frame-pointer -Os find_first_bit.c && time ./a.out
real    0m15.006s
$ nm -nStd
0000000134513492 0000000000000065 T find_first_bit
0000000134513557 0000000000000062 T find_first_zero_bit
0000000134513619 0000000000000190 T testzerobit
0000000134513809 0000000000000187 T testonebit
0000000134513996 0000000000000045 T main

and

$ gcc -fomit-frame-pointer -Os find_first_bit.c && time ./a.out
real    0m17.617s
0000000134513492 0000000000000293 T testzerobit
0000000134513785 0000000000000240 T testonebit
0000000134514025 0000000000000045 T main

So in this particular case, on this particular machine, with this
particular mix of searches, the new code is somewhat faster, even
though it is out-of-line.

A similar, but more convincing, change was seen when the assembly
versions for find_next_bit and find_next_zero_bit where replaced
by the generic ones.

Greetings,
	Alexander
