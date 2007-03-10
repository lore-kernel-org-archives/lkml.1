Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbXCJUop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbXCJUop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 15:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932270AbXCJUop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 15:44:45 -0500
Received: from waste.org ([66.93.16.53]:51717 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbXCJUon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 15:44:43 -0500
Date: Sat, 10 Mar 2007 14:31:57 -0600
From: Matt Mackall <mpm@selenic.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: netconsole system freeze when cable unplugged
Message-ID: <20070310203157.GB10459@waste.org>
References: <45F1B6FD.1060902@simon.arlott.org.uk> <20070309204243.GA28441@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309204243.GA28441@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 09:42:43PM +0100, Francois Romieu wrote:
> Simon Arlott <simon@fire.lp0.eu> :
> > When I unplug the cable the system just stops responding to anything, 
> > at all. No message is printed to the console when the cable is plugged 
> > back in.
> 
> rtl8139_interrupt (spin_lock(&tp->lock))
> -> rtl8139_weird_interrupt
>    -> rtl_check_media
>       -> mii_check_media (printk(KERN_INFO "%s: link down\n", ...))
>          [netpoll stuff here]
>          -> rtl8139_poll_controller
>             -> rtl8139_interrupt
>                *deadlock*

Probably the best thing that can be done here aside from moving
mii_check_media outside interrupt handling is to add
netpoll_plug/unplug(dev) methods that push work off to netpoll's queue
for drivers that have a netpoll recursion problem.

-- 
Mathematics is the supreme nostalgia of our time.
