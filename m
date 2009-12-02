Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZLBVaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZLBVaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbZLBVaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:30:12 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39481 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbZLBVaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:30:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gSKIg3KGH+nV6RhP0Kyoh5SzUVOw+8QxH09AM0dqXntto+iggaTqFQrYNyECqVDeQQ
         7rrXktqUKOE5Cw1aNzGWU/43fweaf0Vcid1/zdhiYm5KkI/VlSVfiyn04B07EsIlG9Al
         027yCUPeAx0VW0xZokDRnue5HXs0hlsr+G3lE=
MIME-Version: 1.0
In-Reply-To: <7946.1259761452@redhat.com>
References: <1259421863-12777-1-git-send-email-vapier@gentoo.org> 
	<7946.1259761452@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 2 Dec 2009 16:29:52 -0500
Message-ID: <8bd0f97a0912021329y7be05434wc9c39d383bfb7ce4@mail.gmail.com>
Subject: Re: [uClinux-dev] Re: [PATCH] FDPIC: respect PT_GNU_STACK exec 
	markings when creating NOMMU stack
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>,
       uClinux development list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 2, 2009 at 08:44, David Howells wrote:
> Mike Frysinger wrote:
>> that tends to be 128kB of waste.
>
> While your patch is reasonable, at least in concept, I don't see where you get
> this bit of the description from.

well, you need the rest of my sentence:
... it causes a pointless icache flush when starting every ...

so i mean iflushing the stack is a waste, and default FDPIC stack
tends to be 128kB

>> +                                      (executable_stack & EXSTACK_ENABLE_X ? PROT_EXEC : 0),
>
> executable_stack might be EXSTACK_DEFAULT, but the default might be to enable
> stack exec - in which case, this is wrong.
>
> I also don't think that the EXSTACK_xxx constants are a bitmask; I think
> they're an enumeration - in which case you shouldn't be using '&' to test
> them.  setup_arg_pages() uses '=='.

err, right, this probably should have read something like:
(executable_stack == EXSTACK_DISABLE_X ? 0 : PROT_EXEC)

> Further, I think it only matters for MMU and MPU modes, not for NOMMU mode.

it matters for all modes wrt the iflush that execution perms imply.
in terms of actually being able to execute anything (and having the
permissions respected), you are correct.  my concern was more for the
former issue ... the latter is just a nice side effect.

> There is one further consequence of your patch that you don't mention: the brk
> area _also_ becomes non-executable.  In NOMMU, I suspect this is irrelevant,
> as I'm not sure brk is used at all (should we make sys_brk() return ENOSYS?).

i didnt realize this ... that's why we have you here ;).  i have seen
a few apps use brk()/sbrk() to query the size of things (like
e2fsprogs), but not to try and increase mappings, let alone to try and
load dynamic code and jump there (i havent even seen this on mmu
systems).  certainly the uClibc malloc implementations dont use these
functions for nommu systems, nor would they work reliably since we
dont have the luxury of assuming the brk() space is wide open (since
it can easily be sitting against another mapping).

> How about the attached instead?

ive tested it and it works fine for me.  my fdpic apps get an exec
stack if the PT_GNU_STACK has E, and they dont if it doesnt.

> Probably VM_DATA_DEFAULT_FLAGS should not
> include VM_EXEC for either Blackfin or FRV, but it may be required for SH.
> The if-statement that calls elf_read_implies_exec() will be optimised away
> unless the arch specifically sets it (which none of FRV, Blackfin or SH do).

while true, wont the later personality test (in VM_DATA_DEFAULT_FLAGS)
be left there ?  guess it's not that big of a deal.

perhaps this define should be added to asm-generic/page.h though
rather than each arch.  the default value you use seems reasonable for
everyone.
-mike
