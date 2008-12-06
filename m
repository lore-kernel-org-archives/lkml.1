Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYLFGew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYLFGew (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 01:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYLFGeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 01:34:44 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:63683 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYLFGeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 01:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Uldv53ycUnUyXZCoZf+pROs/+qaovisO8Dl+18AikaQUZAHpPArOR5obbVCTMFBdO9
         t5JTXbtLoRFb+tJyWpAUzs8XkReekr8qPyFybZc8k9njU4TFm3C9hm4RBZNCZWqJbxOW
         xITELkHFa6YdMAm0WomktsizsffTmlSoREmYY=
Message-ID: <21d7e9970812052234u58586957y83d618eea295e0f7@mail.gmail.com>
Date: Sat, 6 Dec 2008 16:34:43 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: IO space memcpy support for userspace.
Cc: carlos@systemhalted.org, linux-kernel@vger.kernel.org,
       libc-alpha@sources.redhat.com
In-Reply-To: <20081205.122238.12303228.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970812041940h29994c60w3e7bcf20b96efe04@mail.gmail.com>
	 <119aab440812050932h9173a4bm79273b7ea8fe9a3a@mail.gmail.com>
	 <20081205.122238.12303228.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 6:22 AM, David Miller <davem@davemloft.net> wrote:
> From: "Carlos O'Donell" <carlos@systemhalted.org>
> Date: Fri, 5 Dec 2008 12:32:04 -0500
>
>> On Thu, Dec 4, 2008 at 10:40 PM, Dave Airlie <airlied@gmail.com> wrote:
>> > I'm sure this has come up before and I'm sure I'll either wish I never
>> > posted this or someone will show me the crisp corpse of the last guy
>> > who suggested it.
>>
>> Do you plan to prevent the compiler from issuing the same sorts of
>> instructions that might appear in an optimized memcpy?
>>
>> Isn't it dangerous to have memory that doesn't behave like normal
>> memory, and yet try to treat it like normal memory?
>>
>> This mismatch of abstractions is a warning that must not be ignored.
>
> This is basically my opinion as well.
>
> You'll pretty much need to surround accesses to these places with
> accessor macros that do whatever is necessary on a given platform and
> avoids the "dangerous" instructions in cases like IA64.
>
> Treating them like normal memory isn't going to work on all systems.

Its a real pain in the ass with dynamic buffer objects, we don't want userspace
to care where they are located, the kernel migrates them in/out of
video memory, GART, local RAM etc.

However I suspect I just need on these platforms to ban any CPU
accesses to pixmaps in VRAM. However
sw fallbacks to the front buffer will always need these accesses.

Its going to be a real pain getting any traction this stuff upstream
(X.org/Mesa) where the world is x86 and maybe the odd powerpc, having
to do special accessors for shithouse hw is never going to be fun.

Maybe I should start libshithouse to encapsulate the problem, I'll
think about it some more.

Dave.

> BTW, the sunffb xorg driver has special code for "graphics copy"
> which is essentially just a scanline by scanline GCOPY using the
> MMX like stuff sparc64 has.  It also is mindful of avoiding access
> patterns that are known to lock up that chip :)
>
> That's just an aside, since sunffb doesn't provide any offscreen
> pixmap memory and thus shouldn't be susceptible to this problem being
> discussed here.
>
>
