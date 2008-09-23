Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYIWIuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYIWIuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 04:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYIWIuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 04:50:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52790 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYIWIuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 04:50:44 -0400
Date: Tue, 23 Sep 2008 10:50:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -tip 0/4] x86: signal handler improvement
Message-ID: <20080923085027.GA25698@elte.hu>
References: <48D84A2A.2030009@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D84A2A.2030009@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> This patch series is experimental.
> I made it against tip/master.
> 
> I noticed there are inefficient codes in x86 signals.
> For example, disassembled 32-bit setup_sigcontext();
> 
> 0000007c <setup_sigcontext>:
>   7c:	55                   	push   %ebp
>   7d:	89 e5                	mov    %esp,%ebp
>   7f:	57                   	push   %edi
>   80:	31 ff                	xor    %edi,%edi
>   82:	56                   	push   %esi
>   83:	89 c6                	mov    %eax,%esi
>   85:	53                   	push   %ebx
>   86:	83 ec 58             	sub    $0x58,%esp
>   89:	89 55 a4             	mov    %edx,-0x5c(%ebp)
>   8c:	89 fa                	mov    %edi,%edx
>   8e:	8b 41 24             	mov    0x24(%ecx),%eax
>   91:	89 46 04             	mov    %eax,0x4(%esi)
>   94:	89 55 a8             	mov    %edx,-0x58(%ebp)
> ...
>  184:	8b 5d ac             	mov    -0x54(%ebp),%ebx
>  187:	0b 5d a8             	or     -0x58(%ebp),%ebx
>  18a:	0b 5d b0             	or     -0x50(%ebp),%ebx
>  18d:	0b 5d b4             	or     -0x4c(%ebp),%ebx
>  190:	0b 5d b8             	or     -0x48(%ebp),%ebx
>  193:	0b 5d bc             	or     -0x44(%ebp),%ebx
>  196:	0b 5d c0             	or     -0x40(%ebp),%ebx
>  199:	0b 5d c4             	or     -0x3c(%ebp),%ebx
>  19c:	0b 5d c8             	or     -0x38(%ebp),%ebx
>  19f:	0b 5d cc             	or     -0x34(%ebp),%ebx
>  1a2:	0b 5d d0             	or     -0x30(%ebp),%ebx
>  1a5:	0b 5d d4             	or     -0x2c(%ebp),%ebx
>  1a8:	0b 5d d8             	or     -0x28(%ebp),%ebx
>  1ab:	0b 5d dc             	or     -0x24(%ebp),%ebx
>  1ae:	0b 5d e0             	or     -0x20(%ebp),%ebx
>  1b1:	0b 5d e4             	or     -0x1c(%ebp),%ebx
>  1b4:	0b 5d e8             	or     -0x18(%ebp),%ebx
>  1b7:	0b 5d ec             	or     -0x14(%ebp),%ebx
>  1ba:	0b 5d f0             	or     -0x10(%ebp),%ebx
>  1bd:	09 fb                	or     %edi,%ebx
> ...
>  1dc:	09 d8                	or     %ebx,%eax
>  1de:	5b                   	pop    %ebx
>  1df:	09 c8                	or     %ecx,%eax
>  1e1:	5e                   	pop    %esi
>  1e2:	5f                   	pop    %edi
>  1e3:	5d                   	pop    %ebp
>  1e4:	c3                   	ret    
> 
> there is a lot of "or" operation with stack, and it came from a set of
> following lines;
> 
> err |= __put_user(x, ptr);
> 
> The above line compiled to like this;
>   a0:	89 fa                	mov    %edi,%edx
>   a2:	8b 41 20             	mov    0x20(%ecx),%eax
>   a5:	89 46 08             	mov    %eax,0x8(%esi)
>   a8:	89 55 b0             	mov    %edx,-0x50(%ebp)
> 
> and errors in __put_user is stored to stack. At the end of function, 
> all errors in stack are calculated. If access to user space is failed, 
> %edx is set to -EFAULT in exception handler and stored to stack for 
> later operation. It seems inefficient.

yes, very much! Years ago i tried years to improve it but didnt think of 
your solution back then.

> This patch series introduce __{put|get}_user_cerr for cumulative error
> handling. So, the line;
> err |= __put_user(x, ptr);
> changes to
> __put_user_cerr(x, ptr, err);
> 
> and it compiled to like this;
>   92:	8b 41 20             	mov    0x20(%ecx),%eax
>   95:	89 47 08             	mov    %eax,0x8(%edi)
> 
> The cumulative error is kept in the other register, in this example,
> %esi is used for this, and returns it. If access to user space causes fault,
> %esi is set to the value (%esi | -EFAULT) in exception handler.
> 
>  137:	89 f0                	mov    %esi,%eax
>  139:	5b                   	pop    %ebx
>  13a:	5e                   	pop    %esi
>  13b:	5f                   	pop    %edi
>  13c:	5d                   	pop    %ebp
>  13d:	c3                   	ret    
> 
> The results of this, I got a little performance improvement in signal
> handling. Here is a result of lmbench.
> I've tried 64-bit only at this time. Will measure on 32-bit.
> 
> Processor, Processes - times in microseconds - smaller is better
> ------------------------------------------------------------------------------
> Host                 OS  Mhz null null      open slct sig  sig  fork exec sh
>                              call  I/O stat clos TCP  inst hndl proc proc proc
> --------- ------------- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
> tip64-sig Linux 2.6.27- 3788 0.17 0.27 1.67 2.65 3.20 0.32 2.97 180. 524. 1806
> tip64-sig Linux 2.6.27- 3788 0.17 0.27 1.68 2.65 3.20 0.32 2.95 180. 520. 1796
> tip64-sig Linux 2.6.27- 3788 0.17 0.27 1.68 2.72 3.21 0.32 2.96 177. 528. 1812
> tip64     Linux 2.6.27- 3788 0.17 0.27 1.68 2.74 3.22 0.32 3.01 174. 523. 1853
> tip64     Linux 2.6.27- 3788 0.17 0.27 1.68 2.73 3.22 0.32 3.01 175. 523. 1806
> tip64     Linux 2.6.27- 3788 0.17 0.27 1.68 2.74 3.20 0.32 3.01 181. 523. 1791
> 
> This patch series also reduces stack usages and code size.
> 
> $ size signal_*
>    text	   data	    bss	    dec	    hex	filename
>    4507	      0	      0	   4507	   119b	signal_32.o.new
>    5031	      0	      0	   5031	   13a7	signal_32.o.old
>    3827	      0	      0	   3827	    ef3	signal_64.o.new
>    4652	      0	      0	   4652	   122c	signal_64.o.old
> 
> Comments are welcome.
> I'll handle this patch series if it's good.

very nice!!

could we perhaps first finish unifying them into signal.c, and then 
introduce __put_user_cerr() in signal_32/64.c?

Or we could put your patches into tip/x86/signal as-is if you expect to 
finish the unification in the near future.

	Ingo
