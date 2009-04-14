Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZDNP6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZDNP6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbZDNP4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:56:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:61680 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963AbZDNP4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:56:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,186,1239001200"; 
   d="scan'208";a="506365773"
From: "Moore, Robert" <robert.moore@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Arjan van de Ven <arjan@infradead.org>
CC: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Date: Tue, 14 Apr 2009 08:55:58 -0700
Subject: RE: [BISECTED] EEE PC hangs when booting off battery
Thread-Topic: [BISECTED] EEE PC hangs when booting off battery
Thread-Index: Acm9GKGGm1GCXUdES6+rzUWzWUFlyQAAHpcA
Message-ID: <4911F71203A09E4D9981D27F9D8308581D3722EB@orsmsx503.amr.corp.intel.com>
References: <49E065CF.6040408@tuffmail.co.uk>
 <200904140859.02188.bjorn.helgaas@hp.com>
 <20090414081728.10de978a@infradead.org>
 <200904140948.37633.bjorn.helgaas@hp.com>
In-Reply-To: <200904140948.37633.bjorn.helgaas@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fact, ACPI methods can execute concurrently -- constrained by the ACPI specification itself. The "big lock" is released before anything that will block for a significant amount of time, allowing other methods to run.

Bob


>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>owner@vger.kernel.org] On Behalf Of Bjorn Helgaas
>Sent: Tuesday, April 14, 2009 8:49 AM
>To: Arjan van de Ven
>Cc: Alan Jenkins; linux-acpi@vger.kernel.org; linux-kernel; Kernel Testers
>List; Pallipadi, Venkatesh
>Subject: Re: [BISECTED] EEE PC hangs when booting off battery
>
>On Tuesday 14 April 2009 09:17:28 am Arjan van de Ven wrote:
>> On Tue, 14 Apr 2009 08:59:01 -0600
>> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>
>> > I can't help with the real problem of why the asynchronous battery
>> > init causes the hang.
>>
>> that got fixed already for the module case.
>
>But apparently still broken for the builtin case?  I think Alan is
>running pretty new bits -- he said "latest git" on April 11.
>
>> > But I do object to the magic makefile ordering change in that commit.
>> > Nobody reading the makefile can tell why battery is down at the end,
>> > and moving it apparently slows down boot significantly.
>>
>> for all cases I've seen it actually speeds it up, because the battery
>> now runs concurrently with the disk probe.
>
>I understand; I just meant that if somebody moves it back where it
>was, we'll mysteriously lose the speedup you got.  Maybe a comment
>in the makefile would be a short-term solution.
>
>> > So the
>> > ordering change just feels like a band-aid that covers up a place
>> > where ACPI could be improved.
>>
>> the reason for the move is that both the battery and other pieces take
>> the big acpi lock; which defeats the parallelism. So the battery needs
>> to happen at the end instead.
>
>Yep.  But I don't think it's anything about the Linux battery driver
>itself that makes it slow.  I think it's more likely that some of the
>ACPI methods it executes happen to be slow.  And that could afflict
>*any* driver, depending on the whim of a BIOS writer.
>
>My guess is that if we could run ACPI methods concurrently and avoid
>that big lock, the ordering wouldn't matter.  I know we probably can't
>do that any time soon, but I think it's good to make the problem
>visible at least with a "we need this magic order because ACPI doesn't
>support concurrent method execution" sort of comment.
>
>Bjorn
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
