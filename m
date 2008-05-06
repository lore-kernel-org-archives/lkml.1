Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbYEFVGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbYEFVGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 17:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932717AbYEFVFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 17:05:35 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:60535 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765715AbYEFVF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 17:05:29 -0400
Message-ID: <4820C846.2040205@keyaccess.nl>
Date: Tue, 06 May 2008 23:06:14 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] PNP: add AD1815 and AD1816 quirks
References: <481FAC37.6090703@keyaccess.nl> <481FAD12.3030409@keyaccess.nl> <481FAF83.5090305@keyaccess.nl> <200805061308.14673.bjorn.helgaas@hp.com>
In-Reply-To: <200805061308.14673.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-05-08 21:08, Bjorn Helgaas wrote:

> On Monday 05 May 2008 07:08:19 pm Rene Herman wrote:

>> The AD181x chip doesn't support an IRQ-less MPU401 option but works
>> fine without one. This adds (priority: functional) IRQ-less options
>> for each port option to help systems with few available IRQs.
>>
>> The AD1815 quirk can't use pnp_register_irq_resource() due to doubly
>> penalizing the IRQ. Also, while not a practical issue due to no IRQ
>> option being present for the dependents, this needs to add in front,
>> not back.
>>
>> Doesn't use pnp_register_port_resource() for symetry with above.
>>
>> This does not delete the AD1815 independent option even though it
>> should be empty after the IRQ transfer due to AD1816 coming with an
>> empty but still present independent option by default.
>>
>> Was tested on AD1815 and AD1816. The ALSA driver also support the
>> AZT2002 ID for MPU401 but this doesn't as I was unable to test it.
>>
>> Signed-off-by: Rene Herman <rene.herman@gmail.com>
> 
> I'm not opposed to this in principle, but I don't understand
> it well enough to really have an informed opinion.
> 
> IIRC, we give up some seldom-used functionality when running
> the MPU401 without an IRQ.

Not even that in fact. When assigned one, the MPU401 IRQ is used for MIDI 
recording but the ALSA MPU401 driver can record without problem without an 
assigned IRQ as well...

General information, in case it's useful; the MPU401 is the UART that sits 
behind that 15-pin joystick/midi connector on the back of (older, by now) 
soundcards.

If so inclined, you'd attach for example an external MIDI keyboard (keyboard 
in the piano sense) to it after which you can record what you play and/or 
relay the data to a running software synthesizer to turn your keypresses 
into sound.

The difference between an assigned IRQ and no assigned IRQ is (I suppose, I 
should say) just that in the latter case you might experience some worse 
latency due to the polled operation.

However, not many people have external MIDI gear hooked up to an MPU401 in 
the first place and of those that do, none are still using old ISA cards; 
especially not those that care at all about latency. Those people are in 
fact very explicitly likely to use fairly expensive equipment specifically 
for low latency purposes.

(and modern keyboards connect through USB, not MPU401).

The other direction, playing MIDI _to_ the MPU401, is a bit more applicable 
to old hardware still due to soundcards with their own onboard wavetable 
synthesizer that takes its input from the MPU401 ("hardware MIDI") but in 
that direction, nothing changes at all, not even latency.

> Does the driver mention the fact that there's something it can't do
> because we don't have an IRQ? The user might like to know in case he
> needs that functionality and wants to fiddle with other devices to free
> up IRQs.

So no, there's nothing it can't do without an IRQ and ALSA has always been 
fine with IRQ-less MPU401. It's just that normally the hardware exposes an 
IRQ-less option itself so that the device enables without problem even when 
no IRQ is available for it while the AD181x neglects to do so so that the 
PnP layer complains that it can't enable the device when it's not finding a 
free IRQ -- the situation that drew the complaint/report that led to this 
thread.

Moreover, for any readers, please note that the patch doesn't make the 
MPU401 operate without an IRQ -- it just provides it with the last resort 
_option_ of functioning without one if none are available (or if the user 
specifically picks that option manually ofcourse).

> I'm vaguely uncomfortable because this quirk isn't really working
> around a hardware/firmware issue; it's stepping around the fact
> that Linux doesn't know how to allocate IRQs between ISA and PCI.
> Does anybody know how Windows handles this?  If Windows can do it
> without user intervention, maybe we can too.

Yes, I can appreciate the vague uncomfort. This is improving the hardware 
more then it is fixing it and that might feel like a bit of a misuse of 
quirks. However, given Linux's ability to operate the MPU401 fully without 
an assigned IRQ I feel it does make sense. The hardware shouldn't become 
unavailable just because the system can't find a free IRQ for it.

As such, it's not really stepping around much of anything; it's just being 
friendly. Do feel it makes sense. Also feel it makes sense to treat an ISA 
card that insists on an MPU401 IRQ to a ride in a blender but there are in 
fact some nice-ish AD1816A cards such as the TerraTec EWS64S still around.

However, with respect to your direct worry I get sort of foggy. All my ISA 
capable systems seem to have a BIOS that assigns IRQs to each PCI card that 
I put in as evidenced by the neat list of them that most of them print out 
just before the screen says "Verifying DMI Pool Data" and loading linux, an 
OS which I don't recall having ever seen deviate from the BIOS assigned 
values either.

That is, I'm not sure in how far Linux is involved at all :-?

> If we continue down the quirk path, would you mind using dev_info()
> instead of plain printk()?

Yes. Will regenerate against current mainline. My ISA test machine is 
chugging away on things at the moment. Will repost when it's done.

Rene.
