Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbXLSBQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbXLSBQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXLSBQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:16:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307AbXLSBQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:16:38 -0500
Date: Tue, 18 Dec 2007 17:10:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: dwalker@mvista.com, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, linux@bohmer.net, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, kjwinchester@gmail.com
Subject: Re: [PATCH 1/3] ps3: vuart: fix error path locking
Message-Id: <20071218171050.5bf220fa.akpm@linux-foundation.org>
In-Reply-To: <4760922C.2060908@am.sony.com>
References: <20071213003028.676998182@mvista.com>
	<4760922C.2060908@am.sony.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 18:00:12 -0800
Geoff Levand <geoffrey.levand@am.sony.com> wrote:

> > This stray down would cause a permanent sleep which doesn't seem correct. 
> > The other uses of this semaphore appear fairly mutex like it's even initialized
> > with init_MUTEX() ..  So here a patch for removing this one down().
> > 
> > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> > 
> > ---
> >  drivers/ps3/ps3-vuart.c |    1 -
> >  1 file changed, 1 deletion(-)
> 
> 
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
> 
> 
> Looks, good. 

Looks bad to me.

> Andrew, Please apply.

The current code:

	if (result) {
		dev_dbg(&dev->core, "%s:%d: drv->probe failed\n",
			__func__, __LINE__);
		down(&vuart_bus_priv.probe_mutex);
		goto fail_probe;
	}

	up(&vuart_bus_priv.probe_mutex);

	return result;

fail_probe:
	ps3_vuart_set_interrupt_mask(dev, 0);
	kfree(dev->driver_priv);
	dev->driver_priv = NULL;
fail_dev_malloc:
	vuart_bus_priv.devices[dev->port_number] = NULL;
fail_busy:
	ps3_vuart_bus_interrupt_put();
fail_setup_interrupt:
	up(&vuart_bus_priv.probe_mutex);
	dev_dbg(&dev->core, "%s:%d: failed\n", __func__, __LINE__);
	return result;
}

is correct.  Although not exactly a thing of beauty.
