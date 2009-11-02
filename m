Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZKBQwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZKBQwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbZKBQwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:52:45 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65256 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbZKBQwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:52:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=V0nX5FN1ZTP/jQ/Y4gYxgvL0l2diSxlmT/JQljEGsUInveQWi7c7OMSTa8/XoTupZs
         3gjUgiDqQP4U1kmbChq7eumiv1cdRH0hbaQ7pr1ZGaCDS5Dyp01vFo6VusbODMxeP5kS
         0Sh4ziWHZqTAr9yv9KEn4nJlO8txPnwv5QtDc=
MIME-Version: 1.0
Date: Mon, 2 Nov 2009 16:52:47 +0000
Message-ID: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
Subject: Re: Fast LKM symbol resolution
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Carmelo Amoroso <carmelo73@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's my latest code using binary search for symbol resolution.  This
version has benefited from a little more testing (heh), in particular
running on a simulated ARM system.

    web: <http://github.com/sourcejedi/linux-2.6/commits/module-V2-beta1>

    git clone git://github.com/sourcejedi/linux-2.6.git module-V2-beta1

As before, it saves 0.3s boot time for a modular kernel on my netbook
(630 Mhz Celeron M).  On that system it represents something like 90%
of the maximum possible speedup.  It is claimed that slower systems
would benefit from a further speedup (e.g. using hash tables instead),
but we don't have any numbers to illustrate this yet.


Changes since the original patches were posted:

1) The sorted version of the exports is now generated in
arch-independent assembly language, as .tmp-exports-asm.S.  It uses
similar pseudo-instructions to those in the current .tmp-kallsyms.S.

Previously the sorted exports were generated in C, but the compiler
outputted them in reverse order.  This was made to work by reversing
the comparison used in binary search, but it was a brittle hack.

This means mod_export.h now includes two implementations of
EXPORT_SYMBOL; one for general use in C code, and one for use in
.tmp-exports-asm.S.

2) In vmlinux.lds.h, the unsorted exports are now discarded in the
DISCARDS macro.

Previouslly they were discarded before including the sections of
sorted exports.  This broke the ARM build by discarding some unrelated
symbols too early.  It appears that a) the position of /DISCARD/
directives is signficant; b) all /DISCARD/ directives are merged
together and applied at the point of the first /DISCARD/ directive.

3) Now lightly tested on ARM (using qemu)

To build on ARM it was necessary to remove EXPORT_ALIAS, used in
armksyms.c for the sole purpose of allowing out of tree floating point
emulation code to be loaded as a module.  I have posted this change on
the ARM list and received no comments either way.

4) Build-tested on blackfin (a MODULE_SYMBOL_PREFIX arch)

This required that MODULE_SYMBOL_PREFIX be defined via a Kconfig
option, CONFIG_HAVE_SYMBOL_PREFIX.  Up until now it has been defined
in <asm/module.h> - but this also includes C declarations, which made
it impossible to use in .tmp-exports-asm.S.

Alan
