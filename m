Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbYFKViG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbYFKViG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 17:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYFKVhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 17:37:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:8226 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYFKVhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 17:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EMdU1hfP1BnvYPuO9f6HwcB34AarHsLjjaKegahTBOeX4OIUsrIHmVVhnS8IZfMWNP
         17D+x6B1CGQlcwusthciROLcVryTVB0eUCYL8a2jWd1WxPDOYdlyt0Ymcr/Lz/oDyNWN
         4qSMMHrTZlbIg81gESrMt8rpU1efeI/soGsCg=
Message-ID: <6278d2220806111437m22b16795i9650bad8f93120e6@mail.gmail.com>
Date: Wed, 11 Jun 2008 22:37:49 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 8:00 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> On Tue, Jun 10, 2008 at 6:59 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> At Mon, 9 Jun 2008 20:59:00 +0100,
>> Daniel J Blueman wrote:
>>>
>>> Hi Takashi-san,
>>>
>>> I'm experiencing DC offset with the microphone on 2.6.24 (Ubuntu 8.04
>>> LTS x86-64). I can see on Audacity that the DC offset that varies with
>>> the recording capture level.
>>
>> Could you elaborate?  The mic bias level could be changed via the pin
>> control value.  Usually, it's set as VREF 80%.
>
> When the recording->capture level is set to 0, the mic has no DC
> offset as expected. Maxing the recording->capture level, the mic input
> is saturated, in between, we see a linear connection.
>
>>> Plus, the mixer playback->mic-boost
>>> muting enables/disables mic-boost in recording.
>>
>> This is a known bug in alsa-lib mixer abstraction.  No kernel issue.
>
>>> It feels like the ALC883 pins aren't configured quite right. The mobo
>>> is an Asus P5E-VM with current BIOS [1]
>>>
>>> What's the routine to debug this? Would it help to install windows,
>>> dump the register space and compare?
>>
>> You can find *.INI file that contains the default pin configuration
>> in Windows.  This might be useful in the case BIOS is broken but
>> Windows does a black magic.
>
> That'll be these defaults stashed in the INF file [2]. Let me know if
> it's not what you expected and I'll publish the complete INF file.
>
>> Anyway, please run alsa-info.sh with --no-upload option and show the
>> generated file here.  It contains the codec information and mixer
>> setup.
>>        http://hg.alsa-project.org/alsa/raw-file/tip/alsa-info.sh
>
> See [3].

>> Also, you can adjust the pin setting on the fly via hda-verb utility
>> below:
>>        http://ftp.suse.com/pub/people/tiwai/misc/hda-verb-0.2.tar.bz2
>>
>> Don't forget to build snd-hda-intel module with
>> CONFIG_SND_HDA_HWDEP=y to use this command.
>
> I'll give this a shot if I get time.

Looking at the datasheet and ALSA report, changing the front mic node
id also affects capturing from the (rear) mic input.

ftp://66.104.77.130/pc/audio/ALC883_DataSheet_1.3.pdf

We get the "hda_codec: Unknown model for ALC883, trying auto-probe
from BIOS..." kernel message, so we may need to tweak
pci/hda/patch_realtek.c. Also, I can reproduce the problem the with HD
and legacy front-panel audio settings in the BIOS. Do you know a way
to dump eg the pin configuration in windows or other useful state, so
I can compare with all the possible node ID configuration values?

> Thanks for your time!
>  Daniel
>
>> Takashi
>>
>>>
>>> Thanks in advance,
>>>   Daniel
>>>
>>> --- [1]
>>>
>>> $ sudo lspci -vvvxxxs 0:1b.0
>>> 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
>>> Controller (rev 02)
>>>       Subsystem: ASUSTeK Computer Inc. Unknown device 829f
>>>       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>>> Stepping- SERR- FastB2B-
>>>       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>>> <TAbort- <MAbort- >SERR- <PERR-
>>>       Latency: 0, Cache Line Size: 32 bytes
>>>       Interrupt: pin A routed to IRQ 22
>>>       Region 0: Memory at fe9f8000 (64-bit, non-prefetchable) [size=16K]
>>>       Capabilities: [50] Power Management version 2
>>>               Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>>       Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>>>               Address: 0000000000000000  Data: 0000
>>>       Capabilities: [70] Express Unknown type IRQ 0
>>>               Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>>>               Device: Latency L0s <64ns, L1 <1us
>>>               Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>>               Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>               Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>               Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
>>>               Link: Latency L0s <64ns, L1 <1us
>>>               Link: ASPM Disabled CommClk- ExtSynch-
>>>               Link: Speed unknown, Width x0
>>> 00: 86 80 3e 29 06 00 10 00 02 00 03 04 08 00 00 00
>>> 10: 04 80 9f fe 00 00 00 00 00 00 00 00 00 00 00 00
>>> 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 9f 82
>>> 30: 00 00 00 00 50 00 00 00 00 00 00 00 0f 01 00 00
>>> 40: 01 00 00 07 00 00 00 00 00 00 00 00 00 00 00 00
>>> 50: 01 60 42 c8 00 00 00 00 00 00 00 00 00 00 00 00
>>> 60: 05 70 80 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> 70: 10 00 91 00 00 00 00 10 00 08 10 00 00 00 00 00
>>> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> c0: 00 04 00 01 00 00 00 00 31 00 a3 02 00 00 00 00
>>> d0: 61 00 a3 02 00 00 00 00 00 00 00 00 00 00 00 00
>>> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> f0: 00 00 00 00 00 00 00 00 86 0f 02 00 00 00 00 00
>>>
>>> $ aplay -l
>>> **** List of PLAYBACK Hardware Devices ****
>>> card 0: Intel [HDA Intel], device 0: ALC883 Analog [ALC883 Analog]
>>>   Subdevices: 1/1
>>>   Subdevice #0: subdevice #0
>>> card 0: Intel [HDA Intel], device 1: ALC883 Digital [ALC883 Digital]
>>>   Subdevices: 1/1
>>>   Subdevice #0: subdevice #0
>>> card 0: Intel [HDA Intel], device 3: ATI HDMI [ATI HDMI]
>>>   Subdevices: 1/1
>>>   Subdevice #0: subdevice #0
>>> card 2: HDMI [HDA ATI HDMI], device 3: ATI HDMI [ATI HDMI]
>>>   Subdevices: 1/1
>>>   Subdevice #0: subdevice #0
>>> daniel@veyron:~$ aplay -L
>>> default:CARD=Intel
>>>     HDA Intel, ALC883 Analog
>>>     Default Audio Device
>>> front:CARD=Intel,DEV=0
>>>     HDA Intel, ALC883 Analog
>>>     Front speakers
>>> surround40:CARD=Intel,DEV=0
>>>     HDA Intel, ALC883 Analog
>>>     4.0 Surround output to Front and Rear speakers
>>> surround41:CARD=Intel,DEV=0
>>>     HDA Intel, ALC883 Analog
>>>     4.1 Surround output to Front, Rear and Subwoofer speakers
>>> surround50:CARD=Intel,DEV=0
>>>     HDA Intel, ALC883 Analog
>>>     5.0 Surround output to Front, Center and Rear speakers
>>> surround51:CARD=Intel,DEV=0
>>>     HDA Intel, ALC883 Analog
>>>     5.1 Surround output to Front, Center, Rear and Subwoofer speakers
>>> surround71:CARD=Intel,DEV=0
>>>     HDA Intel, ALC883 Analog
>>>     7.1 Surround output to Front, Center, Side, Rear and Woofer speakers
>>> null
>>>     Discard all samples (playback) or generate zero samples (capture)
>>> default:CARD=U0x46d0x990
>>>     USB Device 0x46d:0x990, USB Audio
>>>     Default Audio Device
>>> front:CARD=U0x46d0x990,DEV=0
>>>     USB Device 0x46d:0x990, USB Audio
>>>     Front speakers
>>> surround40:CARD=U0x46d0x990,DEV=0
>>>     USB Device 0x46d:0x990, USB Audio
>>>     4.0 Surround output to Front and Rear speakers
>>> surround41:CARD=U0x46d0x990,DEV=0
>>>     USB Device 0x46d:0x990, USB Audio
>>>     4.1 Surround output to Front, Rear and Subwoofer speakers
>>> surround50:CARD=U0x46d0x990,DEV=0
>>>     USB Device 0x46d:0x990, USB Audio
>>>     5.0 Surround output to Front, Center and Rear speakers
>>> surround51:CARD=U0x46d0x990,DEV=0
>>>     USB Device 0x46d:0x990, USB Audio
>>>     5.1 Surround output to Front, Center, Rear and Subwoofer speakers
>>> surround71:CARD=U0x46d0x990,DEV=0
>>>     USB Device 0x46d:0x990, USB Audio
>>>     7.1 Surround output to Front, Center, Side, Rear and Woofer speakers
>>> iec958:CARD=U0x46d0x990,DEV=0
>>>     USB Device 0x46d:0x990, USB Audio
>>>     IEC958 (S/PDIF) Digital Audio Output
>>> front:CARD=HDMI
>>>     HDA ATI HDMI
>>>     Front speakers
>>> surround40:CARD=HDMI
>>>     HDA ATI HDMI
>>>     4.0 Surround output to Front and Rear speakers
>>> surround41:CARD=HDMI
>>>     HDA ATI HDMI
>>>     4.1 Surround output to Front, Rear and Subwoofer speakers
>>> surround50:CARD=HDMI
>>>     HDA ATI HDMI
>>>     5.0 Surround output to Front, Center and Rear speakers
>>> surround51:CARD=HDMI
>>>     HDA ATI HDMI
>>>     5.1 Surround output to Front, Center, Rear and Subwoofer speakers
>>> surround71:CARD=HDMI
>>>     HDA ATI HDMI
>>>     7.1 Surround output to Front, Center, Side, Rear and Woofer speakers
>
> --- [2]
>
> [OEMSettingsOverride.AddReg]
> HKR,"EP\\0", %PKEY_AudioEndpoint_Association%,,%KSNODETYPE_ANY%
> ;48k16bit HKR,"EP\\0", %PKEY_AudioEngine_OEMFormat%, %REG_BINARY%,
> 41,00,C8,70,28,00,00,00,FE,FF,02,00,80,BB,00,00,00,EE,02,00,04
> ,00,10,00,16,00,10,00,03,00,00,00,01,00,00,00,00,00,10,00,80,00,00,AA,00,38,9B,71
> HKR,"EP\\0", %PKEY_AudioEngine_OEMFormat%, %REG_BINARY%,
> 41,00,C8,70,28,00,00,00,FE,FF,02,00,80,BB,00,00,00,DC,05,00,08,00,20,00,
> 16,00,18,00,03,00,00,00,01,00,00,00,00,00,10,00,80,00,00,AA,00,38,9B,71
> ;;HKR,"EP\\0", %PKEY_AudioEndpoint_Ext_UiClsid%,,%AUDIOENDPOINT_EXT_UI_CLSID%
>
> [OEMSPDIFSettingsOverride.AddReg]
> HKR,"EP\\0", %PKEY_AudioEndpoint_Association%,,%KSNODETYPE_HDMI_INTERFACE%
> HKR,"EP\\0", %PKEY_AudioEngine_OEMFormat%, %REG_BINARY%,
> 41,00,C8,70,28,00,00,00,FE,FF,02,00,80,BB,00,00,00,EE,02,00,04,00,10,00,
> 16,00,10,00,03,00,00,00,01,00,00,00,00,00,10,00,80,00,00,AA,00,38,9B,71
> HKR,"EP\\0", %PKEY_SupportFormat_OEMFormat%, %REG_BINARY%,
> 41,00,75,00,0c,00,00,00,10,00,00,00,02,00,00,00,00,00,00,00
>
> HKR,"EP\\1", %PKEY_AudioEndpoint_Association%,,%KSNODETYPE_ANY%
> HKR,"EP\\1", %PKEY_AudioEngine_OEMFormat%, %REG_BINARY%,
> 41,00,C8,70,28,00,00,00,FE,FF,02,00,80,BB,00,00,00,EE,02,00,04,00,10,00,
> 16,00,10,00,03,00,00,00,01,00,00,00,00,00,10,00,80,00,00,AA,00,38,9B,71
>
> --- [3]
>
> name=daniel&type=33&description=/tmp/alsa-info.txt&expiry=&s=Submit+Post&content=
> !!################################
> !!ALSA Information Script v 0.4.48
> !!################################
>
> !!Script ran on: Wed Jun 11 19:13:55 BST 2008
>
>
> !!Linux Distribution
> !!------------------
>
> Ubuntu 8.04 \n \l DISTRIB_ID=Ubuntu DISTRIB_DESCRIPTION="Ubuntu 8.04"
>
>
> !!Kernel Information
> !!------------------
>
> Kernel release:    2.6.24-18-generic
> Operating System:  GNU/Linux
> Architecture:      x86_64
> Processor:         unknown
> SMP Enabled:       Yes
>
>
> !!ALSA Version
> !!------------
>
> Driver version:     1.0.16
> Library version:    1.0.15
> Utilities version:  1.0.15
>
>
> !!Loaded ALSA modules
> !!-------------------
>
> snd_hda_intel
> snd_usb_audio
> snd_hda_intel
>
>
> !!Soundcards recognised by ALSA
> !!-----------------------------
>
>  0 [Intel          ]: HDA-Intel - HDA Intel
>                      HDA Intel at 0xfe9f8000 irq 22
>  1 [U0x46d0x990    ]: USB-Audio - USB Device 0x46d:0x990
>                      USB Device 0x46d:0x990 at usb-0000:00:1a.7-1, high speed
>  2 [HDMI           ]: HDA-Intel - HDA ATI HDMI
>                      HDA ATI HDMI at 0xfeafc000 irq 17
>
>
> !!PCI Soundcards installed in the system
> !!--------------------------------------
>
> 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
> Controller (rev 02)
> 01:00.1 Audio device: ATI Technologies Inc Radeon HD 3870 Audio device
>
>
> !!Advanced information - PCI Vendor/Device/Susbsystem ID's
> !!--------------------------------------------------------
>
> 00:1b.0 0403: 8086:293e (rev 02)
>        Subsystem: 1043:829f
> --
> 01:00.1 0403: 1002:aa18
>        Subsystem: 174b:aa18
>
>
> !!Modprobe options (Sound related)
> !!--------------------------------
>
> snd-atiixp-modem: index=-2
> snd-intel8x0m: index=-2
> snd-via82xx-modem: index=-2
> snd-usb-audio: index=-2
> snd-usb-usx2y: index=-2
> snd-usb-caiaq: index=-2
> snd-cmipci: mpu_port=0x330 fm_port=0x388
>
>
> !!Loaded sound module options
> !!--------------------------
>
> !!Module: snd_hda_intel
> enable : Y,Y,Y,Y,Y,Y,Y,Y
> enable_msi : 0
> id : <NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>
> index : -1,-1,-1,-1,-1,-1,-1,-1
> model : <NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>
> position_fix : 0,0,0,0,0,0,0,0
> power_save : 0
> power_save_controller : Y
> probe_mask : -1,-1,-1,-1,-1,-1,-1,-1
> single_cmd : N
>
> !!Module: snd_usb_audio
> async_unlink : Y
> device_setup : 0,0,0,0,0,0,0,0
> enable : Y,Y,Y,Y,Y,Y,Y,Y
> id : <NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>
> index : -2,-1,-1,-1,-1,-1,-1,-1
> nrpacks : 8
> pid : -1,-1,-1,-1,-1,-1,-1,-1
> vid : -1,-1,-1,-1,-1,-1,-1,-1
>
> !!Module: snd_hda_intel
> enable : Y,Y,Y,Y,Y,Y,Y,Y
> enable_msi : 0
> id : <NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>
> index : -1,-1,-1,-1,-1,-1,-1,-1
> model : <NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>
> position_fix : 0,0,0,0,0,0,0,0
> power_save : 0
> power_save_controller : Y
> probe_mask : -1,-1,-1,-1,-1,-1,-1,-1
> single_cmd : N
>
>
> !!HDA-Intel Codec information
> !!---------------------------
> --startcollapse--
>
> Codec: Realtek ALC883
> Address: 0
> Vendor Id: 0x10ec0883
> Subsystem Id: 0x1043829f
> Revision Id: 0x100002
> No Modem Function Group found
> Default PCM:
>    rates [0x560]: 44100 48000 96000 192000
>    bits [0xe]: 16 20 24
>    formats [0x1]: PCM
> Default Amp-In caps: N/A
> Default Amp-Out caps: N/A
> GPIO: io=2, o=0, i=0, unsolicited=1, wake=0
>  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0
>  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0
> Node 0x02 [Audio Output] wcaps 0x11: Stereo
>  Converter: stream=0, channel=0
>  PCM:
>    rates [0x560]: 44100 48000 96000 192000
>    bits [0xe]: 16 20 24
>    formats [0x1]: PCM
> Node 0x03 [Audio Output] wcaps 0x11: Stereo
>  Converter: stream=0, channel=0
>  PCM:
>    rates [0x560]: 44100 48000 96000 192000
>    bits [0xe]: 16 20 24
>    formats [0x1]: PCM
> Node 0x04 [Audio Output] wcaps 0x11: Stereo
>  Converter: stream=0, channel=0
>  PCM:
>    rates [0x560]: 44100 48000 96000 192000
>    bits [0xe]: 16 20 24
>    formats [0x1]: PCM
> Node 0x05 [Audio Output] wcaps 0x11: Stereo
>  Converter: stream=0, channel=0
>  PCM:
>    rates [0x560]: 44100 48000 96000 192000
>    bits [0xe]: 16 20 24
>    formats [0x1]: PCM
> Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
>  Converter: stream=0, channel=0
>  Digital: Enabled GenLevel
>  Digital category: 0x1
>  PCM:
>    rates [0x560]: 44100 48000 96000 192000
>    bits [0x1e]: 16 20 24 32
>    formats [0x1]: PCM
> Node 0x07 [Vendor Defined Widget] wcaps 0xf00000: Mono
> Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
>  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
>  Amp-In vals:  [0x00 0x00]
>  Converter: stream=0, channel=0
>  SDI-Select: 0
>  PCM:
>    rates [0x160]: 44100 48000 96000
>    bits [0x6]: 16 20
>    formats [0x1]: PCM
>  Connection: 1
>     0x23
> Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
>  Amp-In caps: ofs=0x08, nsteps=0x1f, stepsize=0x05, mute=1
>  Amp-In vals:  [0x80 0x80]
>  Converter: stream=0, channel=0
>  SDI-Select: 0
>  PCM:
>    rates [0x160]: 44100 48000 96000
>    bits [0x6]: 16 20
>    formats [0x1]: PCM
>  Connection: 1
>     0x22
> Node 0x0a [Audio Input] wcaps 0x100391: Stereo Digital
>  Converter: stream=0, channel=0
>  SDI-Select: 0
>  Digital:
>  Digital category: 0x0
>  PCM:
>    rates [0x560]: 44100 48000 96000 192000
>    bits [0x1e]: 16 20 24 32
>    formats [0x1]: PCM
>  Unsolicited: tag=00, enabled=0
>  Connection: 1
>     0x1f
> Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
>  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
>  Amp-In vals:  [0x0c 0x0c] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80
> 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
>  Connection: 10
>     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17
> Node 0x0c [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-In vals:  [0x00 0x00] [0x00 0x00]
>  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
>  Amp-Out vals:  [0x1f 0x1f]
>  Connection: 2
>     0x02 0x0b
> Node 0x0d [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-In vals:  [0x80 0x80] [0x80 0x80]
>  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
>  Amp-Out vals:  [0x00 0x00]
>  Connection: 2
>     0x03 0x0b
> Node 0x0e [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-In vals:  [0x80 0x80] [0x80 0x80]
>  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
>  Amp-Out vals:  [0x00 0x00]
>  Connection: 2
>     0x04 0x0b
> Node 0x0f [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-In vals:  [0x80 0x80] [0x80 0x80]
>  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
>  Amp-Out vals:  [0x00 0x00]
>  Connection: 2
>     0x05 0x0b
> Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
> Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
> Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
> Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
> Node 0x14 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00]
>  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-Out vals:  [0x00 0x00]
>  Pincap 0x083e: IN OUT HP Detect Trigger
>  Pin Default 0x01014010: [Jack] Line Out at Ext Rear
>    Conn = 1/8, Color = Green
>    DefAssociation = 0x1, Sequence = 0x0
>  Pin-ctls: 0x40: OUT
>  Unsolicited: tag=00, enabled=0
>  Connection: 5
>     0x0c* 0x0d 0x0e 0x0f 0x26
> Node 0x15 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00]
>  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-Out vals:  [0x00 0x00]
>  Pincap 0x083e: IN OUT HP Detect Trigger
>  Pin Default 0x01011012: [Jack] Line Out at Ext Rear
>    Conn = 1/8, Color = Black
>    DefAssociation = 0x1, Sequence = 0x2
>  Pin-ctls: 0x40: OUT
>  Unsolicited: tag=00, enabled=0
>  Connection: 5
>     0x0c 0x0d* 0x0e 0x0f 0x26
> Node 0x16 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00]
>  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-Out vals:  [0x00 0x00]
>  Pincap 0x083e: IN OUT HP Detect Trigger
>  Pin Default 0x01016011: [Jack] Line Out at Ext Rear
>    Conn = 1/8, Color = Orange
>    DefAssociation = 0x1, Sequence = 0x1
>  Pin-ctls: 0x40: OUT
>  Unsolicited: tag=00, enabled=0
>  Connection: 5
>     0x0c 0x0d 0x0e* 0x0f 0x26
> Node 0x17 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00]
>  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-Out vals:  [0x00 0x00]
>  Pincap 0x083e: IN OUT HP Detect Trigger
>  Pin Default 0x01012014: [Jack] Line Out at Ext Rear
>    Conn = 1/8, Color = Grey
>    DefAssociation = 0x1, Sequence = 0x4
>  Pin-ctls: 0x40: OUT
>  Unsolicited: tag=00, enabled=0
>  Connection: 5
>     0x0c 0x0d 0x0e 0x0f* 0x26
> Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>  Amp-In vals:  [0x03 0x03] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00]
>  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-Out vals:  [0x80 0x80]
>  Pincap 0x08173e: IN OUT HP Detect Trigger
>    Vref caps: HIZ 50 GRD 80
>  Pin Default 0x01a19840: [Jack] Mic at Ext Rear
>    Conn = 1/8, Color = Pink
>    DefAssociation = 0x4, Sequence = 0x0
>  Pin-ctls: 0x24: IN VREF_80
>  Unsolicited: tag=00, enabled=0
>  Connection: 5
>     0x0c* 0x0d 0x0e 0x0f 0x26
> Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00]
>  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-Out vals:  [0x80 0x80]
>  Pincap 0x08173e: IN OUT HP Detect Trigger
>    Vref caps: HIZ 50 GRD 80
>  Pin Default 0x02a19c50: [Jack] Mic at Ext Front
>    Conn = 1/8, Color = Pink
>    DefAssociation = 0x5, Sequence = 0x0
>  Pin-ctls: 0x24: IN VREF_80
>  Unsolicited: tag=00, enabled=0
>  Connection: 5
>     0x0c* 0x0d 0x0e 0x0f 0x26
> Node 0x1a [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00]
>  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-Out vals:  [0x80 0x80]
>  Pincap 0x08173e: IN OUT HP Detect Trigger
>    Vref caps: HIZ 50 GRD 80
>  Pin Default 0x0181304f: [Jack] Line In at Ext Rear
>    Conn = 1/8, Color = Blue
>    DefAssociation = 0x4, Sequence = 0xf
>  Pin-ctls: 0x20: IN VREF_HIZ
>  Unsolicited: tag=00, enabled=0
>  Connection: 5
>     0x0c* 0x0d 0x0e 0x0f 0x26
> Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x00 0x00]
>  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-Out vals:  [0x00 0x00]
>  Pincap 0x08173e: IN OUT HP Detect Trigger
>    Vref caps: HIZ 50 GRD 80
>  Pin Default 0x02214c20: [Jack] HP Out at Ext Front
>    Conn = 1/8, Color = Green
>    DefAssociation = 0x2, Sequence = 0x0
>  Pin-ctls: 0xc0: OUT HP VREF_HIZ
>  Unsolicited: tag=04, enabled=1
>  Connection: 5
>     0x0c* 0x0d 0x0e 0x0f 0x26
> Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
>  Pincap 0x0820: IN
>  Pin Default 0x593301f0: [N/A] CD at Int ATAPI
>    Conn = ATAPI, Color = Unknown
>    DefAssociation = 0xf, Sequence = 0x0
>    Misc = NO_PRESENCE
>  Pin-ctls: 0x00:
> Node 0x1d [Pin Complex] wcaps 0x400000: Mono
>  Pincap 0x0820: IN
>  Pin Default 0x4005e601: [N/A] Line Out at Ext N/A
>    Conn = Optical, Color = White
>    DefAssociation = 0x0, Sequence = 0x1
>  Pin-ctls: 0x00:
> Node 0x1e [Pin Complex] wcaps 0x400300: Mono Digital
>  Pincap 0x0810: OUT
>  Pin Default 0x01441130: [Jack] SPDIF Out at Ext Rear
>    Conn = RCA, Color = Black
>    DefAssociation = 0x3, Sequence = 0x0
>    Misc = NO_PRESENCE
>  Pin-ctls: 0x00:
>  Connection: 1
>     0x06
> Node 0x1f [Pin Complex] wcaps 0x400200: Mono Digital
>  Pincap 0x0820: IN
>  Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
>    Conn = 1/8, Color = Black
>    DefAssociation = 0xf, Sequence = 0x0
>    Misc = NO_PRESENCE
>  Pin-ctls: 0x00:
> Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
>  Processing caps: benign=0, ncoeff=17
> Node 0x21 [Vendor Defined Widget] wcaps 0xf00000: Mono
> Node 0x22 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x80 0x80] [0x00
> 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
> [0x80 0x80]
>  Amp-Out caps: N/A
>  Amp-Out vals:  [0x00 0x00]
>  Connection: 11
>     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17 0x0b
> Node 0x23 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x80 0x80] [0x00
> 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
> [0x80 0x80]
>  Amp-Out caps: N/A
>  Amp-Out vals:  [0x00 0x00]
>  Connection: 11
>     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17 0x0b
> Node 0x24 [Vendor Defined Widget] wcaps 0xf00000: Mono
> Node 0x25 [Audio Output] wcaps 0x11: Stereo
>  Converter: stream=0, channel=0
>  PCM:
>    rates [0x560]: 44100 48000 96000 192000
>    bits [0xe]: 16 20 24
>    formats [0x1]: PCM
> Node 0x26 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-In vals:  [0x00 0x00] [0x00 0x00]
>  Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
>  Amp-Out vals:  [0x00 0x00]
>  Connection: 2
>     0x25 0x0b
> Codec: Generic 1095 SI HDMI
> Address: 1
> Vendor Id: 0x10951392
> Subsystem Id: 0xffffffff
> Revision Id: 0x100000
> No Modem Function Group found
> Default PCM:
>    rates [0x0]:
>    bits [0x0]:
>    formats [0x0]:
> Default Amp-In caps: N/A
> Default Amp-Out caps: N/A
> GPIO: io=0, o=0, i=0, unsolicited=0, wake=0
> Node 0x02 [Audio Output] wcaps 0x6211: Stereo Digital
>  Converter: stream=0, channel=0
>  Digital:
>  Digital category: 0x0
>  PCM:
>    rates [0x7f0]: 32000 44100 48000 88200 96000 176400 192000
>    bits [0x1e]: 16 20 24 32
>    formats [0x5]: PCM AC3
> Node 0x03 [Pin Complex] wcaps 0x40738d: Stereo Digital Amp-Out
>  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>  Amp-Out vals:  [0x00 0x00]
>  Pincap 0x0894: OUT Detect R/L
>  Pin Default 0x18560010: [Jack] Digital Out at Int HDMI
>    Conn = Digital, Color = Unknown
>    DefAssociation = 0x1, Sequence = 0x0
>  Pin-ctls: 0x40: OUT
>  Unsolicited: tag=00, enabled=0
>  Connection: 1
>     0x02
> Codec: Generic 1002 ATI R6xx HDMI
> Address: 0
> Vendor Id: 0x1002aa01
> Subsystem Id: 0xaa0100
> Revision Id: 0x100000
> No Modem Function Group found
> Default PCM:
>    rates [0x40]: 48000
>    bits [0x2]: 16
>    formats [0x1]: PCM
> Default Amp-In caps: N/A
> Default Amp-Out caps: N/A
> GPIO: io=0, o=0, i=0, unsolicited=0, wake=0
> Node 0x02 [Audio Output] wcaps 0x201: Stereo Digital
>  Converter: stream=0, channel=0
>  Digital:
>  Digital category: 0x0
> Node 0x03 [Pin Complex] wcaps 0x400381: Stereo Digital
>  Pincap 0x0894: OUT Detect R/L
>  Pin Default 0x18560010: [Jack] Digital Out at Int HDMI
>    Conn = Digital, Color = Unknown
>    DefAssociation = 0x1, Sequence = 0x0
>  Pin-ctls: 0x40: OUT
>  Unsolicited: tag=00, enabled=0
>  Connection: 1
>     0x02
> --endcollapse--
>
>
> !!ALSA Device nodes
> !!-----------------
>
> crw-rw----+ 1 root audio 116,  0 2008-06-11 17:36 /dev/snd/controlC0
> crw-rw----+ 1 root audio 116, 32 2008-06-11 17:36 /dev/snd/controlC1
> crw-rw----+ 1 root audio 116, 64 2008-06-11 17:36 /dev/snd/controlC2
> crw-rw----+ 1 root audio 116,  4 2008-06-11 17:36 /dev/snd/hwC0D0
> crw-rw----+ 1 root audio 116,  5 2008-06-11 17:36 /dev/snd/hwC0D1
> crw-rw----+ 1 root audio 116, 68 2008-06-11 17:36 /dev/snd/hwC2D0
> crw-rw----+ 1 root audio 116, 24 2008-06-11 17:55 /dev/snd/pcmC0D0c
> crw-rw----+ 1 root audio 116, 16 2008-06-11 18:02 /dev/snd/pcmC0D0p
> crw-rw----+ 1 root audio 116, 17 2008-06-11 17:36 /dev/snd/pcmC0D1p
> crw-rw----+ 1 root audio 116, 26 2008-06-11 17:36 /dev/snd/pcmC0D2c
> crw-rw----+ 1 root audio 116, 19 2008-06-11 17:36 /dev/snd/pcmC0D3p
> crw-rw----+ 1 root audio 116, 56 2008-06-11 17:55 /dev/snd/pcmC1D0c
> crw-rw----+ 1 root audio 116, 83 2008-06-11 17:36 /dev/snd/pcmC2D3p
> crw-rw----+ 1 root audio 116,  1 2008-06-11 17:36 /dev/snd/seq
> crw-rw----+ 1 root audio 116, 33 2008-06-11 17:36 /dev/snd/timer
>
>
> !!Aplay/Arecord output
> !!------------
>
> APLAY
>
> **** List of PLAYBACK Hardware Devices ****
> card 0: Intel [HDA Intel], device 0: ALC883 Analog [ALC883 Analog]
>  Subdevices: 1/1
>  Subdevice #0: subdevice #0
> card 0: Intel [HDA Intel], device 1: ALC883 Digital [ALC883 Digital]
>  Subdevices: 1/1
>  Subdevice #0: subdevice #0
> card 0: Intel [HDA Intel], device 3: ATI HDMI [ATI HDMI]
>  Subdevices: 1/1
>  Subdevice #0: subdevice #0
> card 2: HDMI [HDA ATI HDMI], device 3: ATI HDMI [ATI HDMI]
>  Subdevices: 1/1
>  Subdevice #0: subdevice #0
>
> ARECORD
>
> **** List of CAPTURE Hardware Devices ****
> card 0: Intel [HDA Intel], device 0: ALC883 Analog [ALC883 Analog]
>  Subdevices: 1/1
>  Subdevice #0: subdevice #0
> card 0: Intel [HDA Intel], device 2: ALC883 Analog [ALC883 Analog]
>  Subdevices: 1/1
>  Subdevice #0: subdevice #0
> card 1: U0x46d0x990 [USB Device 0x46d:0x990], device 0: USB Audio [USB Audio]
>  Subdevices: 1/1
>  Subdevice #0: subdevice #0
>
> !!Amixer output
> !!-------------
>
> !!-------Mixer controls for card 0 [Intel]
>
> Simple mixer control 'Master',0
>  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
>  Playback channels: Mono
>  Limits: Playback 0 - 31
>  Mono: Playback 31 [100%] [0.00dB] [on]
> Simple mixer control 'Headphone',0
>  Capabilities: pswitch
>  Playback channels: Front Left - Front Right
>  Mono:
>  Front Left: Playback [on]
>  Front Right: Playback [on]
> Simple mixer control 'PCM',0
>  Capabilities: pvolume
>  Playback channels: Front Left - Front Right
>  Limits: Playback 0 - 255
>  Mono:
>  Front Left: Playback 255 [100%] [0.00dB]
>  Front Right: Playback 255 [100%] [0.00dB]
> Simple mixer control 'Front',0
>  Capabilities: pvolume pswitch
>  Playback channels: Front Left - Front Right
>  Limits: Playback 0 - 31
>  Mono:
>  Front Left: Playback 31 [100%] [0.00dB] [on]
>  Front Right: Playback 31 [100%] [0.00dB] [on]
> Simple mixer control 'Front Mic',0
>  Capabilities: pvolume pswitch
>  Playback channels: Front Left - Front Right
>  Limits: Playback 0 - 31
>  Mono:
>  Front Left: Playback 0 [0%] [-34.50dB] [off]
>  Front Right: Playback 0 [0%] [-34.50dB] [off]
> Simple mixer control 'Front Mic Boost',0
>  Capabilities: volume
>  Playback channels: Front Left - Front Right
>  Capture channels: Front Left - Front Right
>  Limits: 0 - 3
>  Front Left: 0 [0%]
>  Front Right: 0 [0%]
> Simple mixer control 'Surround',0
>  Capabilities: pvolume pswitch
>  Playback channels: Front Left - Front Right
>  Limits: Playback 0 - 31
>  Mono:
>  Front Left: Playback 0 [0%] [-46.50dB] [off]
>  Front Right: Playback 0 [0%] [-46.50dB] [off]
> Simple mixer control 'Center',0
>  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
>  Playback channels: Mono
>  Limits: Playback 0 - 31
>  Mono: Playback 0 [0%] [-46.50dB] [off]
> Simple mixer control 'LFE',0
>  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
>  Playback channels: Mono
>  Limits: Playback 0 - 31
>  Mono: Playback 0 [0%] [-46.50dB] [off]
> Simple mixer control 'Side',0
>  Capabilities: pvolume pswitch
>  Playback channels: Front Left - Front Right
>  Limits: Playback 0 - 31
>  Mono:
>  Front Left: Playback 0 [0%] [-46.50dB] [off]
>  Front Right: Playback 0 [0%] [-46.50dB] [off]
> Simple mixer control 'Line',0
>  Capabilities: pvolume pswitch
>  Playback channels: Front Left - Front Right
>  Limits: Playback 0 - 31
>  Mono:
>  Front Left: Playback 0 [0%] [-34.50dB] [off]
>  Front Right: Playback 0 [0%] [-34.50dB] [off]
> Simple mixer control 'Mic',0
>  Capabilities: pvolume pswitch
>  Playback channels: Front Left - Front Right
>  Limits: Playback 0 - 31
>  Mono:
>  Front Left: Playback 12 [39%] [-16.50dB] [on]
>  Front Right: Playback 12 [39%] [-16.50dB] [on]
> Simple mixer control 'Mic Boost',0
>  Capabilities: volume
>  Playback channels: Front Left - Front Right
>  Capture channels: Front Left - Front Right
>  Limits: 0 - 3
>  Front Left: 3 [100%]
>  Front Right: 3 [100%]
> Simple mixer control 'IEC958',0
>  Capabilities: pswitch pswitch-joined
>  Playback channels: Mono
>  Mono: Playback [on]
> Simple mixer control 'IEC958',1
>  Capabilities: pswitch pswitch-joined
>  Playback channels: Mono
>  Mono: Playback [off]
> Simple mixer control 'Capture',0
>  Capabilities: cvolume cswitch
>  Capture channels: Front Left - Front Right
>  Limits: Capture 0 - 31
>  Front Left: Capture 0 [0%] [-12.00dB] [on]
>  Front Right: Capture 0 [0%] [-12.00dB] [on]
> Simple mixer control 'Capture',1
>  Capabilities: cvolume cswitch
>  Capture channels: Front Left - Front Right
>  Limits: Capture 0 - 31
>  Front Left: Capture 0 [0%] [-12.00dB] [off]
>  Front Right: Capture 0 [0%] [-12.00dB] [off]
> Simple mixer control 'Digital',0
>  Capabilities: cvolume
>  Capture channels: Front Left - Front Right
>  Limits: Capture 0 - 120
>  Front Left: Capture 0 [0%] [-30.00dB]
>  Front Right: Capture 0 [0%] [-30.00dB]
> Simple mixer control 'Input Source',0
>  Capabilities: cenum
>  Items: 'Mic' 'Front Mic' 'Line'
>  Item0: 'Mic'
> Simple mixer control 'Input Source',1
>  Capabilities: cenum
>  Items: 'Mic' 'Front Mic' 'Line'
>  Item0: 'Mic'
>
> !!-------Mixer controls for card 1 [U0x46d0x990]
>
> Simple mixer control 'Mic',0
>  Capabilities: cvolume cswitch cswitch-joined
>  Capture channels: Mono
>  Limits: Capture 0 - 3072
>  Mono: Capture 0 [0%] [18.00dB] [off]
>
> !!-------Mixer controls for card 2 [HDMI]
>
> Simple mixer control 'IEC958',0
>  Capabilities: pswitch pswitch-joined
>  Playback channels: Mono
>  Mono: Playback [off]
>
>
> !!Alsactl output
> !!-------------
>
> --startcollapse--
> state.Intel {
>        control.1 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 31'
>                iface MIXER
>                name 'Front Playback Volume'
>                value.0 31
>                value.1 31
>        }
>        control.2 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 2
>                iface MIXER
>                name 'Front Playback Switch'
>                value.0 true
>                value.1 true
>        }
>        control.3 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 31'
>                iface MIXER
>                name 'Surround Playback Volume'
>                value.0 0
>                value.1 0
>        }
>        control.4 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 2
>                iface MIXER
>                name 'Surround Playback Switch'
>                value.0 false
>                value.1 false
>        }
>        control.5 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 1
>                comment.range '0 - 31'
>                iface MIXER
>                name 'Center Playback Volume'
>                value 0
>        }
>        control.6 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 1
>                comment.range '0 - 31'
>                iface MIXER
>                name 'LFE Playback Volume'
>                value 0
>        }
>        control.7 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 1
>                iface MIXER
>                name 'Center Playback Switch'
>                value false
>        }
>        control.8 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 1
>                iface MIXER
>                name 'LFE Playback Switch'
>                value false
>        }
>        control.9 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 31'
>                iface MIXER
>                name 'Side Playback Volume'
>                value.0 0
>                value.1 0
>        }
>        control.10 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 2
>                iface MIXER
>                name 'Side Playback Switch'
>                value.0 false
>                value.1 false
>        }
>        control.11 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 2
>                iface MIXER
>                name 'Headphone Playback Switch'
>                value.0 true
>                value.1 true
>        }
>        control.12 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 31'
>                iface MIXER
>                name 'Mic Playback Volume'
>                value.0 12
>                value.1 12
>        }
>        control.13 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 2
>                iface MIXER
>                name 'Mic Playback Switch'
>                value.0 true
>                value.1 true
>        }
>        control.14 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 31'
>                iface MIXER
>                name 'Front Mic Playback Volume'
>                value.0 0
>                value.1 0
>        }
>        control.15 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 2
>                iface MIXER
>                name 'Front Mic Playback Switch'
>                value.0 false
>                value.1 false
>        }
>        control.16 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 31'
>                iface MIXER
>                name 'Line Playback Volume'
>                value.0 0
>                value.1 0
>        }
>        control.17 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 2
>                iface MIXER
>                name 'Line Playback Switch'
>                value.0 false
>                value.1 false
>        }
>        control.18 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 3'
>                iface MIXER
>                name 'Mic Boost'
>                value.0 3
>                value.1 3
>        }
>        control.19 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 3'
>                iface MIXER
>                name 'Front Mic Boost'
>                value.0 0
>                value.1 0
>        }
>        control.20 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 31'
>                iface MIXER
>                name 'Capture Volume'
>                value.0 0
>                value.1 0
>        }
>        control.21 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 2
>                iface MIXER
>                name 'Capture Switch'
>                value.0 true
>                value.1 true
>        }
>        control.22 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 31'
>                iface MIXER
>                name 'Capture Volume'
>                index 1
>                value.0 0
>                value.1 0
>        }
>        control.23 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 2
>                iface MIXER
>                name 'Capture Switch'
>                index 1
>                value.0 false
>                value.1 false
>        }
>        control.24 {
>                comment.access 'read write'
>                comment.type ENUMERATED
>                comment.count 1
>                comment.item.0 Mic
>                comment.item.1 'Front Mic'
>                comment.item.2 Line
>                iface MIXER
>                name 'Input Source'
>                value Mic
>        }
>        control.25 {
>                comment.access 'read write'
>                comment.type ENUMERATED
>                comment.count 1
>                comment.item.0 Mic
>                comment.item.1 'Front Mic'
>                comment.item.2 Line
>                iface MIXER
>                name 'Input Source'
>                index 1
>                value Mic
>        }
>        control.26 {
>                comment.access read
>                comment.type IEC958
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Con Mask'
>                value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>        }
>        control.27 {
>                comment.access read
>                comment.type IEC958
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Pro Mask'
>                value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>        }
>        control.28 {
>                comment.access 'read write'
>                comment.type IEC958
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Default'
>                value '0482000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>        }
>        control.29 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Switch'
>                value true
>        }
>        control.30 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 1
>                comment.range '0 - 31'
>                iface MIXER
>                name 'Master Playback Volume'
>                value 31
>        }
>        control.31 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 1
>                iface MIXER
>                name 'Master Playback Switch'
>                value true
>        }
>        control.32 {
>                comment.access read
>                comment.type IEC958
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Con Mask'
>                index 1
>                value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>        }
>        control.33 {
>                comment.access read
>                comment.type IEC958
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Pro Mask'
>                index 1
>                value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>        }
>        control.34 {
>                comment.access 'read write'
>                comment.type IEC958
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Default'
>                index 1
>                value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>        }
>        control.35 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Switch'
>                index 1
>                value false
>        }
>        control.36 {
>                comment.access 'read write user'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 255'
>                comment.tlv '0000000100000008ffffec1400000014'
>                iface MIXER
>                name 'PCM Playback Volume'
>                value.0 255
>                value.1 255
>        }
>        control.37 {
>                comment.access 'read write user'
>                comment.type INTEGER
>                comment.count 2
>                comment.range '0 - 120'
>                comment.tlv '0000000100000008fffff44800000032'
>                iface MIXER
>                name 'Digital Capture Volume'
>                value.0 0
>                value.1 0
>        }
> }
> state.U0x46d0x990 {
>        control.1 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 1
>                iface MIXER
>                name 'Mic Capture Switch'
>                value false
>        }
>        control.2 {
>                comment.access 'read write'
>                comment.type INTEGER
>                comment.count 1
>                comment.range '0 - 3072'
>                iface MIXER
>                name 'Mic Capture Volume'
>                value 0
>        }
> }
> state.HDMI {
>        control.1 {
>                comment.access read
>                comment.type IEC958
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Con Mask'
>                value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>        }
>        control.2 {
>                comment.access read
>                comment.type IEC958
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Pro Mask'
>                value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>        }
>        control.3 {
>                comment.access 'read write'
>                comment.type IEC958
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Default'
>                value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>        }
>        control.4 {
>                comment.access 'read write'
>                comment.type BOOLEAN
>                comment.count 1
>                iface MIXER
>                name 'IEC958 Playback Switch'
>                value false
>        }
> }
> --endcollapse--
>
>
> !!All Loaded Modules
> !!------------------
>
> Module
> ppdev
> ipv6
> acpi_cpufreq
> cpufreq_userspace
> cpufreq_stats
> cpufreq_powersave
> cpufreq_ondemand
> freq_table
> cpufreq_conservative
> video
> output
> sbs
> sbshc
> container
> dock
> battery
> microcode
> nfs
> lockd
> nfs_acl
> sunrpc
> iptable_filter
> ip_tables
> x_tables
> ext3
> jbd
> mbcache
> af_packet
> ac
> parport_pc
> lp
> parport
> snd_usb_audio
> snd_usb_lib
> uvcvideo
> snd_hda_intel
> compat_ioctl32
> psmouse
> snd_seq_dummy
> videodev
> v4l1_compat
> v4l2_common
> snd_seq_oss
> snd_seq_midi
> serio_raw
> snd_rawmidi
> snd_pcm_oss
> snd_mixer_oss
> fglrx
> atl1
> mii
> snd_seq_midi_event
> snd_pcm
> snd_seq
> snd_seq_device
> snd_timer
> snd_page_alloc
> snd_hwdep
> intel_agp
> iTCO_wdt
> iTCO_vendor_support
> snd
> button
> evdev
> soundcore
> shpchp
> pci_hotplug
> usbhid
> hid
> xfs
> sg
> sr_mod
> cdrom
> sd_mod
> ahci
> libata
> scsi_mod
> ehci_hcd
> uhci_hcd
> usbcore
> thermal
> processor
> fan
> fbcon
> tileblit
> font
> bitblit
> softcursor
> fuse
> --
> Daniel J Blueman
>



-- 
Daniel J Blueman
