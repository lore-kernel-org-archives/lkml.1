Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbXJCAoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbXJCAoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXJCAn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:43:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbXJCAn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:43:56 -0400
Message-ID: <4702E5C0.5040606@zytor.com>
Date: Tue, 02 Oct 2007 17:43:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@in.ibm.com>, lguest <lguest@ozlabs.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/5] Boot protocol changes
References: <1191368052.17826.40.camel@localhost.localdomain> <4702D867.2060100@goop.org> <4702D9E2.6020407@zytor.com> <4702DAB5.6090003@goop.org>
In-Reply-To: <4702DAB5.6090003@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>>> This series looks like a good start for Xen, but we still need to work
>>> out where to stash the metadata which normally lives in ELF notes. 
>>> Using ELF is convenient for Xen because it lets a large chunk of domain
>>> builder code be reused; on the other hand, loading a plain bzImage is
>>> pretty simple, so maybe it isn't such a big deal.
>>>
>>> HPA, Eric: if we don't go the "embed ELF" path, where's a good
>>> backwards-compatible place to stash the note data?  If we do go with
>>> "embed ELF", how should we go about doing it?  Arrange to put the ELF
>>> headers before the 1M mark?
>>>
>> This sounds like another good reason to do the ELF image as the
>> postcompression image.  The interface to the embedded compression
>> routine is then unchanged, and we get the "full vmlinux" with any
>> notes that belongs there.
>>
>> I'll try to get an implementation of that done -- it really shouldn't
>> be very hard.
> 
> Please explain what you're proposing again, because my memory of your
> plan from last time wouldn't help in this case.  Are you proposing that
> the bzImage contains compressed data that its expecting the bootloader
> to decompress?  Won't that completely break backwards compatibility?  If
> we don't care about backwards compatibility with old bootloaders, then
> it doesn't matter what we do one way or the other.
> 

No, not at all.

I'm proposing that the existing bzImage format be retained, but that the 
payload of the decompressor (already a gzip file) simply be vmlinux.gz 
-- i.e. a gzip compressed ELF file, notes and all.  A pointer in the 
header will point to the offset of the payload (this is new, obviously.)

The decompression stub is adjusted to expect an ELF image, instead of a 
raw binary.

Existing bootloaders (16- or 32-bit) simply load the bzImage the way 
they do now; new bootloaders have the option of accessing the vmlinux.gz 
directly if they either want to load it themselves or want to examine 
the notes.

	-hpa

