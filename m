Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbXBKFU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbXBKFU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 00:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbXBKFU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 00:20:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52128 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbXBKFUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 00:20:55 -0500
Date: Sun, 11 Feb 2007 05:20:45 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] iomap: make PCI iomap stuff excluded when PCI isn't configured
Message-ID: <20070211052045.GQ10050@ftp.linux.org.uk>
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com> <45CE0434.30105@gmail.com> <20070210194630.GA13416@osiris.ibm.com> <45CE43B5.2020806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CE43B5.2020806@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 05:14:13PM -0500, Tejun Heo wrote:
> Heiko Carstens wrote:
> >On Sat, Feb 10, 2007 at 12:43:16PM -0500, Tejun Heo wrote:
> \>> Heiko, how about this?  Does it fix s390?
> >
> >Unfortunately not. Now I get
> >
> >  CC      lib/iomap.o
> >lib/iomap.c: In function 'devm_ioport_map_release':
> >lib/iomap.c:270: warning: implicit declaration of function 'ioport_unmap'
> >lib/iomap.c: In function 'devm_ioport_map':
> >lib/iomap.c:297: warning: implicit declaration of function 'ioport_map'
> >lib/iomap.c:297: warning: assignment makes pointer from integer without a 
> >cast
> 
> I think an arch needs to support ioport_map/unmap and noncoherent dma 
> (just alias to coherent interface on x86/amd64) interface whether PCI is 
> implemented or not.  No?

Another source of breakage: you get devm_request_irq() only if you have
GENERIC_HARDIRQS.  Otherwise kernel/irq/ is simply not built.  Again,
you are mixing default implementation of primitives with the
implementation-agnostic stuff around those primitives.  I'd split
kernel/irq/manage.c in two files and have the places providing
alternative implementations (e.g. arch/sparc/kernel) refer to new
file in their makefiles...

I'm mostly done with that stuff, modulo noncoherent_dma breakage.  Will
send patch once the irq crap is dealt with...
