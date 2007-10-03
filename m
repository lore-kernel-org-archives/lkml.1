Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbXJCBD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbXJCBD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXJCBDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:03:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41748 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbXJCBDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:03:49 -0400
Message-ID: <4702EA68.3090900@zytor.com>
Date: Tue, 02 Oct 2007 18:03:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@in.ibm.com>, lguest <lguest@ozlabs.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/5] Boot protocol changes
References: <1191368052.17826.40.camel@localhost.localdomain> <4702D867.2060100@goop.org> <4702D9E2.6020407@zytor.com> <4702DAB5.6090003@goop.org> <4702E5C0.5040606@zytor.com> <4702E925.70200@goop.org>
In-Reply-To: <4702E925.70200@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> I'm proposing that the existing bzImage format be retained, but that
>> the payload of the decompressor (already a gzip file) simply be
>> vmlinux.gz -- i.e. a gzip compressed ELF file, notes and all.  A
>> pointer in the header will point to the offset of the payload (this is
>> new, obviously.)
>>
>> The decompression stub is adjusted to expect an ELF image, instead of
>> a raw binary.
> 
> It could, or just treat it as a raw binary at 1M+offset to skip the headers.

It would be cleaner to actually parse the ELF; it's only a handful of 
lines of code (we don't have to support arbitrary placement of sections, 
obviously, which makes the problem simpler.)

>> Existing bootloaders (16- or 32-bit) simply load the bzImage the way
>> they do now; new bootloaders have the option of accessing the
>> vmlinux.gz directly if they either want to load it themselves or want
>> to examine the notes. 
> 
> OK, but that has the same problem as making the payload an ELF file:
> 32-bit bootloaders which simply jump to 1M will be jumping into data
> rather than code - and I got the impression from taking to Eric at KS
> that there are such bootloaders.  

Uhm, no it doesn't.  Those bootloaders jump to the decompressor, not to 
the payload.  The decompressor interface hasn't changed.

> If that's not an issue, then I still think the payload should be a plain
> ELF file (possibly self-decompressing, or just a plain uncompressed
> vmlinux, if that's what's desired).  Still think making a protected-mode
> bootloader do the decompression is the wrong way to go about this; ELF
> is enough.

It doesn't have to if it doesn't want to; it only needs to do so if it 
wants to access the kernel as an ELF.  Again, it has the advantage that 
the ELF is the real vmlinux, no funnies.

	-hpa
