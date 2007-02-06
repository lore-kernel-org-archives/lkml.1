Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbXBFTqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbXBFTqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbXBFTqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:46:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:34498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbXBFTqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:46:16 -0500
From: Neil Brown <neilb@suse.de>
To: "Yu-Chen Wu" <g944370@oz.nthu.edu.tw>
Date: Wed, 7 Feb 2007 06:45:41 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17864.56037.855359.839197@notabene.brown>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
Subject: Re: Could "bio_vec" be referenced any time?
In-Reply-To: message from Yu-Chen Wu on Tuesday February 6
References: <005a01c74a01$ec1832a0$0100a8c0@sslabmayasky>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday February 6, g944370@oz.nthu.edu.tw wrote:
> Hi all,
> 	I write a module that creates a kernel thread to show the BIOs from
> MD modules.
> 	The kernel thread will call show_bio() when md passing a BIO to my
> module,else sleep.
> 	Sometimes, show_bio() continues working successfully ,but it
> somtimes makes "general protection fault".
> 	The show_bio() always works when I comment the
> "bio_for_each_segment" loop. 
> 	Is the zone I comment the cause of the fault? 
> 	As above, I consider it's the main problem.Also, I strongly want to
> know your opinions.Thank you for help.
> 
> 	THX

Without seeing how the bio gets to show_bio it is hard to be certain,
but my guess would be that by the time show_bio tries to inspect the
bio, the IO request involving it has already completed and the bio has
been freed, so you are accessing freed memory.

> Feb  6 22:00:28 RAID-SUSE kernel: Code: 8b 00 f6 c4 08 74 0e 48 c7 c7 14 9c
> 45 88 31 c0 e8 b5 bf e2

If you feed this line into ksymoops you get:

Code;  0000000000000000 Before first symbol
   0:   8b 00                     mov    (%rax),%eaxC
...

so it is trying to dereference $rax.

> Feb  6 22:00:28 RAID-SUSE kernel: RAX: 6b6b6b6b6b6b6b6b RBX:
> ffff810037f52668 RCX: 0000000000040000

Which contains 6b6b6b6b6b6b6b6b.
which is lots of copies of 'POISON_FREE' (defined in
include/linux/poison.h) which makes it really look like that memory
has already been freed.

NeilBrown
