Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbXEJVBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbXEJVBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761815AbXEJVBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:01:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53526
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761787AbXEJVBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:01:35 -0400
Date: Thu, 10 May 2007 14:01:38 -0700 (PDT)
Message-Id: <20070510.140138.133012852.davem@davemloft.net>
To: rmk+lkml@arm.linux.org.uk
Cc: cw@f00f.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070510204037.GE29713@flint.arm.linux.org.uk>
References: <20070510203417.GA23019@tuatara.stupidest.org>
	<20070510204037.GE29713@flint.arm.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+lkml@arm.linux.org.uk>
Date: Thu, 10 May 2007 21:40:38 +0100

> On Thu, May 10, 2007 at 01:34:18PM -0700, Chris Wedgwood wrote:
> > MODPOST seems to be spewing bogus warnings.  It's not clear how best
> > to fix it so perhaps we should silence it for now?
> 
> I agree.  Example bogus warning:
> 
> WARNING: arch/arm/mach-iop32x/built-in.o - Section mismatch:
>  reference to .init.text: from .data between 'iq80321_timer'
>  (at offset 0x428) and 'iq80321_serial_device'
> 
> c04088fc d iq80321_timer
> c0408950 d iq80321_serial_device
> 
> It's completely unclear what is referencing what, what the two named
> symbols mean, and even what "at offset" relates to.
> 
> What I can say is that iq80321_timer doesn't reference iq80321_serial_device
> nor vice versa, and iq80321_timer is far smaller than 0x428 bytes.

The range of symbols is just provided to handle inaccuracies
in mid-function and mid-object references, it actually helps.

In this particular case iq80321_timer, which is not init-data,
is referencing iq80321_timer_init() which is init.text

If this is legitimate (which I believe this case is, the init function
method can be init but the offset one is not), add an exception case
like we already have for console drivers et al. to modpost.c and this
warning will go away.
