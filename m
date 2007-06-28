Return-Path: <linux-kernel-owner+w=401wt.eu-S1763625AbXF1CB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763625AbXF1CB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 22:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbXF1CBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 22:01:51 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:37289 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759587AbXF1CBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 22:01:50 -0400
Message-ID: <468315AF.1080105@gmail.com>
Date: Thu, 28 Jun 2007 03:58:07 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Patrick Draper <pdraper@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706271825.17459.ahartmetz@gmail.com> <46829E82.6080804@gmail.com> <200706272110.50744.ahartmetz@gmail.com> <4682EEDD.4020501@gmail.com> <4682FE5C.5070004@gmail.com>
In-Reply-To: <4682FE5C.5070004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 02:18 AM, Patrick Draper wrote:

Please always use Reply-to-All on this list -- subscribers here like to also 
get personal copies.

> Rene Herman wrote:
>> KDE has finally dropped aRts from KDE4 and, again, ALSA has been 
>> mixing by default for some time now so we're talking history anyway. 
>> You want mixing on your card? You got it.
> 
> I've been following this discussion with some interest, to learn more 
> about ALSA. I've been creating startup scripts for all of my sound-using 
> applications which look like this:
> 
> LD_PRELOAD=libaoss.so exec /usr/bin/alsaplayer "$*"
> 
> I found that without libaoss.so preloaded, I wasn't getting software 
> mixing at all.

This would seem to indicate that your alsaplayer (what's in a name) is setup 
to output to OSS and not to ALSA...

The OSS interface -- consisting of direct access to device nodes such as 
/dev/dsp0, /dev/mixer and /dev/music -- is an older interface for sound on 
Linux. The newer ALSA interface works via a library API and is best used 
natively. For backwards compatibility though, ALSA also provides emulation 
of the older OSS interface.

It does so in two different ways in fact -- the first one is a direct kernel 
space emulation where ALSA interprets accesses to those device nodes it then 
manages much like real OSS would do. This kernel space emulation is made 
available through the "OSS PCM/Mixer/Sequencer API" you see as options in 
the ALSA kernel configuration menu.

The other way is a userspace emulation through the libaoss.so library that 
you are using. That library catches accesses to the OSS device nodes in 
userspace and translates them to ALSA accesses before they even get to the 
kernel.

ALSA does software mixing (the act of mixing two seperate streams together 
to form one) in userspace and as such, the kernelspace OSS emulation does 
not support software mixing, while this userspace emulation does -- if your 
ALSA default device is setup for software mixing (it is by default these 
days) this also works for this libaoss route. If you run a OSS program 
without the library preload it's using the kernel emulation though.

So -- the fact that mixing actually works for you when using libaoss means 
software mixing is working correctly for your ALSA setup. The only thing you 
should do is _use_ ALSA (natively) and not its OSS emulation so you can drop 
the library preload.

I don't have alsaplayer installed (wasn't that thing dead?) so I can't walk 
you through its configuration easily, but I suppose you'll be able to figure 
it out. If you need to specify an ALSA device somewhere, make sure it's not 
the old "hw:0" but "default" (or "default:0" for the first card, "default:1" 
for the second, ...). The "hw:N" devices don't do mixing.

> I'm constantly running an MP3 player, and with that library I can get
> sound alerts from other apps too.

I myself mostly use the ogg123 and mpg321 command line players, both based 
on libao and thereby only a simple:

$ echo "default_driver=alsa09" >/etc/libao.conf

away from being native ALSA players.

> I don't understand exactly what you mean by ALSA mixing by default. I 
> have the OSS Mixer API selected during kernel compiles. Is that what you
> are referring to?

No. That's part of the kernel space OSS emulation. A "mixer" in that context 
is the part of a soundcard that controls volumes and may mix the output of 
several parts of the card/chip for playback and its inputs for capture. Ie, 
that which is controlled by a mixer application such as the (ncurses) ALSA 
reference mixer "alsamixer" or the mixer your desktop environment provides.

Once you have everything running as a native ALSA application you could 
disable that option. In fact, since you're using the userspace emulation, 
you could already. The new-ish Flash Player 9 (important for youtube these 
days) for Linux is also an ALSA application and since I use it, I myself 
haven't needed OSS emulation for anything anymore.

Rene.

