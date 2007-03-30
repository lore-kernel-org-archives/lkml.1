Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbXC3Oie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbXC3Oie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 10:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXC3Oie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 10:38:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:55766 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXC3Oid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 10:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=usDg0WRc0CF13mpvpTHYxqPKb7eaInAnTAkxMGtJGTdVsfpNwCW/Qm2rI6qWSRaeV6jPNV5U05aurOhzJ9GJRWK05C98t4I1EagGkBiSDZ78N0TwnoLp6fF+d+G7IBOnfsffJJzpgPsxhcYw0XuGEfqILf7RovFnTLiAsCax42g=
Message-ID: <6d6a94c50703300738i7b9d3fcn341feb08dca8817d@mail.gmail.com>
Date: Fri, 30 Mar 2007 22:38:32 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] nommu arch dont zero the anonymous mapping by adding UNINITIALIZE flag
Cc: "David Howells" <dhowells@redhat.com>, vapier.adi@gmail.com,
       jie.zhang@analog.com, bryan.wu@analog.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070330155635.6a6c55d2@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1175226172.15391.66.camel@roc-desktop>
	 <10785.1175247540@redhat.com>
	 <6d6a94c50703300334w6b4787f3p144715de5166d7bc@mail.gmail.com>
	 <15938.1175253862@redhat.com>
	 <6d6a94c50703300644y28e51f47h19182f550c18c40d@mail.gmail.com>
	 <20070330155635.6a6c55d2@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > I can't find mmap must give zeroed memory in the mmap manual.
> > Is there any reason relying on anon mmap() giving zerod memory?
>
> Its how all Unix/Linux like systems behave.
Fair enough.


> You have to clear the memory
> to something to deal with security on any kind of real system, and zero
> is a good a value as any
>
> > > Personally, I'd prefer to maintain compatibility with MMU-mode wherever
> > > possible, but I'm happy with overrides like the MAP_UNINITIALISED flag
> > > suggested.
> > >
> > Not necessary IMHO.
>
> mmap() for anonymous memory pools should not normally be a hot path,
> because the C library malloc is supposed to show some brains. If you need
> special behaviour (eg for performance hacks) then create yourself
> a /dev/zero like device which just maps uncleared pages. Its not much
> code and it keeps special cases out of the core kernel.
>
On MMU-mode, /dev/zero's-->mmap gives zerod memory.
On NO-MMU-mode, we have to do memset(,,,) to give zerod memory. So the
different malloc size has the different time cost.
So Bryan's test case shows the terrible performance result.
---------------------------------------------------------------
Summary is, when I run the app "time test",

on x86:
real    0m0.066s
user    0m0.008s
sys     0m0.058s

on Blackfin:
real    3m 37.69s
user    0m 0.04s
sys     3m 37.58s
---------------------------------------------------------------
So now the question is,
Keep the same behave as MMU but with bad performance, or keep the same
performance as MMU but without the same behave, Which one is more
important?

-Aubrey
