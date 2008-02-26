Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbYBZDj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbYBZDj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbYBZDjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:39:51 -0500
Received: from server54.tchmachines.com ([72.9.244.106]:34955 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbYBZDju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:39:50 -0500
Date: Mon, 25 Feb 2008 19:39:45 -0800
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Message-ID: <20080226033945.GJ3143@localdomain>
References: <200802210258.45011.yinghai.lu@sun.com> <200802221102.31019.yinghai.lu@sun.com> <47BF1BD9.4020808@firstfloor.org> <200802232148.43255.yinghai.lu@sun.com> <20080224122903.GC13637@one.firstfloor.org> <20080225190819.GE3143@localdomain> <86802c440802251405w7025a8b2na5fde4dcbf56067e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802251405w7025a8b2na5fde4dcbf56067e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 02:05:45PM -0800, Yinghai Lu wrote:
>On Mon, Feb 25, 2008 at 11:08 AM, Ravikiran Thirumalai
><kiran@scalemp.com> wrote:
>> ...
>>  Andi, Yes.  AMD based vSMPowered systems uses clustered APICs, and this
>>  check base on cpu vendor id is not good :(.
>
>please check if you happy with
>
>http://lkml.org/lkml/2008/2/24/273
>

I don't quite understand the purpose of the patch to begin with.  Looking at
the current x86 git tree, apic_is_clustered_box is used only to determine if
tsc is synchronized on the platform.  The AMD docs  imply that TSC's are not
guaranteed to be synced across cores between nodes -- Opteron BKDG for
family 10h, Section 2.9.4:

<quote>
Note: Timers associated with different CPU cores in the same processor
increment at the same rate. Timers associated with different CPU cores
in different processors increment at slightly different rates if (1) they
are located on different nodes and (2) CLKIN for these nodes is derived from
different, non-synchronized oscillator sources.
</quote>

But that is not what the x86 tree does (with your patches) -- it looks for the
X86_FEATURE_CONSTANT_TSC at unsynchronized_tsc() and assumes a synchronized
clock.  Huh!??  Am i missing something here?  X86_FEATURE_CONSTANT_TSC
is set from CPUID Fn8000_0007 -- TscInvariant bit, which implies TSC is
not affected by change in PM states.  This does not talk about whether CLKIN
for different packages are from synchronized/non synchronized oscillator
sources in the above quote.

Thanks,
Kiran
