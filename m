Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZDUM2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZDUM2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 08:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZDUM1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 08:27:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54059 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbZDUM1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:27:52 -0400
Message-ID: <49EDBBBF.90509@redhat.com>
Date: Tue, 21 Apr 2009 15:27:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Xenner design and kvm msr handling
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com> <49EC5C3A.6020108@redhat.com> <49EC68A7.8080403@redhat.com> <49EC6DEE.4070703@redhat.com> <49EC7797.7060004@redhat.com> <49EC7C5F.2000006@redhat.com> <49ED8E6D.80005@redhat.com> <49ED9C70.5010906@redhat.com> <49EDB0E0.5060101@redhat.com>
In-Reply-To: <49EDB0E0.5060101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
>> Can you explain the protocol used by this MSR? How does the guest know
>> how many pages to load? How does the kernel know which type of page to
>> put where?
>
> Sure.
>
>   (1) cpuid 0x40000000, check vmm signature
>   (2) cpuid 0x40000002 -> returns # of pages (eax) and msr (ebx)
>   (3) allocate pages (normal ram)
>   (4) foreach page (wrmsr "guest physical address | pageno")
>
> Xen uses msr 0x40000000.  Due to the msr being queried via cpuid it 
> should be possible to use another one.  Modulo guest bugs of course ...

Is there an interface to forget a page? (if not, how do you unload a 
driver? presumably Xen remembers the page address so it can patch it)

If you load each driver, do you run this multiple times, or does the 
first driver run this once and the others reuse the same pages?

>
>> Note that it would still be interesting to have the guest call the
>> kernel, so it can kick the host kernel Xen netback driver directly
>> instead of going through qemu (and the userspace netback + tap).
>
> With the current codebase netback isn't involved at all.  Backend 
> lives in qemu like virtio-net.  It is a very simple one (no GSO 
> support, ...), there are tons of opportunities for optimizations.  
> Don't feel like tackeling that right now though.  My patch queue is 
> already deep enougth as-is.  Also as time passes the qemu network 
> layer tweaks for virtio-net should make that job easier ;)

Sure, but later on, we may want to take advantage of kernel netback.  Of 
course we'll want to keep qemu netback as well, since it's much simpler 
and can be used unprivileged.

-- 
error compiling committee.c: too many arguments to function

