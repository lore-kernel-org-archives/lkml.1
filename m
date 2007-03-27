Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbXC0DRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbXC0DRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXC0DRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:17:49 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42811 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbXC0DRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:17:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: bunk@stusta.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC: 2.6.21 patch] let PCI_MSI depend on EXPERIMENTAL
References: <20070327010247.GW16477@stusta.de>
	<20070326.182422.115910859.davem@davemloft.net>
Date: Mon, 26 Mar 2007 21:13:16 -0600
In-Reply-To: <20070326.182422.115910859.davem@davemloft.net> (David Miller's
	message of "Mon, 26 Mar 2007 18:24:22 -0700 (PDT)")
Message-ID: <m14po71ir7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Adrian Bunk <bunk@stusta.de>
> Date: Tue, 27 Mar 2007 03:02:47 +0200
>
>> We had during the last months have quite a few MSI bugs and even 
>> regressions due to:
>> - core kernel bugs,
>> - device driver bugs and
>> - hardware bugs
   - architecture bugs
   - MSI enabled on hardware that does not support it.

aka.  Drivers have started supporting MSI, People have started using
and testing MSI, and there has been MSI maintenance.  People care.

The most recent regressions involving MSI have been fixes propagating
their way through the kernel, and I can't think of a one of them
that was MSI specific.  Just that the bug didn't happen to show
up clearly without MSI enabled.

Finding that pci_save_state/pci_restore_state had serious resources
leaks was nasty.

Finding that pci_enable_device isn't suspend/resume safe as
implemented on x86 and ia64 is very nasty.  Currently on x86 it is
only really safe to call pci_enable_device exactly once.  But the bugs
are small enough we don't generally notice.

Personally I prefer glaring outstanding bugs to little subtle once
that only bite you on the second Tuesday of the month.

The recent MSI maintenance has shifted the code around enough that
problems became visible.  I'm not happy with this but I don't expect
this to be an on-going state of affairs.

>> OTOH, MSI doesn't bring any real advantages for most users.

So default it to off, although I suspect we are approaching the
point where it would actually be safe to default it to on.  We
need a kernel release that doesn't have msi issues yet.

>> Let's therefore mark PCI_MSI as EXPERIMENTAL.
>> 
>> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> This is a good way to ensure that the code doesn't get tested
> enough to ever fix the problems.

Dave I agreed.  PCI_MSI is not the problem.

I think marking PCI_MSI as EXPERIMENTAL now would be closing the
barn door after the horses have fled.  I don't know of a core MSI
code path that hasn't been scrutinized lately.  I wouldn't say they
are perfect but they are junk either.  Especially given that the
code is not good enough where non x86 architectures can support
MSI.

There is one big remaining real world problem and that is we enable
MSI optimistically.  Resulting in it being enabled on chipsets that
don't support MSI.  We still need to change that behavior.  I have
been buried in the guts of things so I haven't had the free cycles to
worry about that yet, nor have there been enough people complaining
that it has crossed my pain threshold to just fix the thing.

I think where we are honestly at is that today MSI works on most new
chipsets.   MSI is supported by the hardware.  MSI is supported by the
OS.  With a little more maturity devices and device drivers will start
taking advantage of in ways that matter to users now that it works.

I can guess how they will take advantage of it and make it matter
to users but that would just be speculation on my part.

Eric
