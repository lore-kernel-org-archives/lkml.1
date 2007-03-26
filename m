Return-Path: <linux-kernel-owner+w=401wt.eu-S964863AbXCZJz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863AbXCZJz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964944AbXCZJz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:55:28 -0400
Received: from 26.mail-out.ovh.net ([213.186.42.179]:38087 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964863AbXCZJz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:55:26 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2007 05:55:26 EDT
Message-ID: <46079698.2070506@boichat.ch>
Date: Mon, 26 Mar 2007 17:47:04 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] Macbook pro timer bug (was: "Patch "CPU hotplug: call check_tsc_sync_source()
 with irqs off" breaks some drivers")
References: <4606CA92.1000405@boichat.ch> <46074CD2.8000002@boichat.ch> <20070326065604.GA19402@elte.hu>
In-Reply-To: <20070326065604.GA19402@elte.hu>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.230.111 (nusnet-230-111.dynip.nus.edu.sg)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Nicolas Boichat <nicolas@boichat.ch> wrote:
>
>   
>>> I found out which commit seems to cause these bugs:
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d04f41e35343f1d788551fd3f753f51794f4afcf
>>>
>>> The latest GIT without this commit works fine, but doesn't with it.
>>>       
>> Sorry about blaming this commit. The problems happen randomly (about 1 
>> reboot over 2 is ok, at least with 2.6.21-rc4). I'll run more tests 
>> and post the results later.
>>     
>
> is this the 32-bit kernel? 

Yes it is.

> If yes then does commit 
> 4edc5db83f574dfcc8be35b7b96760ded543b360 (included in -rc5) fix it?
>   

I don't know precisely which commit you are talking about, but I
upgraded to 2.6.21-rc5, and the problem became more obvious.

>From what I experimented, I came to the conclusion that when the
frequency of the first CPU is wrongly detected, the timers get wrong
(i.e. tsc, hpet, with or without high-res timers).

It is not a new bug, it happened in 2.6.20 too (I also found an old
dmesg from 2.6.18-rc2 with the same frequency detection problem), except
that for some reasons it didn't cause that many obvious bugs, so I
didn't notice it at that time.

(in case you don't remember my first message, I have a Macbook Pro first
generation (Core Duo, so x86), see below for /proc/cpuinfo)

This is the diff of two consecutive soft reboots, with the same kernel
(CONFIG_HPET_TIMER unset, CONFIG_HIGH_RES_TIMERS set):

--- dmesg-2.6.21-rc5-nohpet-error-notime	2007-03-26 16:42:00.000000000 +0800
+++ dmesg-2.6.21-rc5-nohpet-success-notime	2007-03-26 16:42:09.000000000 +0800
@@ -100,7 +100,7 @@
 Enabling unmasked SIMD FPU exception support... done.
 Initializing CPU#0
 PID hash table entries: 4096 (order: 12, 16384 bytes)
-Detected 1952.283 MHz processor.
+Detected 1830.920 MHz processor.
 Console: colour VGA+ 80x25
 Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
 Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)


The "+" boot reports the correct CPU frequency (1.83Ghz).

When you run something like this on both:
# ntpdate swisstime.ethz.ch
# ntpdate swisstime.ethz.ch
# sleep 60
# ntpdate swisstime.ethz.ch

You get, with the "+" boot, what you expect:

26 Mar 16:33:34 ntpdate[3385]: adjust time server 129.132.2.21 offset 0.120391 sec
26 Mar 16:32:52 ntpdate[3376]: adjust time server 129.132.2.21 offset 0.137979 sec
-- pause of about 60 seconds
26 Mar 16:33:55 ntpdate[3386]: adjust time server 129.132.2.21 offset 0.125751 sec


i.e. the clock is still correct 60 seconds after you adjust it.

While, with the "-" boot, you get:

26 Mar 16:18:05 ntpdate[3444]: step time server 129.132.2.21 offset 3.829351 sec
26 Mar 16:18:08 ntpdate[3445]: adjust time server 129.132.2.21 offset 0.232023 sec
-- pause
26 Mar 16:19:16 ntpdate[3447]: step time server 129.132.2.21 offset 4.320653 sec

The clock has shifted of about 4.1 seconds in 60 seconds, i.e. an error
of 6.8%, which is in the same range as the error between 1952 and 1833
Mhz (6.5%).
 
I get the same results with both CONFIG_HPET_TIMER and
CONFIG_HIGH_RES_TIMERS unset, some boots are ok, some aren't.

I couldn't get a correct boot with these two options enabled, but it's
probably because I didn't reboot enough times...

I you want some detailed kernel logs, see
http://www.boichat.ch/nicolas/linux/2nd/ .
Please tell me if you need more informations, or if you prefer I file a
bug in the bugzilla.

Best regards,

Nicolas

---

/proc/cpuinfo on an incorrect boot:

nunuche ~ # cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 14
model name	: Genuine Intel(R) CPU           T2400  @ 1.83GHz
stepping	: 8
cpu MHz		: 1952.216
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc pni monitor vmx est tm2 xtpr
bogomips	: 4689.63
clflush size	: 64

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 14
model name	: Genuine Intel(R) CPU           T2400  @ 1.83GHz
stepping	: 8
cpu MHz		: 1952.216
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc pni monitor vmx est tm2 xtpr
bogomips	: 3661.27
clflush size	: 64


