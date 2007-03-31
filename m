Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbXCaQ77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbXCaQ77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbXCaQ77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:59:59 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbXCaQ75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:59:57 -0400
Date: Sat, 31 Mar 2007 09:53:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       "Michael S. Tsirkin" <mst@mellanox.co.il>
Subject: Re: [PATCH v2] Add suspend/resume for HPET
In-Reply-To: <1175358800.28263.36.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703310943190.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> 
 <460BBD1B.4040308@ru.mvista.com>  <200703291531.18253.maximlevitsky@gmail.com>
  <200703291546.48996.maximlevitsky@gmail.com>  <1175356272.28263.27.camel@localhost.localdomain>
  <Pine.LNX.4.64.0703310908160.6730@woody.linux-foundation.org>
 <1175358800.28263.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Mar 2007, Thomas Gleixner wrote:
> 
> Right, but clock - sources/events need to be extremly late suspended and
> early resumed. How can we ensure this ?

Make them be at the top of the device tree by adding them early. That's 
the whole point of the device tree after all - we have an ordering that is 
enforced by its topology, and that we sort by when things were added.

Right now the way things work is (iirc - somebody like Greg should 
double-check me) is that we add all devices to the power list at 
device_add() time by traversing the devices fromt he root all the way out, 
and doing a device_add() which does a device_pm_add(), which in turn adds 
it to the power-management list - so that the list is always topologically 
sorted.

So the only thing that needs to be done is to make sure that we add the 
timer devices early during bootup - something we have to do *anyway*. If a 
device is added early in bootup, that automatically means that it will be 
suspended late, and resumed early - because we maintain that order all the 
way through..

		Linus
