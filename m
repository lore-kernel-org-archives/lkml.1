Return-Path: <linux-kernel-owner+w=401wt.eu-S933861AbXCSNbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861AbXCSNbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 09:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933898AbXCSNbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 09:31:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47324 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933897AbXCSNbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 09:31:50 -0400
Date: Mon, 19 Mar 2007 13:31:49 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [S390] minor fault path optimization.
Message-ID: <20070319133149.GA5781@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-arch@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319130206.GC1292@skybase>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 02:02:06PM +0100, Martin Schwidefsky wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> [S390] minor fault path optimization.
> 
> The minor fault path has grown a lot in terms of cycles. In particular
> the kprobes hook is very costly. Optimize the path to save a couple of
> cycles. If kprobes is enabled more than 300 cycles can be avoided if 
> kprobes_running() is false.

Actually there is a lot more fishy here.  This code is duplicated over
every single architecture.  It uses a notifier chain that only ever has
one actual uaesr.  It exports interfaces that are potential harmful.

Please do the right thing to optimize this instead and rip out the brandead
notifier chain mechanisms and directly call into the krobes handler if
kprobes are active, in particular the DIE_PAGE_FAULT: case of 
kprobe_exceptions_notify.  That allows you to optimize the path both
if kprobes are active, and even further if they're not.

The same should be done for all other architectures, and the other
(ab-)uses of  the kprobes notifiers.
