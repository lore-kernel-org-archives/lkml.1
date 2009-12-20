Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbZLTIcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbZLTIcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 03:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZLTIcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 03:32:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbZLTIcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 03:32:08 -0500
Message-ID: <4B2DE0A9.4090400@redhat.com>
Date: Sun, 20 Dec 2009 10:30:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Roland McGrath <roland@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
       Oleg Nesterov <oleg@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by	08d68323d1f0c34452e614263b212ca556dae47f
References: <20091218005650.GA20667@redhat.com> <20091218030601.GB16470@nowhere> <20091218172747.GA10924@redhat.com> <20091218200503.2CA0DF9A4@magilla.sf.frob.com> <20091218231545.GA8803@nowhere>
In-Reply-To: <20091218231545.GA8803@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2009 01:15 AM, Frederic Weisbecker wrote:
>
>> Apparently it does.  You should hack some printks into do_debug() and see
>> how kvm is differing from real hardware.  (Actually you can probably do
>> this with a notifier added by a module, not that you are shy about
>> recompiling!)
>>
>> Probably kvm's emulation of the hardware behavior wrt the DR6 bits is not
>> sufficiently faithful.  Conceivably, kvm is being consistent with some
>> older hardware and we have encoded assumptions that only newer hardware
>> meets.  But I'd guess it's just a plain kvm bug.
>>      
>    

A kvm bug is most likely.

> It looks like in kvm, before entering the guest, we restore its
> debug registers:
>
> vcpu_enter_guest():
> 	if (unlikely(vcpu->arch.switch_db_regs)) {
> 		set_debugreg(0, 7);
> 		set_debugreg(vcpu->arch.eff_db[0], 0);
> 		set_debugreg(vcpu->arch.eff_db[1], 1);
> 		set_debugreg(vcpu->arch.eff_db[2], 2);
> 		set_debugreg(vcpu->arch.eff_db[3], 3);
> 	}
>
>
> But what happens to dr6, I don't know.
>    

That's done later, in vmx.c:vmx_vcpu_run():

     if (vcpu->arch.switch_db_regs)
         set_debugreg(vcpu->arch.dr6, 6);

Can you describe the failure?  I'll try to construct a test case 
reproducer and work with Jan to fix it.

-- 
error compiling committee.c: too many arguments to function

