Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYCNWin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYCNWin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 18:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYCNWic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 18:38:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58278 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYCNWic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 18:38:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next20080314 build fails with !CONFIG_PM
Date: Fri, 14 Mar 2008 23:37:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, apw@shadowen.org,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       Greg KH <greg@kroah.com>
References: <47DA2FD6.3000100@linux.vnet.ibm.com> <20080314150554.1b79a6ed.akpm@linux-foundation.org>
In-Reply-To: <20080314150554.1b79a6ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803142337.12605.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 14 of March 2008, Andrew Morton wrote:
> On Fri, 14 Mar 2008 13:27:10 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > The next-20080314 tree build fails 
> > 
> > drivers/serial/serial_core.c: In function `uart_add_one_port':
> > drivers/serial/serial_core.c:2359: error: invalid lvalue in assignment
> > make[2]: *** [drivers/serial/serial_core.o] Error 1
> > 
> > The config # CONFIG_PM was not set.The code which is causing the 
> > build failure is 
> > 
> > 	device_can_wakeup(tty_dev) = 1;
> > 
> > when the CONFIG_PM is set the macro is preprocessed as
> > 
> > #define device_can_wakeup(dev) \
> >         ((dev)->power.can_wakeup)
> > 
> > and when not set, it becomes 0 = 1 
> > 
> > #define device_can_wakeup(dev)                  0

Kamalesh, thanks for reporting the problem.

> Caused by Alan's "PM: make wakeup flags available whenever CONFIG_PM is
> set" which I assume Len merged.

It's in the Greg's tree actually.

> Sorry, but that code should be dragged out and shot.  Doing this:
> 
> > 	device_can_wakeup(tty_dev) = 1;
> 
> is just gross and stupid.  It looks daft, it isn't C and it *requires* that
> device_can_wakeup() be implemented as a macro, which totally busts any
> concept of abstraction.
> 
> 
> The code previously had quite reasonable accessors:
> 
>  #define device_set_wakeup_enable(dev,val) \
>         ((dev)->power.should_wakeup = !!(val))
>  #define device_may_wakeup(dev) \
>         (device_can_wakeup(dev) && (dev)->power.should_wakeup)
> 
> can we please go back to that scheme?  Please also convert all these
> magical macros into inlined C functions.  One reason is that this:
> 
> +#define device_init_wakeup(dev,val) \
> +       do { \
> +               device_can_wakeup(dev) = !!(val); \
> +               device_set_wakeup_enable(dev,val); \
> +       } while(0)
> 
> is buggy.  It evaluates its arguments multiple times and will cause
> failures when passed expressions which have side-effects.
> 
> Alan, please also pass all future patches through checkpatch - there is no
> need to be adding trivial coding-style errors in this day and age.
> 
> Thanks.

Well, Greg please drop the "PM: make wakeup flags available whenever CONFIG_PM
is set" and Alan please resubmit the patch with the problems pointed out by
Andrew fixed.

In fact I'd even prefer it to be two patches, one that moves should_wakeup and
the related macros out of the CONFIG_PM_SLEEP #ifdef, because that's what fixes
the problem described in the changelog, and one that makes the remaining
changes with a separate changelog.

Thanks,
Rafael
