Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZK2GGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZK2GGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 01:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbZK2GGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 01:06:00 -0500
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.105]:23980
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbZK2GGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 01:06:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AggBAKidEUt8qMDu/2dsb2JhbAAI02aEMQQ
X-IronPort-AV: E=Sophos;i="4.47,307,1257091200"; 
   d="scan'208";a="76927862"
Subject: Re: Why does the disk still thrash when I have no swap?
From: Ben Nizette <bn@niasdigital.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
In-Reply-To: <4B11FFCE.5050002@shikadi.net>
References: <4B11FFCE.5050002@shikadi.net>
Content-Type: text/plain
Date: Sun, 29 Nov 2009 17:06:26 +1100
Message-Id: <1259474786.4467.129.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-29 at 14:59 +1000, Adam Nielsen wrote:
> Could it be that the disk cache was 
> forced to shrink and suddenly all accesses to the filesystem became unbuffered 
> and incredibly slow?  Why would this stop the X11 mouse cursor from moving?

Pretty much, yeah.  Well, not so much that the filesystem became
unbuffered, the new files you're accessing would have still been pulled
in to RAM, but rather all the old files you were no longer accessing but
were still in memory had to hit the disk before new allocations could
succeed.

Given the modern programmer's love of OOP, pretty much every action you
can think of causes a massive number of (generally small) allocations
and even though each one would likely free shortly after, could still
potentially trigger a dirty page writeback before the allocation would
succeed.

This is one of my pet annoyances - most OOP programmers forget that
object creation is potentially IO-bound in low memory situations (either
by swap or by pagecache writeback) and wonder why seemingly innocuous
things like "new Integer()" can take many seconds to complete!

	--Ben.

