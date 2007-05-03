Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbXECHFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbXECHFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbXECHFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:05:33 -0400
Received: from gw.goop.org ([64.81.55.164]:42853 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbXECHFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:05:31 -0400
Message-ID: <463989BD.6040603@goop.org>
Date: Thu, 03 May 2007 00:05:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       Gerd Hoffmann <kraxel@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org>	<46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org>	<4638F9BE.8090508@zytor.com> <4638FC39.4010101@goop.org>	<4638FE1B.9050901@zytor.com> <46390523.5010809@goop.org>	<463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com> <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@in.ibm.com> writes:
>
>   
>> On Wed, May 02, 2007 at 02:59:11PM -0700, H. Peter Anvin wrote:
>>     
>>> Jeremy Fitzhardinge wrote:
>>>       
>>>> So the bzImage structure is currently:
>>>>
>>>>    1. old-style boot sector
>>>>    2. old-style boot info, followed by 0xaa55 at the end of the sector
>>>>    3. the HdrS boot param block
>>>>    4. setup.S boot code
>>>>    5. the self-decompressing kernel
>>>>
>>>> If we make 5 actually an ELF file, containing properly formed Ehdr,
>>>> Phdrs (for all the mappings required), and the actual kernel
>>>> decompressor, relocator and compressed kernel data, then it would be
>>>> easy for the Xen domain builder to find that and use it as a basis for
>>>> loading.  I think it would just require the bzImage boot param block to
>>>> contain an offset of the start of the ELF file.  The contents of the ELF
>>>> file would be in a form where the normal boot code could just jump over
>>>> the ELF headers, directly into the segment data itself.
>>>>
>>>> ie:
>>>>
>>>>    1. old-style boot sector
>>>>    2. old-style boot info, followed by 0xaa55 at the end of the sector
>>>>    3. the HdrS boot param block
>>>>    4. setup.S boot code (jumps directly into 5.3)
>>>>    5. 32-bit self-decompressing kernel:
>>>>          1. Ehdr
>>>>          2. Phdrs for all necessary mappings
>>>>          3. decompressor/relocator .text
>>>>          4. compressed kernel data
>>>>
>>>> Does that sound reasonable?
>>>>
>>>>         
>>> I don't know if that would break any programs that are currently
>>> bypassing the setup.
>>>       
>
> I think everything will break, unless we make 5.1 and 5.2 
> into 4.2 and 4.3.  In the above design.
>
>   
>> I think kexec bzImage loader will break. It bypasses the setup code and
>> directly jumps to the code present after setup sectors(decompressor).
>>     
>
> Quite likely.    The boot sector except for a handful of bytes actually
> goes unused so we can put extra header information there, I actually
> have patches for placing an ELF header there.

OK, whatever you think will work.  But I do think it should be a proper
ELF file with a correct magic number, so that you can just point an ELF
file parser at it and have it work (which means, of course, that all the
file offsets are offsets from the start of the Ehdr, rather than from
the start of the bzImage).

You haven't specifically commented on using the Phdrs as a way of
specifying the mappings required for decompression and early kernel
execution.  It seems pretty natural to me, but I guess that raises the
general question of what execution environment the kernel can expect to
find itself in, and which modes of booting will actually enable paging
and establish any kinds of mapping at all.

In the Xen case, its obviously the domain builder who creates the
mappings, and we can easily implement p != v mappings.  But when booting
native, presumably paging is off at this stage, and only identity maps
can be implemented.  I guess the rough rule is that if paging is enabled
on entry, the kernel should expect all the bzImage mappings to be in
place, but if paging is off, well, the question is moot.

    J
