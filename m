Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715Ab0AZCfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0AZCfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668Ab0AZCft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:35:49 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53469 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab0AZCfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:35:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Opyha9N66pxLM0JZWJJ20g5JBmPNBrNbadho8BAxwsGVlghwI1EUpqNgdjXSC7Ig5A
         O3RPW1LnfyZIHRpV11Ndpn5HyjqJVetgIJnqSpfBF8OB3hlltIOfxSYM6wrpGdeq/49G
         xVAfURA0FyQKpO/+/UJd+7qsjZM7rpyqPM/kM=
Date: Tue, 26 Jan 2010 03:35:43 +0100
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
Message-ID: <20100126023542.GQ5087@nowhere>
References: <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E3BED.6030705@kernel.org> <20100126010239.GK5087@nowhere> <4B5E4308.8020105@kernel.org> <20100126020113.GM5087@nowhere> <4B5E4FE7.30700@kernel.org> <20100126021846.GO5087@nowhere> <20100126022211.GP5087@nowhere> <4B5E54C0.2040709@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E54C0.2040709@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 11:34:40AM +0900, Tejun Heo wrote:
> On 01/26/2010 11:22 AM, Frederic Weisbecker wrote:
> >> What about this? It doesn't use direct cast to scalar but should
> >> create a pointer type to kernel space datas:
> >>
> >>
> >> #define kernel_space_t(var)	\
> >> 	(typeof(var)	__kernel __force)
> > 
> > 
> > Should be typeof(*var)
> > 
> >>
> >> #define SHIFT_PERCPU_PTR(__p, __offset) ({                              \
> >>         __verify_pcpu_ptr((__p));                                       \
> >>         RELOC_HIDE((typeof(*(kernel_space_t(var)) __kernel __force *)(__p), (__offset)); \
> >> })
> 
> Can you balance ()'s here too?


#define kernel_space_t(var)        \
    (typeof(*(var))    __kernel __force)


/* Weird cast keeps both GCC and sparse happy. */
#define SHIFT_PERCPU_PTR(__p, __offset) ({                              \
        __verify_pcpu_ptr((__p));                                       \
        RELOC_HIDE((typeof(*(kernel_space_t(__p))) __kernel __force *)(__p), (__offset)); \
})

#define per_cpu(var, cpu) \
        (*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)));


No guarantee that will build. I should pull your tree and install
sparse (yeah, shame on me, I've never installed it).

