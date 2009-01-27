Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbZA0TIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbZA0TIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 14:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbZA0THx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 14:07:53 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:38516 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbZA0THw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 14:07:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Iko7QrBzGGxI9xXigMIcBbPOMd+Be1iAjZHEx6p9pjCWMbij9efPig9JEuEeyecwMB
         BisFpyR2Hl0goKXlLRFyB4I4bbZop1LnjVRWmJAPri0ooSjOUoeZ76DsckpzdXvYqqq5
         j6cnqg3Eow83SOPFTscZpbg5s+BDWfaaCPe3E=
MIME-Version: 1.0
In-Reply-To: <497F4982.8060103@goop.org>
References: <497E5F76.10301@goop.org>
	 <73c1f2160901262157g3d281e62nb3ebafe01ab1dfe4@mail.gmail.com>
	 <497EB698.30509@goop.org>
	 <73c1f2160901270435t5623b0d8tbf832b1f8a575b2e@mail.gmail.com>
	 <497F4982.8060103@goop.org>
Date: Tue, 27 Jan 2009 14:07:49 -0500
Message-ID: <73c1f2160901271107n55509844xd02592bf9ed00038@mail.gmail.com>
Subject: Re: unified percpu stuff
From: Brian Gerst <brgerst@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 12:50 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Brian Gerst wrote:
>>>
>>> BTW, does the initial cpu0 percpu area get reallocated and moved during
>>> boot, or does cpu0 keep using the same memory forever?
>>>
>>
>> It is reallocated in setup_per_cpu_areas().
>>
>
> Hm, OK.  What's the reason we need to move cpu 0's percpu area?  Its always
> seemed a bit awkward.
>
> Once it has been moved, how can I find the address of a variable in the
> original boot-time cpu 0 percpu area?  There's a couple of pages which Xen
> will have marked RO which need to be made RW if they're being freed back
> into the kernel pool.  Currently I use per_cpu_var(gdt_page), but guess
> that's a small offset rather than a directly usable address.

The fact that the boot cpu area is moved isn't new.  It's been that
way for a while.  The reason it is moved is so that extra space can be
allocated at the end for dynamic allocations.  It looks like Xen just
avoided it by not loading the per-cpu GDT until after the copy.  I
guess you could get by without reloading the GDT, but you would still
need to set MSR_GS_BASE for 64-bit.  32-bit happens to work because
%fs is probably initialized to the same segment as %ds.  If 32-bit
were ever to switch to zero-based per-cpu like 64-bit, that assumption
would fail.

You need to add __per_cpu_load to the offset to get the address of the
variable in the original boot per-cpu area.

--
Brian Gerst
