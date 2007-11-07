Return-Path: <linux-kernel-owner+w=401wt.eu-S1759603AbXKGXav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbXKGXav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXKGXao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:30:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757187AbXKGXan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:30:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1194473220.11490.93.camel@pmac.infradead.org>
References: <1194473220.11490.93.camel@pmac.infradead.org> <20071107174323.31820.65054.stgit@warthog.procyon.org.uk> <20071107174328.31820.62935.stgit@warthog.procyon.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 1/2] Suppress A.OUT library support in ELF binfmt if !CONFIG_BINFMT_AOUT [try #3]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 07 Nov 2007 23:30:33 +0000
Message-ID: <1784.1194478233@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> wrote:

> Ew, no. This is horridly broken. You should never use CONFIG_xxx_MODULE
> in the static kernel at all -- and you should _especially_ not be using
> it in header files which are exported to userspace.

AOUT support can be mostly built into a module, but a small part of it that is
arch-specific still gets built into the main kernel.  *That* is the main thing
that is wrong.

I suppose it might be possible to move those bits of the main kernel into
inline functions in asm/a.out.h and thus include them directly in
binfmt_aout.ko.

> This abomination certainly doesn't seem to have any direct relation to
> mn10300 support -- I think all you really need there is not to attempt
> to export {asm,linux}/a.out.h if asm/a.out.h doesn't exist, which is
> something you haven't attempted here anyway.

No, it's not that simple.  If asm/a.out.h doesn't exist, then various bits of
the kernel break that shouldn't.  fs/binfmt_elf.c for example.  fs/exec.c for
another.  They *expect* bits of the asm/a.out.h and linux/a.out.h to exist -
which they shouldn't.

Not exporting them isn't by itself sufficient.  The required constants
themselves are not defined for an arch that doesn't have the support, and so
the core code must not depend on them.  This patch fixes that.

Furthermore, STACK_TOP and STACK_TOP_MAX don't belong in asm/a.out.h as far as
I can tell.  They should probably be wherever TASK_SIZE resides (ie:
asm/processor.h).

David
