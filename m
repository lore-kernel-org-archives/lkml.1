Return-Path: <linux-kernel-owner+w=401wt.eu-S1759954AbXKOM5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954AbXKOM5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 07:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXKOM5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 07:57:03 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41230 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbXKOM5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 07:57:01 -0500
Date: Thu, 15 Nov 2007 21:55:34 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: EIP is at device_shutdown+0x32/0x60
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20071115014446.f943d835.akpm@linux-foundation.org>
References: <20071115091158.GB6216@localhost.sw.ru> <20071115014446.f943d835.akpm@linux-foundation.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071115213345.B3C1.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 15 Nov 2007 12:11:58 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > Three boxes rarely oops during reboot or poweroff with 2.6.24-rc2-mm1
> > (1) and during 2.6.24 cycle (2):
> > 
> > 	kernel_restart
> > 	sys_reboot
> > 	[garbage]
> > Code: 8b 88 a8 00 00 00 85 c9 74 04 89
> > EIP is at device_shutdown+0x32/0x60
> 
> Yes, all my test boxes did that - it's what I referred to in the releaee
> notes.  Greg is pondering the problem - seem he's the only person who
> cannot reproduce it ;)

Fortunately, my ia64 box reproduces this oops "every time". 
So, I could chase it.

device_shutdown() function in drivers/base/power/shutdown.c
is followings.
-----------
/**
 * device_shutdown - call ->shutdown() on each device to shutdown.
 */
void device_shutdown(void)
{
        struct device * dev, *devn;

        list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
                                kobj.entry) {
                if (dev->bus && dev->bus->shutdown) {
                        dev_dbg(dev, "shutdown\n");
                        dev->bus->shutdown(dev);
                } else if (dev->driver && dev->driver->shutdown) {
                        dev_dbg(dev, "shutdown\n");
                        dev->driver->shutdown(dev);
                }
        }
}
--------
When oops occured, dev->driver pointed kset_ktype's address,
and dev->driver->shutdown was the address of bus_type_list.
So, Oops was caused by "Illegal operation fault".
kset_ktypes is pointed by system_kset.

If my understanding is correct, this loop can't distinguish between
struct device and struct kset, but both are connected in this list,
right? It may be the cause of this.

Bye.

-- 
Yasunori Goto 


