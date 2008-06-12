Return-Path: <linux-kernel-owner+w=401wt.eu-S1762322AbYFLNst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322AbYFLNst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761578AbYFLNsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:48:36 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:2668 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761212AbYFLNse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MSlGKAhr5kcUQSBL11EX+kRDNyYXSs8fdDT0Khhe2j0i93IaexKuhsTLxHFpBOIVxS
         OYdaY/LRhdn55eNhKDaKosGmQhzcJhsXZ7xnBfXXkwQcN3JP4Gu1cDeMMiDonKVvDoD4
         nK0SXuqnnbqnOnwf2UGnsTNjPqWGDbPiCpRJs=
Message-ID: <19f34abd0806120648j4f15b762r8e72c348c14b946f@mail.gmail.com>
Date: Thu, 12 Jun 2008 15:48:32 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hlk1are3o.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <19f34abd0806120603q2ddc6654r9562dfea556c2791@mail.gmail.com>
	 <s5hlk1are3o.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 3:12 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 12 Jun 2008 15:03:16 +0200, Vegard Nossum wrote:
>> With the "Capture" and "Digital" controls both at 0 in alsamixer, this
>> outputs just a constant 0x80 byte. This seems natural.
>
> The "Digital Capture Volume" is the software attenuation/gain in
> alsa-lib.  Keep it in the middle corresponding to 0dB.  Otherwise you
> change the data digitally by the software.  This control exists for
> some devices that have only digital mics and no hardware analog
> volume controls.
>
> "Capture Volume" is the hardware recording level.
>

Thanks. I have Digital set to 0 dB now, and I am using only the Capture control.

>
>> > You can try to adjust VREF value of mic pins.
>> > For example, the node 0x18 and 0x19 correspond to the rear and front
>> > mics, respectively.  Then run the following as root:
>> >
>> >        # ./hda-verb /dev/snd/hwC0D0 0x18 SET_PIN_WID 0x21
>> >
>> > which will change the widget 0x18 (rear mic) to input-VREF 50%
>> > (0x21).  The original value is input-VREF 80% (0x24).
>>
>> I tried to do this for my card. For me, I need the 0x19 widget, which
>> is the internal mic:
>
> Did you try the external mic, too?
>

Now I've tried the external mic, with only VERY limited success (see below).

> Did you get ANY input from the internal mic?  If no, the pin mapping
> might be wrong.  That is, 0x19 isn't the internal mic.

The external mic:

Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x02, stepsize=0x4f, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x083734: IN OUT Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x02a19840: [Jack] Mic at Ext Front
    Conn = 1/8, Color = Pink
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80

So what I have done is this:

In alsamixer, Capture is set to 21 dB gain (Digital at 0 dB). This
will read mostly 0xa9 with alsarecord. If I try to sing a tone, this
value can change briefly between 0xa9 and 0xaa for as long as I sing,
such as this:

0631340 a9 a9 a9 a9 a9 a9 a9 a9 a9 aa a9 aa aa aa aa aa  >................<
0631360 aa aa aa aa aa aa aa aa aa a9 a9 a9 a9 a9 a9 a9  >................<

...otherwise, it is at a constant 0xa9.

However, something interesting here happens when I change the voltage
level while recording. It seems that there is a short fluctuation (it
lasts only a fraction of a second) where the values change...:

If I change the PinCtl from 0x24 to 0x21, it seems that the data
values will change in this order (with many repetitions of each
value):
... 0xa9 0xb2 0xb1 0xb0 0xaf 0xae 0xad 0xac 0xab 0xaa 0xa9 ...

and then it is back at the constant 0xa9 value. If I change the PinCtl
from 0x21 to 0x24, the values will change in this order
... 0xa9 0xa0 0xa1 0xa2 0xa3 0xa4 0xa5 0xa6 0xa7 0xa8 0xa9 ...

So this seems to be the only difference between the internal and
external mic. I am no expert in this, but I guess the voltage change
will simply raise/lower the membrane of the microphone and the change
will be reflected in the values read back...?

But this at least assures me that the external mic pin configuration is correct.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
