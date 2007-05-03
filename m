Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbXECNYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbXECNYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXECNYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:24:19 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55395 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXECNYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:24:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <4634483E.9030307@goop.org>
	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org>
	<46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org>
	<4638F9BE.8090508@zytor.com> <4638FC39.4010101@goop.org>
	<4638FE1B.9050901@zytor.com> <46390523.5010809@goop.org>
	<463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com>
	<m1tzuuv24z.fsf@ebiederm.dsl.xmission.com> <463989BD.6040603@goop.org>
Date: Thu, 03 May 2007 07:23:31 -0600
In-Reply-To: <463989BD.6040603@goop.org> (Jeremy Fitzhardinge's message of
	"Thu, 03 May 2007 00:05:33 -0700")
Message-ID: <m1ps5iujl8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> OK, whatever you think will work.  But I do think it should be a proper
> ELF file with a correct magic number, so that you can just point an ELF
> file parser at it and have it work (which means, of course, that all the
> file offsets are offsets from the start of the Ehdr, rather than from
> the start of the bzImage).

Yes.  I guess in this context, I am generally for building the ELF
headers by hand instead of with a linker script, because then we
know exactly what is happening and can ensure everything is just so.

> You haven't specifically commented on using the Phdrs as a way of
> specifying the mappings required for decompression and early kernel
> execution.  It seems pretty natural to me, but I guess that raises the
> general question of what execution environment the kernel can expect to
> find itself in, and which modes of booting will actually enable paging
> and establish any kinds of mapping at all.

Sorry, for not being clear I have been expecting to do this for years,
it is one of the reasons I keep coming back to putting an ELF header
on the bzImage.  arch/x86_64/kernel already does this to some extent
as it has to setup up some identity page mappings for itself in the
case it has to do the switch from real to protected mode itself.

> In the Xen case, its obviously the domain builder who creates the
> mappings, and we can easily implement p != v mappings.  But when booting
> native, presumably paging is off at this stage, and only identity maps
> can be implemented.  I guess the rough rule is that if paging is enabled
> on entry, the kernel should expect all the bzImage mappings to be in
> place, but if paging is off, well, the question is moot.

Right.  Except that there is a bit of a catch 22 in the
para-virtualized environments of setting up the page tables, I'm not
at all certain what the gain of setting up p != v mappings are.

Having just written some C code that runs fairly successfully in p !=
v, on arch/i386 I'm not too concerned.  arch/x86_64 ought to work with
a similar level of effort although the expectations there are a little
different. So while I don't necessarily considering running in p != v
when compiled to run at v general it should work for the cases we
are interested in.  Setting up the page tables for arch/x86_64 will
be more interesting.

Part of what I find compelling about this is our initial page tables
for linux have always had more going on than the virtual addresses
just being at a constant offset from of the physical addresses, so
the actions of the current domain builders have me concerned that they
may be violating some early linux booting assumptions and are
currently just getting lucky.  Moving the page table setup code into
the kernel removes that dependency from the domain builders.

Eric
