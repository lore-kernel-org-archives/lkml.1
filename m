Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYH3Bas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYH3Bas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 21:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYH3Bai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 21:30:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:40070 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYH3Bag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 21:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rKtmIjqe72G0YzDX/eyeQohRrLE6i3Vo4E9VwePFIrl5JHKmWspV1Oo2ed/+qP0wFO
         jl5P/548k3iqTp8qxwvBlqcrQJacUusK2So/CxEr7FHwOcHohVGyzWKCpGglAxi4OroS
         GyUCY7p8HFuy7nbKPU2zMzwohHkHeuhDRgj8U=
Message-ID: <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>
Date: Fri, 29 Aug 2008 18:30:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808292157.24179.rjw@sisk.pl>
	 <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>
	 <200808300031.16708.rjw@sisk.pl>
	 <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
	 <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>
	 <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
	 <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 6:11 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> Btw, what was the original regression that commit was
> a2bd7274b47124d2fc4dfdb8c0591f545ba749dd trying to fix?
>
> It's not listed in that commit, even though the commit has a "Bisected-by:
> David Witbrodt <dawitbro@sbcglobal.net>".
>
> In fact, I can find it with google by searching for
>
>        David Witbrodt bisect
>
> and I see that it is 3def3d6ddf43dbe20c00c3cbc38dfacc8586998f.
>
> I'm wondering why that commit wasn't just reverted? Because now that I see
> it, I notice that _that_ is the real bug to begin with.
>
> That commit really was buggy. NO WAY can you insert the code/bss/data
> resources before you've done e820 handling, because it may well be that
> some strange e820 table contains things that cross the resources.

we reverted the commit , David's problem still happen.

the root cause is:
before 2.6.26, call init_apic_mapping and will insert_resource for
lapic address.
and then call e820_resource_resouce (with request_resource) to
register e820 entries.
so the lapic entry in the resource tree will prevent some entry in
e820 to be registered.
later request_resource for BAR res (==hpet) will succeed.

from 2.6.26. we move lapic address registering to late_initcall, so
the entry is reserved in e820 getting into resource tree at first.
and later pci_resource_survey::request_resource for BAR res (==hpet,
0xfed00000) will fail. so pci_assign_unsigned... will get new
res for the BAR, so it messed up hpet setting.

solutions will be
1. use quirk to protect hpet in BAR, Ingo said it is not generic.
2. or the one you are reverted... check_bar_with_valid. (hpet, ioapic,
mmconfig) --> happenly reveal another problem with Rafael's
system/chipset.
3. or sticky resource... , but could have particallly overlapping
4. or don't register reserved entries in e820.. Eric, Nacked.
5. or you sugges, regiser some reserved entries later...., and have
insert_resource_expand_to_fit...

YH
