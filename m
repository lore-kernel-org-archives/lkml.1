Return-Path: <linux-kernel-owner+w=401wt.eu-S966051AbXJPXbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966051AbXJPXbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbXJPXbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:31:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:20387 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbXJPXbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:31:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XJDClVfpIR8re9n1lY6yn2cKksySduWd12o5beLkQrY+Bo/ggKgbjBs/EWjbasbvMr+2SekSrDFjmD5wwGuUPg8iWhVptHoz7UmqsmO3MDW119c9dkzgkSlVmEyhn/vx5CTQ8XoNoS3JvtvJ0GLeZelCSqEtameaG7pGpZrQuzU=
Message-ID: <b647ffbd0710161631s9fdfe25h1daea8b88fad1fec@mail.gmail.com>
Date: Wed, 17 Oct 2007 01:31:22 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>
Subject: Re: [git pull] scheduler updates for v2.6.24
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4715378A.4050806@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071015141723.GA29486@elte.hu>
	 <20071015113527.6bf91baf.akpm@linux-foundation.org>
	 <20071015185307.GA26763@elte.hu> <4715378A.4050806@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ cc'ed Srivatsa ]

On 17/10/2007, Gabriel C <nix.or.die@googlemail.com> wrote:
> Ingo Molnar wrote:
> [15692.917111] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000044
> ...
> [15692.917629] EFLAGS: 00010046   (2.6.23-g65a6ec0d #330)
> [15692.917661] EIP is at pick_next_task_fair+0x1f/0x2d

Gabriel, could you please post a disassembled code for pick_next_task_fair()?
(objdump -d kernel/sched.o and then search for pick_next_task_fair --
copy_and_past)

anyway, my guess is that it's :

                se = pick_next_entity(cfs_rq);
                cfs_rq = group_cfs_rq(se);

'se' _happens_ to be NULL and group_cf_rq(se) does se->my_q and
(according to my calculations) offset(my_q) == 68 (0x44) for x86 32bit
system with CONFIG_SCHEDSTATS=n and CONFIG_FAIR_GROUP_SCHED=y
(according to the config).

that might take place provided put_prev_task_fair() failed for some
reason to insert 'current' (or its corresponding group element) back
into the tree in schedule()... say, due to some inconsistency in
cfs_rq's data.

Srivatsa, that's somewhat similar to another issue that has been
posted earlier today (crash in put_prev_task_fair() -->
__enqueue_task() --> rb_insert_color()) that you are already aware of
...  (/me will continue tomorrow).


-- 
Best regards,
Dmitry Adamushko
