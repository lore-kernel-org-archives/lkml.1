Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZBUE3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZBUE3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 23:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZBUE3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 23:29:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:40569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbZBUE3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 23:29:34 -0500
Date: Fri, 20 Feb 2009 20:29:41 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: kay.sievers@vrfy.org, greg@kroah.com, cornelia.huck@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH/RESEND] driver core: remove polling for 
 driver_probe_done(v4)
Message-ID: <20090220202941.6c33b627@infradead.org>
In-Reply-To: <d82e647a0902201728s5e57f02cs8f8c20567f914717@mail.gmail.com>
References: <1235139447-5829-1-git-send-email-tom.leiming@gmail.com>
	<20090220073345.501247f7@infradead.org>
	<d82e647a0902201728s5e57f02cs8f8c20567f914717@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 09:28:34 +0800
Ming Lei <tom.leiming@gmail.com> wrote:
> >
> > you broke it i this revision though
> >
> >> -int wait_for_device_probe(void)
> >> +void driver_wait_probe_done(void)
> >>  {
> >> -     /* wait for the known devices to complete their probing */
> >> -     while (driver_probe_done() != 0)
> >> -             msleep(100);
> >> -     async_synchronize_full();
> >> -     return 0;
> >> +     pr_debug("%s: probe_count = %d\n", __func__,
> >> +              atomic_read(&probe_count));
> >> +     wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
> >
> >
> > You lost the async_synchronize_full()!
> 
> I patch  patch-v2.6.29-rc5-next-20090220.gz against v2.6.29-rc5
> directly to build
> the linux-next tree(it is quicker for me),so I don't know why you add
> async_synchronize_full()
>  in driver core and  seems it doesn't matter with driver core.

I do not add it; you removed it!
(it is needed to synchronize both the pending probes AND the
asynchronous work; that is the point of the consolidation patches to do
all of this in one place)

> 
> Would you mind  that I resend a patch,which does
> async_synchronize_full()  after
> driver_wait_probe_done() in do_mounts.c or do_mounts_md.c ?

that is not the right solution. The patch that introduced
wait_for_device_probe() was there to make sure it all happens in one
central location. To then decentralize this 2nd function call to all
locations that call the function does not make sense to me.....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
