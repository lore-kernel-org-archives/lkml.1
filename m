Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZEYXfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZEYXfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZEYXfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:35:12 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:34582 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZEYXfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:35:12 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Mon, 25 May 2009 18:35:08 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <4A1B0ACD.8020502@zytor.com> <200905251803.51478.lkml@morethan.org>
In-Reply-To: <200905251803.51478.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905251835.10958.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon May 25 2009, Michael S. Zick wrote:

PS: gcc-4.1.2 does compile the function the same
within the main file or as a stand-alone file.
Along with maintaining the programmer specified
order of operations without trying to hardcode
corrections to LEA.
I'll stick with 4.1.2 myself.  YMMV

Mike
> On Mon May 25 2009, H. Peter Anvin wrote:
> > Michael S. Zick wrote:
> > > On Mon May 25 2009, Michael S. Zick wrote:
> > > 
> > > In actual application, this *should not* make a difference.
> > > 
> > 
> > No kidding.  This is a valid transformation for integers, since it is
> > all done with 2's-complement arithmetic.
> > 
> 
> Load Effective Address does two's complement arithmetic?
> I'll take your word for it.
> 
> For example:
> 
> #include <stdio.h>
> 
> extern int diff_umask(int mask, int *cnt1, int *cnt2)
> { return (((mask - *cnt1) + *cnt2) & mask); }
> 
> int main() {
>  int msk  = 0x7fffffff; /* max positive */
>  int idx1 = 0x7ffffffd; /* max positive - 2 */
>  int idx2 = 0x7fffffff; /* max positive */
> 
>  int rst;
> 
>  rst = diff_umask(msk, &idx1, &idx2);
>  printf("\n\t%d\n", rst);  /* " 1 " - correct */
> }
> 
> But that is because when it is compiled as a
> single source file, gcc is hardcoding the lea
> adjustment when it is not an external file:
> (compare to the above listings)
> Like I wrote - I don't use 31-bit ring buffers, so I don't care.
> 
> objdump -d testdiff:
> - - - snip - - -
> 080483b0 <diff_umask>:
>  80483b0:       8b 44 24 0c             mov    0xc(%esp),%eax
>  80483b4:       8b 4c 24 04             mov    0x4(%esp),%ecx
>  80483b8:       8b 10                   mov    (%eax),%edx
>  80483ba:       8d 04 11                lea    (%ecx,%edx,1),%eax
>  80483bd:       8b 54 24 08             mov    0x8(%esp),%edx
>  80483c1:       2b 02                   sub    (%edx),%eax
>  80483c3:       21 c8                   and    %ecx,%eax
>  80483c5:       c3                      ret
> - - - snip - - -
> 
> Mike
> 
> > Floating-point numbers is a whole other game.
> > 
> > 	-hpa
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


