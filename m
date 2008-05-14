Return-Path: <linux-kernel-owner+w=401wt.eu-S1763584AbYENSmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763584AbYENSmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763348AbYENSm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:42:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763350AbYENSmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:42:24 -0400
Date: Wed, 14 May 2008 11:41:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
       kernel-testers@vger.kernel.org
Subject: Re: 2.6.26-rc2-mm1: sparc64 - possible recursive locking detected
Message-Id: <20080514114150.acee5bb7.akpm@linux-foundation.org>
In-Reply-To: <200805142029.40373.m.kozlowski@tuxland.pl>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	<200805142029.40373.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 20:29:40 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	Got this on sparc64 startup:

whoa.  A sparc64 tester?  Thanks!

> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.26-rc2-mm1 #2
> ---------------------------------------------
> modprobe/514 is trying to acquire lock:
>  (&cls->mutex){--..}, at: [<00000000005ff538>] device_add+0x3c0/0x5c0
> 
> but task is already holding lock:
>  (&cls->mutex){--..}, at: [<000000000060287c>] class_interface_register+0x44/0xe0
> 
> other info that might help us debug this:
> 1 lock held by modprobe/514:
>  #0:  (&cls->mutex){--..}, at: [<000000000060287c>] class_interface_register+0x44/0xe0
> 
> stack backtrace:
> Call Trace:
>  [000000000048cc64] __lock_acquire+0x104c/0x1400
>  [000000000048d098] lock_acquire+0x80/0xa0
>  [0000000000701898] mutex_lock_nested+0xc0/0x4e0
>  [00000000005ff538] device_add+0x3c0/0x5c0
>  [00000000005ff74c] device_register+0x14/0x20
>  [00000000005ff808] device_create+0xb0/0xe0
>  [0000000010012ef8] sg_add+0x160/0x380 [sg]
>  [00000000006028d4] class_interface_register+0x9c/0xe0
>  [0000000000617050] scsi_register_interface+0x18/0x40
>  [000000001001c0a4] init_sg+0xac/0x180 [sg]
>  [00000000004960c8] sys_init_module+0xb0/0x1c0
>  [00000000004463cc] sys32_init_module+0x14/0x20
>  [0000000000406294] linux_sparc_syscall32+0x3c/0x40
>  [0000000000013698] 0x136a0
> 

Yeah, this is a bug which has always been there, afaik.  A
semaphore was converted to a mutex.  Semaphores don't have lockdep
checking, but mutexes do, so we just now got to find out about it. 
Some finger-pointing is occurring over on the scsi list ;)

I assume the machine otherwise works OK?
