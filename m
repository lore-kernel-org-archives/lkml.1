Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZCISRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZCISRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZCISQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:16:59 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:37109 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZCISQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:16:58 -0400
Message-ID: <49B55D10.7060707@freescale.com>
Date: Mon, 09 Mar 2009 13:16:48 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com
Subject: Re: [PATCH v2] add function spin_event_timeout()
References: <1236611904-9843-1-git-send-email-timur@freescale.com> <1236614775.8389.692.camel@laptop>
In-Reply-To: <1236614775.8389.692.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> This changelog utterly fails to justify this interface. And to me it
> seems a rather bad one. 

I'll update the commit to include a justification, but in the meantime,
let me answer your question.

The primary purpose of this macro is to provide a way for drivers to
poll a status register waiting for a bit to change.  In most cases, this
 bit should change very quickly, even within a few cycles.  The timeout
is used as a way to easily deal with situations where the hardware is
misprogrammed such that the bit never changes.

Too often, developers do something like this:

	while (!(in_be32(&ssi->sisr) & CCSR_SSI_SISR_RFF0));

If something goes wrong and RFF0 never gets set, then this loop will
never exit.  So to encourage developers to do it the right way, and to
make it simpler to identify code which does this sort of thing, I'm
introducing spin_event_timeout().

> Why would we ever be wanting to spin in order of
> jiffies?

I picked jiffies because it seems straightforward, but I think I see
your point.  It has two drawbacks:

1) It's too coarse of a time measurement.  Most people will probably use
a value of 1 or 2.

2) It can't be used if interrupts are disabled, because then jiffies
won't be updated.

So I can switch that to using ndelay().

-- 
Timur Tabi
Linux kernel developer at Freescale
