Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZKPVpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZKPVpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZKPVpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:45:38 -0500
Received: from relay3.sgi.com ([192.48.152.1]:56274 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750905AbZKPVph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:45:37 -0500
Message-ID: <4B01C803.1010303@sgi.com>
Date: Mon, 16 Nov 2009 13:45:39 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration bootup
 messages
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210728.267482000@alcatraz.americas.sgi.com> <20091116212427.GC2221@elte.hu>
In-Reply-To: <20091116212427.GC2221@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> --- linux.orig/init/calibrate.c
>> +++ linux/init/calibrate.c
>> @@ -123,23 +123,26 @@
>>  {
>>  	unsigned long ticks, loopbit;
>>  	int lps_precision = LPS_PREC;
>> +	bool boot_cpu = (smp_processor_id() == 0);
> 
> this code is shared by other architectures too - are you sure 
> smp_processor_id()==0 is a proper 'I am the boot CPU' assumption 
> everywhere?
> 
> 	Ingo

This was where having the boot_cpu_id would have been handy.

I could add something like:

--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -539,13 +539,15 @@
  *     Activate the first processor.
  */

+int boot_cpu_id __read_mostly;
+
 static void __init boot_cpu_init(void)
 {
-       int cpu = smp_processor_id();
+       int boot_cpu_id = smp_processor_id();
        /* Mark the boot cpu "present", "online" etc for SMP and UP case */
-       set_cpu_online(cpu, true);
-       set_cpu_present(cpu, true);
-       set_cpu_possible(cpu, true);
+       set_cpu_online(boot_cpu_id, true);
+       set_cpu_present(boot_cpu_id, true);
+       set_cpu_possible(boot_cpu_id, true);
 }

 void __init __weak smp_setup_processor_id(void)

and remove boot_cpu_id from arch/x86 ... ?

Thanks,
Mike
