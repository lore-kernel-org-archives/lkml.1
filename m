Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZIBP7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZIBP7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 11:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZIBP7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 11:59:09 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52179 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZIBP7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 11:59:08 -0400
Date: Wed, 2 Sep 2009 08:19:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tree rcu: call_rcu scalability problem?
Message-ID: <20090902151927.GA6774@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090902094835.GB12251@wotan.suse.de> <20090902122756.GC12251@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902122756.GC12251@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 02:27:56PM +0200, Nick Piggin wrote:
> On Wed, Sep 02, 2009 at 11:48:35AM +0200, Nick Piggin wrote:
> > Hi Paul,
> > 
> > I'm testing out scalability of some vfs code paths, and I'm seeing
> > a problem with call_rcu. This is a 2s8c opteron system, so nothing
> > crazy.
> > 
> > I'll show you the profile results for 1-8 threads:
> > 
> > 1:
> >  29768 total                                      0.0076
> >  15550 default_idle                              48.5938
> >   1340 __d_lookup                                 3.6413
> >    954 __link_path_walk                           0.2559
> >    816 system_call_after_swapgs                   8.0792
> >    680 kmem_cache_alloc                           1.4167
> >    669 dput                                       1.1946
> >    591 __call_rcu                                 2.0521
> > 
> > 2:
> >  56733 total                                      0.0145
> >  20074 default_idle                              62.7313
> >   3075 __call_rcu                                10.6771
> >   2650 __d_lookup                                 7.2011
> >   2019 dput                                       3.6054
> > 
> > 4:
> >  98889 total                                      0.0253
> >  21759 default_idle                              67.9969
> >  10994 __call_rcu                                38.1736
> >   5185 __d_lookup                                14.0897
> >   4475 dput                                       7.9911

Four threads runs on one socket but 8 threads runs on two sockets,
I take it?

> > 8:
> > 170391 total                                      0.0437
> >  31815 __call_rcu                               110.4688
> >  12958 dput                                      23.1393
> >  10417 __d_lookup                                28.3071
> > 
> > Of course there are other scalability factors involved too, but
> > __call_rcu is taking 54 times more CPU to do 8 times the amount
> > of work from 1-8 threads, or a factor of 6.7 slowdown.
> > 
> > This is with tree RCU.
> 
> It seems like nearly 2/3 of the cost is here:
>         /* Add the callback to our list. */
>         *rdp->nxttail[RCU_NEXT_TAIL] = head; <<<
>         rdp->nxttail[RCU_NEXT_TAIL] = &head->next;

Hmmm...  That certainly is not the first list of code in call_rcu() that
would come to mind...

> In loading the pointer to the next tail pointer. If I'm reading the profile
> correctly. Can't see why that should be a probem though...

The usual diagnosis would be false sharing.

Hmmm...  What is the workload?  CPU-bound?  If CONFIG_PREEMPT=n, I might
expect interference from force_quiescent_state(), except that it should
run only every few clock ticks.  So this seems quite unlikely.

Could you please try padding the beginning and end of struct rcu_data
with a few hundred bytes and rerunning?  Just in case there is a shared
per-CPU variable either before or after rcu_data in your memory layout?

							Thanx, Paul

> ffffffff8107dee0 <__call_rcu>: /* __call_rcu total: 320971 100.000 */
>    697  0.2172 :ffffffff8107dee0:       push   %r12
>    228  0.0710 :ffffffff8107dee2:       push   %rbp
>    133  0.0414 :ffffffff8107dee3:       mov    %rdx,%rbp
>    918  0.2860 :ffffffff8107dee6:       push   %rbx
>    316  0.0985 :ffffffff8107dee7:       mov    %rsi,0x8(%rdi)
>    257  0.0801 :ffffffff8107deeb:       movq   $0x0,(%rdi)
>   1660  0.5172 :ffffffff8107def2:       mfence
>  27730  8.6394 :ffffffff8107def5:       pushfq
>  13153  4.0979 :ffffffff8107def6:       pop    %r12
>    903  0.2813 :ffffffff8107def8:       cli
>   2562  0.7982 :ffffffff8107def9:       mov    %gs:0xde68,%eax
>   1784  0.5558 :ffffffff8107df01:       cltq
>                :ffffffff8107df03:       mov    0x60(%rdx,%rax,8),%rbx
>                :ffffffff8107df08:       pushfq
>   3494  1.0886 :ffffffff8107df09:       pop    %rdx
>    896  0.2792 :ffffffff8107df0a:       cli
>   2655  0.8272 :ffffffff8107df0b:       mov    0xd0(%rbp),%rcx
>   1800  0.5608 :ffffffff8107df12:       cmp    (%rbx),%rcx
>     21  0.0065 :ffffffff8107df15:       je     ffffffff8107df32 <__call_rcu+0x52
>                :ffffffff8107df17:       mov    0x40(%rbx),%rax
>     81  0.0252 :ffffffff8107df1b:       mov    %rcx,(%rbx)
>      3 9.3e-04 :ffffffff8107df1e:       mov    %rax,0x38(%rbx)
>                :ffffffff8107df22:       mov    0x48(%rbx),%rax
>                :ffffffff8107df26:       mov    %rax,0x40(%rbx)
>                :ffffffff8107df2a:       mov    0x50(%rbx),%rax
>                :ffffffff8107df2e:       mov    %rax,0x48(%rbx)
>                :ffffffff8107df32:       push   %rdx
>   1194  0.3720 :ffffffff8107df33:       popfq
>   9518  2.9654 :ffffffff8107df34:       pushfq
>   4179  1.3020 :ffffffff8107df35:       pop    %rdx
>   1277  0.3979 :ffffffff8107df36:       cli
>   2546  0.7932 :ffffffff8107df37:       mov    0xc8(%rbp),%rax
>   1748  0.5446 :ffffffff8107df3e:       cmp    %rax,0x8(%rbx)
>      5  0.0016 :ffffffff8107df42:       je     ffffffff8107df57 <__call_rcu+0x77
>                :ffffffff8107df44:       movb   $0x1,0x19(%rbx)
>      2 6.2e-04 :ffffffff8107df48:       movb   $0x0,0x18(%rbx)
>                :ffffffff8107df4c:       mov    0xc8(%rbp),%rax
>                :ffffffff8107df53:       mov    %rax,0x8(%rbx)
>    921  0.2869 :ffffffff8107df57:       push   %rdx
>    151  0.0470 :ffffffff8107df58:       popfq
> 183507 57.1725 :ffffffff8107df59:       mov    0x50(%rbx),%rax
>    995  0.3100 :ffffffff8107df5d:       mov    %rdi,(%rax)
>      2 6.2e-04 :ffffffff8107df60:       mov    %rdi,0x50(%rbx)
>     18  0.0056 :ffffffff8107df64:       mov    0xd0(%rbp),%rdx
>    940  0.2929 :ffffffff8107df6b:       mov    0xc8(%rbp),%rax
>     15  0.0047 :ffffffff8107df72:       cmp    %rax,%rdx
>      1 3.1e-04 :ffffffff8107df75:       je     ffffffff8107dfb0 <__call_rcu+0xd0
>    787  0.2452 :ffffffff8107df77:       mov    0x58(%rbx),%rax
>     58  0.0181 :ffffffff8107df7b:       inc    %rax
>      2 6.2e-04 :ffffffff8107df7e:       mov    %rax,0x58(%rbx)
>   1679  0.5231 :ffffffff8107df82:       movslq 0x4988fb(%rip),%rdx        # ffff
>     40  0.0125 :ffffffff8107df89:       cmp    %rdx,%rax
>      5  0.0016 :ffffffff8107df8c:       jg     ffffffff8107dfd7 <__call_rcu+0xf7
>    588  0.1832 :ffffffff8107df8e:       mov    0xe0(%rbp),%rdx
>     84  0.0262 :ffffffff8107df95:       mov    0x51f924(%rip),%rax        # ffff
>      5  0.0016 :ffffffff8107df9c:       cmp    %rax,%rdx
>    505  0.1573 :ffffffff8107df9f:       js     ffffffff8107dfc8 <__call_rcu+0xe8
>  17580  5.4771 :ffffffff8107dfa1:       push   %r12
>   1671  0.5206 :ffffffff8107dfa3:       popfq
>  24201  7.5399 :ffffffff8107dfa4:       pop    %rbx
>   1367  0.4259 :ffffffff8107dfa5:       pop    %rbp
>    377  0.1175 :ffffffff8107dfa6:       pop    %r12
>                :ffffffff8107dfa8:       retq
>                :ffffffff8107dfa9:       nopl   0x0(%rax)
>                :ffffffff8107dfb0:       mov    %rbp,%rdi
>                :ffffffff8107dfb3:       callq  ffffffff813be930 <_spin_lock_irqs
>     12  0.0037 :ffffffff8107dfb8:       mov    %rbp,%rdi
>                :ffffffff8107dfbb:       mov    %rax,%rsi
>                :ffffffff8107dfbe:       callq  ffffffff8107d8e0 <rcu_start_gp>
>                :ffffffff8107dfc3:       jmp    ffffffff8107df77 <__call_rcu+0x97
>                :ffffffff8107dfc5:       nopl   (%rax)
>                :ffffffff8107dfc8:       mov    $0x1,%esi
>     10  0.0031 :ffffffff8107dfcd:       mov    %rbp,%rdi
>                :ffffffff8107dfd0:       callq  ffffffff8107dd50 <force_quiescent
>      1 3.1e-04 :ffffffff8107dfd5:       jmp    ffffffff8107dfa1 <__call_rcu+0xc1
>    451  0.1405 :ffffffff8107dfd7:       mov    $0x7fffffffffffffff,%rdx
>    411  0.1280 :ffffffff8107dfe1:       xor    %esi,%esi
>                :ffffffff8107dfe3:       mov    %rbp,%rdi
>                :ffffffff8107dfe6:       mov    %rdx,0x60(%rbx)
>    317  0.0988 :ffffffff8107dfea:       callq  ffffffff8107dd50 <force_quiescent
>   4510  1.4051 :ffffffff8107dfef:       jmp    ffffffff8107dfa1 <__call_rcu+0xc1
>                :ffffffff8107dff1:       nopw   %cs:0x0(%rax,%rax,1)
> 
> 
