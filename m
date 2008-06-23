Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbYFWSyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbYFWSyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYFWSyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:54:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:38882 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbYFWSyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:54:39 -0400
Date: Mon, 23 Jun 2008 11:54:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Fix open/close race in saa7134
Message-ID: <20080623115432.5ce376e5@infradead.org>
In-Reply-To: <20080623184937.GA5593@joi>
References: <20080622100507.779acc59@infradead.org>
	<20080622172826.GA7487@joi>
	<20080622105832.1c61fb92@infradead.org>
	<20080623184937.GA5593@joi>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 20:49:42 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> On Sun, Jun 22, 2008 at 10:58:32AM -0700, Arjan van de Ven wrote:
> > On Sun, 22 Jun 2008 19:33:37 +0200
> > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > 
> > > On Sun, Jun 22, 2008 at 10:05:07AM -0700, Arjan van de Ven wrote:
> > > > 
> > > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > > Date: Sun, 22 Jun 2008 10:03:02 -0700
> > > > Subject: [PATCH] Fix open/close race in saa7134
> > > > 
> > > > The saa7134 driver uses a (non-atomic) variable in an attempt to
> > > > only allow one opener of the device (how it deals with sending
> > > > the fd over unix sockets I don't know).
> > > > 
> > > > Unfortunately, the release function first decrements this
> > > > variable, and THEN goes on to disable more of the device. This
> > > > allows for a race where another opener of the device comes in
> > > > after the decrement of the variable, configures the hardware
> > > > just to then see the hardware be disabled by the rest of the
> > > > release function.
> > > 
> > > Simplier fix:
> > > http://lkml.org/lkml/2008/6/9/308
> > > But I don't remember whether it was applied or not...
> > 
> > 
> > the patch might be simpler, but it's not fully correct...
> > the decrement is non-atomic and not protected by any lock
> > whatsoever.
> 
> It's not atomic, but it don't have to, because there's only one
> thread which "owns" the device.

this is not correct!

this is a close->open race, not an open->close!
which means the guy who's closing it and the guy who's then opening it
again do not have to be the same guy

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
