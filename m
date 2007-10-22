Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbXJVDV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbXJVDV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbXJVDVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:21:52 -0400
Received: from 1wt.eu ([62.212.114.60]:3477 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbXJVDVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:21:51 -0400
Date: Mon, 22 Oct 2007 05:21:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: Tal Kelrich <tal@musicgenome.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.4/2.6 local TCP connect oddity
Message-ID: <20071022032145.GA14735@1wt.eu>
References: <20071021175337.605e843e@shodan.orpak.com> <20071021172901.GV10199@1wt.eu> <20071021225329.1a971751@shodan.orpak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021225329.1a971751@shodan.orpak.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 10:53:29PM +0200, Tal Kelrich wrote:
> On Sun, 21 Oct 2007 19:29:02 +0200
> Willy Tarreau <w@1wt.eu> wrote:
> 
> > Hi,
> > 
> > On Sun, Oct 21, 2007 at 05:53:37PM +0200, Tal Kelrich wrote:
> > > Hi,
> > > 
> > > I've run into a problem where a process trying to connect to a local
> > > port within the local port range eventually ends up connected to
> > > itself, with source port = dest port.
> > > 
> > > similar behavior can be gotten by running netcat as follows:
> > > nc -p 1025 localhost 1025
> > > 
> > > I'm not really sure if that's a bug, but the original case was at
> > > least unexpected.
> > 
> > It is not a bug, it is caused by the "simultaneous connect" feature of
> > TCP. Although rarely used, in TCP you can connect two clients
> > together. They just have to exchange their SYN, SYN/ACK then ACK and
> > bingo, they're connected. In fact, you found the easiest way to
> > achieve it, by using the same port. To demonstrate the feature, I'm
> > used to either temporarily block SYNs with iptables, or by unplugging
> > the cable between two machines.
> > 
> 
> Hi,
> 
> It still seems confusing that a connect against localhost may
> randomly succeed.
> 
> Here's a better example, if somewhat violent. eventually succeeds.
> (p=$((`cat /proc/sys/net/ipv4/ip_local_port_range|cut -f1`+1)); while
> true ; do nc -v -v 127.0.0.1 $p ; done)

Of course, for the same reason. If you reduce the ip_local_port_range, it
will even succeed more often. This is because the source port is choosen
before the first packet is sent, so when it is sent, it reaches a pending
connection (itself).

I can understand that it is confusing when you see it as a single
connection, but try to imagine (or reproduce) with 2 machines, then
translate that to the localhost with a single and same connection.
You may even draw the exchanges on paper, an you will notice that
"each end" of the connection gets its SYN-SYN/ACK-ACK sequence.

You may also tcpdump on loopback if that helps.

Regards,
Willy

