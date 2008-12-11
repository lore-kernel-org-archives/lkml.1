Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451AbYLKKks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbYLKKks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 05:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYLKKkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 05:40:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:56841 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbYLKKkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 05:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=iktmpOUfe5+ZFPcZtbjzMkR3r9QXoG8wjkFLQxP4G3lcup3Kev1ZJwf4s+3uUjxgcB
         8lrIku25fno/bfi1041dXv408jfS79pImxC4PKrLN7cw+jj7XWGUFAIoOBwC3ghkGOi8
         lLuexpfyiLgimzb3L12hg6FiGiLfgF+RWzBwY=
Message-ID: <386072610812110240l7af568f9h40c672036abe49f6@mail.gmail.com>
Date: Thu, 11 Dec 2008 18:40:38 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [Question] Can I open a substream in kernel space without attach to a file pointer?
Cc: "ALSA devel" <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hljvfbt8h.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610811190200l576d7735rb0188ab53f5185fa@mail.gmail.com>
	 <s5h63mjddvj.wl%tiwai@suse.de>
	 <386072610811190742ycab0dbasc585376dc6ac47db@mail.gmail.com>
	 <s5hljvfbt8h.wl%tiwai@suse.de>
X-Google-Sender-Auth: 7f0a623a5e57b80e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

I just made some progress about this USB audio gadget driver. But I
still got some questions about the audio playback.
Please kindly help me to work out here, as you're the best one to ask, -:)

I can receive ISO transfer packets from PC host. The packet includes
192 bytes audio data.
So I tried to use vfs_write() function to write this 192 bytes to the
opened snd card.
There is no sound.

Then I create a buffer which is 6K bytes size and a workqueue. I will
fill the 6K buffer with the ISO packets data.
When the 6K buffer is full, in the workqueue handler I will call
vfs_write() function to write these 6K bytes data to the sound card.
This time, sound played and it works although it is not very smooth.

So I guess the audio buffer I great is very important to playback audio.
How to choose the buffer size? If the size < 6K, there is no sound.
I guess it depends on the sound card hardware, but I failed to find
any info from hw_params and sw_params.

Actually, I want to remove the audio buffer here, just write the 192
audio data to sound card directly. Is that possible?

Thanks a lot.
-Bryan


On Thu, Nov 20, 2008 at 12:01 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 19 Nov 2008 23:42:48 +0800,
> Bryan Wu wrote:
>>
>> On Wed, Nov 19, 2008 at 9:49 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Wed, 19 Nov 2008 18:00:36 +0800,
>> > Bryan Wu wrote:
>> >>
>> >> Hi Takashi,
>> >>
>> >> I am developing a USB gadget driver compliant to USB Audio Class Spec 2.0.
>> >> So I want to open a PCM substream and do some playback of capture,
>> >> then close them?
>> >>
>> >> I found snd_pcm_open_substream() is for opening a substream and attach
>> >> it to a file.
>> >> But in my application, there is no need to open a file before opening
>> >> a substream.
>> >>
>> >> - Is there any interface for me to open a substream in kernel space
>> >> without attach to a file?
>> >> - How to playback and capture in kernel space, use snd_pcm_lib_write
>> >> and snd_pcm_lib_read?
>> >> - How to get the snd_pcm_hardware struct from low level driver,
>> >> because I have to get the hardware configuration of the snd pcm
>> >> device?
>> >>
>> >> And I am reading the code of OSS emulator in ALSA. It provides some
>> >> info about the kernel space sound card programming.
>> >
>> > Yes, OSS emulation code handles the PCM in the kernel.
>> > But, basically I don't recommend you to do this -- it's not the job of
>> > the sound card driver.  The whole PCM stuff is handled by the PCM
>> > middle layer, not the driver itself.
>>
>> No, my plan is not a sound card driver. It is an USB gadget audio driver.
>> When an embedded system for example Blackfin board connects to a USB host (PC),
>> PC will recognize this USB device as a USB Audio Class device.
>>
>> Generally, there should be a sound card on the embedded system. Our
>> Blackfin board
>> has an AD1980 ALSA sound card. The USB gadget audio driver will open this sound
>> card and export this device to USB host PC by some USB audio class specific
>> descriptors. Then the PC can playback some audio stream by USB cable, USB gadget
>> audio driver will receive this stream and playback the data by AD1980
>> ALSA playback
>> substream. Capture is the similar.
>>
>> > Any reason why you handle the PCM stuff completely in your driver
>> > code?
>> >
>>
>> There is USB gadget MIDI driver in kernel. But it asked the user to
>> use aconnect tool to
>> connect the virtual MIDI card to a real one. I don't want travel to
>> user space and it should
>> be more efficient in kernel space to handle all things including PCM
>> open/release/read/write
>> and Mixer control.
>>
>> Any hints about this? I really need some help from ALSA guru, cause
>> I'm not familiar the internal
>> things here.
>
> Well, the access in the kernel space is fairly similar as in the user
> space.  It opens, issues ioctls, reads and writes.  The difference is
> that you access via dedicated function calls instead of syscalls.
> There is no way to poke the driver internal from other drivers.
> To answer your questions...
>
>> >> - Is there any interface for me to open a substream in kernel space
>> >> without attach to a file?
>
> No.
>
>> >> - How to playback and capture in kernel space, use snd_pcm_lib_write
>> >> and snd_pcm_lib_read?
>
> Yes.  But for the kernel space buffer, you'd need to fake the
> user-space pointer by snd_enter_user() and snd_leave_user().  See
> snd_pcm_oss_write3().
>
>> >> - How to get the snd_pcm_hardware struct from low level driver,
>> >> because I have to get the hardware configuration of the snd pcm
>> >> device?
>
> Not way to peek/poke the driver internals from the outside.
> You'll need to negotiate via snd_pcm_kernel_ioctl() like user-space
> programs.
>
>
> HTH,
>
> Takashi
>
