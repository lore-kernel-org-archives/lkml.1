Return-Path: <linux-kernel-owner+w=401wt.eu-S934688AbXJPXzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934688AbXJPXzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761072AbXJPXyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:54:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:31202 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761034AbXJPXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=mrqJ5xkHOcV1z69uz3zDcjtRsnV8PfjV1WmrmBEaA9Dz6ohFgixytKh5eWl0eUjaS44JuF7bLULrd/WWPSmCO1tFnFMohP38TV7b+Mgl4pBpQhmZJbO8uvVvwPFFt05kLotvy91NFJV4sJFocD9vaZthScK5NMYH2dDd2cAmvI8=
Message-ID: <47154E62.5010003@googlemail.com>
Date: Wed, 17 Oct 2007 01:50:58 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler updates for v2.6.24
References: <20071015141723.GA29486@elte.hu>	 <20071015113527.6bf91baf.akpm@linux-foundation.org>	 <20071015185307.GA26763@elte.hu> <4715378A.4050806@googlemail.com> <b647ffbd0710161631s9fdfe25h1daea8b88fad1fec@mail.gmail.com>
In-Reply-To: <b647ffbd0710161631s9fdfe25h1daea8b88fad1fec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> [ cc'ed Srivatsa ]
> 
> On 17/10/2007, Gabriel C <nix.or.die@googlemail.com> wrote:
>> Ingo Molnar wrote:
>> [15692.917111] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000044
>> ...
>> [15692.917629] EFLAGS: 00010046   (2.6.23-g65a6ec0d #330)
>> [15692.917661] EIP is at pick_next_task_fair+0x1f/0x2d
> 
> Gabriel, could you please post a disassembled code for pick_next_task_fair()?
> (objdump -d kernel/sched.o and then search for pick_next_task_fair --
> copy_and_past)

Sure here it is :

00000e49 <pick_next_task_fair>:
     e49:       53                      push   %ebx
     e4a:       31 d2                   xor    %edx,%edx
     e4c:       83 78 40 00             cmpl   $0x0,0x40(%eax)
     e50:       74 20                   je     e72 <pick_next_task_fair+0x29>
     e52:       83 c0 38                add    $0x38,%eax
     e55:       8b 50 20                mov    0x20(%eax),%edx
     e58:       31 db                   xor    %ebx,%ebx
     e5a:       85 d2                   test   %edx,%edx
     e5c:       74 0a                   je     e68 <pick_next_task_fair+0x1f>
     e5e:       8d 5a f8                lea    -0x8(%edx),%ebx
     e61:       89 da                   mov    %ebx,%edx
     e63:       e8 a9 ff ff ff          call   e11 <set_next_entity>
     e68:       8b 43 44                mov    0x44(%ebx),%eax
     e6b:       85 c0                   test   %eax,%eax
     e6d:       75 e6                   jne    e55 <pick_next_task_fair+0xc>
     e6f:       8d 53 d0                lea    -0x30(%ebx),%edx
     e72:       89 d0                   mov    %edx,%eax
     e74:       5b                      pop    %ebx
     e75:       c3                      ret


> 
> anyway, my guess is that it's :
> 
>                 se = pick_next_entity(cfs_rq);
>                 cfs_rq = group_cfs_rq(se);
> 
> 'se' _happens_ to be NULL and group_cf_rq(se) does se->my_q and
> (according to my calculations) offset(my_q) == 68 (0x44) for x86 32bit
> system with CONFIG_SCHEDSTATS=n and CONFIG_FAIR_GROUP_SCHED=y
> (according to the config).
> 
> that might take place provided put_prev_task_fair() failed for some
> reason to insert 'current' (or its corresponding group element) back
> into the tree in schedule()... say, due to some inconsistency in
> cfs_rq's data.
> 
> Srivatsa, that's somewhat similar to another issue that has been
> posted earlier today (crash in put_prev_task_fair() -->
> __enqueue_task() --> rb_insert_color()) that you are already aware of
> ...  (/me will continue tomorrow).
> 
> 
