Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab0CJWTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:19:15 -0500
Received: from mail-ew0-f216.google.com ([209.85.219.216]:34111 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab0CJWTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:19:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IB4vBLKjOcT0fA9sxSZgSbkiKTC8OQ6iAs6VxQ4VKoLNEj+fN/DRs3HMuF1sVrkDhO
         zcmHzSPJbV6MHvHcKCu2LyKpInz6YPLBZfcQ2nVsOeEdFrFTfptHURfEb7c9yjtQqEZE
         vFF44fFPhNzVJEpKs/C0dLGX8t8wbo7SIQJYs=
MIME-Version: 1.0
In-Reply-To: <b637ec0b1003101409j6b03e219m5ac587b96bf5e26b@mail.gmail.com>
References: <b637ec0b1003091458j67efc62cg2c975e9e286f4b0b@mail.gmail.com>
	 <71cd59b01003100507q79878fdan98e53cb4e705d2c2@mail.gmail.com>
	 <b637ec0b1003100546l121f3a54o311aba94c8cabc5e@mail.gmail.com>
	 <b637ec0b1003101409j6b03e219m5ac587b96bf5e26b@mail.gmail.com>
Date: Wed, 10 Mar 2010 23:19:06 +0100
Message-ID: <b637ec0b1003101419i81391fchd99410530915b1a3@mail.gmail.com>
Subject: Re: Possible bug in eeepc-laptop.c - EeePC 900
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I'm sorry but I have some more detils to add.

On Wed, Mar 10, 2010 at 11:09 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> HI again.
>
> On Wed, Mar 10, 2010 at 2:46 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>> Hi.
>>
>> On Wed, Mar 10, 2010 at 2:07 PM, Corentin Chary
>> <corentin.chary@gmail.com> wrote:
>>> On Tue, Mar 9, 2010 at 11:58 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>>>> Hi.
>>>> I have an EeePC 900 running 2.6.34-rc1.
>>>>
>>>> If I boot it on AC the cpu runs at full speed, 900MHz; if I boot it on
>>>> battery it runs only at 630Mhz. Plugging / unplugging the AC does not
>>>> change the cpu frequency. Only a reboot can change the situation.
>>>>
>>>> I already tried to echo 0 or 1 to the
>>>> /sys/devices/platform/eeepc/cpufv file; no effects, even if the file
>>>> changes its value.
>>>>
>>>> This is not a regression from 2.6.33: this behavior is also present in
>>>> that version.
>>>>
>>>> Does this ring any bells? This is really annoying, especially when
>>>> trying to watch a movie on battery. Also 3D apps show a 30%
>>>> performance drop, as expected.
>>>
>>> Can you change the frequency with cpufreq ?
>>
>> No, I can't. Which cpufreq driver am I supposed to use? With only
>> cpufreq compiled in, the directory
>> /sys/drivers/system/cpu/cpu0/cpufreq is empty.
>
> OK, there's something really wrong here.
> I tried every possible cpufreq driver and the only one that loads is
> p4-clockmod (the others say "no such device"). But...
>
> The result is really unexpected, at least to me. The system switches
> immediately to full speed, 900MHz (while running on battery). The
> motivation is probably this:
>
> [    3.698307] conservative governor failed, too long transition
> latency of HW, fallback to performance governor
> [    3.698334] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
>
> The cause of this is probably that this driver thinks that my eeepc is
> capable of many intermediate cpu frequency values:
>
> cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
> 112500 225000 337500 450000 562500 675000 787500 900000
>
> but the machine is only capable of 630 and 900MHz.
>
> So, for me this is a really useful workaround: I compiled p4-clockmod
> statically and so just a few seconds after boot I have my system
> running at full speed :-)

Unfortunately this is not true. /proc/cpuinfo says:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 13
model name	: Intel(R) Celeron(R) M processor          900MHz
stepping	: 8
cpu MHz		: 900.000
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
clflush dts acpi mmx fxsr sse sse2 ss tm pbe nx up bts
bogomips	: 1260.35
clflush size	: 64
cache_alignment	: 64
address sizes	: 32 bits physical, 32 bits virtual

As you can see, 900MHz with only 1260.35 bogomips (the value
correspondent to 630MHz).

A quick performance test confirms that the cpu is running at 630MHz
and that the value reported by /proc/cpuinfo is totally fake.

>
> To summarize:
>
> -----Without p4-clockmod
> * the eeepc-laptop cpufv interface doesn't work at all on my eeepc900
> * this happens at least with 2.6.33 and 2.6.34-rc1
> * if the system boots on AC power it stays forever at 900MHz
> * if it boots on battery it stays forever at 630MHz
>
> ---With p4-clockmod
> * the system boots at 630MHz if on battery
> * as soon that p4-clockmod is loaded it switches to 900MHz
> * p4-clockmod has a frequency table which is totally meaningless on the eeepc900

* p4-clockmod does not work at all on the eeepc900 too!

>
> What a mess....
>

Indeed.

> Regards,
> Fabio
>

Fabio




>>
>>> Did you try all cpufv values (see cpufv_available file) ?
>>
>> Yes, it only shows 0 and 1. I tried both, without success.
>>
>>> Is you bios up-to-date ?
>>
>> Yes it is, it's 1006.
>>
>>>
>>> --
>>> Corentin Chary
>>> http://xf.iksaif.net
>>>
>>
>> Thanks.
>> Fabio
>>
>
