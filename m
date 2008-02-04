Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYBDU3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYBDU3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYBDU2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:28:55 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50715 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593AbYBDU2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:28:53 -0500
Date: Mon, 4 Feb 2008 21:28:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, bryan.wu@analog.com, hskinnemoen@atmel.co,
       dhowells@redhat.com
Subject: Re: [patch 0/4] cleanup - use _AC macro to define PAGE_SIZE
Message-ID: <20080204202857.GB16919@uranus.ravnborg.org>
References: <47a5a65d.03eb300a.07b8.130e@mx.google.com> <20080203122239.GF20810@uranus.ravnborg.org> <8bd0f97a0802041201w326404b6j25c20951ee35b0b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0802041201w326404b6j25c20951ee35b0b6@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 03:01:30PM -0500, Mike Frysinger wrote:
> On Feb 3, 2008 7:22 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Sun, Feb 03, 2008 at 02:22:17PM +0300, Cyrill Gorcunov wrote:
> > > This patch series removes code duplication for PAGE_SIZE
> > > definition on various architectures.
> > >
> > > Please review. Any comments are welcome. *UNTESTED*
> >
> > Looks good.
> > Could you do a followup patch for each architecture introducing
> > use of PAGE_SIZE in their respective kernel/vmlinux.lds.S too?
> > I think more than your 4 listed architectures could need this fix.
> 
> what did you have in mind exactly ?  afaik, the Blackfin linker script
> should already be friendly wrt using defines instead of hardcoded
> constants ...
Blackfin look ok.
Lets take following code snippet from blackfin:
       .init.text :
        {
                . = ALIGN(PAGE_SIZE);
                __sinittext = .;
                INIT_TEXT
                __einittext = .;
        }


And a grep quicly reveals:

m32r/kernel/vmlinux.lds.S-  . = ALIGN(4096);            /* Init code and data */
m32r/kernel/vmlinux.lds.S-  __init_begin = .;
m32r/kernel/vmlinux.lds.S-  .init.text : {
m32r/kernel/vmlinux.lds.S-      _sinittext = .;
m32r/kernel/vmlinux.lds.S:      INIT_TEXT
m32r/kernel/vmlinux.lds.S-      _einittext = .;
m32r/kernel/vmlinux.lds.S-  }
m32r/kernel/vmlinux.lds.S-  .init.data : { INIT_DATA }
m32r/kernel/vmlinux.lds.S-  . = ALIGN(16);
m32r/kernel/vmlinux.lds.S-  __setup_start = .;
--
m68knommu/kernel/vmlinux.lds.S-
m68knommu/kernel/vmlinux.lds.S- .init : {
m68knommu/kernel/vmlinux.lds.S-         . = ALIGN(4096);
m68knommu/kernel/vmlinux.lds.S-         __init_begin = .;
m68knommu/kernel/vmlinux.lds.S-         _sinittext = .;
m68knommu/kernel/vmlinux.lds.S:         INIT_TEXT
m68knommu/kernel/vmlinux.lds.S-         _einittext = .;

It is maybe common knowledge that 4096 is equal to PAGE_SIZE
but it is more descriptive to use a constant.

As for sparc64 where we fixed this recently it was a bug since the
page size are configuration dependent.

So I just ask to use appropriate constants when they are
already available and visible from the vmlinux.lds.S files.

Consistent indenting in all vmlinux.lds.S files would also
be good - but I am still missing a third of them.
Blackfin looks good also in this respect.

	Sam
