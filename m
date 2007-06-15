Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbXFOMNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbXFOMNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXFOMLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:11:42 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55134 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbXFOMLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:11:36 -0400
Date: Fri, 15 Jun 2007 06:11:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Message-ID: <20070615121133.GF8154@parisc-linux.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <1181897905.26853.66.camel@localhost.localdomain> <200706151128.39566.arnd@arndb.de> <200706151131.38429.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706151131.38429.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 11:31:37AM +0200, Arnd Bergmann wrote:
> One common problem with 32 bit system call and ioctl emulation
> is the different alignment rules between i386 and 64 bit machines.
> A number of drivers work around this by marking the compat
> structures as 'attribute((packed))', which is not the right
> solution because it breaks all the non-x86 architectures that
> want to use the same compat code.
> 
> Hopefully, this patch improves the situation, it introduces two
> new types, compat_u64 and compat_s64. These are defined on all
> architectures to have the same size and alignment as the 32 bit
> version of u64 and s64.

You're relying on compat_[us]64 being only used in structures which are
already packed.  If someone uses them in a non-packed struct, they won't
decrease the alignment.  I think it would be more effective to specify
it as:

__attribute__((aligned(4), packed))

The other problem is that if someone defines a struct like this:

struct foo {
	short bar;
	compat_s64 baz;
} __attribute__((packed))

it'll have different definitions on x86 and ia64.

So I think we should be aiming for the ((aligned, packed)) definition and
remove the __attribute__((packed)) from the struct definitions.  What do
you think?
