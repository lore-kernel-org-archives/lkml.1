Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYHZRId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYHZRId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYHZRIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:08:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:1645 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYHZRIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UAgIORy9+5NhVuJKVIm3mHACk8Pag1dfsCclx93g33qZTuBNwejeasVZSLBNWRu2a0
         FjQfaTktQ0t7mLE/1LV1Kshcd2yCz8VfC4Yr277acXcScU0cZEG4rRYOek+twP2dD/c/
         bAbtOcLi+nl6+K0MEaTYGLFGWtborN1epgTiE=
Message-ID: <86802c440808261008t1b66d6bpe93974be5988acab@mail.gmail.com>
Date: Tue, 26 Aug 2008 10:08:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "Ingo Molnar" <mingo@elte.hu>, "David Miller" <davem@davemloft.net>,
       Alan.Brunelle@hp.com, travis@sgi.com, tglx@linutronix.de, rjw@sisk.pl,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, arjan@linux.intel.com,
       rusty@rustcorp.com.au
In-Reply-To: <alpine.LFD.1.10.0808260939070.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org>
	 <20080826072220.GB31876@elte.hu>
	 <20080826.004607.253712060.davem@davemloft.net>
	 <20080826075355.GA7596@elte.hu>
	 <86802c440808260136t3a33a9c8if53b6f70ab9df9e2@mail.gmail.com>
	 <alpine.LFD.1.10.0808260939070.3363@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 9:51 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 26 Aug 2008, Yinghai Lu wrote:
>>
>> wonder if could use "unsigned long *" directly.
>
> I would actually suggest something like this:
>
>  - we continue to have a magic "cpumask_t".
>
>  - we do different cases for big and small NR_CPUS:
>
>        #if NR_CPUS <= BITS_PER_LONG
>
>        /*
>         * Make it an array - that way passing it as an argument will
>         * always pass it as a pointer!
>         */
>        typedef unsigned long cpumask_t[1];
>
>        static inline void create_cpumask(cpumask_t *p)
>        {
>                *p = 0;
>        }
>        static inline void free_cpumask(cpumask_t *p)
>        {
>        }
>
>        #else
>
>        typedef unsigned long *cpumask_t;
>
>        static inline void create_cpumask(cpumask_t *p)
>        {
>                *p = kcalloc(..);
>        }
>
>        static inline void free_cpumask(cpumask_t *p)
>        {
>                kfree(*p);
>        }
>
>        #endif
>
> and now after you do this, you can just do something like
>
>        cpumask_t mycpu;
>
>        create_cpumask(&mycpu);
>        ..
>        free_cpumask(&mycpu);
>
> and in between, you can use 'cpumask' as a pointer, because even when it
> is an array directly allocated on the stack, the array can always
> degenerate into a pointer by C type rules!
>

that is good for local variables.

for global variables, need to allocate them in some point. may need one
int cpumask_size;

cpumask_t online_cpu_map;
DEFINE_DYN_ARRAY(online_cpu_map, sizeof(unsigned long), cpumask_size,
PAGE_SIZE, NULL);

or something like that.

YH
