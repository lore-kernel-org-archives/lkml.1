Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbYKLRHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbYKLRHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYKLRHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:07:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:40297 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYKLRHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uaPqTGCTehXdkAQkgYhAfCsNcIcA3sU7QOSkX5c1D6yHrHFiHVUTSZ0iOqRIJtCQG8
         IXHShJH/859FGnx20kS3gSVsvNEwcmeQGPJKSwLxGxQDHYilPOdtAcPbEXDWwufxDm+T
         HZWoztfdfGTsWUpC7xpVc63YVu0MmRsCFTEss=
Message-ID: <491B0D38.1050207@gmail.com>
Date: Wed, 12 Nov 2008 19:07:04 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
References: <s5h3ai11dpt.wl%tiwai@suse.de>	<20081109151323.GA18705@rhlx01.hs-esslingen.de>	<s5h7i7c916e.wl%tiwai@suse.de>	<20081109200929.GA29333@rhlx01.hs-esslingen.de> <s5hiqqtkxqr.wl%tiwai@suse.de>
In-Reply-To: <s5hiqqtkxqr.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Sun, 9 Nov 2008 21:09:29 +0100,
> Andreas Mohr wrote:
>> On Sun, Nov 09, 2008 at 07:58:17PM +0100, Takashi Iwai wrote:
>>> At Sun, 9 Nov 2008 16:13:23 +0100,
>>> Andreas Mohr wrote:
>>>> OK, _THIS_ time I actually did get the correct model (last time I tried
>>>> modprobe with model=acer-aspire, but apparently it then used the
>>>> /etc/modprobe.d/ model=toshiba setting, since this time gamix showed
>>>> entirely different controls with i-Mic etc.) - all the more reason to
>>>> log the model name chosen/selected by the driver!!
>>> Build with the debug option (why turned off even if you *are*
>>> debugging?).  Then the driver will show you details.
>> Hmm, right, that would have been an (very useful) option, but not for the
>> majority of users OTOH.
> 
> I thought many ditros set this option...
> 
>> Especially since this is a user-visible module parameter which should thus
>> be confirmed in mainstream user code, via logging.
> 
> You can check via /sys/modules/snd_hda_intel/parameters/model whether
> you passed correctly or not, at least :)
> 
>> Admittedly not many modules log their settings during startup,
>> but for snd_hda_intel with its two myriads of codec/machine variants
>> and a resulting quarter myriad of issues that would be very useful.
> 
> Passing the model option is already a kind of debugging work, IMO.
> You shouldn't do it unless you need it, indeed.
> 
>>>> --> I have to admit that usability sucks^Hcould be a lot better.
>>> One would call it rather debuggability than usability.
>>> These are completely different things.
>> See above ;)
>>
>>>> i-Mic on Ekiga with lotsa mixer fiddling didn't work either this time.
>>> OK, then something is missing.  But you should test by arecord first
>>> than any complicated applications as a primary test.
>> Good point, will do.
>>
>> Oh, and is there a way to manually alter codec registers?
> 
> Try hda-verb program.  Build your kernel with CONFIG_SND_HDA_HWDEP=y
> and access via the hwdep device.
> 	ftp://ftp.suse.com/pub/people/tiwai/misc/hda-verb-0.2.tar.bz2
> 
> 
> Takashi


Hi,

I pretty much studied the datasheet and driver, and this is what I found:
btw, my acer 5720 and aspire one share same ALC268.
Some stuff is trivially fixable, some seems to be unfixable at all:

model=acer is used on my regular laptop.
model-acer-aspire is used on aspire one laptop, and it needs to be renamed, as both are aspire.


1) internal beep volume/mute isn't preserved on resume on acer (I call the big laptop this way).
2) aspire one, has same beep routing, but it isn't supported by this model, it should be added I think.

3) on acer internal mic is mapped wrongly, it assumes that it is a digital mic, while in fact this is
analog mic, and pin configs are set correctly, but they are ignored. fix is trivial, but might break other laptops.
Maybe add this as a new input, like analog mic, at least it can be added for aspire 5720.


4) There is really no internal mic boost on aspire, it is digital, not a bug.

5) Codec supports two ADCs, and so does the driver, but for some models second ADC is ignored.
alc268_capture_alt_mixer is used instead of alc268_capture_mixer.

Here on acer both ADCs are present, and it might be worth to use them both (record from line in and mic)
on aspire one there is only external and internal mic, probably doesn't worth it.

6) Codec supports two DACs too, so it is in theory possible to play different streams on speakers and headphones.
2nd DAC is connected only to headphones, while 1st DAC is connected to all. But here on acer they reversed the connections
and connected speakers to headphones output and headphones to speakers, so probably useless, and besides this doesn't worth the trouble probably.

7) SPDIF is supported on my notebook, but no by the driver, don't yet have a device to test it againt thought, but adding support should be easy.
it is shared with headphones output.
How we can detect that digital headphones are connected, don't know, probably impossible in hardware.


8) The issue of capture volume on aspire one:
when I try to increase internal mic's volume I have to increase ether left
or right channel but not both.

Well, first of all, aspire one mic is really digital.
then, digital mic inputs are supposed to be connected by two mics each resulting in total
of 4 mics.

ADC multiplexers hide difference between analog and digital pins, but of course digital pins
aren't really processed by ADC in analog sense, their input is probably sampled, and digitaly amplified.
Maybe we really need to use only left or right channel there.
I'll test this more carefully.



And now for unfixable problems:

1) There is strong DC offset on all inputs.
it is even different on left/right and depends on capture volume.
I tried to change the VREF only param that could help, but it doesn't.
I feel that this is hardware flaw.
(It is possible that voltage on inputs is created by circuit made by acer, and then ALC268 amplifies it.)



2) That 'analog loopback' when setting any 'boost' setting to high.
The is no mention of that in datasheets, and thus I strongly suspect that this should be called crosstalk.
I understand the block diagram of the chip and there is no loopback, so this isn't alsa bug.


Lastly I noticed that datasheet mentions so called 'coefficients':
the codecs exposes lots of internal and undocumented registers using set address/ get/set value scheme.
maybe some of above bugs are fixable there, but ether realtek has to provide data for that or reverse engineering of
windows driver is required.

(I will test whenever the above happens in windows, at least the #2)

And I hope those registers are for debuging only.

Best regards,
	Maxim Levitsky
