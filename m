Return-Path: <linux-kernel-owner+w=401wt.eu-S1765956AbXGaQUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765956AbXGaQUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765631AbXGaQUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:20:08 -0400
Received: from ns1.coraid.com ([65.14.39.133]:14163 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765543AbXGaQUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:20:07 -0400
Date: Tue, 31 Jul 2007 12:21:40 -0400
From: "Ed L. Cashin" <ecashin@coraid.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, ak@suse.de
Subject: Re: ATA over ethernet swapping and obfuscated code
Message-ID: <20070731162140.GI3206@coraid.com>
References: <20070731135831.GA4604@elf.ucw.cz> <20070731150324.GE3206@coraid.com> <20070731152924.GM2087@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731152924.GM2087@elf.ucw.cz>
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 05:29:24PM +0200, Pavel Machek wrote:
...
> Is the protocol documented somewhere? aoe.txt only points at
> HOWTO... aha, protocol is linked from wikipedia.
> http://www.coraid.com/documents/AoEr10.txt ... perhaps that should be
> linked from aoe.txt, too?

Perhaps.  Most people reading the aoe.txt file won't need to refer to
the protocol itself, though.

> Hmm, aoe protocol is really trivial. Perhaps netpoll/netconsole
> infrastructure could be used to create driver good enough for
> swapping? (Ok, it would not neccessarily perform too well, but... we'd
> simply wait for the reply synchronously. It should be pretty simple).

I think that in general you still need a way to receive write
confirmations without allocating memory, and the driver can't provide
that mechanism.  The problem is that when memory is scarce, writes of
dirty data must be able to complete, but because memory is scarce,
there might not be enough to receive and process packets write-reponse
packets, and the driver has no way of affecting the situation.  That's
why I think a callback could work: The network layer could allow
storage drivers to register a callback that recognizes write
responses.

Usually the callback would not be used, but if free pages became so
scarce that network receives could not take place in a normal fashion,
the (zero or few) registered callbacks would be used to quickly
determine whether each packet was a write response.  The distinction
is important, because write responses can result in the freeing of
pages.

When a storage driver's callback identified a write response, then a
reserved skb could be used to process the receive without allocating
memory.  During the memory crunch packets that were not write
responses would be dropped just as they are already, but dirty pages
would be flushed.  The mechanism would only take effect when free
pages were scarce.

It is easy to chat, though.  Maybe someday I will test and submit a
patch that implements this mechanism, but I'm hoping that somebody
beats me to it.  :)

-- 
  Ed L Cashin <ecashin@coraid.com>
