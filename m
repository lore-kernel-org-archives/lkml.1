Return-Path: <linux-kernel-owner+w=401wt.eu-S1751841AbZKCN7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbZKCN7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZKCN7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:59:05 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38512 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZKCN7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:59:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PRUzF5rsBXR9rZlZQ6ZaGfoxHcnGGmOPkYSPSJbLY05/0PGWWncwy2PUaSs/UHfwh8
         bySaCg1JCyEjIYba7RRU8XwzZzz3RLTfx0409FAI08kzT4alm+Zi0N7MXA5cUKL2b+s6
         tUEfgbs17qQTX7owIlaIcKWEul0+1VoPZgd1Q=
MIME-Version: 1.0
In-Reply-To: <20091103134652.GB12841@linux-sh.org>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> 
	<1257242782-10496-5-git-send-email-alan-jenkins@tuffmail.co.uk> 
	<8bd0f97a0911030219y685a1dafy2a8e066d7132ac45@mail.gmail.com> 
	<4AF01F18.8040807@tuffmail.co.uk> <8bd0f97a0911030430s3ecb2467hc52ebac658c39ccd@mail.gmail.com> 
	<20091103132935.GA12841@linux-sh.org> <8bd0f97a0911030539s582598d6k2f78693bbfa559b0@mail.gmail.com> 
	<20091103134652.GB12841@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 3 Nov 2009 08:58:49 -0500
Message-ID: <8bd0f97a0911030558h58725a95m31bb2f73c0772547@mail.gmail.com>
Subject: Re: [PATCH 04/10] module: make MODULE_SYMBOL_PREFIX into a CONFIG 
	option
To: Paul Mundt <lethal@linux-sh.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 08:46, Paul Mundt wrote:
> On Tue, Nov 03, 2009 at 08:39:29AM -0500, Mike Frysinger wrote:
>> On Tue, Nov 3, 2009 at 08:29, Paul Mundt wrote:
>> > Having it in the Kconfig also makes it a nuisance for platforms that can
>> > use -elf and -linux toolchains for the same tree for different platforms.
>> > It would be nice to have this supported in such a way that we can just
>> > set a flag from the Makefile and have a compiler test that determines
>> > whether it is necessary or not.
>>
>> what arch is this an issue for ?  the only symbol prefixed arches are
>> Blackfin and H8300, and they dont provide toolchains that omit the
>> prefix.
>
> No, those are the only symbol prefixed platforms enabled in the kernel at
> present because neither one ships different toolchains.

and most likely never will.  the Blackfin symbol prefix is every
where, userspace included.

> The symbol prefixing itself is more an artifact of a -elf target
> contrasted with a -linux one than anything "platform" specific. Thus, any
> nommu platform using a bare metal or -elf toolchain can easily be used
> for building the kernel if this can be supported in a clean way. As such,
> a config option is not useful.

which has no bearing on the Blackfin case as every toolchain target
can currently be used to build the kernel

>> trying to enable symbol prefix support dynamically based on the
>> toolchain is a bad idea and pretty fragile.  the arch-specific
>> assembly code would have to be all rewritten to wrap all C-visible
>> symbols with a macro like VMLINUX_SYMBOL().
>
> There is nothing fragile about it, symbols are either prefixed or they
> aren't. The common case for things like the syscall table obiously have
> to be wrapped, but so what? C_SYMBOL_PREFIX() used to be the norm back in
> the day, so it obiously worked well enough for the common case.

it worked well when it was the *common* case as you said.  when people
rarely use it (which is what happens today), things constantly break
because no one tests it, the usage is awkward, and it's an artifact
that shouldnt exist in the first place.

>> i say let anyone who actually has such a system and wants to do such a
>> crazy ass thing put together a working arch first before we worry
>> about it.  the current code doesnt preclude dynamic hooking anyways
>> (manually adding -DCONFIG_xxx to CPPFLAGS).
>
> You talk about fragile bad ideas and then throw out defining Kconfig
> variables from Makefiles? This simply has no place in the Kconfig space,
> as it is now and always has been a toolchain property, not an
> architectural/platform one.

my point was that it can easily be mixed.  i personally could care
less where the symbol is declared so long as it's declared just once.

> The other thing you seem to have ignored is that pretty much everyone has
> such a system, it's only crippled platforms like blackfin and h8300 that
> don't support toolchains without the prefix.

"cripple" is exactly the right word.  why in the world do you want to
cripple people that dont need it ?  attempting to support busted
toolchains by forcing even more symbol prefix crap throughout an arch
makes no sense at all.  use the -fno-leading-underscore gcc option if
you want to re-use a non-standard symbol prefixed elf compiler to
build an arch.
-mike
