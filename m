Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbYFLNDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbYFLNDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760639AbYFLNDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:03:19 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:38362 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760310AbYFLNDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HhkNt0dy1lPfsrQT+OTx+L7OCXGY4b+I6fiWKGEWmQ9FRDHn6osQ+eoHoaB0BfpaR/
         5+oIihKgSmmHL+XnB+o6omc7CV8/qbHdwJXbxatHp7/TjMsT5fcEYzzbvOP1XmNZWkJs
         s00zfx4lR6zymm3h0mAFnX/NaWX0fiUbvipAQ=
Message-ID: <19f34abd0806120603q2ddc6654r9562dfea556c2791@mail.gmail.com>
Date: Thu, 12 Jun 2008 15:03:16 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hiqwf0vyr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 12, 2008 at 12:49 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 11 Jun 2008 20:00:17 +0100,
> Daniel J Blueman wrote:
>>
>> On Tue, Jun 10, 2008 at 6:59 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Mon, 9 Jun 2008 20:59:00 +0100,
>> > Daniel J Blueman wrote:
>> >>
>> >> Hi Takashi-san,
>> >>
>> >> I'm experiencing DC offset with the microphone on 2.6.24 (Ubuntu 8.04
>> >> LTS x86-64). I can see on Audacity that the DC offset that varies with
>> >> the recording capture level.
>> >
>> > Could you elaborate?  The mic bias level could be changed via the pin
>> > control value.  Usually, it's set as VREF 80%.
>>
>> When the recording->capture level is set to 0, the mic has no DC
>> offset as expected. Maxing the recording->capture level, the mic input
>> is saturated, in between, we see a linear connection.

I find that a good way to examine the captured PCM is the following command:

    $ arecord | od -t x1z -v

With the "Capture" and "Digital" controls both at 0 in alsamixer, this
outputs just a constant 0x80 byte. This seems natural.

With "Digital" at 0, changing "Capture" has no effect. However, with
"Capture" at 0 and these values for "Digital":

db gain -30 byte read 0x80
db gain -28 byte read 0x81
db gain -26 byte read 0x82
db gain -22 byte read 0x83
db gain -19 byte read 0x84
db gain -17 byte read 0x85
db gain -15 byte read 0x86
db gain -13 byte read 0x87
db gain -12 byte read 0x88
db gain -11 byte read 0x89
db gain -10 byte read 0x8a
db gain -9 byte read 0x8b
db gain -8 byte read 0x8d <-- up two here
db gain -7 byte read 0x8e
db gain -6 byte read 0x90
db gain -5 byte read 0x92
db gain -4 byte read 0x94
db gain -3 byte read 0x97
...
db gain 12 byte read 0xff
db gain 13 (and up) byte read 0x00 <-- seems to flip over or get capped

If I now change "Capture" to have dB gain 0 (35% in alsamixer), I get
this instead (for different values of "Digital"):

db gain -30 byte read 0x80
db gain -29 byte read 0x85
...
db gain -18 byte read 0x90
...
db gain -12 byte read 0xa0
...
db gain -6 byte read 0xc0
...
db gain -1 byte read 0xf2

So in fact, if both controls are at dB gain 0 (or one of them is
higher), the only byte I can read is 0x00.

> You can try to adjust VREF value of mic pins.
> For example, the node 0x18 and 0x19 correspond to the rear and front
> mics, respectively.  Then run the following as root:
>
>        # ./hda-verb /dev/snd/hwC0D0 0x18 SET_PIN_WID 0x21
>
> which will change the widget 0x18 (rear mic) to input-VREF 50%
> (0x21).  The original value is input-VREF 80% (0x24).

I tried to do this for my card. For me, I need the 0x19 widget, which
is the internal mic:

Node 0x19 [Pin Complex] wcaps 0x40008b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x02, stepsize=0x4f, mute=0
  Amp-In vals:  [0x00 0x00]
  Pincap 0x083724: IN Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x99a30941: [Fixed] Mic at Int ATAPI
    Conn = ATAPI, Color = Unknown
    DefAssociation = 0x4, Sequence = 0x1
    Misc = NO_PRESENCE
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0

And I tried various values for the PinCtl. 0x20, 0x21, and 0x22, (0x24
was the default), but with no change in the input byte stream AT ALL!
And I double-checked, my input source is set to "Internal Mic". (Just
to be 100% sure, I tried all three input sources, but it was the same
for all. So no change in the input at all.)

Do you have any more tips that I can try out?

Also, I am just curious, is it possible to break the microphone (or
other physical components) by changing the voltage levels to
unsupported values, or is it safe to experiment freely? I read this in
the HDA specification:

"The VRefEn field encoding selects one of the possible states for the
VRef signal(s). If the value written to this control does not
correspond to a supported value as defined in the Pin Capabilities
parameter, the control must either retain the previous value or take
the value of 000, which will put the control in a Hi-Z state and
prevent damage to any attached components."

Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
