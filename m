Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab0BYK0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:26:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47053
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759028Ab0BYK0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:26:00 -0500
Date: Thu, 25 Feb 2010 02:26:18 -0800 (PST)
Message-Id: <20100225.022618.256301798.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
CC: paulus@samba.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: perf per-symbol histogram causes memory corruption
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When builtin-annotate.c processes sample events via
process_sample_event() it uses 'sample_filter'

sample_filter() sizes the histogram object for a symbol based upon the
size, calculated as "sym->end - sym->start", to determine the number
of IP sample slots to allocate.

The problem is, the sym->end value is not stable at this point.

For example, dso__load_sym() first loads all of the symbols, then it
makes another pass over the symbols by calling symbols__fixup_end()
which will adjust the sym->end values of various symbols.

At this point, the histogram IP sample array allocated by
sample_filter() can become too small, and hits recorded can thus
access past the end of the array corrupting memory.

I get this very reliably on sparc64, and it took me a few days to root
cause this. :-)

I don't see an immediate way to fix this, any ideas?

