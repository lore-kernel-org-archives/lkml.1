Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098Ab0AZCWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0AZCWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279Ab0AZCWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:22:17 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54415 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0AZCWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bJ73exKwjB9iY0pFPb/EPBKGbBuIaIKYQ1/b7h4xi6pLdxqmox2bRrm7Vw2e+ZIZe6
         YuUqODwMDHEp07F32c910tFWp/vdxicDbj1B7/jgSduGHF+0ULoMEDUcyAeYiGaVkI5G
         onYELpv/S6xp8CCA30vOjrfKENarhor9z9ueU=
Date: Tue, 26 Jan 2010 03:22:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
       x86@kernel.org, mingo@redhat.com, dan.j.williams@intel.com,
       borislav.petkov@amd.com, ying.huang@intel.com, lenb@kernel.org,
       neilb@suse.de, cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to
	hw_breakpoint
Message-ID: <20100126022211.GP5087@nowhere>
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E3BED.6030705@kernel.org> <20100126010239.GK5087@nowhere> <4B5E4308.8020105@kernel.org> <20100126020113.GM5087@nowhere> <4B5E4FE7.30700@kernel.org> <20100126021846.GO5087@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126021846.GO5087@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 03:18:48AM +0100, Frederic Weisbecker wrote:
> On Tue, Jan 26, 2010 at 11:13:59AM +0900, Tejun Heo wrote:
> > Hello,
> > 
> > On 01/26/2010 11:01 AM, Frederic Weisbecker wrote:
> > > So, may be it considers you are applying the address space overriding
> > > to the pointer to the type and not to the type itself.
> > > 
> > > Consider:
> > > 
> > > 	int __percpu i;
> > > 
> > > What you do above *might* be considered as if SHIFT_PERCPU_PTR
> > > returns something of a type:
> > > 
> > > 	int * __percpu i;
> > > 
> > > So the pointer is in the normal address space, but its content is in
> > > __percpu address space.
> > > 
> > > What if you do this:
> > > 
> > > 
> > > #define SHIFT_PERCPU_PTR(__p, __offset)      ({                      \
> > >       __verify_pcpu_ptr((__p));                                       \
> > >       RELOC_HIDE((__p), (__offset)); \
> > > })
> > > 
> > > #define per_cpu(var, cpu) \
> > >       (typeof(var) __kernel __force)(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
> > 
> > arch/x86/kernel/cpu/common.c:1149:20: warning: cast to non-scalar
> > arch/x86/kernel/cpu/common.c:1149:20: error: strange non-value function or array
> >   CC      arch/x86/kernel/cpu/common.o
> > arch/x86/kernel/cpu/common.c: In function 'cpu_init':
> > arch/x86/kernel/cpu/common.c:1149: error: cast specifies array type
> > 
> > Can't cast that way.  :-(
> 
> 
> What about this? It doesn't use direct cast to scalar but should
> create a pointer type to kernel space datas:
> 
> 
> #define kernel_space_t(var)	\
> 	(typeof(var)	__kernel __force)


Should be typeof(*var)



> 
> #define SHIFT_PERCPU_PTR(__p, __offset) ({                              \
>         __verify_pcpu_ptr((__p));                                       \
>         RELOC_HIDE((typeof(*(kernel_space_t(var)) __kernel __force *)(__p), (__offset)); \
> })
> 
> #define per_cpu(var, cpu) \
>         (*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
> 

