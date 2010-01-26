Return-Path: <linux-kernel-owner+w=401wt.eu-S1753660Ab0AZCdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0AZCdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653Ab0AZCdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:33:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60458 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0AZCdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:33:31 -0500
Date: Tue, 26 Jan 2010 02:32:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, ebiederm@xmission.com, tytso@mit.edu,
       Trond.Myklebust@netapp.com, aelder@sgi.com, hch@infradead.org,
       davem@davemloft.net, netdev@vger.kernel.org, x86@kernel.org,
       mingo@redhat.com, dan.j.williams@intel.com, borislav.petkov@amd.com,
       ying.huang@intel.com, lenb@kernel.org, neilb@suse.de,
       cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to
	hw_breakpoint
Message-ID: <20100126023238.GC19799@ZenIV.linux.org.uk>
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E3F2C.2010702@zytor.com> <4B5E4E12.7060900@kernel.org> <20100126020452.GB19799@ZenIV.linux.org.uk> <4B5E508A.1030305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E508A.1030305@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 11:16:42AM +0900, Tejun Heo wrote:

> # define RELOC_HIDE(ptr, off)					\
>   ({ unsigned long __ptr;					\
>      __ptr = (unsigned long) (ptr);				\
>     (typeof(ptr)) (__ptr + (off)); })
> 
> #define __verify_pcpu_ptr(ptr)	do {					\
> 	const void __percpu *__vpp_verify = (typeof(ptr))NULL;		\
> 	(void)__vpp_verify;						\
> } while (0)
> 
> /* Weird cast keeps both GCC and sparse happy. */
> #define SHIFT_PERCPU_PTR(__p, __offset)	({				\
> 	__verify_pcpu_ptr((__p));					\
> 	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
> })
> 
> #define per_cpu(var, cpu) \
> 	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))

Eh...  You are leaving that noderef in place in case of array.  And _that_
is not an address space, so casts to AS 0 won't do you any good.
