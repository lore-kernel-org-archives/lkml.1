Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbZD1Kkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbZD1Kkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbZD1Kk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:40:29 -0400
Received: from fallback-out1.mxes.net ([216.86.168.190]:1270 "EHLO
	fallback-in1.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755559AbZD1Kk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:40:27 -0400
X-Greylist: delayed 759 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2009 06:40:27 EDT
Message-ID: <49F6DA14.7030608@tuffmail.co.uk>
Date: Tue, 28 Apr 2009 11:27:32 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH] [RFC] EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk>	 <200904140859.02188.bjorn.helgaas@hp.com>	 <20090414081728.10de978a@infradead.org>	 <200904140948.37633.bjorn.helgaas@hp.com> <49E5F01B.2060201@tuffmail.co.uk>	 <49EF0ABD.2080801@tuffmail.co.uk> <49F446AE.6070607@tuffmail.co.uk>	 <49F6CA0E.5040101@tuffmail.co.uk> (sfid-20090428_111942_198975_13CDA6F5) <1240912688.28835.10.camel@johannes.local>
In-Reply-To: <1240912688.28835.10.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> It seems the only reason lockdep doesn't warn is the detour to userspace
> (modprobe) and the waiting for a userspace task (waiting isn't lockdep
> annotated and I don't think it can be)
>
> It seems you cannot load a module while under _any_ lock, ever, since
> userspace might turn around and do something that requires that lock? I
> think we should probably add a warning to the code that waits for the
> userspace task:
>
> 	debug_check_no_locks_held(current);
>
> Or not? Some purely internal locks _might_ be ok... but how could you
> verify that?
>
>   
>> - ieee80211_wep_init(), which is called with rtnl_lock() held, is
>> blocked in request_module() [waiting for modprobe to load a crypto module].
>>     
>
> Right.
>
>   
>> - modprobe is blocked in a call to flush_workqueue(), caused by closing
>> a TTY.
>>     
>
> Can you point out where? I can't find that.
>   

I posted the calltraces earlier at
<http://marc.info/?l=linux-wireless&m=124074566523506&w=2>.

wait_for_completion
flush_cpu_workqueue
? wq_barrier_func
flush_workqueue
flush_scheduled_work
tty_ldisc_release
? tty_fasyc
tty_release_dev
? free_pgtables
tty_release
__fput
filp_close
sys_close
syscall_call


>> - worker_thread is blocked because the workqueue item linkwatch_event()
>> is blocked on rtnl_lock.
>>     
>
> This I know about.
>
>   
>> I've hacked up a test patch to move wep_init() outside of rtnl_lock, and
>> it solved the problem.  My one caveat is that it would probably be
>> cleaner to move it after rtnl_unlock(), instead of before rtnl_lock(). 
>> I just wasn't 100% sure if that would be safe.  Here's the patch:
>>     
>
> That doesn't seem relevant, this just does some initialisation. However,
> you definitely missed adding a call to wep_free().
>   

Hah, I should have realized something was wrong when I noticed I was
removing more lines that I added. 

The crypto init does cause the module load:

wait_for_completion
call_usermodehelper_exec
__request_module
crypto_larval_lookup
? extract_entropy
crypto_alg_mod_lookup
crypto_alloc_base
ieee80211_wep_init
ieee80211_register_hw
? ath5k_hw_set_bss
ath5k+pci_probe
local_pci_probe
pci_device_probe
driver_probe_device
__driver_attach
bus_for_each_dev
driver_attach
? __driver_attach
buad_add_driver
driver_register
? ktime_get_ts
__pci_register_driver
init_ath5k_pci
_stext
? init_ath5k_pci
? proc_create_data
? register_ieq_proc
kernel_init


Thanks
Alan

