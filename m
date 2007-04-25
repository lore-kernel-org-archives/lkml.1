Return-Path: <linux-kernel-owner+w=401wt.eu-S1423367AbXDYSRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423367AbXDYSRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423365AbXDYSRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:17:38 -0400
Received: from gw.goop.org ([64.81.55.164]:58015 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423359AbXDYSRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:17:37 -0400
Message-ID: <462F9B64.3020107@goop.org>
Date: Wed, 25 Apr 2007 11:18:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>	<20070425044813.f83dde4e.akpm@linux-foundation.org>	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>
>   
>> Andrew Morton wrote:
>>
>>     
>>> This patch causes oopses after a minute or so running LTP's
>>>
>>> ./testcases/bin/growfiles -W gf16 -b -e 1 -i 0 -L 120 -u -g 4090 -T 100 -t
>>>       
>> 408990 -l -C 10 -c 1000 -S 10 -f Lgf02_
>>     
>>> on everyone's favoutite Vaio, configured with
>>> http://userweb.kernel.org/~akpm/config-sony.txt
>>>
>>>       
>> *BLINK*
>>
>> This patch only affects the initial page tables, which should have been
>> thrown out *way* long ago at this point.
>>     
>
> Yes.  I noticed this was happening a few days ago.
> I must not have mentioned it loudly enough.
>   

I might have introduced it as part of the paravirt_ops patches.  When
setting up pagetables under Xen, we need to make sure we preserve the
initial mappings Xen put in place (it starts the VM with paging enabled,
and a sane initial pagetable).  This may have leaked over into native if
it doesn't replace an existing entry.

Hm, but it should be overwriting small mappings with large ones.  Maybe
I overlooked that.

> I'm halfway through putting together a patchset to address a
> bunch of these.
>
> I haven't yet resolved how I want to allocate the pages for the
> identity mapping of the page table yet.  I can't use the bootmem
> allocate as it exists because that assumes the page is mapped
> into the address space already.
>   

Are you going to clash horribly with the paravirt pagetable setup?  We
should probably coordinate if so.

    J
