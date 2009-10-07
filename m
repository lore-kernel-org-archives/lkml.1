Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbZJGQf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbZJGQf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759579AbZJGQf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:35:28 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:46152 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759576AbZJGQf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:35:27 -0400
Date: Wed, 7 Oct 2009 18:35:22 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] Re: [PATCH] xen: Disable stack protector for irq
	helper
Message-ID: <20091007163521.GA17998@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Ingo Molnar <mingo@redhat.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Stable Kernel <stable@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Xen-devel <xen-devel@lists.xensource.com>
References: <20091004183013.GA26101@wavehammer.waldi.eu.org> <4AC92A65.40806@goop.org> <20091005013517.GA6081@wavehammer.waldi.eu.org> <4ACA2AFD.4080305@goop.org> <20091005224310.GA32144@wavehammer.waldi.eu.org> <4ACA90F2.1060909@goop.org> <20091006033050.GA6332@wavehammer.waldi.eu.org> <4ACB93F8.5010900@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4ACB93F8.5010900@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 12:01:12PM -0700, Jeremy Fitzhardinge wrote:
> On 10/05/09 20:30, Bastian Blank wrote:
> > The original version saves ecx, but not edx. Both are official
> > caller-saved registers.
> Hm.  It doesn't save edx because that can be half of a 64-bit return
> value, and in general both eax and edx are marked clobbered.

Then it will be also wrong for functions returning void. They may
clobber eax but never set it to something correct.

>                                                               Except one
> place; does the patch below help?

Don't you need to remove the complete wrapper setup to get a correct
result? (And type safety.)

> > Well, my call stack say something different. It crashs during early
> > startup without a console. The modifications to the function pointers is
> > done much later.
> You're right.  But you're holding out on me; can I see your backtrace? 

Well, I'm traveling and it needs some time to recreate a broken kernel.

> And the disassembly of the troublesome code (both the Xen function and
> the calling function)?

That is easy.

| c12dc725 <_spin_lock_irqsave>:
| c12dc725:       83 ec 04                sub    $0x4,%esp
| c12dc728:       89 c2                   mov    %eax,%edx
| c12dc72a:       65 a1 14 00 00 00       mov    %gs:0x14,%eax
| c12dc730:       89 04 24                mov    %eax,(%esp)
| c12dc733:       31 c0                   xor    %eax,%eax
| c12dc735:       ff 15 bc 1a 3f c1       call   *0xc13f1abc
Call to pv_irq_ops.save_fl.
| c12dc73b:       89 c1                   mov    %eax,%ecx
| c12dc73d:       ff 15 c4 1a 3f c1       call   *0xc13f1ac4
| c12dc743:       b8 00 01 00 00          mov    $0x100,%eax
| c12dc748:       f0 66 0f c1 02          lock xadd %ax,(%edx)
| c12dc74d:       38 e0                   cmp    %ah,%al
| c12dc74f:       74 06                   je     c12dc757 <_spin_lock_irqsave+0x32>
| c12dc751:       f3 90                   pause  
| c12dc753:       8a 02                   mov    (%edx),%al
Try to use (clobbered) edx.
| c12dc755:       eb f6                   jmp    c12dc74d <_spin_lock_irqsave+0x28>
| c12dc757:       8b 14 24                mov    (%esp),%edx
| c12dc75a:       65 33 15 14 00 00 00    xor    %gs:0x14,%edx
| c12dc761:       89 c8                   mov    %ecx,%eax
| c12dc763:       74 05                   je     c12dc76a <_spin_lock_irqsave+0x45>
| c12dc765:       e8 28 58 d6 ff          call   c1041f92 <__stack_chk_fail>
| c12dc76a:       5a                      pop    %edx
| c12dc76b:       c3                      ret    

| c1005dbc <xen_save_fl>:
| c1005dbc:       83 ec 04                sub    $0x4,%esp
| c1005dbf:       65 a1 14 00 00 00       mov    %gs:0x14,%eax
| c1005dc5:       89 04 24                mov    %eax,(%esp)
| c1005dc8:       31 c0                   xor    %eax,%eax
| c1005dca:       64 a1 0c 70 47 c1       mov    %fs:0xc147700c,%eax
| c1005dd0:       80 78 01 00             cmpb   $0x0,0x1(%eax)
| c1005dd4:       0f 94 c0                sete   %al
| c1005dd7:       0f b6 c0                movzbl %al,%eax
| c1005dda:       f7 d8                   neg    %eax
| c1005ddc:       25 00 02 00 00          and    $0x200,%eax
| c1005de1:       8b 14 24                mov    (%esp),%edx
| c1005de4:       65 33 15 14 00 00 00    xor    %gs:0x14,%edx
| c1005deb:       74 05                   je     c1005df2 <xen_save_fl+0x36>
| c1005ded:       e8 a0 c1 03 00          call   c1041f92 <__stack_chk_fail>
| c1005df2:       5a                      pop    %edx
Clobbers edx with the old eax.
| c1005df3:       c3                      ret    

| c13f1ab8 g     O .data  0000001c pv_irq_ops


-- 
I'm frequently appalled by the low regard you Earthmen have for life.
		-- Spock, "The Galileo Seven", stardate 2822.3
