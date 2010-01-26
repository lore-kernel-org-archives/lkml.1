Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248Ab0AZCBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0AZCBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177Ab0AZCBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:01:21 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51623 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0AZCBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:01:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u1vunaFef3kfPcR4byT2qZEfYa2JnLE9bpo1MOduGDsCOoBF2/AA3+gj4bFfkQR3XD
         rkInkOL5HYLkumn8tOhXdi6PNaJSaOypddaf5fk9evb0VAOe0niqgLKuSPldx24JGfMj
         kUkRmXgSfoiNLYPs4YCGWXnAaxkGdNUG/gbDU=
Date: Tue, 26 Jan 2010 03:01:14 +0100
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
Message-ID: <20100126020113.GM5087@nowhere>
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E3BED.6030705@kernel.org> <20100126010239.GK5087@nowhere> <4B5E4308.8020105@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E4308.8020105@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 10:19:04AM +0900, Tejun Heo wrote:
> Hello,
> 
> On 01/26/2010 10:02 AM, Frederic Weisbecker wrote:
> > Well, sorry I must be missing something obvious, but is it impossible
> > to make per_cpu(var, cpu) returning something cast in:
> > 
> > 	(typeof(var) __force)
> > 
> > Or I guess you did that already and it is not working with static
> > arrays, or?
> 
> Yeap, the definition looks like
> 
>  #define SHIFT_PERCPU_PTR(__p, __offset)	({			\
> 	__verify_pcpu_ptr((__p));					\
> 	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
>  })
> 
>  #define per_cpu(var, cpu) \
> 	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
> 
> but it just ends up putting the __force at the wrong layer.  It seems
> that (typeof(var) __kernel __force) tell sparse var is in the kernel
> address space but not its members.


So, may be it considers you are applying the address space overriding
to the pointer to the type and not to the type itself.

Consider:

	int __percpu i;

What you do above *might* be considered as if SHIFT_PERCPU_PTR
returns something of a type:

	int * __percpu i;

So the pointer is in the normal address space, but its content is in
__percpu address space.

What if you do this:


#define SHIFT_PERCPU_PTR(__p, __offset)      ({                      \
      __verify_pcpu_ptr((__p));                                       \
      RELOC_HIDE((__p), (__offset)); \
})

#define per_cpu(var, cpu) \
      (typeof(var) __kernel __force)(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))

This should work because &(var) should be dereferencable directly, since
it is not of type "__force t" but of type "*__force t"

And you're not doing anymore this:

	*(int * __kernel __force) i;
but
	*(int __kernel __force *) i;


That all might make no sense, I'm just trying to think like a backend
so it might sound like I should just take more sleep and just shut up...

