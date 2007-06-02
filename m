Return-Path: <linux-kernel-owner+w=401wt.eu-S1762222AbXFBA7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762222AbXFBA7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbXFBA7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:59:10 -0400
Received: from gw.goop.org ([64.81.55.164]:49817 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbXFBA7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:59:08 -0400
Message-ID: <4660C0CD.5060606@goop.org>
Date: Fri, 01 Jun 2007 17:58:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org> <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <466087CF.70708@goop.org> <4660924A.2070009@zytor.com> <466093E3.4010701@goop.org> <46609636.4050208@zytor.com> <4660BBDF.1040007@goop.org> <4660BCF8.7000208@zytor.com>
In-Reply-To: <4660BCF8.7000208@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> That's a method of defining the memory space.
>
> I think the current definition is suitable for entering at the 16-bit
> entry point.

I agree.  I'm going to assume that if we're booting all the way up from
real mode, we're either on real hardware, or some environment that's
trying hard to be real hardware.  In that case, there won't necessarily
be much need for the subarch-specific data, but even if there is, it can
be way out of the real-mode address space, and therefore be a non-issue
for 16-bit code.

Just to clarify:

In my proposal is that we have bzImage structured something like (where
"|" is concatenation, and "()" is a  blob containing stuff):

    bzImage = 16-bit setup | ELF file (decompressor, compressed kernel)
      

With the intention that 32-bit only bootloader always loads the ELF file
as-is and just runs it.  Aside from the fact that its an ELF file,
there's nothing else about it which really concerns the bootloader,
since once its loaded and running, it does all its own setup.  Its not
clear that code32_start really means much in this case, though I guess
it could point to the same place as the ELF file's entrypoint.

Whereas you're proposing:

    bzImage = 16-bit setup | decompressor | compressed kernel (ELF file)
      

where code32_start points to the decompressor, and some other pointer
points to the compressed kernel data.  And your intent is that an
external bootloader could also interpret the compressed kernel image,
and identify what format its in and handle it appropriately from
outside.  Right?

In both cases, it seems to me that we need an extra boot_param pointer
to point to the offset of the payload blob (ELF file in my case,
compressed kernel in yours).  Yes?

    J
