Return-Path: <linux-kernel-owner+w=401wt.eu-S1423345AbXDYRv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423345AbXDYRv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423348AbXDYRv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:51:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38891 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423350AbXDYRv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:51:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>
	<20070425044813.f83dde4e.akpm@linux-foundation.org>
	<462F73A0.40003@zytor.com>
Date: Wed, 25 Apr 2007 11:50:53 -0600
In-Reply-To: <462F73A0.40003@zytor.com> (H. Peter Anvin's message of "Wed, 25
	Apr 2007 08:28:32 -0700")
Message-ID: <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Andrew Morton wrote:
>
>> 
>> This patch causes oopses after a minute or so running LTP's
>> 
>> ./testcases/bin/growfiles -W gf16 -b -e 1 -i 0 -L 120 -u -g 4090 -T 100 -t
> 408990 -l -C 10 -c 1000 -S 10 -f Lgf02_
>> 
>> on everyone's favoutite Vaio, configured with
>> http://userweb.kernel.org/~akpm/config-sony.txt
>> 
>
> *BLINK*
>
> This patch only affects the initial page tables, which should have been
> thrown out *way* long ago at this point.

Yes.  I noticed this was happening a few days ago.
I must not have mentioned it loudly enough.

> Yet they seem to have stuck around.  This is a very bad thing on many
> levels, especially since we should have switched the kernel 1:1 area
> over to PSE pages a long time ago.

Yep.  We don't continue to use the early page table pages if you
enable PAE, but otherwise we do.

Which also gives us potential permission issues with the initial page
tables.

>> BUG: unable to handle kernel paging request at virtual address c084fa8c
>>  printing eip:
>> c0174c46
>> *pde = 0042a027
>> *pte = 00000000
>
> Touching a non-PSE page which is zero, and quite consistent with being a
> remnant from the original page tables.
>
> Methinks this has smoked out a bug in the initial page table setup which
> probably has been a performance roadblock for quite some time.

Yes our initial page table setup on arch/i386 is full of issues.

I'm halfway through putting together a patchset to address a
bunch of these.

I haven't yet resolved how I want to allocate the pages for the
identity mapping of the page table yet.  I can't use the bootmem
allocate as it exists because that assumes the page is mapped
into the address space already.

Eric
