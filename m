Return-Path: <linux-kernel-owner+w=401wt.eu-S1761479AbYBOTTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479AbYBOTTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYBOTS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:18:59 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:56751 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbYBOTS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KVUMGOIFFYRrWUnALuYVXjvcvdu3AtHkQSP+kSTJZwBrisfnaN4ljGMifSsS2hX6oMQSXK+PjHSdtRtthI8UX1Iq0I7yRq6aNLlZ9UeUHDIz6/5NI6DCXSUUc0P0k4kGzHtIyjss0A3stE2TpwktQlYgIMLWyhXlrgyWAbzaEVY=
Message-ID: <19f34abd0802151118k142439e9nc47ea1f7a359fe0f@mail.gmail.com>
Date: Fri, 15 Feb 2008 20:18:54 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 4/4] kmemcheck v4
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Daniel Walker" <dwalker@mvista.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080214214907.GC19473@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B49DB2.2090402@gmail.com> <47B49E71.4040900@gmail.com>
	 <20080214214907.GC19473@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 10:49 PM, Andi Kleen <andi@firstfloor.org> wrote:
>  The ifdefs are quite ugly. I would recommend to define standard
>  functions (kmemcheck_init_zero or similar and an own __GFP flag) that can
>  be used without ifdef and easily nop'ed out on !KMEMCHECK kernels.

Yes, they are. We do in fact have a flag for this purpose,
__GFP_NOTRACK (or SLAB_NOTRACK for entire slab caches). I have now
changed some of the hunks to use this method instead of ifdefs. Thanks
for pointing this out.

Also note that this patch is not meant to be a part of kmemcheck
itself; it simply silences some of the (some bogus) warnings.
Preferably, each one of these call-sites should be carefully audited
and "fixed" independently of kmemcheck itself. In fact, the patch
should probably be split, one for the bogus warnings (where the
bogus-warning fixes are no-ops if kmemcheck is disabled), and the real
errors in their own patches.

There is currently a huge problem with bit-fields. When bit-fields are
initialized, gcc may use the AND/OR instructions to initialize one
field at a time (depending on what the C code looks like, of course).
This is seen by kmemcheck as 1. full 8/16/32-bit read 2. full
8/16/32-bit write. Therefore the first initialization of (access to) a
bit-field variable will generally cause a warning from kmemcheck. And
this is perfectly legal from the compiler point of view.

Ingo's approach so far has been to initialize all the bit-field
variables at once. This is probably what the author of the original
code wants to do anyway, though not in all cases. I admit that I am
not confident enough with kernel code myself to decide what the
appropriate fix would be in most cases of kmemcheck warnings.
Therefore, take this last patch with a grain of salt (for now).

Thank you.


Vegard
