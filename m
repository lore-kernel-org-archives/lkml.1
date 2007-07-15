Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbXGOCtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbXGOCtJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 22:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXGOCs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 22:48:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:11862 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbXGOCs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 22:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HaHbxQdPSL1cgZDs9kpRF/Uc5GbI7DOyv3oZVpF11YarcIwA8Yx+PKOMi3XhPbPQhSaej7egQj7ujFO+pa2K/lFS/vbkBU+fNVDFcQJAK9mUH7znXQVeVw4oCKDorSupLoT5wS4cLfAtODX1D/4mx5coIXqkWn/me9rWZJRjFCk=
Message-ID: <787b0d920707141948t71b4059s7ae68610f9f81eac@mail.gmail.com>
Date: Sat, 14 Jul 2007 22:48:57 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: olaf@aepfle.de, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering writes:
> On Sat, Jul 14, H. Peter Anvin wrote:
>> Olaf Hering wrote:

>>> Declare PAGE_SIZE as getpagesize() for userspace.
>>> PAGE_SIZE is used in resource.h and shm.h
>>
>> I would think it would be better to not define it at all.
>> Several architectures already don't have PAGE_SIZE visible
>> to userspace in any way.
>
> i386 has it, so everyone uses it.

Since i386 was the first architecture and is still probably the
most common architecture (x86_64 being 30% AFAIK), i386 sets the
standard for the Linux API. Several architectures are broken and
thus suffering from incompatibility.

A real constant-value PAGE_SIZE is useful and doable.

It's useful because a getpagesize() can't be used for numerous
things, such as setting the size of an array.

It's doable, even on architectures that support multiple page
sizes, because ABIs specify alignment requirements. There are
two alignments of interest here:

a. the smallest that mmap() will ever naturally return on any
   correct implementation of the architecture's ABI ("naturally"
   meaning that MAP_FIXED was not used)

b. the smallest that mprotect() will tolerate on all
   correct implementations of the architecture

Pick either to be the Linux definition of PAGE_SIZE.

For example, if an architecture is specified to have a page size
of at least 4 K but no more than 64 K, then mprotect() will only
tolerate 64 K on all correct implementations of the architecture.
The ABI might allow mmap() to naturally return 4 K aligned data,
but might instead require 64 K alignment. Assuming 4 K, then the
mmap() value doesn't match the mprotect() value. Either one will
do as the value of PAGE_SIZE, as long as this is standardized in
the way that breaks the least code.
