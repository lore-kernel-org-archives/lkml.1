Return-Path: <linux-kernel-owner+w=401wt.eu-S1751700AbZGSGBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbZGSGBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 02:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZGSGBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 02:01:19 -0400
Received: from smtp.nokia.com ([192.100.105.134]:54226 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZGSGBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 02:01:18 -0400
Subject: Re: block2mtd and ubi are initialized too early when compiled in
 on 2.6.31-rc2
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Tobias Diedrich <ranma@tdiedrich.de>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <20090716142816.GA19523@yamamaya.is-a-geek.org>
References: <20090715115235.GA21888@yamamaya.is-a-geek.org>
	 <1247746844.11353.152.camel@localhost.localdomain>
	 <20090716142816.GA19523@yamamaya.is-a-geek.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Jul 2009 09:00:59 +0300
Message-Id: <1247983259.11353.214.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Jul 2009 06:01:04.0416 (UTC) FILETIME=[4CDB0A00:01CA0836]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 16:28 +0200, Tobias Diedrich wrote:
> Artem Bityutskiy wrote:
> > Hi,
> > 
> > On Wed, 2009-07-15 at 13:52 +0200, Tobias Diedrich wrote:
> > > On 2.6.31-rc2 the block2mtd drivers module_init is called before any
> > > block devices have been registered.
> > 
> > Hmm, ok. Is this because block devices are registered asynchronously?
> > Could you please point to the code where it is done, just for reference.
> 
> AFAICS yes.
> All module_init()s are called asynchronously from init/main.c:do_initcalls()

They are done in a kernel thread, but sequentially, one after the other.
So there is no real synchronicity there.

I think the real problem is that block-devices are probed/initialized
asynchronously. E.g., see 'ata_host_register()'. They call
'async_schedule()' which is doing the slow initialization in a separate
thread.

Thus, you probably should to try to add something like
'async_synchronize_full()' to the blk2mtd driver and wait for block
devices to initialize. Or indeed 'wait_for_device_probe()' may be what
you need.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

