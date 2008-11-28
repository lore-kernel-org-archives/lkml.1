Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYK1Jek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYK1Jek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYK1Je2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:34:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44707 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbYK1Je1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:34:27 -0500
Date: Fri, 28 Nov 2008 09:34:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, rth@twiddle.net,
       ink@jurassic.park.msu.ru
Subject: Re: [PATCH 6/6] fs: Introduce kern_mount_special() to mount
	special vfs
Message-ID: <20081128093419.GM28946@ZenIV.linux.org.uk>
References: <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDCAB.1070204@cosmosbay.com> <20081128092604.GL28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128092604.GL28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 09:26:04AM +0000, Al Viro wrote:

gyah...  That would be

> static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
> {
> 	unsigned long temp, res;
> 	__asm__ __volatile__(
> 	"1:     ldl_l %0,%1\n"
> 	"       cmpne %0,%4,%2\n"
 	"       beq %2,3f\n"
 	"       addl %0,%3,%2\n"
> 	"       stl_c %2,%1\n"
> 	"       beq %2,2f\n"
> 	"3:\n"
>         ".subsection 2\n"
>         "2:     br 1b\n"
>         ".previous"
>         :"=&r" (temp), "=m" (v->counter), "=&r" (res)
>         :"Ir" (a), "Ir" (u), "m" (v->counter) : "memory");
> 	smp_mb();
> 	return res;
> }
> 
> static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
> {
> 	unsigned long temp, res;
> 	__asm__ __volatile__(
> 	"1:     ldq_l %0,%1\n"
> 	"       cmpne %0,%4,%2\n"
 	"       beq %2,3f\n"
 	"       addq %0,%3,%2\n"
> 	"       stq_c %2,%1\n"
> 	"       beq %2,2f\n"
> 	"3:\n"
>         ".subsection 2\n"
>         "2:     br 1b\n"
>         ".previous"
>         :"=&r" (temp), "=m" (v->counter), "=&r" (res)
>         :"Ir" (a), "Ir" (u), "m" (v->counter) : "memory");
> 	smp_mb();
> 	return res;
> }
> 
> Comments?
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
