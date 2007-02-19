Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbXBSUhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbXBSUhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932611AbXBSUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:37:05 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:54246 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616AbXBSUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:37:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kS0odUFA4YTpc+wHPtPo74ND6ZqrBuW4lhZWDeZxMOvAfyPti+eoIUQfxhD1nox7qgNmeIPCsO2GfPsG+qhg/MYaGdsP3oL2NtVcJLphYrQOzbCtHlZOeMNgzVRgJFBlrmPyBEMapL70S7lgC+RWZ+quXbjuO5tU7Lsl8xMW1Rg=
Message-ID: <f2b55d220702191237o2e6c4211u58a77deae1febe70@mail.gmail.com>
Date: Mon, 19 Feb 2007 12:37:00 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Jose Goncalves" <jose.goncalves@inov.pt>
Subject: Re: Serial related oops
Cc: "Frederik Deweerdt" <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <45D9E46C.4030408@inov.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070220132909.GD566@slug>
	 <20070219134539.GA27370@flint.arm.linux.org.uk>
	 <20070220142442.GF566@slug>
	 <20070219143520.GB27370@flint.arm.linux.org.uk>
	 <20070220144814.GJ566@slug>
	 <20070219150508.GD27370@flint.arm.linux.org.uk>
	 <45D9D073.7020701@inov.pt>
	 <20070219164200.GF27370@flint.arm.linux.org.uk>
	 <45D9E46C.4030408@inov.pt>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What we've seen on our embedded ARM is that enabling an interrupt that
is shared between multiple UARTs, at a stage when you have not set up
all the data structures touched by the ISR and softirq, can have
horrible consequences, including soft lockups and fandangos on core.
You will be vulnerable to this unless you lock out the interrupt
source (at the interrupt controller or, if you have to, globally)
across the UART registration process in your platform's
arch/mach-dependent core.c, in which case the TX irq test will of
course fail.  Roll-your-own SoC UARTs with bugs or "extended features"
in IRQ enabling and delivery make things worse.

I would love to see this disentangled in a maintainable way.  It's
such a nasty problem (especially given that bootloaders and early boot
code frequently turn on one or more UARTs and leave them in an unknown
state) that all we've been able to do so far is hack around it.  I'll
send an example patch when we've more or less isolated it, but it will
be of limited use to you unless you have the exact set of UART warpage
we do.

Cheers,
- Michael
