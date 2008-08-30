Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYH3EmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYH3EmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 00:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbYH3Elz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 00:41:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:53368 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYH3Ely (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 00:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O5Kdb/hwFwGmU+fouvjgsGtGfk8KDUV/d3Qh6wjrt99Jo6OpfdhZa6uHTHGMlvlY9D
         bKx4onxQCx171OWqvlNqQF/0ChVBDSfgU/R4ARsEhvTC8lClOXs9YGdfYGF4BjlTqsP5
         zy5OqgQC86IyC9rOHR104ZyOeZ4M46DCgxZeU=
Message-ID: <86802c440808292141g6ffd1329p54e58ee04c26540a@mail.gmail.com>
Date: Fri, 29 Aug 2008 21:41:53 -0700
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
In-Reply-To: <alpine.LFD.1.10.0808292017440.5010@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>
	 <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
	 <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
	 <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>
	 <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
	 <86802c440808292007t3588edfnef95b723320ff023@mail.gmail.com>
	 <alpine.LFD.1.10.0808292017440.5010@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 8:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 29 Aug 2008, Yinghai Lu wrote:
>>
>> we need to use insert_resource_split_to_fit instead...
>>
>> otherwise __request_region will not be happy.
>
> Are you really really sure?
>
> Try just removing the IORESOURCE_BUSY. As mentioned, if we expect the PCI
> BAR's to work with the e820 resources, then BUSY really is simply not
> right any more. Not that I think it should matter either..
>
> The ones that are added _early_ should be IORESOURCE_BUSY (ie the ones
> that cover RAM), but the others we now expect to nest with PCI BARs.

not all. some are MMCONF, some are for GART, and some for fixed lapic,
and fixed ioapic, and fixed HPET.

>
> But since we add them after we have parsed the BAR's, I don't even see why
> the BUSY bit should even matter - we've already added the fixed BARs, and
> any newly allocated non-fixed ones shouldn't be allocated in e820 areas
> _regardless_ of whether the BUSY bit is set or not.
>
> So pls explain why it matters?

if we don't add the IORESOURCE_BUSY, why bother to add these entries...

good layout from BIOS, it should only reserve mmio range is not showing in BAR.

for example:
0xdc000000 - 0xdd000000 for GART ( some offset BAR 0x94)
0xdd000000 - 0xde000000 is for bus 0x80
0xde000000 - 0xdf000000 is for bus 0x00
0xe0000000 - 0xf0000000 is for mmconfig ( CPU set it in MSR for amd fam 10h)

if one stupid BIOS set
0xdc000000 - 0x100000000 for reserved.

then when in insert that range late
we should still have set ranges other than range 0xdd000000 - 0xdf000000

also do we need set other leaf range in 0xdd000000 - 0xdf0000000 ?

YH
