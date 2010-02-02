Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0BBUiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:38:07 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53363 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab0BBUiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:38:04 -0500
Date: Tue, 2 Feb 2010 21:38:00 +0100
From: Andreas Mohr <andi@lisas.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Andreas Mohr <andi@lisas.de>, Oliver Neukum <oliver@neukum.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       Luke -Jr <luke@dashjr.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100202203800.GA21253@rhlx01.hs-esslingen.de>
References: <20100129185434.GH19501@one-eyed-alien.net> <201002021248.10994.oliver@neukum.org> <1265112072.12634.53.camel@pc1117.cambridge.arm.com> <201002021307.56991.oliver@neukum.org> <20100202121116.GA24926@rhlx01.hs-esslingen.de> <4B6839E9.1040407@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6839E9.1040407@ladisch.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 03:42:49PM +0100, Clemens Ladisch wrote:
> Andreas Mohr wrote:
> > Or... usb-audio? I should have verified that it is using bulk endpoints
> > (and thus the patch applies to my case).
> > usb-audio probably uses isochronous transfers, thus that would be
> > an obvious reason why the patch didn't work for me.
> 
> snd-usb-audio indeed uses isochronous transfers, but those buffers are
> never mapped into user space.  The intermediate vmalloc()ed buffer is,
> however, and there was a bugfix for this recently.  Do you have these
> patches in your tree?
> http://git.kernel.org/?p=linux/kernel/git/tiwai/sound-2.6.git;a=commit;h=3e879d7bac705be4813a0ec9560cbe31db4b269f
> http://git.kernel.org/?p=linux/kernel/git/tiwai/sound-2.6.git;a=commit;h=c32d977b8157bf67cdf47729ce7dd054a26eb534

OK, I've now added both patches to my quilt series (and pushed everything),
rebuilt, reflashed image and copied modules, and it still bombs
just the very same way.
And this also with Catalins latest patch version (the one using != PIPE_CONTROL
to hit iso transfers etc. as well).
So it seems I still haven't got to the core of the issue despite all these
rather different patch attempts.

I'm afraid if it turns out that keeping open the sound device manually
via another process manages to workaround it, then I'll simply
give it all up completely and live with the current semi-satisfying situation
on my custom 2.6.31.9 build.

Any further ideas or patches that I could try?
(I might investigate the issue myself in a serious way sometime later,
but don't count on it)

Thanks!

Andreas Mohr

netconsole log (some previous crashes were at __bzero, now it was two times
at __copy_user - maybe the patches changed something for real?):

Instruction bus error, epc == 80004dd8, ra == 80000018
Oops[#1]:                                             
Cpu 0                                                 
$ 0   : 00000000 1000d000 00000000 00000000           
$ 4   : 7f9e6be8 81ee7ec4 00000004 00000000           
$ 8   : 00000000 00000000 00000000 81fac000           
$12   : 4b688a80 80340000 81d6e868 00000400           
$16   : 81ee7f00 00000000 7f9e6be8 00000001           
$20   : 81ee7eb8 00000000 7f9e6c9c 7f9eb320           
$24   : 00000000 2b565ed0                             
$28   : 81ee6000 81ee7ea8 7f9f6c98 80000018           
Hi    : 00000000                                      
Lo    : 00000000                                      
epc   : 80004dd8 __copy_user+0xd4/0x2bc               
    Not tainted                                       
ra    : 80000018 0x80000018                           
Status: 1000d003    KERNEL EXL IE                     
Cause : 00800018                                      
PrId  : 00029029 (Broadcom BCM3302)                   
Modules linked in: snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm evdev snd_timer snd_page_alloc snd_usb_lib snd_rawmidi usbhid snd_seq_device snd_hwdep hid snd input_core soundcore ipv6 arc4 ecb cryptomgr aead pcompress crypto_blkcipher crypto_hash crypto_algapi b43 mac80211 cfg80211                                                                    
Process mpd (pid: 1310, threadinfo=81ee6000, task=81d92838, tls=00000000)                                             
Stack : 00000000 800afd4c 81ee56f8 00000219 00000000 00000000 00000000 00000000                                       
        ffffffff 3b043616 81ee7f00 7f9e6be8 00000000 00000000 00000000 800b1370                                       
        7f9e6ca0 81ee5680 000182fc 00493a83 81ee7f00 8009f6b0 00000219 03b1daad                                       
        00000000 00002710 00000000 00000000 7f9f6ca0 7f9e6ca0 7f9ec528 00000127                                       
        00000000 800031f0 00000000 2ae49060 7f9f75a8 2ae49060 7f9e6be8 7f9f5bd8                                       
        ...                                                                                                           
Call Trace:                                                                                                           
[<80004dd8>] __copy_user+0xd4/0x2bc                                                                                   


Code: 8ca80000  24a50004  24c6fffc <ac880000> 1706fffb  24840004  10c00040  00864821  240a0020 
Disabling lock debugging due to kernel taint                                                   
Instruction bus error, epc == 80096fa0, ra == 80000018                                         
Oops[#2]:                                                                                      
Cpu 0                                                                                          
$ 0   : 00000000 1000d000 c0156064 00000064                                                    
$ 4   : 00000032 803b5514 00000032 81fa8000                                                    
$ 8   : 8037f840 00080000 81040000 00000003                                                    
$12   : 00000010 8037f840 00000004 00000000                                                    
$16   : 00000032 81fa8d54 2ab55000 00398f45                                                    
$20   : 2ab56000 0064d613 00000000 00000000                                                    
$24   : 00000000 80018ff0                                                                      
$28   : 81ee6000 81ee7c58 00000000 80000018                                                    
Hi    : 00000000                                                                               
Lo    : 00000000                                                                               
epc   : 80096fa0 swap_info_get+0x74/0xfc                                                       
    Tainted: G      D                                                                          
ra    : 80000018 0x80000018                                                                    
Status: 1000d003    KERNEL EXL IE                                                              
Cause : 00800018                                                                               
PrId  : 00029029 (Broadcom BCM3302)                                                            
Modules linked in: snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm evdev snd_timer snd_page_alloc snd_usb_lib snd_rawmidi usbhid snd_seq_device snd_hwdep hid snd input_core soundcore ipv6 arc4 ecb cryptomgr aead pcompress crypto_blkcipher crypto_hash crypto_algapi b43 mac80211 cfg80211                                                                    
Process mpd (pid: 1310, threadinfo=81ee6000, task=81d92838, tls=00000000)                                             
Stack : ffffffff 800736a0 00000004 81d6e870 80350fd0 80099498 81d929cc 81036e40                                       
        81fa8bfc 2aaff000 00064000 81fa8d54 2ab55000 80088a30 8033dab8 80029d78                                       
        803402d4 00000006 2ab55fff 8033d9c0 81eaae60 81f0c2a8 81f0c2a8 2ab56000                                       
        00000000 00000001 80c4c0bc 81eaae60 8037f840 81eaae94 81d92838 00000000                                       
        00000001 7f9eb320 7f9f6c98 8008db1c 81ee7d00 80c4ce90 00000000 ffffffff                                       
        ...                                                                                                           
Call Trace:                                                                                                           
[<80096fa0>] swap_info_get+0x74/0xfc                                                                                  
[<80099498>] free_swap_and_cache+0x1c/0x218                                                                           
[<80088a30>] unmap_vmas+0x418/0x63c                                                                                   
[<8008db1c>] exit_mmap+0xb8/0x148                                                                                     
[<8002e3c4>] mmput+0xc0/0x1d8                                                                                         
[<800333e8>] exit_mm+0x260/0x298
[<800357cc>] do_exit+0x1cc/0x688
[<80014658>] nmi_exception_handler+0x0/0x34


Code: 00041840  8ca20020  00431021 <94440000> 1480001d  8fbf0014  3c048030  3c05802c  24a5f280
Fixing recursive fault but reboot is needed!
Instruction bus error, epc == 80004dd8, ra == 80000018
Oops[#3]:
Cpu 0
$ 0   : 00000000 1000d000 00000000 00000000
$ 4   : 7fcd81b0 81c0ddd0 00000000 1000d001
$ 8   : 00000000 00000000 00000000 806f8000
$12   : 4b688a84 7f9f7f18 81d6e868 00000000
$16   : 00000004 00000000 81c0ddc0 81c0ddc0
$20   : 7fcd81b0 00000000 81c0ddcc 00000000
$24   : 00000000 2b565ed0
$28   : 81c0c000 81c0dd98 00000001 80000018
Hi    : 0000007d
Lo    : eb254400
epc   : 80004dd8 __copy_user+0xd4/0x2bc
    Tainted: G      D
ra    : 80000018 0x80000018
Status: 1000d003    KERNEL EXL IE
Cause : 00800018
PrId  : 00029029 (Broadcom BCM3302)
Modules linked in: snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm evdev snd_timer snd_page_alloc snd_usb_lib snd_rawmidi usbhid snd_seq_device snd_hwdep hid snd input_core soundcore ipv6 arc4 ecb cryptomgr aead pcompress crypto_blkcipher crypto_hash crypto_algapi b43 mac80211 cfg80211
Process init (pid: 1, threadinfo=81c0c000, task=81c08480, tls=00000000)
Stack : 00000000 81c0dda8 81c0df00 80350fb0 81c0ddc0 81c0ddc4 81c0ddc8 81c0ddcc
        81c0ddd0 81c0ddd4 00000400 00000000 00000000 00000000 00000000 00000000
        00000000 00000000 81d98000 ffffff9c 81c0dea8 0044a234 7fcd8598 8009b864
        00000001 81c0dea8 00000001 81d98000 ffffff9c 800a2d18 00000003 00000002
        00000003 00000003 0000000d 00000000 00000000 00000000 000000c9 00001180
        ...
Call Trace:
[<80004dd8>] __copy_user+0xd4/0x2bc


Code: 8ca80000  24a50004  24c6fffc <ac880000> 1706fffb  24840004  10c00040  00864821  240a0020
kobject: 'ep_01' (81e52f10): kobject_uevent_env
kobject: 'ep_01' (81e52f10): kobject_uevent_env: filter function caused the event to drop!
Kernel panic - not syncing: Attempted to kill init!

