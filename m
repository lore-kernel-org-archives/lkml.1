Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbYH3DAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbYH3DAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 23:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbYH3DAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 23:00:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:45163 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbYH3DAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 23:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qIhBvp9B6O3gS7vUzxwx8vXKwqjHitDYMoXLzUvB/5JDzTqrSjR2Dh24ZzHGtIWsIK
         a1atauPjl/nUF90rg6M3Rui0QsV9KU3jaJKHZU2bpzQ1dBRovfSDFIja+4rWVPNEKkfW
         jSPXDj2ZMAxp1vew3eDTHBO7bEvQLZrZAqHCM=
Message-ID: <86802c440808292000v767ce75fn80f665f2cf79ce3d@mail.gmail.com>
Date: Fri, 29 Aug 2008 20:00:31 -0700
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
In-Reply-To: <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>
	 <200808300031.16708.rjw@sisk.pl>
	 <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
	 <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>
	 <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
	 <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
	 <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>
	 <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 7:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 29 Aug 2008, Yinghai Lu wrote:
>>
>> the root cause is:
>> before 2.6.26, call init_apic_mapping and will insert_resource for
>> lapic address.
>> and then call e820_resource_resouce (with request_resource) to
>> register e820 entries.
>
> So the problem there was that traditionally, e820_reserve_resource()
> expected to be the first one to populate any resources. That's changed,
> and that's why it now needs to use "insert_resource()" rather than
> "request_resource()".
>
>> so the lapic entry in the resource tree will prevent some entry in
>> e820 to be registered.
>> later request_resource for BAR res (==hpet) will succeed.
>>
>> from 2.6.26. we move lapic address registering to late_initcall, so
>> the entry is reserved in e820 getting into resource tree at first.
>> and later pci_resource_survey::request_resource for BAR res (==hpet,
>> 0xfed00000) will fail. so pci_assign_unsigned... will get new
>> res for the BAR, so it messed up hpet setting.
>
> So this didn't work _originally_ either?

orginally it works, because lapic address entry open the big hole for
near address.

>
>> solutions will be
>> 1. use quirk to protect hpet in BAR, Ingo said it is not generic.
>
> Yeah, I don't like it. The quirk I was talking about was the one about
> apparetly bogus MMIO address:
>
>>> pci 0000:00:00.0: BAR has MMCONFIG at e0000000-ffffffff
>>        PCI: Using MMCONFIG at e0000000 - efffffff
>>
>> Where did it get that bogus "ffffffff" end address?
>
> which you said came from another BAR. That isn't the HPET.

that is from Rafael's system mmconfig BAR in 00:00.0. that chipset is broken ...

>
>
>> 2. or the one you are reverted... check_bar_with_valid. (hpet, ioapic,
>> mmconfig) --> happenly reveal another problem with Rafael's
>> system/chipset.
>
> Yeah, no, that's horrid. I'm happy it's reverted.

if update res->end according mmconfig end, before insert it forcibly,
then could fix the chipset BAR problem too.

>
>> 3. or sticky resource... , but could have particallly overlapping
>
> And no, this doesn't work.
>
>> 4. or don't register reserved entries in e820.. Eric, Nacked.
>
> Yeah, no, we do want reserved entries from e820 to show up to at least
> stop late _dynamic_ allocations from taking over.
>
>> 5. or you sugges, regiser some reserved entries later...., and have
>> insert_resource_expand_to_fit...
>
> Yes. And I do think this is a workable model.

BTW, insert_resource_expand_to_fit need to be replaced with
insert_resource_split_to_fit....
test stub reveal expand will make __request_region not working for
some devices...because reserved_entries from e820 take
IORESOUCE_BUSY...

YH
