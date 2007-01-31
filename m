Return-Path: <linux-kernel-owner+w=401wt.eu-S1030507AbXAaSWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030507AbXAaSWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030509AbXAaSWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:22:04 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15537 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030507AbXAaSWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:22:03 -0500
In-Reply-To: <45C02AFA.4080501@yahoo.com.au>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org> <45C02AFA.4080501@yahoo.com.au>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <14B41768-94FD-4750-838F-36DE95550F63@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Date: Wed, 31 Jan 2007 10:20:42 -0800
To: Nick Piggin <nickpiggin@yahoo.com.au>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The only thing I saw in Zach's post against the use of threads is that
> some kernel API would change. But surely if this is the showstopper  
> then
> there must be some better argument than sys_getpid()?!

Haha, yeah, that's the silly example I keep throwing around :).  I  
guess it does leave a little too much of the exercise up to the reader.

Perhaps a less goofy example are the uses of current->ioprio and  
current->io_context?

If you create and destroy threads around each operation then you're  
going to be creating and destroying an io_context around each op  
instead of getting a reference on a pre-existing context in  
additional ops.  ioprio is inherited it seems, though, so that's not  
so bad.

If you have a pool of threads and you want to update the ioprio for  
future IOs, you now have to sync up the pool's ioprio with new  
desired priority.

It's all solvable, sure.  Get an io_context ref in copy_process().   
Share ioprio instead of inheriting it.  Have a fun conversation with  
Jens about the change in behaviour this implies.  Broadcasting to  
threads to update ioprio isn't exactly rocket science.

But with the fibril model the user don't have to know to worry about  
the inconsistencies and we kernel developers don't have to worry  
about pro-actively stamping them out.  A series of sync write and  
ioprio setting calls behaves exactly the same as that series of calls  
issued sequentially as "async" calls.  That's worth aiming for, I think.

- z
