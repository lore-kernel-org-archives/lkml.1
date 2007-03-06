Return-Path: <linux-kernel-owner+w=401wt.eu-S1751226AbXCFUHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbXCFUHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbXCFUHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:07:11 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:26398 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXCFUHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:07:08 -0500
Date: Tue, 6 Mar 2007 12:06:50 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Bill Irwin <bill.irwin@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
Message-ID: <20070306200650.GB18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <45E5913D.3080505@redhat.com> <20070228204144.GA32316@one.firstfloor.org> <20070304015031.GA4224@holomorphy.com> <45EDBA1B.8050007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EDBA1B.8050007@redhat.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin wrote:
>> Chuck, is any of this of any use to you?

On Tue, Mar 06, 2007 at 01:59:39PM -0500, Chuck Ebbert wrote:
> I said "simple." :)
> In the 4k/4k stack i386 kernel, is there any fundamental reason it
> can't be 4k/8k? We seem to be mostly hitting problems in overflowing
> the IRQ stack... I think. Overhead would only be 4k per CPU for that.

current is derived from current_thread_info()->task which is in turn
derived from the stack pointer. Using segmentation to derive per-thread
state would allow i386 to make IRQ and task stack-sizes independent.
There are beginnings of this in the i386 PDA code.

A patch to allow 8K/8K is relatively simple and may serve your
purposes. vmalloc() of the task and IRQ stacks has negative
performance and resource scalability implications, though it's not
particularly involved. It also ensures no memory corruption can occur
from stack overflow save in the case of stack frames larger than a
page, where furthermore the procedure references distant locations
prior to close ones, such as a reverse array walk. Allowing larger
stacksizes than 8K doesn't seem to be of interest to you, probably due
to the negative resource scalability implications, though it may
stabilize some workloads.

I'm not sure what to say on the simplicity front apart from patches
consisting largely of Kconfig edits are demonstrably simple. There
really wasn't much to any of this from my POV, but I do understand
that others may differ particularly on the stack vmalloc() front.
The individual patches of the series are mostly independent save for
textual affairs, and I intended for users to cherrypick whatever
strategies they preferred as per the config options provided. An
individual patch for the preferred strategy can also be respun in
isolation, if any of those provided are considered desirable.

Otherwise I suppose I can actually make use of the PDA to make the
IRQ stacksize independent of the task stacksize.


-- wli
