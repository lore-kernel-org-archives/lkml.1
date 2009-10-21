Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZJUUYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZJUUYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbZJUUYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:24:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbZJUUYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:24:11 -0400
Date: Wed, 21 Oct 2009 16:22:31 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: XFS stack overhead
Message-ID: <20091021162231.0238a79c@katamari.usersys.redhat.com>
In-Reply-To: <4ADF5F52.10508@redhat.com>
References: <20091015183540.GA8098@redhat.com>
	<20091015190720.GA19467@elte.hu>
	<4ADF2DAA.9030604@redhat.com>
	<20091021110053.26ab9982@infradead.org>
	<4ADF59F8.7010205@redhat.com>
	<20091021191648.GA12259@elte.hu>
	<4ADF5F52.10508@redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 14:21:54 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> > Also, the posting apparently mixes 'stack overhead' with 'runtime 
> > overhead'.
> 
> right, that's why I asked, I'm not sure if stackprotector has runtime
> overhead as well.
> 

A bigger stack causes runtime overhead too because it increases the cache
footprint of the workload.

For the function I looked at the insn overhead was substantial:

On entry:
ffffffff8113ffa0:       48 83 ec 10             sub    $0x10,%rsp
...
ffffffff8113ffa9:       65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
ffffffff8113ffb0:       00 00
ffffffff8113ffb2:       48 89 45 f8             mov    %rax,-0x8(%rbp)

On exit:
ffffffff81140000:       48 8b 55 f8             mov    -0x8(%rbp),%rdx
ffffffff81140004:       65 48 33 14 25 28 00    xor    %gs:0x28,%rdx
ffffffff8114000b:       00 00
ffffffff8114000d:       74 13                   je     ffffffff81140022 <mem_cgroup_get_reclaim_stat_from_page+0x86>
...
ffffffff8114001d:       e8 ef 42 f2 ff          callq  ffffffff81064311 <__stack_chk_fail>

So that's 37 extra bytes of code: 1 subtract, 4 reg/mem moves, an xor
and a conditional jump that always get executed -- on every function
call.

And all that, in this case, for a function that doesn't even have any
on-stack variables and can hardly be expected to be vulnerable to
stack-smashing attacks.
