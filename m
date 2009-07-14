Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbZGNOpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbZGNOpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZGNOpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:45:00 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:60986 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZGNOo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MbvhS1DEv5zXHazh2sk+F/yYXndBW9BQTNC4ioF3zep3zW/0YemoK9dEAvnX0gN3eH
         oPmg5Zmi/hXtt5aE+fgpDJvvUx08/UhLJdoQPyjmNvEQjANE6vn9bl2aKBLir4S6sUkp
         ubHj22Rli3xLm2QN4H8VPvbwqSYq73dSBS0Dk=
MIME-Version: 1.0
In-Reply-To: <20090709233447.GA1770@ucw.cz>
References: <200907081556.34682.czoccolo@gmail.com>
	 <20090708161052.GA20951@srcf.ucam.org>
	 <4e5e476b0907081041g5561a8b2s1bc393809a09b78b@mail.gmail.com>
	 <20090709233447.GA1770@ucw.cz>
Date: Tue, 14 Jul 2009 16:44:57 +0200
Message-ID: <4e5e476b0907140744qb2cf9cajc1c5dbbeba2ab66d@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Introduces stepped frequency increase
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <mjg@redhat.com>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 1:34 AM, Pavel Machek<pavel@ucw.cz> wrote:
> On Wed 2009-07-08 19:41:23, Corrado Zoccolo wrote:
>> Hi Matthew,
>>
>> On Wed, Jul 8, 2009 at 6:10 PM, Matthew Garrett<mjg@redhat.com> wrote:
>> > On Wed, Jul 08, 2009 at 03:56:33PM +0200, Corrado Zoccolo wrote:
>> >> The patch introduces a new sysfs tunable cpufreq/ondemand/freq_step,
>> >> as found in conservative governor, to chose the frequency increase step,
>> >> expressed as percentage (default = 100 is previous behaviour).
>> >>
>> >> This allows fine tuning powersaving on mobile CPUs, since smaller steps will allow to:
>> >> * absorb punctual load spikes
>> >> * stabilize at the needed frequency, without passing for more power consuming states, and
>> >
>> > Is this a measured powersaving? The ondemand model is based on the
>> > assumption that the idle state is disproportionately lower in power than
>> > any running state, and therefore it's more sensible to run flat out for
>> > short periods of time than run at half speed for longer. Is this
>> > inherently flawed, or is it an artifact of differences in your processor
>> > design?
>
> Different processors behave differently -- that assumption is wrong at
> least for old athlon64s... Those have power-hungry idle states, and 4x
> power consumption at 2x frequency....
>
> (Original Intel speedstep was similar iirc).

Actually, I think that if the assumption was completely fulfilled by
some hardware, the 'performance' governor would be better than
cpufreq, since it would have less latency, and reach idle faster.
However, even for recent hardware, at least states C1/C2 drain more
power at higher frequencies, so cpufreq is actually useful, and
avoiding unnecessary peaks (as this patch intends to do) can be useful
as well.

Moreover. as I said before, for some processors, the performances are
not directly proportional to the core frequency, but depend on the
workload.

For example: on Pentium M (banias), with frequency ranging from 600 to 1300MHz,
the following program, compiled with -O3 -funroll-loops:
#include <stdlib.h>
#define SIZE 16*1024*1024
#define TYPE long
int main() {
  TYPE * memory=(TYPE*)calloc(SIZE,sizeof(TYPE));
  int i, j;
  for (j=0; j<20; ++j)
    for (i=1; i<SIZE-1; ++i)
      memory[i] += memory[i-1] + memory[i+1];

  return 0;
}

achieves:
[root@localhost hd]# echo powersave >
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
[root@localhost hd]# time ./time_me
3.19user 0.11system 0:03.36elapsed 98%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+16506minor)pagefaults 0swaps
[root@localhost hd]# echo performance >
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
[root@localhost hd]# time ./time_me
3.06user 0.07system 0:03.18elapsed 98%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+16506minor)pagefaults 0swaps
[root@localhost hd]# echo  ondemand >
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
[root@localhost hd]# echo 5 >
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/freq_step
[root@localhost hd]# sleep 5; time ./time_me
2.90user 0.11system 0:03.18elapsed 94%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+16506minor)pagefaults 0swaps

it has only 9% performance decrease passing from 1300MHz to 600MHz,
and the difference between performance and ondemand with
(freq_step=5%) is not measurable.

The same program on an Atom doesn't show the same effect. It seems
that Atoms scale also the FSB frequency together with core frequency.

Corrado

>
>                                                                Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
