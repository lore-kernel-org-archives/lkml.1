Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbZDWUp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbZDWUp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbZDWUpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:45:30 -0400
Received: from kroah.org ([198.145.64.141]:52262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757761AbZDWUp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:45:28 -0400
Date: Thu, 23 Apr 2009 13:39:45 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: WARNING: at fs/sysfs/group.c:138 sysfs_remove_group
Message-ID: <20090423203945.GA3890@kroah.com>
References: <c4e36d110904170213q24c2688ag9bcaa8562dddaa3f@mail.gmail.com> <20090423130930.50a6c9db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423130930.50a6c9db.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 01:09:30PM -0700, Andrew Morton wrote:
> On Fri, 17 Apr 2009 11:13:08 +0200
> Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
> 
> > Hi
> > 
> > 
> > When I've checked  2.6.30-rc2 kernel and  I've got among other errors
> > with Wifi message below.
> > As I've noticed - some people were reporting this problem already earlier:
> > 
> > http://www.gossamer-threads.com/lists/linux/kernel/1058276?page=last
> > 
> > But for me - it started with 2.6.30-rc kernels.
> > I've T61, 4GB, C2D, X86_64.
> > 
> > 
> > 
> > Zdenek
> > 
> > 
> > platform microcode: firmware: requesting intel-ucode/06-0f-0a
> > platform microcode: firmware: requesting intel-ucode/06-0f-0a
> 
> Lots of people are reporting this.  One person reported that each
> attempt takes 60 seconds, thus delaying boot be several minutes.
> 
> > Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> > ------------[ cut here ]------------
> > WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0x10b/0x110()
> > Hardware name: 6464CTO
> > sysfs group ffffffffa038d900 not found for kobject 'cpu0'
> > Modules linked in: microcode(-) binfmt_misc dm_mirror dm_region_hash
> > dm_log dm_mod kvm_intel kvm i915 dr
> > m i2c_algo_bit uinput btusb bluetooth arc4 ecb cryptomgr aead
> > pcompress thinkpad_acpi snd_hda_codec_analog crypto_blkcipher
> > crypto_hash snd_hda_intel cry
> > pto_algapi snd_hda_codec iwl3945 snd_seq_oss iwlcore
> > snd_seq_midi_event mac80211 snd_seq rfkill backlight i2c_i801 psmouse
> > intel_agp snd_seq_device snd_p
> > cm_oss rtc_cmos rtc_core sr_mod cdrom i2c_core sdhci_pci sdhci
> > mmc_core serio_raw led_class iTCO_wdt iTCO_vendor_support nvram
> > cfg80211 snd_mixer_oss e10
> > 00e rtc_lib snd_pcm snd_timer snd evdev soundcore button ac battery
> > snd_page_alloc uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
> > scsi_wait_scan]
> > Pid: 1983, comm: rmmod Not tainted 2.6.30-rc2-00076-g3ee8da8 #51
> > Call Trace:
> >  [<ffffffff802434bf>] warn_slowpath+0xaf/0xf0
> >  [<ffffffff8039c3dd>] ? kobject_release+0x5d/0xa0
> >  [<ffffffff80333f7b>] sysfs_remove_group+0x10b/0x110
> >  [<ffffffffa038b3f8>] mc_sysdev_remove+0x38/0x50 [microcode]
> >  [<ffffffff8043c08f>] sysdev_driver_unregister+0x5f/0xa0
> >  [<ffffffffa038bee8>] microcode_exit+0x39/0x65 [microcode]
> >  [<ffffffff8026e974>] sys_delete_module+0x1b4/0x280
> >  [<ffffffff8039ff18>] ? __up_write+0xd8/0x150
> >  [<ffffffff8053e35f>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> >  [<ffffffff8020c19b>] system_call_fastpath+0x16/0x1b
> 
> ugh, where to start?
> 
> sysdev_driver_register() calls all the ->add methods and cheerily drops
> their return codes on the floor.  Consequently
> sysdev_driver_unregister() will call the ->remove method on objects
> which were not successfully add()ed.

Ugh, the sysdev code sucks so badly it's not funny.  It's next on my
chopping block for cleanups, need to still do some driver core rework
first though :(

> mc_sysdev_add() will return an error if microcode_init_cpu() failed but
> fails to remove its attr_group in that case.  So if
> sysdev_driver_register()/sysdev_driver_unregister() get fixed,
> microcode will misbehave.
> 
> This patch:
> 
> : commit af5c820a3169e81af869c113e18ec7588836cd50
> : Author:     Rusty Russell <rusty@rustcorp.com.au>
> : AuthorDate: Wed Mar 11 16:32:36 2009 +1030
> : Commit:     Ingo Molnar <mingo@elte.hu>
> : CommitDate: Wed Mar 18 13:50:47 2009 +0100
> : 
> :     x86: cpumask: use work_on_cpu in arch/x86/kernel/microcode_core.c
> : 
> 
> attempted to fix things up a bit:
> 
> : @@ -379,8 +390,11 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
> :         if (err)
> :                 return err;
> :  
> : -       microcode_init_cpu(cpu);
> : -       return 0;
> : +       err = microcode_init_cpu(cpu);
> : +       if (err)
> : +               sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
> : +
> : +       return err;
> :  }
> :  
> :  static int mc_sysdev_remove(struct sys_device *sys_dev)
> 
> But it seems that the sysfs_remove_group() later got removed again.

So, this is a microcode specific issue?

thanks,

greg k-h
