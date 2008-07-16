Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYGPCGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYGPCGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 22:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbYGPCG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 22:06:28 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45852 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835AbYGPCG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 22:06:27 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080715221826.GD4280@redhat.com>
References: <1216146802.3312.95.camel__45052.4692344063$1216146917$gmane$org@localhost.localdomain>
	 <y0mr69vj5p0.fsf@ton.toronto.redhat.com>
	 <1216151526.3312.102.camel@localhost.localdomain>
	 <20080715200718.GC4280@redhat.com>
	 <1216153462.3312.126.camel@localhost.localdomain>
	 <20080715221826.GD4280@redhat.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 21:06:23 -0500
Message-Id: <1216173983.3312.183.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 18:18 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Tue, Jul 15, 2008 at 03:24:22PM -0500, James Bottomley wrote:
> > [...]
> > > > > > This is highly undesirable because it represents a subversion of the
> > > > > > kernel API to gain access to unexported symbols.
> > > [...]
> > > Maybe, but what "subversion" are you talking about?
> > 
> > using a hand crafted relocation function to gain access to kernel
> > symbols instead of the provided API.
> 
> Please choose your words more carefully.  We don't "subvert" anything,
> where one would mean sneaking around some sort of protection.

Actually, I did and you do.  One of the OED's definition of subvert is
"to undermine or overturn a condition or order of things, a principle or
a law etc."  In this particular case, this:

commit 3a872d89baae821a0f6e2c1055d4b47650661137
Author: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date:   Mon Oct 2 02:17:30 2006 -0700

    [PATCH] Kprobes: Make kprobe modules more portable
 
Which provided a portable input to kprobes (the symbol_name/offset one)
and revoked the global accessibility of the kallsyms_lookup_name().

The design was for kprobes users to stop using kallsyms_lookup_name()
and to use the symbol_name/offset instead.  What systemtap did is code
its own _stp_module_lookup() as a fairly direct replacement for
kallsyms_lookup_name().  That's deliberately overturning the condition
or order of things, because you deliberately ignored the specific
replacement API in rolling your own, hence subversion.

It's actually worse than this, though.  The kernel API isn't fixed in
stone, it evolves usually by trying to make problematic use cases
better.  By refusing to consider using the replacement API, you lost the
opportunity to point out the shortcomings and negotiate for a better
one, so it's languished for two years with no real testing or update.
Worse still, you cut yourself off from the development flow of the
kernel and effectively forked a private API for you own use.  Now,
because of this, most kernel developers will be far less inclined to
listen to your input because you've chosen not to listen to theirs.  The
give and take of open source development that produces the virtuous
circle of innovation is broken.  To redress this, you have to use the
correct API and begin engaging in the dialogue which stalled two years
ago.

But let's examine the consequences objectively.  I have a simple single
probe file:

probe kernel.statement("*@block/bsg.c:144") {
        print ("here\n");
}

It emits a single probe and produces this in the module build:

-rw-r--r-- 1 root root  17996 2008-07-15 20:45 stap_2154.c

About 600 lines.

However, it also needs this for the symbol table:

-rw-r--r-- 1 root root 446137 2008-07-15 20:45 stap-symbols.h

About 12,500 lines just for the symbols.

Together these produce a module

-rw-r--r-- 1 root root 652509 2008-07-15 20:46 stap_2154.ko

That's well over half a megabyte largely because of the symbols.

By now the embedded guys are already having WTF attacks about your
module wanting a significant portion of their available ram ... and so
on ... Are you seriously arguing that a good 0.6MB of bloat just because
you refuse to use a provided API is a good thing?

I'm afraid this is your classic fish or cut bait issue:  You can choose
either to engage in dialogue with the kernel community, try to use the
provided API and improve it based on demonstrated use cases (and if you
choose to do this, I can help you with it, since interaction will need
to go both ways) and thus benefit from the open source innovation
stream, or you can keep within your own community, eschewing the broader
kernel development community, ignoring their feedback and spending all
your effort constructing work arounds for what you consider to be kernel
problems leading the systemtap users to be unhappy and Sun Marketing
pulverising us over our lack of useful tracing tools.

Which is it to be?

James


