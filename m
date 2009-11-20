Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZKTWT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZKTWT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 17:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZKTWT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 17:19:56 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58731 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbZKTWTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 17:19:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZjmeSqycnqXcwFi9zNb4zogQy+O+drYCHZXJ3ypQe3w8gLcN+NjdZBgzcJ4U1Pf61V
         +qpkBlCd39noW+sRUW6zROvMbJ8B3CV70pGPV8m4yyLYhRiTwyg4wKQp0O1Kt+nCiDZq
         tYGjBVCA575V+ZhdR60Ody0NTgOHq0v780yl8=
MIME-Version: 1.0
In-Reply-To: <200911091347.57286.rusty@rustcorp.com.au>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
	 <20091104171916.GA6323@merkur.ravnborg.org>
	 <4AF2E00A.3010107@tuffmail.co.uk>
	 <200911091347.57286.rusty@rustcorp.com.au>
Date: Fri, 20 Nov 2009 14:20:01 -0800
Message-ID: <12c511ca0911201420i5f2d4751m25ae5288b69dbabb@mail.gmail.com>
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the 
	kernel (__ksymtab)
From: Tony Luck <tony.luck@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier.adi@gmail.com>,
       greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, achiang@hp.com, kyle@mcmartin.ca,
       deller@gmx.de, jejb@parisc-linux.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sorted ksymtab breaks ia64 (and possibly ppc64 and
parisc too).

Alex Chiang did the bisect to find this change as
the cause of the breakage.  The problem is that ia64
expects that the first item in each ksymtab entry to be
a function pointer.  The code in modpost that creates
.tmp_exports-asm.S doesn't know about types of exported
objects, so it uses __EXPORT_SYMBOL from linux/mod_export.h
for everything. This results in

        PTR SYM(sym);
        PTR SYM(__kstrtab_##sym);

which the preprocessor expands to entries like:

        .long ____pagevec_lru_add
        .long __kstrtab____pagevec_lru_add

which puts the address of the first instruction of the
function into the table, rather than the address of a
function pointer (which on ia64 is a two element data
object containing the code address and the global data
pointer).

The syntax you need for this* is:

        .long @fptr(____pagevec_lru_add)
        .long __kstrtab____pagevec_lru_add

Note that you must only use the @fptr(name) syntax for
function exports. Exported data items just need an address.

-Tony

* On ia64 ... powerpc and parisc might need something else.
