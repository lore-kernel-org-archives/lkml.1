Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZJLMs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZJLMs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZJLMsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:48:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:37936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZJLMsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:48:55 -0400
Subject: Re: [PATCH] panic.c: export panic_on_oops
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091012123630.GA23285@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	 <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost>
	 <20091012113758.GB11035@elte.hu>
	 <20091012140149.6789efab@marrow.netinsight.se>
	 <20091012120951.GA16799@elte.hu>
	 <1255349748.10605.13.camel@macbook.infradead.org>
	 <20091012122023.GA19365@elte.hu>
	 <1255350798.10605.19.camel@macbook.infradead.org>
	 <20091012123630.GA23285@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 13:48:03 +0100
Message-Id: <1255351683.30919.5.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 14:36 +0200, Ingo Molnar wrote:
> Well other than not using sleeping locks in that codepath it should be 
> properly serializable. If the serial driver, netconsole, fbcon and all 
> the other non-trivial console drivers can do it then MTD should be able 
> to do it too.

It's distinctly non-trivial. A 'real' user of the hardware may have just
triggered a block erase, which could take hundreds (or even thousands)
of milliseconds to complete. We can't always suspend that erase; do we
really want to _wait_ for it?

If we're actually in a _panic_ situation, then yes -- we want to wait,
and that's what the device driver's panic_write() method should do.

But for less critical output? I'm not so sure.

Of course, I'm currently looking at revamping the MTD APIs so they're
not entirely synchronous, and are queue-based like the block device API.
Then the console ->write() method could just queue the write, and we
need some other logic to ensure that it really does _happen_ when the
system crashes. A kind of 'purge queue of console writes' function in a
panic handler... except that as you point out, sometimes we actually
want that even when we haven't actually panicked.

-- 
dwmw2

