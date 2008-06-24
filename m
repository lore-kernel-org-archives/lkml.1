Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYFXAzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYFXAzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYFXAzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:55:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:2956 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYFXAzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:55:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tJuzFlJH5aTF6X0zRvUygBIF66VYfGRavxolL0aktcpZXJZusFSgdLXssmCynkfQ7/
         bdI8Q3znaNXDG6hBme0WO5Pzk1vEKdWYpJ67VMJkPiq6YLubJukSRnm1lRwUnc/YdUI2
         uMYqWV08VuLbEFn8Stbpkst2LF6yDLvGiwXk8=
Date: Tue, 24 Jun 2008 04:50:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080624005053.GA4827@martell.zuzino.mipt.ru>
References: <20080615033001.GE26421@linux.vnet.ibm.com> <20080615162150.GA8289@martell.zuzino.mipt.ru> <20080615181710.GA17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151323101.2949@woody.linux-foundation.org> <20080615232754.GD17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151633290.2949@woody.linux-foundation.org> <20080616030154.GA7445@martell.zuzino.mipt.ru> <20080616033126.GF17915@linux.vnet.ibm.com> <20080616034659.GA7600@martell.zuzino.mipt.ru> <20080617034228.GA18217@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617034228.GA18217@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[rcutorture failures with PREEMPT_RCU]

Status update:
* bug is reproduced on another box with the very same symptoms:
  SMP=y, maxcpus=1 kernel occasionally fails, SMP=n is fine.
  Also Core 2 Duo, x86_64 [1]

  Race is wide -- 60 seconds of rcutorture is enough.

So far tried without effect:
	not doing SMP-alternatives
	NO_HZ=y/n
	HIGH_RES_TIMERS=y/n
	compiling with gcc 3.4.6/4.1.2
	different HZ
	s/asm/asm volatile/g at percpu asm code and PDA asm code
	turning on and off varying CONFIG_DEBUG_ options
	CONFIG_DEBUG_PREEMPT
	softlockup on/off
	making x86_64 cpu_idle() same as 32-bit one wrt rcu_pending et al
	sched_setaffinity() in __synchronize_sched doesn't fail

Probably forgot something, but not a single thing that can remove the
bug in SMP=y case.

Using SMP percpu stuff for UP case miserably failed because of some hard
hang due to incomplete patch, but I still leave this for doomsday.

I'm going to try 32-bit setup and reading rcupreempt disassembly with
microscope.

[1]

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz
stepping	: 11
cpu MHz		: 800.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm ida
bogomips	: 4791.74
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz
stepping	: 11
cpu MHz		: 800.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm ida
bogomips	: 4787.76
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:
-----------------------------------------------------------------------------
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz
stepping	: 2
cpu MHz		: 2135.041
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 4272.61
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz
stepping	: 2
cpu MHz		: 2135.041
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 4270.14
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

