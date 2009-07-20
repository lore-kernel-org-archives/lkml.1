Return-Path: <linux-kernel-owner+w=401wt.eu-S1751135AbZGTFDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbZGTFDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 01:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZGTFDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 01:03:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:60111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZGTFDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 01:03:07 -0400
Subject: Re: [PATCH] SOUND: OSS sequencer should be initialized after
 snd_seq_system_client_init
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1248041987.4302.6.camel@toshiba-laptop>
References: <1247861644.4513.15.camel@ht.satnam>
	 <s5h4ot8op0b.wl%tiwai@suse.de> <1248017194.2548.3.camel@ht.satnam>
	 <s5h1voclkz0.wl%tiwai@suse.de>  <1248020914.2471.4.camel@ht.satnam>
	 <1248041987.4302.6.camel@toshiba-laptop>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 10:32:01 +0530
Message-Id: <1248066121.2626.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Catalin,

On Sun, 2009-07-19 at 23:19 +0100, Catalin Marinas wrote:
> On Sun, 2009-07-19 at 21:58 +0530, Jaswinder Singh Rajput wrote:
> > [PATCH] SOUND: OSS sequencer should be initialized after snd_seq_system_client_init
> > 
> > When build SND_SEQUENCER in kernel then OSS sequencer(alsa_seq_oss_init)
> > is initialized before System (snd_seq_system_client_init) which leads to
> > memory leak :
> 
> Thanks for investigating this. I haven't looked at the code in detail
> but I find it a bit weird that initialisation order fixes the memory
> leak. Shouldn't the memory allocation logic change slightly to avoid the
> leak as well (that's in case someone manually inserts the modules in the
> wrong order)?
> 

No, you cannot change the order of modules because 
'insmod sound/core/seq/oss/snd-seq-oss.ko' need following symbols :

[  385.258252] snd_seq_oss: Unknown symbol snd_seq_kernel_client_enqueue
[  385.258435] snd_seq_oss: Unknown symbol snd_seq_set_queue_tempo
[  385.258639] snd_seq_oss: Unknown symbol snd_seq_delete_kernel_client
[  385.258751] snd_seq_oss: Unknown symbol snd_seq_autoload_lock
[  385.258871] snd_seq_oss: Unknown symbol snd_seq_kernel_client_dispatch
[  385.259782] snd_seq_oss: Unknown symbol snd_seq_kernel_client_enqueue_blocking
[  385.260191] snd_seq_oss: Unknown symbol snd_seq_autoload_unlock
[  385.260418] snd_seq_oss: Unknown symbol snd_seq_device_register_driver
[  385.260537] snd_seq_oss: Unknown symbol snd_midi_event_free
[  385.260701] snd_seq_oss: Unknown symbol snd_midi_event_no_status
[  385.260964] snd_seq_oss: Unknown symbol snd_use_lock_sync_helper
[  385.261469] snd_seq_oss: Unknown symbol snd_seq_device_unregister_driver
[  385.261659] snd_seq_oss: Unknown symbol snd_seq_event_port_detach
[  385.261768] snd_seq_oss: Unknown symbol snd_midi_event_new
[  385.261910] snd_seq_oss: Unknown symbol snd_midi_event_decode
[  385.262067] snd_seq_oss: Unknown symbol snd_seq_create_kernel_client
[  385.262233] snd_seq_oss: Unknown symbol snd_seq_kernel_client_write_poll
[  385.262432] snd_seq_oss: Unknown symbol snd_midi_event_encode_byte
[  385.262963] snd_seq_oss: Unknown symbol snd_seq_kernel_client_ctl

And we can get these symbols in this way :

1. insmod sound/core/seq/snd-seq-device.ko
[  385.258751] snd_seq_oss: Unknown symbol snd_seq_autoload_lock
[  385.260191] snd_seq_oss: Unknown symbol snd_seq_autoload_unlock
[  385.260418] snd_seq_oss: Unknown symbol snd_seq_device_register_driver
[  385.261469] snd_seq_oss: Unknown symbol snd_seq_device_unregister_driver

2. insmod sound/core/seq/snd-seq.ko
[  385.258252] snd_seq_oss: Unknown symbol snd_seq_kernel_client_enqueue
[  385.258435] snd_seq_oss: Unknown symbol snd_seq_set_queue_tempo
[  385.258639] snd_seq_oss: Unknown symbol snd_seq_delete_kernel_client
[  385.258871] snd_seq_oss: Unknown symbol snd_seq_kernel_client_dispatch
[  385.259782] snd_seq_oss: Unknown symbol snd_seq_kernel_client_enqueue_blocking
[  385.260964] snd_seq_oss: Unknown symbol snd_use_lock_sync_helper
[  385.261659] snd_seq_oss: Unknown symbol snd_seq_event_port_detach
[  385.262067] snd_seq_oss: Unknown symbol snd_seq_create_kernel_client
[  385.262233] snd_seq_oss: Unknown symbol snd_seq_kernel_client_write_poll
[  385.262963] snd_seq_oss: Unknown symbol snd_seq_kernel_client_ctl

3. insmod sound/core/seq/snd-seq-midi-event.ko
[  385.260701] snd_seq_oss: Unknown symbol snd_midi_event_no_status
[  385.260537] snd_seq_oss: Unknown symbol snd_midi_event_free
[  385.261768] snd_seq_oss: Unknown symbol snd_midi_event_new
[  385.261910] snd_seq_oss: Unknown symbol snd_midi_event_decode
[  385.262432] snd_seq_oss: Unknown symbol snd_midi_event_encode_byte

So the only order is :

1. insmod sound/core/seq/snd-seq-device.ko
2. insmod sound/core/seq/snd-seq.ko
3. insmod sound/core/seq/snd-seq-midi-event.ko
4. insmod sound/core/seq/oss/snd-seq-oss.ko

which is correct, if you change the order like we was getting in
build-in kernel, which leads to improper initialization and memory leak
was the side-effect.

Thanks,
--
JSR

