Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYKTOPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYKTOPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbYKTOPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:15:34 -0500
Received: from smtp.nokia.com ([192.100.105.134]:51068 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbYKTOPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:15:33 -0500
Date: Thu, 20 Nov 2008 16:14:38 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Richard Purdie <rpurdie@linux.intel.com>
Cc: me@felipebalbi.com, linux-kernel@vger.kernel.org,
       Felipe Balbi <felipe.balbi@nokia.com>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <greg@kroah.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] led: simplify led_trigger_register_simple
Message-ID: <20081120141438.GK7476@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1226545753-6640-1-git-send-email-me@felipebalbi.com> <1226579912.5402.21.camel@dax.rpnet.com> <20081113181407.GC17166@frodo> <20081113191046.GA25855@frodo> <1227188008.22263.9.camel@ted>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227188008.22263.9.camel@ted>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 20 Nov 2008 14:14:53.0742 (UTC) FILETIME=[5BC1A4E0:01C94B1A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 01:33:28PM +0000, ext Richard Purdie wrote:
> On Thu, 2008-11-13 at 21:10 +0200, Felipe Balbi wrote:
> > On Thu, Nov 13, 2008 at 08:14:16PM +0200, Felipe Balbi wrote:
> > > On Thu, Nov 13, 2008 at 12:38:32PM +0000, Richard Purdie wrote:
> > > > The simple triggers were designed to cause minimum interference to the
> > > > usually external subsystem code they were added into. As an example this
> > > > meant things like errors were just handled gracefully with a printk
> > > > warning and did not take down the whole subsystem. I therefore don't
> > > > regard this patch as a simplification, more a complication.
> > > 
> > > That's a matter of changing the return ERR_PTR(err); back to a printk.
> > 
> > And here you are. I still think we should at least kfree(trigger) in
> > case of error, though.
> 
> This patch now just changes the calling convention of the function which
> doesn't seem to serve much purpose.

Well, it's your call then. But I don't like the idea of declaring a
pointer, passing a pointer to that pointer to a function and changing
the value of the original pointer.

I think allocating inside led_trigger_register_simple() and returning
the pointer would look better.

> In answer to your question about kfree, I agree it needs to be called
> upon error. The callers should just be calling
> led_trigger_unregister_simple() in their failure paths though which
> should take care of all problems? I know we used to register the simple
> triggers late in paths so no error handling was needed to keep the code
> simple and minimise the LED triggers impact on those systems.

Well, led_trigger_register_simple() doesn't return anything. Imagine
led_trigger_register_simple() fails, but the driver author decides
it's not a failure if, let's say, a led doesn't turn on when we insert
a mmc card to the slot since it doesn't change functionality.

Now, imagine the user notes the led is not turning on and decides to
unload and reload the module to try again. Once again the led doesn't go
on. If the user keeps trying, it's quite a dangerous memory leak, right
?

-- 
balbi
