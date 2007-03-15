Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbXCOIcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbXCOIcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 04:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933458AbXCOIcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 04:32:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:56311 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933449AbXCOIca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 04:32:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+i82lxK/qiP0qsvmOT2ZH55xph+iljeizKgxN47b
	6xAmMdMtE2aE72
Subject: Re: kref refcounting breakage in mainline
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070315080639.GA14641@kroah.com>
References: <20070302005833.949be737.akpm@linux-foundation.org>
	 <20070306002521.GA12164@kroah.com>
	 <1173159802.6955.6.camel@Homer.simpson.net>
	 <20070306210445.GB29164@kroah.com>
	 <1173245937.6613.26.camel@Homer.simpson.net>
	 <1173541446.6561.32.camel@Homer.simpson.net>
	 <20070315052724.GA12576@kroah.com>
	 <1173945187.6624.14.camel@Homer.simpson.net>
	 <20070315080639.GA14641@kroah.com>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 09:32:26 +0100
Message-Id: <1173947546.6624.29.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 01:06 -0700, Greg KH wrote:

> That's good.  But why don't we have a module name for this driver?
> 
> And if we don't have a module name, why would there be a symlink to
> remove?  That's what is keeping your module from unloading, right?

Ya got me, but according to my debug logs, what's causing my lockup is
the reference we add while making the symlink when we hit...
 if (driver_name) in module_add_driver().  Maybe we go through there
twice, once with a name, and once without?  Dunno.
 
> > [   24.670410] ipmi message handler version 39.1
> > [   24.675000] ipmi device interface
> > [   24.678542] IPMI System Interface driver.
> > [   24.703956] BUG: at kernel/module.c:2429 module_remove_driver()
> > [   24.716837]  [<c0105086>] show_trace_log_lvl+0x1a/0x30
> > [   24.728909]  [<c01057b2>] show_trace+0x12/0x14
> > [   24.740239]  [<c0105856>] dump_stack+0x16/0x18
> > [   24.751469]  [<c01441ce>] module_remove_driver+0xa5/0xa7
> > [   24.763584]  [<c035a014>] bus_remove_driver+0x6d/0x82
> > [   24.775390]  [<c035a978>] driver_unregister+0xb/0x18
> > [   24.787019]  [<c034c8c2>] init_ipmi_si+0x7a9/0x7c1
> > [   24.798450]  [<c06705bc>] init+0x144/0x26c
> > [   24.809129]  [<c0104cfb>] kernel_thread_helper+0x7/0x1c
> > [   24.820916]  =======================
> > [   24.830926] ipmi_si: Unable to find any System Interface(s)
> > [   24.842952] IPMI Watchdog: driver initialized
> >   24.853749] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
> 
> With the above change, it all works correctly?

I don't know about _correctly_, but my diag patch _boots_, as does your
patch plus my addon diag bits.

> If the ipmi driver is loaded, what does the /sys/module/MODULE_NAME/
> tree look like (replacing MODULE_NAME with whatever the module name
> really is, sorry, I don't know)?

Well, I will never see that, because ipmi_si finds no interfaces, so
always backs out.  After backout, with my patch and yours + my addons, I
have there leftovers.

root@Homer: ls -R /sys/module/ipmi_si
/sys/module/ipmi_si:
drivers  parameters

/sys/module/ipmi_si/drivers:

/sys/module/ipmi_si/parameters:
bt_debug  hotmod  kcs_debug  smic_debug

