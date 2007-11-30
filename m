Return-Path: <linux-kernel-owner+w=401wt.eu-S934563AbXK3By4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563AbXK3By4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 20:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759739AbXK3Byn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 20:54:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763600AbXK3Bym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 20:54:42 -0500
Date: Thu, 29 Nov 2007 17:54:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
Message-Id: <20071129175440.ead82de6.akpm@linux-foundation.org>
In-Reply-To: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 16:19:51 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> When the conversion factor between jiffies and milli- or microseconds
> is not a single multiply or divide, as for the case of HZ == 300, we
> currently do a multiply followed by a divide.  The intervening
> result, however, is subject to overflows, especially since the
> fraction is not simplified (for HZ == 300, we multiply by 300 and
> divide by 1000).
> 
> This is exposed to the user when passing a large timeout to poll(),
> for example.
> 
> This patch replaces the multiply-divide with a reciprocal
> multiplication on 32-bit platforms.  When the input is an unsigned
> long, there is no portable way to do this on 64-bit platforms there is
> no portable way to do this since it requires a 128-bit intermediate
> result (which gcc does support on 64-bit platforms but may generate
> libgcc calls, e.g. on 64-bit s390), but since the output is a 32-bit
> integer in the cases affected, just simplify the multiply-divide
> (*3/10 instead of *300/1000).
> 
> The reciprocal multiply used can have off-by-one errors in the upper
> half of the valid output range.  This could be avoided at the expense
> of having to deal with a potential 65-bit intermediate result.  Since
> the intent is to avoid overflow problems and most of the other time
> conversions are only semiexact, the off-by-one errors were considered
> an acceptable tradeoff.
> 
> NOTE: This patch uses a bc(1) script to compute the appropriate
> constants.

Does this add the first dependency upon the availability of bc?
