Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbZKYOPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbZKYOPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934542AbZKYOPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:15:09 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:32556 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758426AbZKYOPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:15:04 -0500
X-IronPort-AV: E=Sophos;i="4.47,286,1257138000"; 
   d="scan'208";a="7951567"
Message-ID: <4B0D3BD5.2060703@analog.com>
Date: Wed, 25 Nov 2009 22:14:45 +0800
From: Jie Zhang <jie.zhang@analog.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Shredder/3.0
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: uClinux development list <uclinux-dev@uclinux.org>,
       David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org> <20091125061640.GB17203@shareable.org> <4B0CCE4A.5000602@analog.com> <20091125114908.GA21778@shareable.org>
In-Reply-To: <20091125114908.GA21778@shareable.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Nov 2009 14:15:03.0475 (UTC) FILETIME=[AE664830:01CA6DD9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 07:49 PM, Jamie Lokier wrote:
> Jie Zhang wrote:
>> On 11/25/2009 02:16 PM, Jamie Lokier wrote:
>>> Mike Frysinger wrote:
>>>> From: Jie Zhang<jie.zhang@analog.com>
>>>>
>>>> The mmu code uses the copy_*_user_page() variants in access_process_vm()
>>>> rather than copy_*_user() as the former includes an icache flush.  This is
>>>> important when doing things like setting software breakpoints with gdb.
>>>> So switch the nommu code over to do the same.
>>>
>>> Reasonable, but it's a bit subtle don't you think?
>>> How about a one-line comment saying why it's using copy_*_user_page()?
>>>
>>> (If it was called copy_*_user_flush_icache() I wouldn't say anything,
>>> but it isn't).
>>>
>> But I think it's well known in Linux kernel developers that
>> copy_to_user_page and copy_from_user_page should do cache flushing. It's
>> documented in Documentation/cachetlb.txt. I don't think it's necessary
>> to replicate it here.
>
> You're right, however I now think the commit message is misleading.
>
> Since this is the *only place in the entire kernel* where these
> functions are used (plus the mmu equivalent), I'm not sure I'd agree
> about well known, and the name could be better (copy_*_user_ptrace()),
> but I agree now, it doesn't need a comment.
>
> It was the talk of icache flush which bothered me, as I (wrongly)
> assumed copy_*_user_page() was used elsewhere, without knowledge of
> icache vs non-icache differences - which are often the responsibility
> of userspace to get right, so often the kernel does not care.
>
> In fact, it's not just icache.  copy_*_user_page() has to do some
> *data* cache flushing too, on some architecures.  For example, see

You are right. We needs dcache flushing here, too. However, for harvard 
architecture, flushing icache implies you have to flush dcache. So in 
implementation, there is dcache flushing in flush_icache_range, as we do 
for Blackfin, as well as they do for ARM. So when we say icache 
flushing, dcache flushing is implied.

> I'm not sure why I don't see the same dcache flushing on ARM, so I
> wonder if the ARM implementation of these buggy.
>
I'm not familiar with ARM. But I believe they do dcache flushing after 
some grepping in arch/arm/*.

> Which is why, given they are only used for ptrace (have just grepped),
> I'm inclined to think it'd be clearer to rename the functions to
> copy_*_user_ptrace().  And make your no-mmu change of course :-)
> Any thoughts on the rename?
>
I have no opinion on renaming things. I can live with the current naming.


Jie
