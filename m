Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbXF3DDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbXF3DDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbXF3DDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:03:46 -0400
Received: from science.horizon.com ([192.35.100.1]:18650 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752412AbXF3DDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:03:45 -0400
Date: 29 Jun 2007 23:03:43 -0400
Message-ID: <20070630030343.31711.qmail@science.horizon.com>
From: linux@horizon.com
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: 2.6.22-rcX Transmeta/APM regression
Cc: ak@suse.de, bk@suse.de, hpa@zytor.com, linux@horizon.com,
       michal.k.k.piotrowski@gmail.com
In-Reply-To: <20070627153114.17953.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, after a ridiculous amount of bisecting and recompiling and
rebooting...

First I had to find out that the kernel stops booting as of
bf50467204: "i386: Use per-cpu GDT immediately on boot"
(With theis commit, it silently stops booting.  The GP fault I
posted earlier comes a little later, but I didn't bother finding it.)

and starts again as of
b0b73cb41d: "i386: msr.h: be paranoid about types and parentheses"

However, one commit before the former suspends properly, and the latter
fails to suspend (exactly the same problem at get_fixed_ranges+0x9/0x60),
so I had to bisect further between the two, backporting the msr.h changes
across the msr-index.h splitoff.

Anyway, the patch which introduces the problem is the aptly named 3ebad:
3ebad59056: [PATCH] x86: Save and restore the fixed-range MTRRs of the BSP when suspending

2.6.22-rc6 plus that one commit reverted successfully does APM suspend
(and resume) for me.
