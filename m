Return-Path: <linux-kernel-owner+w=401wt.eu-S2992865AbXCIBgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992865AbXCIBgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 20:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992868AbXCIBgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 20:36:49 -0500
Received: from smtpout.mac.com ([17.250.248.171]:55792 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992865AbXCIBgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 20:36:48 -0500
In-Reply-To: <45EFBA14.9090307@cosmosbay.com>
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com> <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org> <200703071952.13219.dada1@cosmosbay.com> <20070307221401.GA16938@kryten> <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org> <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com> <6E1C86DF-D512-418C-B270-BC5C4316BC0A@mac.com> <45EFBA14.9090307@cosmosbay.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <8638AE87-6005-4021-98EB-43E55694B0FB@mac.com>
Cc: "Michael K. Edwards" <medwards.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: 8BIT
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [patch] epoll use a single inode ...
Date: Thu, 8 Mar 2007 20:34:50 -0500
To: Eric Dumazet <dada1@cosmosbay.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 08, 2007, at 02:24:04, Eric Dumazet wrote:
> Kyle Moffett a écrit :
>> Prefetching is also fairly critical on a Power4 or G5 PowerPC  
>> system as they have a long memory latency; an L2-cache miss can  
>> cost 200+ cycles.  On such systems the "dcbt" prefetch instruction  
>> brings in a single 128-byte cacheline and has no serializing  
>> effects whatsoever, making it ideal for use in a linked-list- 
>> traversal inner loop.
>
> OK, 200 cycles...
>
> But what is the cost of the conditional branch you added in prefetch 
> (x) ?
>
> if (!x) return;
>
> (correctly predicted or not, but do powerPC have a BTB ?)

Well, PowerPC "dcbt" does prefetch() correctly, it doesn't ever raise  
exceptions, doesn't have any side effects, takes only enough CPU to  
decode the address, and is ignored if it would have to do anything  
other than load the cacheline from RAM.  Prefetch streams are halted  
when they reach the end of a page boundary (no trapping to the MMU)  
and if the TLB entry isn't present then they would asynchronously  
abort.  This is a suitable prefetch implementation for G5:

   #define prefetch(x) __asm__ __volatile__ ("dcbt 0, %0"::"r"(x));

On GCC4+ the "__builtin_prefetch" built-in functions is probably  
mildly better tuned for most architectures:

   #define PREFETCH_RD 0
   #define PREFETCH_WR 1
   #define PREFETCH_LOCALITY_NONE 0
   #define PREFETCH_LOCALITY_LOW  1
   #define PREFETCH_LOCALITY_MED  2
   #define PREFETCH_LOCALITY_HIGH 3
   #define prefetch(x, args...) __builtin_prefetch(x ,##args)

The pertinent GCC docs:
> This function is used to minimize cache-miss latency by moving data  
> into a cache before it is accessed. You can insert calls to  
> __builtin_prefetch into code for which you know addresses of data  
> in memory that is likely to be accessed soon. If the target  
> supports them, data prefetch instructions will be generated. If the  
> prefetch is done early enough before the access then the data will  
> be in the cache by the time it is accessed.
>
> The value of addr is the address of the memory to prefetch. There  
> are two optional arguments, rw and locality. The value of rw is a  
> compile-time constant one or zero; one means that the prefetch is  
> preparing for a write to the memory address and zero, the default,  
> means that the prefetch is preparing for a read. The value locality  
> must be a compile-time constant integer between zero and three. A  
> value of zero means that the data has no temporal locality, so it  
> need not be left in the cache after the access. A value of three  
> means that the data has a high degree of temporal locality and  
> should be left in all levels of cache possible. Values of one and  
> two mean, respectively, a low or moderate degree of temporal  
> locality. The default is three.
> 	for (i = 0; i < n; i++) {
> 		a[i] = a[i] + b[i];
> 		__builtin_prefetch (&a[i+j], 1, 1);
> 		__builtin_prefetch (&b[i+j], 0, 1);
> 		/* ... */
> 	}
>
> Data prefetch does not generate faults if addr is invalid, but the  
> address expression itself must be valid. For example, a prefetch of  
> p->next will not fault if p->next is not a valid address, but  
> evaluation will fault if p is not a valid address.
>
> If the target does not support data prefetch, the address  
> expression is evaluated if it includes side effects but no other  
> code is generated and GCC does not issue a warning.

Cheers,
Kyle Moffett

