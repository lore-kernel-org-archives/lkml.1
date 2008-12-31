Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYLaIr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYLaIr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYLaIrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:47:49 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:37723 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbYLaIrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:47:48 -0500
Message-ID: <495B319B.5080601@knaff.lu>
Date: Wed, 31 Dec 2008 09:47:23 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>, greg@kroah.com,
       Roland <devzero@web.de>
Subject: Re: The bzip2/lzma patches
References: <495ADD46.7080601@zytor.com>
In-Reply-To: <495ADD46.7080601@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hi Alain,
> 
> I finally got the tree with your latest bzip2/LZMA code unburied.

Thanks for finally getting back to it.

>  My
> apologies for having sat on it for so long (you know why.)

I think the real problem here really is that there is nobody else who
seems to be able to jump in for you if you're unavailable for a longer
period for whatever reason.

> Anyway, I did run into a few things that I'd really like to get fixed.
> 
> First of all, there are more than just the x86 and ARM tree which is
> using the old API, I count at least four more architectures.  I can't
> apply the ARM tree anyway, and we clearly need a saner migration way.

Yes, that's why I introduced the NEW_CODE define. Especially since I've
got no way to test for these 4 architectures. Is that #ifdef really that
big of a catastrophe if it actually solves the problem? Especially since
it's only going to be around for a while, and then go away, once those 4
architectures are ported too.

> Second, the ugly if...goto hacks in init/initramfs.c could be much
> cleaner handled by iterating down a list of function pointers -- except
> that gunzip() seems to have a different return value (in init/than the
> others?!
> 
> Third, you're using the construct if (!foo() < 0 && message == NULL)
> 
> ... which is wrong on three(!) accounts, one technical (! has higher
> precedence than <) and two stylistic (write >= instead of !(.. < ..) and
> write !message instead of message == NULL).
> 
> I think the solution to all of this is to introduce a new function
> instead of gunzip(), and have the old gunzip() be a wrapper using the
> old ABI.

The purpose here was to have a change footprint as small as possible, in
order to avoid breaking ugly (but working) code.

The thing is, if you discourage having ugly "old" code in patches, ugly
leftovers from the early days will never be fixed because:
1. Piecemeal approach is prohibited (as that would leave ugly code in patch)
2. "Ugly" code by definition is hard to understand. If you can only get
it fixed by removing it entirely in one go, nobody might dare to change
it, for fear of breaking stuff.

>  That is much cleaner than relying on #ifdef NEW_CODE.

Having a wrapper may not be feasible in the pre-boot environment,
because there the code is #included, not linked. You'd have lots of
symbol clashes between the real gunzip's internal variables, and the
ones that are used to pass parameters to the wrapper.

It's feasible, but non-trivial legwork. After all what happened, I'm
really hesitant to spend nights on work that will just sit in a corner
ignored for months, especially if this is by definition for temporary
stuff (in order to cover the period between the time when the patch is
applied for ARM and Intel, and the time when it will be applied to all
architectures). The #ifdef NEW_CODE solves the problem in a clean way
for the purpose. Clean does not necessarily mean "looks nice in an
editor" or "complies to arbitrary 'thouh shalt not #ifdef' rules", but
can also mean "efficiently addresses the problem". Please read up on
agile methodologies.

> Finally, I know I suggested it, but I don't think the

You see, that's exactly why by now I've become increasingly hesitant to
act on your suggestions, especially when they involve non-trivial
amounts of work. I'm getting the feeling that all this is just a charade
to never get the patch accepted.

> <linux/decompress/*.h> header file are justified given that they only
> contain a single function header.  Might as well put them all in a
> single <linux/decompress.h> header.
> 
> 	-hpa
> 

If I may suggest something: what if *YOU* provided a patch (or series of
patches, or whatever you like) complying to your high stylistic
requirements, and I check it for functionality (whether it is able to
decompress kernels compressed by the 3 methods on the 2 architectures
that I have access to). Maybe that way we can get this moving along faster?

Thanks & Best Wishes for 2009 for Everybody!

Alain
