Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbXLVG0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbXLVG0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 01:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXLVG0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 01:26:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXLVG0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 01:26:12 -0500
Date: Fri, 21 Dec 2007 22:24:28 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, zaitcev@redhat.com
Subject: Re: [PATCH 4/4] usb: libusual: locking cleanup
Message-Id: <20071221222428.a75a5a34.zaitcev@redhat.com>
In-Reply-To: <20071221205859.316759032@mvista.com>
References: <20071221205854.408865412@mvista.com>
	<20071221205859.316759032@mvista.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 00:00:04 -0800, Daniel Walker <dwalker@mvista.com> wrote:

> I converted the usu_init_notify semaphore to normal mutex usage, and it 
> should still prevent the request_module before the init routine is
> complete. Before it acted more like a complete, now the mutex protects
> two distinct section from running at the same time..

Let's see.

> @@ -178,10 +179,7 @@ static int usu_probe_thread(void *arg)
>  	int rc;
>  	unsigned long flags;
>  
> -	/* A completion does not work here because it's counted. */
> -	down(&usu_init_notify);
> -	up(&usu_init_notify);
> -
> +	mutex_lock(&usu_probe_mutex);
>  	rc = request_module(bias_names[type]);

When I tried it, usb-storage would not load with unresolved symbols.
It happens if child (usu_probe_thread) runs ahead of its parent
(usb_usual_init -> usb_register -> usu_probe). It's entirely possible,
depending on your scheduler.

I hate this down-up trick too, so if you have a better idea, I'm all ears.

-- Pete
