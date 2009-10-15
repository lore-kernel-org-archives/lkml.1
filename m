Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbZJOPsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbZJOPsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760794AbZJOPsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:48:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54178 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759686AbZJOPsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:48:39 -0400
Date: Thu, 15 Oct 2009 16:49:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Remove or convert empty ioctls ?
Message-ID: <20091015164906.5b2c03db@lxorguk.ukuu.org.uk>
In-Reply-To: <4AD74151.7020306@garzik.org>
References: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain>
	<4AD711BC.2030409@garzik.org>
	<20091015160109.6d9353e8@lxorguk.ukuu.org.uk>
	<4AD73E40.1010501@garzik.org>
	<20091015163103.5e42fabe@lxorguk.ukuu.org.uk>
	<4AD74151.7020306@garzik.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 11:35:45 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> On 10/15/2009 11:31 AM, Alan Cox wrote:
> > EINVAL means you used an ioctl that is correct for the driver but that
> > for some reason the driver didn't like it.
> 
> Precisely.
> 
> The driver author proactively chose to implement the ioctl and return a 
> value other than ENOTTY.

Jeff - wake up - take coffee if neeeded.

The case in question is the case where ->unlocked_ioctl() == NULL. In
that case the driver author didn't implement anything and the correct
return from the layer doing the handling is -ENOTTY.

In the case where there is an ioctl handler the common 

foo_ioctl()
{
	return -EINVAL;
}

stub case is simply broken, and caused by the fact a lot of early Linux
drivers were wrong and people keep propogating mistakes (a serious
problem in the open source world is that most code is produced by copying
stuff but often by copying buggy code).

Essentially the only times you should be returning -EINVAL is where the
driver actually has


	case IOCWIBBLE:
		/* Do stuff */
		if (foo < 1)
			return -EINVAL;

All the "I don't know this" cases should be -ENOTTY.

There are cases where

	case IOCWIBBLE:
		return -EINVAL;

is correct but they are unusual - basically the case where the driver
author wants to "support" the ioctl but there is no argument that it can
be given which is correct.


Anyway the case discussed which is ".unlocked_ioctl = NULL" should return
-ENOTTY, and there isn't any argument about the driver authors intentions.
