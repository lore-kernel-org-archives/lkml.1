Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbYFWTXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbYFWTXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYFWTXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:23:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:45853 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYFWTXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KR3Ja+FeeUVAodV5A4tI8okd06YNBSaGjzi2uaZZbn9gU6iqDtg77h2ifaHNxeuKWX
         PpJc/ggqWIv8OMX9Gic7KNrRF1NqTOgepFFbDj+yeMxRLNA+HlZdAm/1M5vP8+EpGXdQ
         A4vMFN/2gcaHIWnYz3sIk/wOcpVrhj0zMTuHk=
Date: Mon, 23 Jun 2008 21:22:03 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Fix open/close race in saa7134
Message-ID: <20080623192141.GB5593@joi>
References: <20080622100507.779acc59@infradead.org> <20080622172826.GA7487@joi> <20080622105832.1c61fb92@infradead.org> <20080623184937.GA5593@joi> <20080623115432.5ce376e5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623115432.5ce376e5@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 11:54:32AM -0700, Arjan van de Ven wrote:
> On Mon, 23 Jun 2008 20:49:42 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > On Sun, Jun 22, 2008 at 10:58:32AM -0700, Arjan van de Ven wrote:
> > > On Sun, 22 Jun 2008 19:33:37 +0200
> > > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > > 
> > > > On Sun, Jun 22, 2008 at 10:05:07AM -0700, Arjan van de Ven wrote:
> > > > > 
> > > > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > > > Date: Sun, 22 Jun 2008 10:03:02 -0700
> > > > > Subject: [PATCH] Fix open/close race in saa7134
> > > > > 
> > > > > The saa7134 driver uses a (non-atomic) variable in an attempt to
> > > > > only allow one opener of the device (how it deals with sending
> > > > > the fd over unix sockets I don't know).
> > > > > 
> > > > > Unfortunately, the release function first decrements this
> > > > > variable, and THEN goes on to disable more of the device. This
> > > > > allows for a race where another opener of the device comes in
> > > > > after the decrement of the variable, configures the hardware
> > > > > just to then see the hardware be disabled by the rest of the
> > > > > release function.
> > > > 
> > > > Simplier fix:
> > > > http://lkml.org/lkml/2008/6/9/308
> > > > But I don't remember whether it was applied or not...
> > > 
> > > 
> > > the patch might be simpler, but it's not fully correct...
> > > the decrement is non-atomic and not protected by any lock
> > > whatsoever.
> > 
> > It's not atomic, but it don't have to, because there's only one
> > thread which "owns" the device.
> 
> this is not correct!
> 
> this is a close->open race, not an open->close!
> which means the guy who's closing it and the guy who's then opening it
> again do not have to be the same guy

If dev->empress_users could be > 1 then ok - it could break, but it can only be 1 or 0.
If it's 1 you won't open the device. If it's 0 you won't reach ts_close.

If you still see the race, please show me the sequence, because I don't
(of course when decrementing is the last operation of ts_close).

Marcin
