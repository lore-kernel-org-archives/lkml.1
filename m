Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbXLVRCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbXLVRCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 12:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbXLVRCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 12:02:36 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:30863 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbXLVRCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 12:02:35 -0500
Subject: Re: [PATCH 4/4] usb: libusual: locking cleanup
From: Daniel Walker <dwalker@mvista.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
In-Reply-To: <20071221222428.a75a5a34.zaitcev@redhat.com>
References: <20071221205854.408865412@mvista.com>
	 <20071221205859.316759032@mvista.com>
	 <20071221222428.a75a5a34.zaitcev@redhat.com>
Content-Type: text/plain
Date: Sat, 22 Dec 2007 09:01:50 -0800
Message-Id: <1198342910.2742.14.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-21 at 22:24 -0800, Pete Zaitcev wrote:

> When I tried it, usb-storage would not load with unresolved symbols.
> It happens if child (usu_probe_thread) runs ahead of its parent
> (usb_usual_init -> usb_register -> usu_probe). It's entirely possible,
> depending on your scheduler.
> 
> I hate this down-up trick too, so if you have a better idea, I'm all ears.

This is what you originally had,

static int usu_probe_thread(void *arg)
{

        /* A completion does not work here because it's counted. */
        down(&usu_init_notify);
        up(&usu_init_notify);
...
}

static int __init usb_usual_init(void)
{
        sema_init(&usu_init_notify, 0); <-- Locked init

        rc = usb_register(&usu_driver);
        up(&usu_init_notify);
        return rc;
}

The locked init can easily be an unlocked init combined with a down() ..
So your protecting usb_register() from something else. 

Then in usu_probe_thread() your basically stopping it at the start of
the function with a down(), and the up() is just ancillary .. So you
could easily move the up() further down in the function and still have
the same level of exclusion.. 

static int usu_probe_thread(void *arg)
{

        down(&usu_init_notify);
...
        up(&usu_init_notify);
}

static int __init usb_usual_init(void)
{
        sema_init(&usu_init_notify, 1); <-- Unlocked init

	down(&usu_init_notify);
        rc = usb_register(&usu_driver);
        up(&usu_init_notify);
        return rc;
}

The above protects the same way that your original code did, with the
added benefit of conforming to mutex style usage. The next step is to
convert to the mutex API..

What I've done is all suppose to be mathematical translations, I wasn't
trying to improve the code just make it use a different API..

Daniel

