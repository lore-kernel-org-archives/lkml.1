Return-Path: <linux-kernel-owner+w=401wt.eu-S1423329AbXBPGPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423329AbXBPGPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423330AbXBPGPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:15:24 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:48415 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423329AbXBPGPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:15:23 -0500
Message-ID: <45D54BD5.8010707@vmware.com>
Date: Thu, 15 Feb 2007 22:14:45 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Ian Pratt <ian.pratt@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
References: <20070216022449.739760547@goop.org> <20070216022531.570154735@goop.org>
In-Reply-To: <20070216022531.570154735@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2007 06:15:22.0686 (UTC) FILETIME=[D741A5E0:01C75191]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2007 06:25 PM, Jeremy Fitzhardinge wrote:
> The XEN config option enables the Xen paravirt_ops interface, which is
> installed when the kernel finds itself running under Xen. (By some
> as-yet fully defined mechanism, implemented in a future patch.)
> 
> Xen is no longer a sub-architecture, so the X86_XEN subarch config
> option has gone.
> 
> The disabled config options are:
> - PREEMPT: Xen doesn't support it
> - HZ: set to 100Hz for now, to cut down on VCPU context switch rate.
>   This will be adapted to use tickless later.
> - kexec: not yet supported
> 

>  
>  config KEXEC
>  	bool "kexec system call"
> +	depends on !XEN
>  	help
>  	  kexec is a system call that implements the ability to shutdown your
>  	  current kernel, and to start another kernel.  It is like a reboot

>  config DOUBLEFAULT
>  	default y
>  	bool "Enable doublefault exception handler" if EMBEDDED
> +	depends on !XEN
>  	help
>            This option allows trapping of rare doublefault exceptions that
>            would otherwise cause a system to silently reboot. Disabling this


> +config XEN
> +	bool "Enable support for Xen hypervisor"
> +	depends PARAVIRT
> +	default y
> +	help
> +	  This is the Linux Xen port.

>  choice
> -	prompt "Timer frequency"
> +	prompt "Timer frequency" if !XEN
>  	default HZ_250
>  	help
>  	 Allows the configuration of the timer frequency. It is customary
> @@ -49,7 +49,7 @@ endchoice
>  
>  config HZ
>  	int
> -	default 100 if HZ_100
> +	default 100 if HZ_100 || XEN
>  	default 250 if HZ_250
>  	default 300 if HZ_300
>  	default 1000 if HZ_1000


>  config PREEMPT
>  	bool "Preemptible Kernel (Low-Latency Desktop)"
> +	depends on !XEN
>  	help
>  	  This option reduces the latency of the kernel by making
>  	  all kernel code (that is not executing in a critical section)
> 

I hate to sound like a broken record, but this really isn't the right 
way to do this.  If you are going to inhibit config settings when Xen 
support is compiled, then it should be:

config XEN
     depends on !KEXEC && !DOUBLEFAULT && HZ_100 && !PREEMPT

I'm really not trying to make things more difficult for you or for Xen 
users.

One of the primary goals of paravirt-ops is to allow the same kernel 
binary to bind to multiple hypervisor interfaces (and native), at 
runtime.  So, we should assume that kernels which are built with 
CONFIG_PARAVIRT will also enable all the paravirt-ops backends; and this 
is a good thing.

But, the problem is, then, when someone enables paravirt (and all the 
backends, including Xen), you are silently forcing all these options 
off.  Compiling in paravirt support should not change force you into 
using some set of config option; when a paravirt-ops kernel is run on 
native, it should be as fully featured as a non-paravirtops kernel.

So, this should really be solved (in order of preference) by:

1) Complete the xen paravirt-ops backend so it can handle these 
"incompatible" options.  I realize this is just a matter of time (at 
least for most of them, what is your plan for PREEMPT?).

2) Disable the option at runtime only if the kernel is booted on Xen. 
When the kernel is booted on native, lhype, paravirt kvm, vmware, etc it 
should be not be inhibited.  This may not be feasible for all of these 
options, but as Zach pointed out, is easy enough for DOUBLEFAULT.  Maybe 
it can be done for KEXEC?  And HZ is easy to allow too, even though Xen 
will still give interrupts at 100hz -- we do this when you boot on VMI. 
  PREEMPT is probably the only real compile time incompatible options 
with Xen.  You just simply have to change the loop decrementors in your 
timer interrupt.

You basically chose #2 for SMP: while your backend doesn't support it 
yet, it's not harmful to have the config option enabled; you just don't 
allow a second vcpu to startup when running on Xen.

3) Use the config XEN line I suggest above.  The net effect is the same 
as your proposed change (it prevents users from compiling the 
incompatible options together), but at least the user understands what 
is going on, instead of options just silently changing on them.

Dan
