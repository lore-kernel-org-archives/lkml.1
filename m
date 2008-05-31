Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYEaWNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYEaWNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYEaWNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:13:04 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:59611 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbYEaWNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:13:00 -0400
Date: Sun, 1 Jun 2008 00:12:24 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, linux-acpi@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/4] Fix forcedeth hibernate/wake-on-lan problems
Message-ID: <20080531221223.GA2630@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ayaz Abdulla <aabdulla@nvidia.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	David Brownell <david-b@pacbell.net>, linux-acpi@vger.kernel.org,
	linux-pm@lists.linux-foundation.org
References: <20080518125715.GA19229@yamamaya.is-a-geek.org> <20080518150908.GA4606@yamamaya.is-a-geek.org> <20080525150444.GA29739@yamamaya.is-a-geek.org> <20080525181329.GA5044@yamamaya.is-a-geek.org> <20080527062153.GA3651@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080527062153.GA3651@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Tobias Diedrich wrote:
> > Tobias Diedrich wrote:
> > > So my BIOS is not as borked as I thought and it should be possible
> > > to wake up the machine even with platform.  Further debugging will
> > > have to wait until at least next weekend though (maybe longer)...
> > 
> > Or maybe it doesn't have to wait, I was just too curious:
> > 
> > Summary first: I got platform mode to work!
> > 
> > After grepping and reading through kernel/power/disk.c and
> > (rather obfuscated) drivers/acpi/.* code, and reading up on
> > ACPI _GPE (General Purpose Event?), and having a look at my DSDT I
> > noticed two things:
> > 
> > 1) The network controllers are assigned to their own _GPE bits(pins?):
> > |[...]
> > |    Scope (\_GPE)
> > |    {
> > |[...]
> > |        Method (_L0B, 0, NotSerialized)
> > |        {
> > |            Notify (\_SB.PCI0.MMAC, 0x02)
> > |        }
> > |
> > |        Method (_L0A, 0, NotSerialized)
> > |        {
> > |            Notify (\_SB.PCI0.MAC1, 0x02)
> > |        }
> > |[...]
> > 
> > 2) drivers/acpi/sleep/proc.c registers a 'wakeup' file:
> > |        proc_create("wakeup", S_IFREG | S_IRUGO | S_IWUSR,
> > |                    acpi_root_dir, &acpi_system_wakeup_device_fops);
> > 
> > And I then remembered that someone said in
> > http://bugzilla.kernel.org/show_bug.cgi?id=8381
> > it works for him if he writes $MAGICVALUE into a proc file.
> > 
> > And yes, if I write 'MMAC' and 'MAC1' into /proc/acpi/wakeup, then
> > wake-on-lan works even in platform mode.
> > 
> > So...
> > AFAICS this bit of setup magic should not be required, because:
> > 
> > 1) /proc/acpi/wakeup knows which pci device is associated to each GPE bit
> > |ranma@melchior:~$ cat /proc/acpi/wakeup 
> > |Device	S-state	  Status   Sysfs node
> > |HUB0	  S5	 disabled  pci:0000:00:06.0
> > |XVR0	  S5	 disabled  
> > |XVR1	  S5	 disabled  pci:0000:00:0e.0
> > |XVR2	  S5	 disabled  
> > |XVR3	  S5	 disabled  
> > |XVR4	  S5	 disabled  
> > |XVR5	  S5	 disabled  pci:0000:00:0a.0
> > |UAR1	  S5	 disabled  pnp:00:09
> > |PS2K	  S4	 disabled  pnp:00:0b
> > |USB0	  S4	 disabled  pci:0000:00:02.0
> > |USB2	  S4	 disabled  pci:0000:00:02.1
> > |AZAD	  S5	 disabled  pci:0000:00:06.1
> > |MMAC	  S5	 enabled   pci:0000:00:08.0
> > |MAC1	  S5	 enabled   pci:0000:00:09.0
> > (values after manually enabling MMAC and MAC1)
> > 
> > 2) kernel/power/disk.c calls hibernation_ops->enter(), which is
> > acpi_suspend_enter, which calls acpi_enable_wakeup_device, which
> > sets up GPE wakup bits.  This _should_ take care of enabling MMAC
> > and MAC1 automatically, but apparently does not work correctly at
> > some point.
> > 
> > I guess someone more knowledgable in ACPI stuff should have a look
> > at this.
> 
> Any reason this patch hasn't made it into the kernel so far?
> http://lists.laptop.org/pipermail/devel/2007-April/004691.html
> 
> (Ok, I tried getting it to apply to a current kernel, but it
> a splodes (reboots instead of powering off, last message on the
> serial console is "ACPI handle has no context!", see below))
> 
> The platform_enable_wakeup() hook is still there, but unused.
> AFAICS this patch should solve the "'ethtool -s eth0 wol g' doesn't
> suffice, I also have to write magic values into /proc/acpi/wakeup"
> issue.

Ok, after another long debugging session I finally found out the
reason for the immediate reboot (after finding the place that
suspends the serial console (drivers/pnp) and disabling that suspend
path):
The system is woken up by USB activity! (Optical mouse, anyone?)

Lo and behold:
drivers/usb/core/hcd-pci.c tries it's best to activate 'wake on
usb', which I didn't know since it apparently also never worked.
However, after applying the 'use platform_enable_wakeup'-patch,
not only forcedeth wake starts working, also usb wake.
If I prevent usb wake:
|echo disabled > /sys/devices/pci0000\:00/0000\:00\:02.0/power/wakeup'
|echo disabled > /sys/devices/pci0000\:00/0000\:00\:02.1/power/wakeup'
And then hibernate in platform mode, the immediate reboot is gone
and waking up using magic packets works fine even without setting up
/proc/acpi/wakeup first.

Maybe I should try hooking mouse and keyboard onto different usb
host controllers, so I can disable wakeup for the mouse host
controller and enable wakeup for the keyboard host controller,
then it should be possible to wake the system by pressing a key. :)

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
