Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYGSPo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYGSPo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 11:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYGSPou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 11:44:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:58005 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbYGSPot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 11:44:49 -0400
Date: Sat, 19 Jul 2008 08:44:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
Message-ID: <20080719084448.7859afd0@infradead.org>
In-Reply-To: <4881A161.7050902@keyaccess.nl>
References: <20080718151524.5ef9e29b@infradead.org>
	<20080718151608.46dc17c0@infradead.org>
	<48819D92.8050904@keyaccess.nl>
	<4881A161.7050902@keyaccess.nl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008 10:10:09 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 19-07-08 09:53, Rene Herman wrote:
> > On 19-07-08 00:16, Arjan van de Ven wrote:
> > 
> >> +static void __init do_initcalls(void)
> >> +{
> >> +    initcall_t *call;
> >> +    static DECLARE_WORK(async_work, do_async_initcalls);
> >> +    int phase = 0; /* 0 = levels 0 - 6, 1 = level 6a, 2 = after
> >> level 6a */
> >> +
> >> +    async_init_wq = create_singlethread_workqueue("kasyncinit");
> >> +
> >> +    for (call = __initcall_start; call < __initcall_end; call++) {
> >> +        if (phase == 0 && call >= __async_initcall_start) {
> >> +            phase = 1;
> >> +            queue_work(async_init_wq, &async_work);
> >> +        }
> >> +        if (phase == 1 && call >= __async_initcall_end)
> >> +            phase = 2;
> >> +        if (phase != 1)
> >> +            do_one_initcall(*call);
> >> +    }
> > 
> > I'm not sure about this comment, being not very sure about the
> > semantics of late_initcall but shouldn't late_initcall (level 7)
> > wait for 6s to have completed?
> 
> Following up on this myself -- see for example kernel/power/disk.c: 
> power_suspend(). It's a late intitcall so that, as it comments, "all 
> devices are discovered and initialized". However, your first followup 
> patch makes the USB HCI init async meaning that any USB storage
> device might not be ready yet when it runs, no?


good spotting/comment.

you would have a valid point... if it weren't for the case where much
of this actual "end device" probing is in various cases already
asynchronous... what you do have found is a bug in the suspend code.
Unless code does:
        /* wait for the known devices to complete their probing */
        while (driver_probe_done() != 0)
                msleep(100);
(taken from init/do_mounts.c)

... the assertion in the comment that probing is done is absolutely
false, with or without my patches.

(Not that I want the suspend/resume code to call this, because that
would make the boot even longer ;( )


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
