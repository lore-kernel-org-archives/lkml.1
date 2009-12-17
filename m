Return-Path: <linux-kernel-owner+w=401wt.eu-S1764987AbZLQRNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764987AbZLQRNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759483AbZLQRNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:13:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:50863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759453AbZLQRNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:13:44 -0500
Subject: Re: [Bug][perf hw-breakpoints] Null pointer exception when using
 register_user_hw_breakpoint with inherit flag
From: Peter Zijlstra <peterz@infradead.org>
To: prasad@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091217170309.GA5457@in.ibm.com>
References: <20091217170309.GA5457@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 18:13:09 +0100
Message-ID: <1261069989.27920.604.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-17 at 22:33 +0530, K.Prasad wrote:
> Hi,
>   While testing out two new interfaces (to be sent separately) that
> in-turn uses register_user_hw_breakpoint() and unregister_hw_breakpoint(),
> I noticed the following error.
> 
> The bug is seen only when 'inherit' flag of 'perf_event_attr' is set
> (not otherwise) before the call to register_user_hw_breakpoint(),
> and when the user-space process tries to spawn a new thread.
> 
> Please find the screen logs taken from an x86 box, running -tip kernel 
> commit 7818b3d0fc68f5c2a85fed86d9fa37131c5a3068.
> 
> Digging further, the causative line of code appears to be
> 
> 	atomic_long_inc(&parent_event->filp->f_count);
> 
> in inherit_event() function, wherein f_count is NULL (and hence the
> error). I haven't analysed further to understand why/if the said
> pointer is/should be NULL.
> 
> Thought might bring it to the community's notice for wider
> notice/further investigation.

Ooh, cute, it seems the inherit code assumes we have a file structure
around, which isn't true for events that get created through the kernel
interface.

I think its a simple matter of testing to see if event->filp is set, but
we'd better audit the code for it.

