Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZKUACg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZKUACg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 19:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZKUACf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 19:02:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:15036 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZKUACe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 19:02:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BDmcledbapnmEOtUbDcfau9aNFClL0rCj+jWpwj3gsP76s2WK3+XPSyzuXzAKWUb4W
         NbhAID0iDBOnbwivRVTTL33x2dvceLy5nVnE6xB+qO5nzXqdkJQo2emIxc/kwx7/I79B
         fTXcSQDsOCH5UWuX1Tl5Nfi3yaFpac8d3dQIY=
Message-ID: <4B072E31.4000906@tuffmail.co.uk>
Date: Sat, 21 Nov 2009 00:02:57 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Mike Frysinger <vapier.adi@gmail.com>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, achiang@hp.com, kyle@mcmartin.ca,
       deller@gmx.de, jejb@parisc-linux.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the
 kernel (__ksymtab)
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>	 <20091104171916.GA6323@merkur.ravnborg.org>	 <4AF2E00A.3010107@tuffmail.co.uk>	 <200911091347.57286.rusty@rustcorp.com.au> <12c511ca0911201420i5f2d4751m25ae5288b69dbabb@mail.gmail.com>
In-Reply-To: <12c511ca0911201420i5f2d4751m25ae5288b69dbabb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> The sorted ksymtab breaks ia64 (and possibly ppc64 and
> parisc too).
>
> Alex Chiang did the bisect to find this change as
> the cause of the breakage.  The problem is that ia64
> expects that the first item in each ksymtab entry to be
> a function pointer.  The code in modpost that creates
> .tmp_exports-asm.S doesn't know about types of exported
> objects, so it uses __EXPORT_SYMBOL from linux/mod_export.h
> for everything. This results in
>
>         PTR SYM(sym);
>         PTR SYM(__kstrtab_##sym);
>
> which the preprocessor expands to entries like:
>
>         .long ____pagevec_lru_add
>         .long __kstrtab____pagevec_lru_add
>
> which puts the address of the first instruction of the
> function into the table, rather than the address of a
> function pointer (which on ia64 is a two element data
> object containing the code address and the global data
> pointer).
>
> The syntax you need for this* is:
>
>         .long @fptr(____pagevec_lru_add)
>         .long __kstrtab____pagevec_lru_add
>
> Note that you must only use the @fptr(name) syntax for
> function exports. Exported data items just need an address.
>
> -Tony
>
> * On ia64 ... powerpc and parisc might need something else.
>   

Thanks!  It doesn't sound too hard to retro-fit your suggestion.

Still, I can't help wondering if I've done this all wrong :-/.  Perhaps 
I should avoid the assembler.  Instead, I could write a tool to sort the 
ksymtab elf sections in-place (and mangle their relocations 
accordingly).  That should preserve any special handling for function 
symbols without arch-specific special cases.  It would also concentrate 
all the magic in one tool - rather than it being scattered between the 
modpost tool, mod_export.h, tmp_exports.S, and vmlinux.lds.h.

Alan
