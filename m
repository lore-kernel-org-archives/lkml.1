Return-Path: <linux-kernel-owner+w=401wt.eu-S934454AbZJNPQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454AbZJNPQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbZJNPQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:16:55 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:51811 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZJNPQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:16:54 -0400
Date: Wed, 14 Oct 2009 17:16:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] m68knommu: Move __init_end out of the .init
	section.
Message-ID: <20091014151616.GA6901@merkur.ravnborg.org>
References: <4AD3BFD8.90408@snapgear.com> <1255397413-4862-1-git-send-email-tabbott@ksplice.com> <1255397413-4862-2-git-send-email-tabbott@ksplice.com> <1255397413-4862-3-git-send-email-tabbott@ksplice.com> <1255397413-4862-4-git-send-email-tabbott@ksplice.com> <1255397413-4862-5-git-send-email-tabbott@ksplice.com> <1255397413-4862-6-git-send-email-tabbott@ksplice.com> <1255397413-4862-7-git-send-email-tabbott@ksplice.com> <4AD55682.7060502@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD55682.7060502@snapgear.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 02:41:38PM +1000, Greg Ungerer wrote:
> Hi Tim,
>
> Tim Abbott wrote:
>> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
>> ---
>>  arch/m68knommu/kernel/vmlinux.lds.S |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
>> index 73fe172..49d5c4d 100644
>> --- a/arch/m68knommu/kernel/vmlinux.lds.S
>> +++ b/arch/m68knommu/kernel/vmlinux.lds.S
>> @@ -169,6 +169,8 @@ SECTIONS {
>>  		CON_INITCALL
>>  		SECURITY_INITCALL
>>  		INIT_RAM_FS
>> +	} > INIT
>> +	.init_end : {
>>  		. = ALIGN(PAGE_SIZE);
>>  		__init_end = .;
>>  	} > INIT
>
>
> After applying this I can no longer boot.
>
> Resulting headers for vmlinux are:
>
> vmlinux:     file format elf32-m68k
>
> Sections:
> Idx Name          Size      VMA       LMA       File off  Algn
>   0 .text         00125ff0  40020000  40020000  00002000  2**4
>                   CONTENTS, ALLOC, LOAD, READONLY, CODE
>   1 .data         00012010  40145ff0  40145ff0  00127ff0  2**4
>                   CONTENTS, ALLOC, LOAD, DATA
>   2 .init         0000b608  40158000  40158000  0013a000  2**2
>                   CONTENTS, ALLOC, LOAD, CODE
>   3 .init_end     000009f8  40163608  40163608  00145608  2**0
>                   ALLOC
>   4 .bss          0000a9ec  40164000  40164000  00145608  2**4
>                   ALLOC
>   5 .comment      00001c56  00000000  00000000  00145608  2**0
>                   CONTENTS, READONLY

Took a look at this trying to understand why this
caused a non-booting system.

The previous post should have created a section named "init_begin",
but it is not present in the above.
I think this is beacuse the section had a zero size and thus
got ignored by the linker.

An the linker is allowed to rearrange sections so the concept
with a init_begin, init_end sections looks wrongs.
We do not know the order of these sections and they may
be linked in a different order than what we expect.

I think the better solution is to use the same section name
several times like this:

	.init : {
              . = ALIGN(PAGE_SIZE);
              __init_end = .;
      } > INIT

We should do this both for begin and end.
Then the linker will not fool us and try to rearrange stuff.
And we do not end up with zero sized sections.
		
Greg - I assume the boot failed when it tried to free initmem.

	Sam
