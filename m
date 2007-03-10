Return-Path: <linux-kernel-owner+w=401wt.eu-S1767761AbXCJEBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767761AbXCJEBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993174AbXCJEBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:01:37 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40091 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767772AbXCJEBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:01:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2: BUG: at drivers/pci/pci.c:679 pci_restore_state during suspend testing
References: <200703090113.14627.rjw@sisk.pl>
	<20070309190009.20b912a6.akpm@linux-foundation.org>
Date: Fri, 09 Mar 2007 21:00:49 -0700
In-Reply-To: <20070309190009.20b912a6.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 9 Mar 2007 19:00:09 -0800")
Message-ID: <m164993fym.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> On Fri, 9 Mar 2007 01:13:14 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>> I get the following traces from 2.6.21-rc3-mm2 during the "resume" phase
>> of testing with 'echo test > /sys/power/disk && echo disk > /sys/power/state':
>> 
>> acpi thermal:00: resuming
>> pci 0000:00:00.0: resuming
>> pcieport-driver 0000:00:01.0: resuming
>> BUG: at drivers/pci/pci.c:679 pci_restore_state()
>> 
>> Call Trace:
>>  [<ffffffff803ab3e9>] pci_restore_state+0x229/0x270
>>  [<ffffffff803b10f9>] pcie_portdrv_restore_config+0x19/0x40
>>  [<ffffffff803b1171>] pcie_portdrv_resume+0x11/0x20
>>  [<ffffffff803ad92c>] pci_device_resume+0x2c/0x70
>>  [<ffffffff80411d41>] resume_device+0xe1/0x160
>>  [<ffffffff80411e69>] dpm_resume+0xa9/0x110
>>  [<ffffffff80411f18>] device_resume+0x48/0x60
>>  [<ffffffff802bb355>] pm_suspend_disk+0x235/0x250
>>  [<ffffffff802b99c5>] enter_state+0x65/0x250
>>  [<ffffffff802b9c2a>] state_store+0x7a/0xa0
>>  [<ffffffff80316734>] subsys_attr_store+0x24/0x30
>>  [<ffffffff803168a0>] sysfs_write_file+0x100/0x140
>>  [<ffffffff802181cf>] vfs_write+0xdf/0x180
>>  [<ffffffff80218d10>] sys_write+0x50/0x90
>>  [<ffffffff8026529e>] system_call+0x7e/0x83
>
> Yes, a number of people (including myself) have been hitting these
> new warnings.  I don't think we know why yet, but Eric is offline
> for a bit and I'm travelling.  We'll sort it out over the next few
> weeks I guess.

I'm online again.  I had fun getting caught in the trailing edge of a blizzard
in Nebraska earlier but I have found my way back to my apartment and my computer 
and friends.

Jeff Garzik is the one who really spotted what the problem is.  He pointed
out that pci_save_state and pci_restore_state have not historically required
being paired (as the usually are during suspend and resume) and there is
a practical use in resetting devices for not requiring them to be paired.

The recent additions to pci_save_state and pci_restore_state for the msi,
pci-e, pci-x all assumed those calls would be paired, and thus allocated
a buffer on save and freed the buffer and restore.

My WARN_ON's tested to ensure all of the buffers were freed.

However drivers like the tg3 that use pci_save/restore_state for more than
just suspend/resume wind up triggering the warning.

I have recently sent out two patches to remove the pairing requirement
but I haven't figured out suspend/resume for any of my machines so I
couldn't test them.

Eric
