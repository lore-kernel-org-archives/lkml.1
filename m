Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbXFREoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbXFREoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 00:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXFREnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 00:43:53 -0400
Received: from gw.goop.org ([64.81.55.164]:52107 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbXFREnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 00:43:52 -0400
Message-ID: <46760D87.2000502@goop.org>
Date: Sun, 17 Jun 2007 21:43:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
References: <20070617214231.GA3588@stusta.de>
In-Reply-To: <20070617214231.GA3588@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Linus, please revert commit 21564fd2a3deb48200b595332f9ed4c9f311f2a7
>
> It's not acceptable since illegal modules should definitely not get 
> write access to paravirt_ops.
>   

What's the concern?  That a module will update the pv_ops structure to
repoint the function?  In practice that won't work because inline
patching will have already happened, so all the callsites will have
direct calls to the appropriate function.

> Andi forwarded it although the following people had already NAK'ed it:
> - Christoph Hellwig [1]
> - Peter Zijlstra [2]
> - Alan Cox [3]
>
> Considering that Andi forwarded it 2 days after he himself said a 
> different solution was pending [4] I assume he mistakenly sent it for 
> inclusion in your tree.
>   

We played with some ideas, but they all turned out way too ugly to live. 

> Reverting is safe since it simply re-establishes the 2.6.21 status quo.
>   

Well, not really.  It breaks any non-GPL module when CONFIG_PARAVIRT is
enabled, even though the same module would work fine otherwise.  That's
a pretty large regression.

I'm not really sure what the concerns are with exporting paravirt_ops as
a non-GPL symbol.

I think the basic arguments are:

    security - it makes an obvious place to hook things in.  Perhaps,
    but in practice the patching code will replace all the indirect
    calls with either inline code or a direct call to the proper
    function.  Once that's happened, changing the structure will have no
    effect.

    license - it makes GPL-only functions visible to non-GPL modules. 
    This is largely moot, since in the non-PARAVIRT case most of the
    functions in question are exported from the kernel as inline code in
    headers anyway, and so are available to all modules anyway.  In
    either case (ie PARAVIRT or no), non-inlined GPL functions will
    still be unavailable to non-GPL modules, and will still cause errors
    at insmod time.  If a module decides to directly access paravirt_ops
    (which is never a supported API, for anyone), then they could get
    access to GPL code without raising a complaint - but it would be
    very fragile piece of code, and definitely easily broken (it would
    be not much different from  jumping into the kernel at a fixed
    address because it "knows" a particular function is there).

It would be possible to arrange for paravirt_ops to be largely cleared
out once patching has happened, so that anyone looking at it wouldn't
get any useful information anyway (we'd need to keep a non-exported copy
around for patching modules, but that's OK).

Or, alternatively, we could wrap parts of struct paravirt_ops with
#ifdef MODULE to obscure the entrypoints from modules.  They would still
be able to get around this, of course, but it makes the intent clear
("thou shalt not play with these").  But I think its overkill, ugly, and
doesn't really achieve much in practice.

    J

