Return-Path: <linux-kernel-owner+w=401wt.eu-S1161151AbXD2VJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbXD2VJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161339AbXD2VJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:09:32 -0400
Received: from web32406.mail.mud.yahoo.com ([68.142.207.199]:39145 "HELO
	web32406.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161151AbXD2VJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:09:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=tauUgYMe7gUfIW1+6Lkh54RV6NH+gATxugkIt9Y/KuO9JfLkDfyPMBqk5XIL37bU2TP5IUHXkeRaa2SbWGfcV0EsqbY183/TEJUWZAovpn3ixg+kfY9ERFcbWs7eh5NqqnLpR6MfuoqgsJFnN5vt3oJhoJlx1WtZ6g9zinSdN1M=;
X-YMail-OSG: yJZhNG0VM1mV0s7a9yBi6gyr4KTShvz0PvkOub1yWVyxxOxvP65ovy4oQRLatj0fRbvBwwzeU1nNfB4vR8OjRhFrQd0XOE3VyqXJ.JyK9rPgMPVPPqXJs_Vs5nAZ4w--
Date: Sun, 29 Apr 2007 14:09:29 -0700 (PDT)
From: Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: Boot failure with 2.6.21 with snd-maestro3
To: Adrian Bunk <bunk@stusta.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Clemens Ladisch <clemens@ladisch.de>,
       Takashi Iwai <tiwai@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       alsa-devel@alsa-project.org
In-Reply-To: <20070429173559.GP3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <768801.1756.qm@web32406.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Adrian Bunk <bunk@stusta.de> wrote:

> On Sun, Apr 29, 2007 at 09:55:18AM -0700, Giridhar Pemmasani wrote:
> > When snd-maestro3 (ESS Maestro 3 driver) is enabled, kernel 2.6.21 fails
> to
> > boot - it seems to stop at various points depending on what other modules
> are
> > enabled. Disabling snd-maestro3 fixes all issues. Moreover, with
> everything
> > else being same, using maestro3.c from 2.6.20 kernel and using it in
> 2.6.21
> > kernel also works - i.e., system boots fine. I will try to isolate the
> issue
> > and follow up.
> 
> There were only the two attached patches between 2.6.20 and 2.6.21 to 
> this driver:
> - maestro3: add request_firmware()
> - maestro3 - Use quirk list helper function
> 
> 2.6.21 + 2.6.20 maestro3.c works for you.
> 
> Does 2.6.21 + 2.6.20 maestro3.c + patch-maestro3-1 work?

2.6.21 with 2.6.20's maestro3.c with patch-maestro3-1 exhibited the same
issue. However, I identified the cause: maestro3 driver in 2.6.21 (even just
patch-maestro3-1) tries to load firmware file from user space. But each time
request_firmware is called it takes about 1 minute to timeout (because I
don't have the firmware installed?). If I let the system take its time, even
with maestro3.c from 2.6.21, it boots after timing out twice. So after about
2 minutes of no activity, system does boot. Following are trace messages I
added to identify the issue:

[   17.004000] input: TPPS/2 IBM TrackPoint as /class/input/input5
[   70.904000] sound/pci/maestro3.c (snd_m3_create:2763): -2
[   70.920000] sound/pci/maestro3.c (snd_m3_create:2774): -2
[  130.940000] sound/pci/maestro3.c (snd_m3_create:2777): -2
[  130.956000] sound/pci/maestro3.c (snd_m3_create:2788): -2
[  130.972000] sound/pci/maestro3.c (snd_m3_create:2794): 0
[  130.992000] sound/pci/maestro3.c (snd_m3_create:2797): 0
[  131.012000] sound/pci/maestro3.c (snd_m3_create:2802): 0
[  131.044000] sound/pci/maestro3.c (snd_m3_create:2804): 0
[  131.580000] sound/pci/maestro3.c (snd_m3_create:2807): 0
[  131.596000] sound/pci/maestro3.c (snd_m3_create:2810): 0
[  131.612000] sound/pci/maestro3.c (snd_m3_create:2814): 0
[  131.628000] sound/pci/maestro3.c (snd_m3_create:2821): 0
[  132.364000] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:
dm-d
evel@redhat.com


Giri

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
