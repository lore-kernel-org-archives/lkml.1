Return-Path: <linux-kernel-owner+w=401wt.eu-S1030297AbXCSQDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297AbXCSQDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030295AbXCSQDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:03:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:59127 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030284AbXCSQC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:02:59 -0400
Message-ID: <45FEB431.8030504@qumranet.com>
Date: Mon, 19 Mar 2007 18:02:57 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Avi Kivity <avi@argo.co.il>, Anthony Liguori <aliguori@us.ibm.com>,
       kvm-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 0/15] KVM userspace interface updates
References: <11736212072915-git-send-email-avi@qumranet.com> <20070316083650.GA8525@osiris.boeblingen.de.ibm.com> <45FAA39C.9050705@us.ibm.com> <20070316150145.GB8525@osiris.boeblingen.de.ibm.com> <45FD1778.6030602@argo.co.il> <20070319154311.GB8331@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20070319154311.GB8331@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
>> Right.  I agree it's more natural to associate a vcpu with a task
>> instead of a vcpu being an independent entry.  We'd still need a
>> handle for it, and in Linux that's an fd (pid doesn't cut it as it's
>> racy, and probably slower too as it has to go through a global structure).
>>     
>
> If you go for: only one VM per thread group and only one vcpu per thread
> you don't need any identifier.
>   

That's the idea, but if I want to send an inter-processor-interrupt to 
another cpu, I need to be able to identify it.  The pid [tid] is 
natural, but racy if the thread can die.

> All relevant information or a pointer to it would be saved in the
> thread_info structure.
> That would give you two system calls to add/remove cpus which implicitely
> create a VM if none is present. This add_vcpu syscall would also map
> a memory range to user space which would be used to communicate between
> user/kernel space to avoid frequent copy_to/from_user just like your
> latest patches for KVM_RUN do.
>
> We implemented a prototype on s390 based on a system call interface
> and which does have full smp support.

[...]

> The interesting part with this is that you don't need any locking
> for a kvm_run system call, simply because only the thread itself can
> create/remove the vcpu:
>   

Yes!  The vcpu is an implied parameter (current->vcpu).

> Of course all this is rather simplified, but should give a good idea
> why I think that a syscall based interface should be the way to go.
>   

I agree with all of the above, and in addition, integration to the 
scheduler will allow us to reduce vcpu migration rate, and maybe do 
things like gang scheduling.

But that doesn't mean it can be done now: we really need to see how it 
works out with smp and with an additional arch, and then we can 
stabilize it.  Meanwhile I'd like a stable ABI so distros can start 
shipping kvm without worrying about upgrade headaches.

So the plan is:
- get the /dev/kvm ABI into 2.6.22
- implement smp
- add another arch
- move to a syscall based interface in parallel; userspace should work 
with both
- deprecate the old ABI and external modules.

-- 
error compiling committee.c: too many arguments to function

