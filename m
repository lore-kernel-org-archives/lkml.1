Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXCHR36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXCHR36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXCHR35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:29:57 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48282 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbXCHR34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:29:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       <linux-pci@atrey.karlin.mff.cuni.cz>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu>
	<20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk>
	<20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz>
	<20070305084257.GA4464@mellanox.co.il>
	<20070305101120.GA23032@elte.hu> <45ECFC5F.7000102@garzik.org>
	<45ED0BBF.1050000@intel.com> <20070306090444.GA25409@elte.hu>
	<45ED8A12.5040803@intel.com>
	<m1ejo1elj6.fsf@ebiederm.dsl.xmission.com>
	<45EEE8CF.1060803@intel.com> <45EEEC2C.5090609@intel.com>
	<m1649cdfas.fsf@ebiederm.dsl.xmission.com>
	<20070307185317.5601d452.akpm@linux-foundation.org>
	<m1wt1s6x2p.fsf@ebiederm.dsl.xmission.com>
	<45EFDD8C.3070702@garzik.org>
Date: Thu, 08 Mar 2007 10:27:28 -0700
In-Reply-To: <45EFDD8C.3070702@garzik.org> (Jeff Garzik's message of "Thu, 08
	Mar 2007 04:55:24 -0500")
Message-ID: <m1abyn7iin.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Eric W. Biederman wrote:
>> Until I get the best scenario I can come up with is a tg3 hardware bug
>> that doesn't renable the pci-X capability after a restore of power state.
>
>
> Speaking of tg3, make sure you are aware that the number of calls to save-state
> functions may not match the number of calls to the restore-state functions.
> ISTR seeing some memleak bugs in PCI related to this.

Thanks that looks like the problem, multiple calls to save before one
call to restore when you have a pci-x capability would easily trigger
this problem.  I just surveyed a bunch of the pci_save_state and
pci_restore_state users and this appears to be a common idiom not just
a tg3 thing....

It looks like when code was added to save/restore the msi capability
was added to pci_save/restore_state that an assumption was added that
pci_save_state and pci_restore state were only used for suspend and
only used in pairs.  There is even a partial bug fix that removed the
worst of the symptoms of that assumption from the msi code but failed
to recognize the core problem.

Now that we have code to work with pcie and pcix capabilities as well
as msi this problem is much easier to hit.

All of pci_save_state and pci_restore_state is going to have to be
restructured to fix this, and it is late in the game.  Ugh.
Oh well, better to fix it now 

At least I get my answer about if what pci_save_state is doing
is reasonable. It is not.  pci_save_state no longer supports being
used in conjunction with hardware reset and has become a
suspend/resume specific function.

Now I'm off to wite some patches to fix this.

Eric
