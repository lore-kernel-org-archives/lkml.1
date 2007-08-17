Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXHQKo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXHQKo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 06:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXHQKoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 06:44:19 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:34646
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbXHQKoS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 06:44:18 -0400
Message-Id: <46C5982F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 17 Aug 2007 11:44:31 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: recursive use of bust_spinlocks()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Various architectures may call bust_spinlocks() recursively (when calling die() in
the context do an unresolved page fault); the function itself, however, doesn't
appear to be meant to be called in this manner. Nevertheless, this doesn't
appear to be a problem as long as bust_spinlocks(0) doesn't get called twice
in a row (otherwise, unblank_screen() may enter the scheduler). However, at
least on i386 die() has been capable of returning (and on other architectures
this should really be that way, too) when notify_die() returns NOTIFY_STOP.

The question now is: Should bust_spinlocks() increment/decrement
oops_in_progress (and kick klogd only when the count drops to zero), or
should we just avoid entering the scheduler by forcibly setting
oops_in_progress to 1 prior to calling unblank_screen(), or should all
architectures currently doing so avoid calling bust_spinlocks() recursively?

Further, many (if not all) architectures seem to have adopted the recursive
die() invocation protection. However, the logic there unconditionally calls
spin_unlock_irqrestore() (besides also allowing for bust_spinlocks() to be
used recursively), instead of undoing just what had been done for the
current function invocation.

Suggestions?

Thanks, Jan

