Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbZA2MkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbZA2MkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 07:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZA2Mjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 07:39:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37803 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZA2Mjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 07:39:51 -0500
Date: Thu, 29 Jan 2009 12:39:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH C 06/13] OMAP3 clock: DPLLs should enter bypass if new rate is sys_ck
Message-ID: <20090129123936.GA16644@n2100.arm.linux.org.uk>
References: <20090128190724.12092.22239.stgit@localhost.localdomain> <20090128190823.12092.2638.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128190823.12092.2638.stgit@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 12:08:26PM -0700, Paul Walmsley wrote:
> This patch causes a DPLL to enter bypass when it is instructed to set
> its rate to that of its bypass clock.  Previously this was only possible
> after setting the DPLL rate, then disabling and re-enabling it.

The more I think about this, especially with reference to patch D1, the
more I'm convinced this is not entirely the right approach.

Patch D1 introduces the necessary mechanics to make clk_get_parent()
work.  If you use this on a PLL clock, and the PLL is in bypass mode,
it returns the non-bypass clock.

Now, I suspect that your first thought to resolving that would be to
add some complexity to clk_get_parent().  I advise against that.
Instead, arrange for clk->parent to _always_ point at the correct
parent clock, whether the PLL is in bypass mode or not.

In other words, encapsulate all the PLL mechanics localized inside
the PLL handling code and don't let them leak outside that code.
