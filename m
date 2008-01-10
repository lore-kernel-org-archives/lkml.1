Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbYAJCOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbYAJCOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYAJCOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:14:38 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:49897 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbYAJCOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:14:37 -0500
Date: Wed, 9 Jan 2008 21:14:04 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: andi@firstfloor.org, harvey.harrison@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: uml and -regparm=3
Message-ID: <20080110021404.GA11287@c2.user-mode-linux.org>
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu> <p734pdmput0.fsf@bingen.suse.de> <E1JCiLx-0006lI-HR@pomaz-ex.szeredi.hu> <20080109213258.GC15612@one.firstfloor.org> <E1JCioy-0006os-6i@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JCioy-0006os-6i@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:50:48PM +0100, Miklos Szeredi wrote:
> > FASTCALL is useless and should not make a difference. It enables
> > regparm on specific functions, but that should not make a difference
> > if it works or not.
> 
> __down_write() in include/asm-x86/rwsem.h seems to assume, that the
> semaphore pointer is passed in %eax down to rwsem_down_write_failed(),
> so regparm does make a difference there.

And rwsem_down_write_failed seems to think it's getting the pointer in
%eax:

Dump of assembler code for function rwsem_down_write_failed:
0x08193599 <rwsem_down_write_failed+0>: push   %ebp
0x0819359a <rwsem_down_write_failed+1>: mov    %esp,%ebp
0x0819359c <rwsem_down_write_failed+3>: push   %ebx
0x0819359d <rwsem_down_write_failed+4>: mov    %eax,%ebx
0x0819359f <rwsem_down_write_failed+6>: sub    $0x10,%esp
0x081935a2 <rwsem_down_write_failed+9>: push   $0xffffffff
0x081935a4 <rwsem_down_write_failed+11>:        lea    0xffffffec(%ebp),%eax
0x081935a7 <rwsem_down_write_failed+14>:        push   %eax
0x081935a8 <rwsem_down_write_failed+15>:        push   %ebx
0x081935a9 <rwsem_down_write_failed+16>:        movl   $0x2,0xfffffff8(%ebp)
0x081935b0 <rwsem_down_write_failed+23>:        call   0x8193423 <rwsem_down_failed_common>

This is clearly taking something from %eax and something on the stack
(and a -1) and passing it to rwsem_down_failed_common, corresponding
to this:
	rwsem_down_failed_common(sem, &waiter,
				RWSEM_WAITING_BIAS - RWSEM_ACTIVE_BIAS);

So, this does look right to me.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
