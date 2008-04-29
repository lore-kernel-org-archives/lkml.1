Return-Path: <linux-kernel-owner+w=401wt.eu-S933657AbYD2AmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657AbYD2AmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 20:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbYD2Aly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 20:41:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708AbYD2Alx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 20:41:53 -0400
Date: Mon, 28 Apr 2008 17:41:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [2.6 patch] fs/block_dev.c:I_BDEV() mustn't be inline
In-Reply-To: <20080428153831.GC2813@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804281736230.3119@woody.linux-foundation.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
 <20080428153831.GC2813@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Apr 2008, Adrian Bunk wrote:
>
> This patch fixes the following build error with UML and gcc 4.3:

I'm not going to apply these before I understand what the breakage is all 
about.

> -inline struct block_device *I_BDEV(struct inode *inode)
> +struct block_device *I_BDEV(struct inode *inode)
>  {
>  	return &BDEV_I(inode)->bdev;
>  }

There is NO WAY IN HELL this function shouldn't be inlined, and it doesn't 
matter a whit if some users outside of this file then also want the 
non-inlined version.

The whole setup should result in a single offset-of from the inode, ie 
we're talking something that normally generates no code at all when 
inlined (because the offset will be subsumed into whatever actually uses 
the result).

So just removing the inline is simply not acceptable any more, since it 
just implies total and utter breakage of the compiler. At some point you 
just have to say: "That is sh*t", and not take it any more.

What is UML doing to trigger this? 

Or should be just tell people that gcc-4.3 is unusable crap?

			Linus
