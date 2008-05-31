Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYEaN6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYEaN6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 09:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYEaN6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 09:58:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46308 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752487AbYEaN6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 09:58:13 -0400
Date: Sat, 31 May 2008 14:43:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH 1/1] Char: tty_io, fix closecount counting
Message-ID: <20080531144345.0a2f3c11@core>
In-Reply-To: <48413B6E.3050202@gmail.com>
References: <1211810923-3122-1-git-send-email-jirislaby@gmail.com>
	<48413B6E.3050202@gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is ever vcs1, which is /dev/console and it is the only treated separately 
> (otherwise I think we would have more (and distinct) reports like this). 
> When the console is HUPped? And what should happen with openers? The 
> 2.6.22+suse happened when sulogin /dev/console was invoked. Any ideas how to 
> track this down?

Its a complete and total mess is the obvious answer. In fact its far
worse than it first looks and I don't believe it can be fixed without
reworking the whole printk/console stuff.

I spent several days this week mapping out how the tty open/close/hangup
logic works and to be honest what I've learned is

- It doesn't
- It can't be easily fixed to
- There are numerous races
- The whole "tty/console" abstraction for printk type stuff is totally
broken by design and replicated in several places for good measure.

At this point I have to say I can't even see a way to get from the
existing tty open/close/hangup logic to a working one which does not
involve changes to every driver with a 'flag day' type switch between the
two implementations.

For the existing codebase I think the best we can do in this area is label
it "condemned" and not touch it, because any change will be unpredictable
in its effect and not a real fix.

I'd love to be proved wrong. Doing a grand reimplementation of large
chunks of the tty layer isn't what I want to do, I just see no
alternative at this point.

Alan
