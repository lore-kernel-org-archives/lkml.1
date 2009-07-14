Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbZGNOhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbZGNOhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZGNOhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:37:36 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:54352 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZGNOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:37:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PaCXn4qCIaIBJ8HNEziDq6bVSZNs8nv0olZ98VZWK1eGG4VoM360cp7Un5OcW7Y2Kf
         VMqykDDyFkjr5hy+ninZcl+0pWTzZDmhwcokSdKIPyH0xF27TcCQbwkAWg8VOkpVfYJ6
         sFQq9cvKbrv+VR/eTgO8wTkHLDsAOK8YC7Hu8=
MIME-Version: 1.0
In-Reply-To: <20090708174741.GA23487@srcf.ucam.org>
References: <200907081556.34682.czoccolo@gmail.com>
	 <20090708161052.GA20951@srcf.ucam.org>
	 <4e5e476b0907081041g5561a8b2s1bc393809a09b78b@mail.gmail.com>
	 <20090708174741.GA23487@srcf.ucam.org>
Date: Tue, 14 Jul 2009 16:37:32 +0200
Message-ID: <4e5e476b0907140737g74220bb1n42ceba5d8c8aa92a@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Introduces stepped frequency increase
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Content-Type: multipart/mixed; boundary=00504502e2a00230a7046eab6104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502e2a00230a7046eab6104
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Wed, Jul 8, 2009 at 7:47 PM, Matthew Garrett<mjg@redhat.com> wrote:
> On Wed, Jul 08, 2009 at 07:41:23PM +0200, Corrado Zoccolo wrote:
>> Hi Matthew,
>> > Is this a measured powersaving? The ondemand model is based on the
>> > assumption that the idle state is disproportionately lower in power than
>> > any running state, and therefore it's more sensible to run flat out for
>> > short periods of time than run at half speed for longer. Is this
>> > inherently flawed, or is it an artifact of differences in your processor
>> > design?
>>
>> The flawed assumption is that running at doubled frequency halves the
>> completion time.
>> On cpus that can change the core speed without impacting the
>> memory-cache bandwidth
>> (i.e. the Pentium M), workloads that access lot of memory go at the
>> same speed at
>> maximum and minimum frequency.
>> Now I see new CPUs that can flush their cache during deep idle states (Atoms),
>> this aggravates the aforementioned problem, rendering the high
>> frequency state much less appetible.
>
> Do you have numbers to support this? What effect does the ramping up
> have on user-visible latency?
I have the numbers now (see attached).
On my Pentium M machine, I run twice the following test, one with
freq_step = 100, and one with 5, sampling the remaining capacity every
20 minutes, for 12 samples.
* booted from battery after full discharge and full recharge.
* started firefox (with empty page)
* run the script:
for cpu in /sys/devices/system/cpu/cpu[0]/; do
    # reset to defaults for my system
    cat $cpu/cpufreq/phc_default_vids > $cpu/cpufreq/phc_vids
    echo ondemand > $cpu/cpufreq/scaling_governor
    echo 0 > $cpu/cpufreq/ondemand/ignore_nice_load
    echo 20000 > $cpu/cpufreq/ondemand/sampling_rate
done

for cpu in /sys/devices/system/cpu/cpu[0]/; do
    echo $1 > $cpu/cpufreq/ondemand/freq_step;
done

killall xscreensaver
sync
xrandr --output LVDS --off
for i in `seq 0 11`; do
    cat /proc/acpi/battery/BAT*/state > test.$1.$i.bat
    sleep 1200
done
xrandr --output LVDS --auto
shutdown -h now

The attached tsv shows that freq_step=5 saves around 1%-2% of power
with respect to freq_step=100 (default cpufreq behaviour).
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------

--00504502e2a00230a7046eab6104
Content-Type: text/tab-separated-values; charset=US-ASCII; name="result.tsv"
Content-Disposition: attachment; filename="result.tsv"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fx4q5mba0

InNhbXBsZSIJNQkxMDAJImRpZmYiCjAJMzk2MAkzOTYwCTAKMQkzODAwCTM4MDAJMAoyCTM2ODAJ
MzY0MAk0MAozCTM1NjAJMzUyMAk0MAo0CTM0MDAJMzM2MAk0MAo1CTMyNDAJMzIwMAk0MAo2CTMx
MjAJMzA4MAk0MAo3CTI5NjAJMjkyMAk0MAo4CTI4NDAJMjc2MAk4MAo5CTI2ODAJMjYwMAk4MAox
MAkyNTIwCTI0NDAJODAKMTEJMjM2MAkyMzIwCTQwCg==
--00504502e2a00230a7046eab6104--
