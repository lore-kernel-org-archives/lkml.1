Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZKPVeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZKPVeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZKPVeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:34:14 -0500
Received: from relay3.sgi.com ([192.48.152.1]:44495 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754263AbZKPVeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:34:12 -0500
Message-ID: <4B01C554.8040201@sgi.com>
Date: Mon, 16 Nov 2009 13:34:12 -0800
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
Subject: Re: [PATCH 1/6] x86: Limit the number of processor bootup messages
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210726.585624000@alcatraz.americas.sgi.com> <20091116212216.GA2221@elte.hu>
In-Reply-To: <20091116212216.GA2221@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> +	if (cpu == 0)
>> +		printk(KERN_INFO "CPU0: Thermal monitoring enabled (%s)\n",
>> +		       tm2 ? "TM2" : "TM1");
> 
> Hm, 'cpu==0 means boot cpu' assumptions are not particularly clean.

Yes.  It appears that boot_cpu_id is only defined for x86.  I don't know
any other way to identify the boot cpu.  (Hmm, in this case it *is* an
x86 specific function, so I'll change it.)

> 
>> +#ifdef CONFIG_NUMA
>> +	if (system_state == SYSTEM_BOOTING) {
>> +		static int current_node = -1;
>> +		int node = cpu_to_node(cpu);
>> +
>> +		if (node != current_node) {
>> +			if (current_node > (-1))
>> +				pr_cont(" Ok.\n");
>> +			current_node = node;
>> +			pr_info("Booting Node %3d, Processors ", node);
>> +		}
>> +		pr_cont(" #%d%s", cpu, cpu == (nr_cpu_ids - 1) ? " Ok.\n" : "");
>> +	} else
>> +#endif
>> +		pr_info("Booting Processor %d APIC 0x%x\n", cpu, apicid);
> 
> preprocessor directives cutting into if/else branches in an assymetric 
> way is being frowned upon. I'd also suggest to put this into a helper 
> inline.

ok.

> 
> Is the SYSTEM_BOOTING check there to not re-print this on CPU hotplug?

Actually you get the old style "Booting Processor" message for hotplug off/on.

newton:~ # cd /sys/devices/system/cpu
newton:/sys/devices/system/cpu # echo 0 > cpu6/online
[ 3037.593411] CPU 6 is now offline

newton:/sys/devices/system/cpu # echo 1 > cpu6/online
[ 3045.843469] Booting Processor 6 APIC 0x3

I can't test going into/out of the sleep modes, so it may be better to
summarize for those operations as well.

Thanks,
Mike

