Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbZFRPZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbZFRPZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZFRPZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:25:03 -0400
Received: from mail-yx0-f192.google.com ([209.85.210.192]:38285 "EHLO
	mail-yx0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZFRPZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=oKeQ80ESldTgcmVBwcIvC2PJhdIHNcsOCKYz49toBWdGaVOvmlSnBDkPi8m4lZd40C
         HdxNYU1LwiF0dX+lYjFYvSufxeH7oinNVByqFNkzMSpwhzNMTR2znObtfBi0ziXfuRVw
         O6pllZwtdActoMokDvnVEzCP9/Igw4rkvYJN8=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 18 Jun 2009 11:24:44 -0400
Message-ID: <8bd0f97a0906180824y17a00110i57565aee16207e5@mail.gmail.com>
Subject: module version magic and arches with symbol prefixes
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the current check_modstruct_version() does this:
{
    const unsigned long *crc;

    if (!find_symbol("module_layout", NULL, &crc, true, false))
        BUG();
    return check_version(sechdrs, versindex, "module_layout", mod, crc);
}
the trouble here is that it looks for a literal "module_layout" symbol
and for ports that have symbol prefixes (a quick check shows Blackfin
& h8300), this aint going to work.

i tried to hack it in the Blackfin port by add this to the linker script:
module_layout = _module_layout
but that didnt seem to work.  maybe kallsysms couldnt find it or i
need to hack a different name ...

we could add a new function to asm-generic/sections.h:
#ifndef arch_symbol_name
#define arch_symbol_name(sym) sym
#endif
and in the case of Blackfin systems, we'd do:
#define arch_symbol_name(sym) "_" sym

no other consumer of find_symbol() has a problem because they're all
dynamic -- they scan the modules for required symbols and then scan
the kernel for those, so all the symbol prefixes line up.

that would fix the find_symbol() invocation, and check_version()
wouldnt need changing because in that case, it's look for the literal
symbol that scripts/mod/modpost.c is adding -- "module_layout" in this
case.

also, using BUG() here seems pretty damn harsh.  wouldnt it make more
sense to do something like:
    if (WARN_ON(!find_symbol("module_layout", NULL, &crc, true, false)))
        return 0;
this way the module is simply not loaded rather than killing the kernel
-mike
