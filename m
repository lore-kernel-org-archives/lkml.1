Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbYHCNit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbYHCNit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYHCNii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:38:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58483 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbYHCNih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:38:37 -0400
Date: Sun, 3 Aug 2008 07:38:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Hong Tran Duc <hongtd2k@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Oops when read/write or mount/unmount continuously ~ 600.000 times
Message-ID: <20080803133817.GG26461@parisc-linux.org>
References: <4895A96E.2040303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4895A96E.2040303@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 07:49:50PM +0700, Hong Tran Duc wrote:
> I?m using kernel 2.4.20 with fully preemptive enable (patch & set the 
> CONFIG option). My CPU is PowerPC 750FX, HDD 80GB, RAM 512,

2.4.20 was released in November 2002; almost 6 years ago.  I don't think
you're going to find too many people interested in helping you debug
this.  If you can reproduce the problem with something more recent (say
2.6.26 or even 2.4.36.6 if you can't use 2.6 for whatever reason), then
I think people will be more interested.

> The reasons is almost linked list on those function was broken. Ex: 
> linkedlist->next linkedlist->prev = NULL or set to invalid address.
> In the situation SIGILL, the instruction pointer (NIP) is same as the 
> return address register (LR).

In later kernels, we have a list debugging option which lets you find
list corruptions earlier.

> The newest Oops, I got on function __wait_on_buffer(). The main 
> sequences of __wait_on_buffer() are:
> 1. put_bh -> atomic_inc(bh->b_count);
> 2. add wait queue
> 3. loop: do some thing task manipulation, call *schedule()*
> 4. remove wait queue
> 5. get_bh -> atomic_dec(bh->b_count); *<- Got Oops here, SEGV because 
> bh->b_count = R25 = 0x02 *
> 
> After analysis assembly code (I upload on pastebin bellow) at this 
> point, I found that:
> * At the point (1) -> address of bh->b_count stored in register r25.
> * The point from (2) ->(4) all of affect to register 25 will be restored 
> from stack (r25 act as non violent register in gcc ABI).
> * An step 5, *r25 = 0x02 ??? I don?t know why r25 is changed ? May be 
> stack on somewhere was corrupted ?*

The implementation of __wait_on_buffer has completely changed since
then.  It's probably not worth trying to debug this.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
