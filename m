Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbYEYSO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbYEYSO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbYEYSOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:14:08 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:36105 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091AbYEYSOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:14:06 -0400
Date: Sun, 25 May 2008 20:13:29 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/4] Fix forcedeth hibernate/wake-on-lan problems
Message-ID: <20080525181329.GA5044@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ayaz Abdulla <aabdulla@nvidia.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Hemminger <shemminger@linux-foundation.org>
References: <20080518125715.GA19229@yamamaya.is-a-geek.org> <20080518150908.GA4606@yamamaya.is-a-geek.org> <20080525150444.GA29739@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080525150444.GA29739@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> So my BIOS is not as borked as I thought and it should be possible
> to wake up the machine even with platform.  Further debugging will
> have to wait until at least next weekend though (maybe longer)...

Or maybe it doesn't have to wait, I was just too curious:

Summary first: I got platform mode to work!

After grepping and reading through kernel/power/disk.c and
(rather obfuscated) drivers/acpi/.* code, and reading up on
ACPI _GPE (General Purpose Event?), and having a look at my DSDT I
noticed two things:

1) The network controllers are assigned to their own _GPE bits(pins?):
|[...]
|    Scope (\_GPE)
|    {
|[...]
|        Method (_L0B, 0, NotSerialized)
|        {
|            Notify (\_SB.PCI0.MMAC, 0x02)
|        }
|
|        Method (_L0A, 0, NotSerialized)
|        {
|            Notify (\_SB.PCI0.MAC1, 0x02)
|        }
|[...]

2) drivers/acpi/sleep/proc.c registers a 'wakeup' file:
|        proc_create("wakeup", S_IFREG | S_IRUGO | S_IWUSR,
|                    acpi_root_dir, &acpi_system_wakeup_device_fops);

And I then remembered that someone said in
http://bugzilla.kernel.org/show_bug.cgi?id=8381
it works for him if he writes $MAGICVALUE into a proc file.

And yes, if I write 'MMAC' and 'MAC1' into /proc/acpi/wakeup, then
wake-on-lan works even in platform mode.

So...
AFAICS this bit of setup magic should not be required, because:

1) /proc/acpi/wakeup knows which pci device is associated to each GPE bit
|ranma@melchior:~$ cat /proc/acpi/wakeup 
|Device	S-state	  Status   Sysfs node
|HUB0	  S5	 disabled  pci:0000:00:06.0
|XVR0	  S5	 disabled  
|XVR1	  S5	 disabled  pci:0000:00:0e.0
|XVR2	  S5	 disabled  
|XVR3	  S5	 disabled  
|XVR4	  S5	 disabled  
|XVR5	  S5	 disabled  pci:0000:00:0a.0
|UAR1	  S5	 disabled  pnp:00:09
|PS2K	  S4	 disabled  pnp:00:0b
|USB0	  S4	 disabled  pci:0000:00:02.0
|USB2	  S4	 disabled  pci:0000:00:02.1
|AZAD	  S5	 disabled  pci:0000:00:06.1
|MMAC	  S5	 enabled   pci:0000:00:08.0
|MAC1	  S5	 enabled   pci:0000:00:09.0
(values after manually enabling MMAC and MAC1)

2) kernel/power/disk.c calls hibernation_ops->enter(), which is
acpi_suspend_enter, which calls acpi_enable_wakeup_device, which
sets up GPE wakup bits.  This _should_ take care of enabling MMAC
and MAC1 automatically, but apparently does not work correctly at
some point.

I guess someone more knowledgable in ACPI stuff should have a look
at this.

Hope that helps,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
