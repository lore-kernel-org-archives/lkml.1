Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYCNWHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYCNWHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 18:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbYCNWHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 18:07:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083AbYCNWHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 18:07:10 -0400
Date: Fri, 14 Mar 2008 15:05:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>
Subject: Re: linux-next20080314 build fails with !CONFIG_PM
Message-Id: <20080314150554.1b79a6ed.akpm@linux-foundation.org>
In-Reply-To: <47DA2FD6.3000100@linux.vnet.ibm.com>
References: <47DA2FD6.3000100@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 13:27:10 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> The next-20080314 tree build fails 
> 
> drivers/serial/serial_core.c: In function `uart_add_one_port':
> drivers/serial/serial_core.c:2359: error: invalid lvalue in assignment
> make[2]: *** [drivers/serial/serial_core.o] Error 1
> 
> The config # CONFIG_PM was not set.The code which is causing the 
> build failure is 
> 
> 	device_can_wakeup(tty_dev) = 1;
> 
> when the CONFIG_PM is set the macro is preprocessed as
> 
> #define device_can_wakeup(dev) \
>         ((dev)->power.can_wakeup)
> 
> and when not set, it becomes 0 = 1 
> 
> #define device_can_wakeup(dev)                  0
> 

Caused by Alan's "PM: make wakeup flags available whenever CONFIG_PM is
set" which I assume Len merged.


Sorry, but that code should be dragged out and shot.  Doing this:

> 	device_can_wakeup(tty_dev) = 1;

is just gross and stupid.  It looks daft, it isn't C and it *requires* that
device_can_wakeup() be implemented as a macro, which totally busts any
concept of abstraction.


The code previously had quite reasonable accessors:

 #define device_set_wakeup_enable(dev,val) \
        ((dev)->power.should_wakeup = !!(val))
 #define device_may_wakeup(dev) \
        (device_can_wakeup(dev) && (dev)->power.should_wakeup)

can we please go back to that scheme?  Please also convert all these
magical macros into inlined C functions.  One reason is that this:

+#define device_init_wakeup(dev,val) \
+       do { \
+               device_can_wakeup(dev) = !!(val); \
+               device_set_wakeup_enable(dev,val); \
+       } while(0)

is buggy.  It evaluates its arguments multiple times and will cause
failures when passed expressions which have side-effects.

Alan, please also pass all future patches through checkpatch - there is no
need to be adding trivial coding-style errors in this day and age.

Thanks.
