Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbXLVGdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbXLVGdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 01:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbXLVGdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 01:33:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56210 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbXLVGdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 01:33:45 -0500
Date: Fri, 21 Dec 2007 22:31:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Daniel Walker <dwalker@mvista.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com
Subject: Re: [PATCH 4/4] usb: libusual: locking cleanup
Message-Id: <20071221223134.1567b755.akpm@linux-foundation.org>
In-Reply-To: <20071221222428.a75a5a34.zaitcev@redhat.com>
References: <20071221205854.408865412@mvista.com>
	<20071221205859.316759032@mvista.com>
	<20071221222428.a75a5a34.zaitcev@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 22:24:28 -0800 Pete Zaitcev <zaitcev@redhat.com> wrote:

> On Fri, 21 Dec 2007 00:00:04 -0800, Daniel Walker <dwalker@mvista.com> wrote:
> 
> > I converted the usu_init_notify semaphore to normal mutex usage, and it 
> > should still prevent the request_module before the init routine is
> > complete. Before it acted more like a complete, now the mutex protects
> > two distinct section from running at the same time..
> 
> Let's see.
> 
> > @@ -178,10 +179,7 @@ static int usu_probe_thread(void *arg)
> >  	int rc;
> >  	unsigned long flags;
> >  
> > -	/* A completion does not work here because it's counted. */
> > -	down(&usu_init_notify);
> > -	up(&usu_init_notify);
> > -
> > +	mutex_lock(&usu_probe_mutex);
> >  	rc = request_module(bias_names[type]);
> 
> When I tried it, usb-storage would not load with unresolved symbols.
> It happens if child (usu_probe_thread) runs ahead of its parent
> (usb_usual_init -> usb_register -> usu_probe). It's entirely possible,
> depending on your scheduler.

afaict Daniel's change will fix that?

He releases usu_probe_mutex once the usb_register() has completed and this
then allows the usb_probe_thread() to start working.

I'm still wondering if that theory has been tested though.

> I hate this down-up trick too

I'd be worried if you were proud of it ;)

