Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbXLDLaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbXLDLaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 06:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXLDLaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 06:30:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52654 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbXLDLaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 06:30:21 -0500
Date: Tue, 4 Dec 2007 03:29:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
Message-Id: <20071204032949.c677c021.akpm@linux-foundation.org>
In-Reply-To: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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

My ia64 allmodconfig build has taken

akpm     15700 89.6  0.0   8256   700 pts/4    RN+  03:09  10:41 bc -q kernel/timeconst.bc

11 minutes so far.  fc6/x86_64.


