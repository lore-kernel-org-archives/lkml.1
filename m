Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbZBMBKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbZBMBKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 20:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZBMBKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 20:10:24 -0500
Received: from ns2.suse.de ([195.135.220.15]:58343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbZBMBKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 20:10:24 -0500
Date: Thu, 12 Feb 2009 17:08:27 -0800
From: Greg KH <gregkh@suse.de>
To: David Engel <david@istwok.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.16
Message-ID: <20090213010827.GA8562@suse.de>
References: <20090212180448.GC15341@kroah.com> <20090212180505.GD15341@kroah.com> <20090212180448.GC15341@kroah.com> <20090212230100.GA31159@opus.istwok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212230100.GA31159@opus.istwok.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 05:01:00PM -0600, David Engel wrote:
> On Thu, Feb 12, 2009 at 10:04:48AM -0800, Greg KH wrote:
> > We (the -stable team) are announcing the release of the 2.6.27.16
> > kernel.
> > 
> > It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
> > series are strongly encouraged to upgrade.
> 
> I get the following oops when starting hald on my Sony VAIO SZ360.
> 
> Starting Hardware abstraction layer: haldBUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c0220048>] show_docked+0xe/0x37
> *pde = 00000000
> Oops: 0000 [#2] SMP
> Modules linked in: autofs4 acpi_cpufreq cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table btusb bluetooth usbhid pcmcia arc4 ecb crypto_blkcipher cryptomgr crypto_algapi snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device joydev i2c_i801 iwl3945 pcspkr rtc_cmos tifm_7xx1 mac80211 thermal yenta_socket snd sky2 ide_cd_mod rsrc_nonstatic i2c_core rtc_core ehci_hcd pcmcia_core tifm_core bitrev soundcore uhci_hcd
> sony_laptop cdrom psmouse ohci1394 rng_core rtc_lib snd_page_alloc crc32 ieee1394 usbcore evdev cfg80211 backlight battery ac processor button intel_agp agpgart unix
> 
> Pid: 2404, comm: hald Tainted: G      D   (2.6.27.16 #1)

"D"?  TAINT_DIE?  Odd...

> EIP: 0060:[<c0220048>] EFLAGS: 00010282 CPU: 0
> EIP is at show_docked+0xe/0x37
> EAX: 00000000 EBX: f6d93000 ECX: f6d93000 EDX: f6d99f38
> ESI: c03af2fc EDI: c022003a EBP: f6cdb254 ESP: f6d99f38
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process hald (pid: 2404, ti=f6d98000 task=f72c78d0 task.ti=f6d98000)
> Stack: fffffff4 fffffffb c0246cc1 c03b5600 f6cdb240 f781e7c8 c01b6507 40038000
>        00000003 00001000 40038000 c03b5600 f7854480 f7016940 40038000 c01b6480
>        00001000 c017836d f6d99fa0 f7bf2774 f7016940 fffffff7 00000000 f6d98000
> Call Trace:
>  [<c0246cc1>] dev_attr_show+0x21/0x50
>  [<c01b6507>] sysfs_read_file+0x87/0x120
>  [<c01b6480>] sysfs_read_file+0x0/0x120
>  [<c017836d>] vfs_read+0x9d/0x140
>  [<c01784e1>] sys_read+0x41/0x80
>  [<c01032ca>] syscall_call+0x7/0xb
>  =======================
> Code: fd ff 58 5a ba 02 00 00 00 8d 83 80 00 00 00 8d 4c 24 10 e8 bb f7 fc ff 83 c4 18 5b c3 53 89 cb 83 ec 04 8b 80 d8 00 00 00 89 e2 <8b> 00 8b 00 e8 77 d2 ff ff 85 c0 75 07 68 60 b1 37 c0 eb 05 68
> EIP: [<c0220048>] show_docked+0xe/0x37 SS:ESP 0068:f6d99f38
> ---[ end trace abcf04f7c3ef131b ]---
> 
> The following change is the part which causes it.
> 
> > diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> > index e28469e..eab790f 100644
> > --- a/drivers/acpi/dock.c
> > +++ b/drivers/acpi/dock.c
> > @@ -691,8 +691,14 @@ fdd_out:
> >  static ssize_t show_docked(struct device *dev,
> >  			   struct device_attribute *attr, char *buf)
> >  {
> > -	return snprintf(buf, PAGE_SIZE, "%d\n", dock_present(dock_station));
> > +	struct acpi_device *tmp;
> > +
> > +	struct dock_station *dock_station = *((struct dock_station **)
> > +		dev->platform_data);
> >  
> > +	if (ACPI_SUCCESS(acpi_bus_get_device(dock_station->handle, &tmp)))
> > +		return snprintf(buf, PAGE_SIZE, "1\n");
> > +	return snprintf(buf, PAGE_SIZE, "0\n");
> >  }
> >  static DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
> 
> It seems that dev->platform_data is NULL on my system.

Not good, let me dig to see if I missed a patch...

thanks,

greg k-h
