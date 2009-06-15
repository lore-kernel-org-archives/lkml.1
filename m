Return-Path: <linux-kernel-owner+w=401wt.eu-S1761699AbZFOPQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761699AbZFOPQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZFOPQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:16:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:41358 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbZFOPQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:16:41 -0400
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
From: Petr Tesarik <ptesarik@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
In-Reply-To: <20090612180626.GB18203@uranus.ravnborg.org>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
	 <20090612180626.GB18203@uranus.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Mon, 15 Jun 2009 17:16:42 +0200
Message-Id: <1245079002.17481.118.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg píše v Pá 12. 06. 2009 v 20:06 +0200:
> On Fri, Jun 12, 2009 at 03:40:32PM +0200, Petr Tesarik wrote:
> > The handling of various sections in the VDSO linker script
> > looks pretty haphazard. This patch series cleans it up in
> > these regards:
> > 
> >  - improve the coding style
> >  - remove superfluous sections
> >  - issue a linker error if a section is encountered which
> >    is known not to work
> >  - check that the .got section is empty, except for the
> >    three entries defined by the ABI
> >  - discard sections which are not useful to user-space
> > 
> > Petr Tesarik (8):
> >   x86: Adjust the coding style of vdso-layout.lds.S
> >   x86: Remove .sdata from the vDSO linker script
> >   x86: add .broken section to the vDSO linker script
> >   x86: mark altinstr-related sections in vDSO as broken
> >   x86: mark some standard sections as broken in a vDSO
> >   x86: check the size of GOT in vDSO
> >   x86: remove unneeded section from the vDSO
> The above looks good.
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> > 
> >   x86: Remove .dynbss from the vDSO linker script
> This one I am a little reluctant about as I do not understand
> why ld sometimes adds and sometimes does not add this section.
> At least judging from the arch specific linker scripts some archs
> include it and others do not.

The .dynbss section is a place to put symbols which are defined by
dynamic objects, are referenced by regular objects, and are not
functions. Space for these objects is allocated in the process image and
the dynamic linker copies the object data (using a copy relocation).

This is normally not needed, but if the process image uses the address
of a shared object in a read-only section, the link editor (ld) cannot
use the object in the DSO directly (since its address is only known at
runtime).

An example can probably explain it better:

$ cat >shared.c <<EOF
int shared_object[100];
EOF
$ cat >exe.c <<EOF
#include <stdio.h>
extern int shared_object[100];
int main(void) {
	printf("%p\n", &shared_object); 
	return 0;
}
EOF

It seems pretty obvious to me that a .dynbss section can never occur in
a DSO, because:

 1. a DSO must be position-independent, i.e. it cannot put absolute
    addresses into a constant section
 2. even if the DSO could do such a thing, the object is not allocated
    in the DSO; consequently, there will never be a copy relocation,
    and no need to have any data in .dynbss

I agree that the current documentation of the purpose of various ELF
sections is insufficient, so it's not easy to understand it. But I think
Roland also understands enough of it to confirm my reasoning.

I'm going to publish the knowledge I got during this vDSO excercise
soon.

Petr Tesarik


