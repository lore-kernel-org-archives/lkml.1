Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYEKU47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYEKU47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYEKU4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:56:52 -0400
Received: from mail.aknet.ru ([78.158.192.26]:63595 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbYEKU4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:56:51 -0400
Message-ID: <48275D8D.10500@aknet.ru>
Date: Mon, 12 May 2008 00:56:45 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
CC: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.26-rc1 regression: e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <482737BE.20502@infracom.it> <4827415A.7060101@aknet.ru> <482756F0.8020609@infracom.it>
In-Reply-To: <482756F0.8020609@infracom.it>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------050808010805060105040706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050808010805060105040706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello.

Roberto Oppedisano wrote:
>> cat /proc/asound/cards
>>   
>  0 [pcsp           ]: PC-Speaker - pcsp
>                       Internal PC-Speaker at port 0x61
>  1 [I82801DBICH4   ]: ICH4 - Intel 82801DB-ICH4
>                       Intel 82801DB-ICH4 with AD1981B at irq 10
>  2 [Modem          ]: ICH-MODEM - Intel 82801DB-ICH4 Modem
>                       Intel 82801DB-ICH4 Modem at irq 10
>> I guess you simply got the pc-speaker driver
>> loaded first and became your primary sound
>> driver, which is not what you want.
> yes, that's true. Anyway in this case the sound server crashes with a
> signal 6.
I can't say for sure why does the
crash happen, but what is known is
that you need a very recent alsa-lib
to get pc-speaker working properly.
And  even 1.0.16 is not modern enough
for that. :(
But that's not a big deal.
The attached config is only what's
needed. Put it into /usr/share/alsa/cards
and /etc/alsa/cards and maybe that
will help. There should be already
the file with that name - overwrite it.

> Passing -D dsp1 to artsd avoids the crash,
The easiest solution is
---
options snd-pcsp index=2
---
into /etc/modprobe.conf. It will
then not go ahead of 2 other drivers
of yours.

--------------050808010805060105040706
Content-Type: text/plain;
 name="PC-Speaker.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="PC-Speaker.conf"

#
# Configuration for PC-Speaker driver
#

<confdir:pcm/front.conf>

PC-Speaker.pcm.front.0 {
	@args [ CARD ]
	@args.CARD {
		type string
	}
	type softvol
	slave.pcm {
		type hw
		card $CARD
	}
	control {
		name "Master Playback Volume"
		card $CARD
	}
	min_dB -10.0
	max_dB 20.0
}	

# default with dmix & null
PC-Speaker.pcm.default {
	@args [ CARD ]
	@args.CARD {
		type string
	}
	type asym
	playback.pcm {
		type softvol
		control {
			name "Master Playback Volume"
			card $CARD
		}
		min_dB -10.0
		max_dB 20.0
		slave.pcm {
			type plug
			slave.pcm {
				@func concat
				strings [ "dmix:" $CARD ]
			}
		}
	}
	capture.pcm {
		type null
	}
}


--------------050808010805060105040706--
