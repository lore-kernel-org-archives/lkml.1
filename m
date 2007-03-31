Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXCaPvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXCaPvc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 11:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbXCaPvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 11:51:31 -0400
Received: from www.osadl.org ([213.239.205.134]:53340 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753189AbXCaPvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 11:51:13 -0400
Subject: Re: [PATCH v2] Add suspend/resume for HPET
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
In-Reply-To: <200703291546.48996.maximlevitsky@gmail.com>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <460BBD1B.4040308@ru.mvista.com>
	 <200703291531.18253.maximlevitsky@gmail.com>
	 <200703291546.48996.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 17:51:11 +0200
Message-Id: <1175356272.28263.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-29 at 15:46 +0200, Maxim Levitsky wrote:
> Subject: Add suspend/resume for HPET
> This adds support of suspend/resume on i386 for HPET
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
>
> +static struct sysdev_class hpet_class = {
> +	set_kset_name("hpet"),
> +	.suspend	= hpet_suspend,
> +	.resume		= hpet_resume,
> +};
> +
> +static struct sys_device hpet_device = {
> +	.id		= 0,
> +	.cls		= &hpet_class,
> +};

Sorry for being inresponsive. I was travelling and unexpectedly cut off
from the internet for some days.

While I agree in principle with the patch, I'm a bit uncomfortable. The
sys device suspend / resume ordering is not guaranteed and relies on the
registering order.

Jeff still seems to have problems with CONFIG_NO_HZ=n and it might be
caused by time keeping / tick management resume happening before the
HPET resume.

The required resume order is:

clocksources
timekeeping
clockevents
tick management

I'm not sure how to do this properly with the sys device facilities, but
I look into it.

/me goes off to understand the sys device magic.

	tglx


