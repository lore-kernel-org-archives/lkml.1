Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbYF1M3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbYF1M3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbYF1M3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:29:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:51763 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbYF1M3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ve2oBxyNOn9tdjCAUe8ixB9xWDoq89fj/2+/iB+zQzAyr+cuAh0DJj1K9WNo+3H2ko
         1ROYrlaVZJ3j0xZUUbnypJxAzKd68M627VpWh5HoAbB6gGrgVH8aC4pbSTz+6zO9UvBm
         S+hbAd23aS6IzI3Q3GfvzD8j8PR0iJCP3IDeo=
Message-ID: <6278d2220806280529n70c6233dk1c5768df5d52acf@mail.gmail.com>
Date: Sat, 28 Jun 2008 13:29:32 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: ALC883 recording troubles...
Cc: "Takashi Iwai" <tiwai@suse.de>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220806280329j2f77c52dp8fbae78420c136c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <6278d2220806271705v5bd5fec3l86c3560283063092@mail.gmail.com>
	 <19f34abd0806280311s115062e6vc6d0f304cb744934@mail.gmail.com>
	 <6278d2220806280329j2f77c52dp8fbae78420c136c1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 11:29 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> On Sat, Jun 28, 2008 at 11:11 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> (removed linux-kernel from Cc)
>>
>> On Sat, Jun 28, 2008 at 2:05 AM, Daniel J Blueman
>> <daniel.blueman@gmail.com> wrote:
>>> As the mic is working fine, but with this variable DC offset, it felt
>>> like something needed tweaking in the mixer (summation) node. I
>>> understand more about the node connectivity now, and found muting the
>>> front mic mixer input and setting LR gain to 0 at mixer node 23h
>>> addresses the issue:
>>>
>>> (from page 42 at ftp://66.104.77.130/pc/audio/ALC883_DataSheet_1.3.pdf)
>>>
>>> # ./hda-verb /dev/snd/hwC0D0 0x23 SET_AMP_GAIN_MUTE 0x7180
>>
>> Are you saying that this fixes the problem completely for you?
>
> Yes, this addresses the problem squarely. The front mix mixer input is
> adding this offset, looks like they have a capacitor between a
> reference voltage and the pin or something, so it floats up.
>
>>> Vegard - your HD bus enumeration looks similar and I'd bet the vendor
>>> followed the same Realtek application note, so can you give this a
>>> shot too? If not, try mixer node 20h.
>>
>> I agree. Thanks for the link, I found ALC268 now as well, and I am
>> experimenting...
>>
>> I think 23h is [in]correct -- this is the one with caps f00040h for me too.
>>
>> But neither of them had any effect at all.
>
> OK, I'll take another look at the debug output you posted; I forgot
> you aren't using the ALC883.

Using your dumped config and
ftp://202.65.194.211/pc/audio/ALC268_DataSheet_1.3.pdf page 42, your
front mic pin complex is at node 19h; the mixers connecting to it are
at nodes 0Bh, 22h and 23h, all at the second input index, so one of
these should work:

# ./hda-verb /dev/snd/hwC0D0 0x0b SET_AMP_GAIN_MUTE 0x7280
# ./hda-verb /dev/snd/hwC0D0 0x22 SET_AMP_GAIN_MUTE 0x7280
# ./hda-verb /dev/snd/hwC0D0 0x23 SET_AMP_GAIN_MUTE 0x7280

On my ALC883, we need to mute the first input instead, thus 0x7180.
Can you see if the above helps you out?

Thanks,
  Daniel
-- 
Daniel J Blueman
