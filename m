Return-Path: <linux-kernel-owner+w=401wt.eu-S933011AbXBVLBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbXBVLBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945962AbXBVLBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:01:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36673 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbXBVLBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:01:31 -0500
Subject: Re: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to
	a	central arch-independent location
From: Arjan van de Ven <arjan@infradead.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Dor Laor <dor.laor@qumranet.com>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <45DD7330.1030001@qumranet.com>
References: <45D979D3.2020907@qumranet.com>
	 <20070219103052.4D23725016B@il.qumranet.com><20070221103733.GI3945@ucw.cz>
	 <45DD6CF0.3010509@qumranet.com>
	 <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>
	 <1172140490.3531.236.camel@laptopd505.fenrus.org>
	 <45DD7330.1030001@qumranet.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 12:01:21 +0100
Message-Id: <1172142081.3531.243.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 12:40 +0200, Avi Kivity wrote:
> Arjan van de Ven wrote:
> >> I have Ingo's network PV hypercalls to commit in my piplien.
> >>     
> >
> > I have 5 or so pending as well :)
> > can't wait for the infrastructure to be there so that it's relatively
> > easy to add my paravirt block driver
> >   
> 
> I can't wait for your pv block driver :)
> 
> What do you think is missing?  My list has:
> 
> - registration of hypercall handlers from module

optional I think, but yeah easier for the user

> - execution of hypercall handlers outside vcpu_load() (so they are 
> preemptible and sleepable)

I don't need this; most of my hypercalls are non-blocking. The ones that
are can already undo the load themselves, no big deal.

> - passing unhandled hypercalls to userspace for qemu-based devices

hm could do I suppose

One thing I'd like to see is some way to do batched hypercalls. I don't
quite know how this will work in general, but let me explain the
scenario:
The guest submits a bunch of disk IO requests into a submit queue.
The host gets a hypercall and goes to process the submit queue
While this is processing, the guest submits more IO
The guest would here do another hypercall.. 

.. but what could be done is have the host poll at the end of it's scan
of the queue if there's more, and while the host is scanning, just
disable the hypercall the guest would make. So that if there is a
"submit while scanning/processing" going on, no need for more
hypercalls. 

(Otoh... the current situation isn't all that bad, there's one hypercall
for an entire batch of IO's, and the blocklayer isn't all that bad at
giving us nice large batches)



-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

