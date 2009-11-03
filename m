Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZKCNjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZKCNjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZKCNjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:39:44 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:37973 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbZKCNjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:39:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=A4ZVsrNvYFMpNdCm0mr8OM8nSBtVUj8CSv0VNUpXPHrpCCkIsOaoxPRHBsnyrD+ln8
         QYY1pnKO30uRCvmZ9Mv50NtuO6YWyz4tsZs/ONrGcO/9NKtHRh7CZaZOant+JkbaBzku
         LzokQYP0BlIKdagAvkdYa7zWuR2HdrhLfXmvs=
MIME-Version: 1.0
In-Reply-To: <20091103132935.GA12841@linux-sh.org>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> 
	<1257242782-10496-5-git-send-email-alan-jenkins@tuffmail.co.uk> 
	<8bd0f97a0911030219y685a1dafy2a8e066d7132ac45@mail.gmail.com> 
	<4AF01F18.8040807@tuffmail.co.uk> <8bd0f97a0911030430s3ecb2467hc52ebac658c39ccd@mail.gmail.com> 
	<20091103132935.GA12841@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 3 Nov 2009 08:39:29 -0500
Message-ID: <8bd0f97a0911030539s582598d6k2f78693bbfa559b0@mail.gmail.com>
Subject: Re: [PATCH 04/10] module: make MODULE_SYMBOL_PREFIX into a CONFIG 
	option
To: Paul Mundt <lethal@linux-sh.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 08:29, Paul Mundt wrote:
> On Tue, Nov 03, 2009 at 07:30:20AM -0500, Mike Frysinger wrote:
>> On Tue, Nov 3, 2009 at 07:16, Alan Jenkins wrote:
>> > Mike Frysinger wrote:
>> >> On Tue, Nov 3, 2009 at 05:06, Alan Jenkins wrote:
>> >>> The next commit will require the use of MODULE_SYMBOL_PREFIX in
>> >>> .tmp_exports-asm.S. ??Currently it is mixed in with C structure
>> >>> definitions in "asm/module.h". ??Move the definition of this arch option
>> >>> into Kconfig, so it can be easily accessed by any code.
>> >>>
>> >>> This also lets modpost.c use the same definition. ??Previously modpost
>> >>> relied on a hardcoded list of architectures in mk_elfconfig.c.
>> >>
>> >> this should also let us push VMLINUX_SYMBOL() out of
>> >> arch/*/kernel/vmlinux.lds.S and into asm-generic/vmlinux.lds.h ...
>> >
>> > I don't think that's possible.
>> >
>> > ?? #define VMLINUX_SYMBOL(_sym_) _##_sym_
>> >
>> > I don't know any "unstringify" operation. ??So I can't convert a string value
>> > of CONFIG_SYMBOL_PREFIX to the unquoted underscore we neeed for this macro.
>> > ??The same applies for the SYM() macro I use.
>>
>> let the build system do the unstringify operation.
>> qstrip = $(strip $(subst ",,$(1)))
>> CPPFLAGS_vmlinux.lds += -DVMLINUX_SYMBOL_PREFIX=$(call
>> qstrip,CONFIG_SYMBOL_PREFIX)
>>
>> > If we positively want to keep the generality, I guess I should put
>> > MODULE_SYMBOL_PREFIX in a header file of it's own. ??The disadvantage is that
>> > it makes it inaccessible to host programs again, like modpost (which
>> > currently hardcodes the list of affected architectures in mk_elfconfig.c).
>>
>> having it in the arch Kconfig removes any and all possible
>> limitations, and it keeps the cruft out of the common init/Kconfig and
>> in the arch-specific Kconfig, and avoids a dead symbol
>> (HAVE_SYMBOL_PREFIX)
>
> Having it in the Kconfig also makes it a nuisance for platforms that can
> use -elf and -linux toolchains for the same tree for different platforms.
> It would be nice to have this supported in such a way that we can just
> set a flag from the Makefile and have a compiler test that determines
> whether it is necessary or not.

what arch is this an issue for ?  the only symbol prefixed arches are
Blackfin and H8300, and they dont provide toolchains that omit the
prefix.

if anything, the common build code could easily do:
ifeq ($(CONFIG_SYMBOL_PREFIX),)
CFLAGS += $(call cc-option,-fno-leading-underscore)
endif

trying to enable symbol prefix support dynamically based on the
toolchain is a bad idea and pretty fragile.  the arch-specific
assembly code would have to be all rewritten to wrap all C-visible
symbols with a macro like VMLINUX_SYMBOL().

i say let anyone who actually has such a system and wants to do such a
crazy ass thing put together a working arch first before we worry
about it.  the current code doesnt preclude dynamic hooking anyways
(manually adding -DCONFIG_xxx to CPPFLAGS).
-mike
