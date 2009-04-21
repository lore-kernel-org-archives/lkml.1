Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZDUOGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZDUOGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZDUOGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:06:19 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36700 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZDUOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:06:17 -0400
Date: Tue, 21 Apr 2009 15:05:33 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>, David VomLehn <dvomlehn@cisco.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421140533.GA6375@shareable.org>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu> <20090421063549.3b71881d@infradead.org> <20090421135034.GA30114@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421135034.GA30114@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Arjan van de Ven <arjan@infradead.org> wrote:
> > But more importantly... USB *CANNOT* do this fundamental 
> > operation. USB does not have the capability to know when you have 
> > seen all devices that are connected. Devices just show up a random 
> > amount of time after you turn the power on for the bus.... there's 
> > no "and now we've seen all" operation.
> 
> Yes - and this is fundamentally true of any hotplug bus design.

It's not fundamental, for devices you know are plugged in at boot.
All it takes is for the bus to support a synchronous "enumerate all"
procedure.  That _could_ involve a timeout, but there are better ways.
But not for USB.

> What i'm saying is: instead of "wait 2000 msecs, maybe it works out" 
> hack, there should be a proper sleep+event based approach to the 
> same. With perhaps a _timeout_ for the "no console arrived" negative 
> case as well. (which timeout can be set to zero in the "I _know_ 
> there's no console around".)

Isn't the proposed code doing exactly that?  It sleeps waiting for a
console, with a timeout of X msecs.  If a console arrives before that,
doesn't it wake immediately?

> Do you see the fundamental design difference between the two 
> solutions?

The only difference I see is: If you asked for a USB console, the
timeout should begin relative to when the USB host driver kicks the
bus, not the first /dev/console open.

Conceptually the timeout is a USB characteristic, not a generic
console one.

For other (non-USB) devices which might take a while to initialise, it
should work as you describe.  E.g. an ethernet TCP console should
register ("i'm trying to give you a console") followed by ("got it")
or ("failed, carry on without me").

-- Jamie
