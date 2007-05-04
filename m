Return-Path: <linux-kernel-owner+w=401wt.eu-S1161856AbXEDFrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161856AbXEDFrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031353AbXEDFrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:47:24 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56988 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031349AbXEDFrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:47:23 -0400
Subject: Re: kernel/relay.c: a strange usage of delayed_work
From: Tom Zanussi <zanussi@us.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Karim Yaghmour <karim@opersys.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070503213835.GA243@tv-sign.ru>
References: <200704260110.22224.rjw@sisk.pl>
	 <20070425165410.b73443b4.akpm@linux-foundation.org>
	 <20070426100922.GB12892@in.ibm.com> <20070426101547.GA97@tv-sign.ru>
	 <20070426125838.GC12892@in.ibm.com>
	 <20070427184258.62794053.akpm@linux-foundation.org>
	 <20070503213835.GA243@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 04 May 2007 00:42:30 -0500
Message-Id: <1178257351.4623.16.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 01:38 +0400, Oleg Nesterov wrote:
> relay_switch_subbuf() does schedule_delayed_work(&buf->wake_readers, 1),
> wakeup_readers() only does wake_up_interruptible() and nothing more.
> 
> Why can't we use a plain timer for this?
> 
> In any case, this "wake_up ->read_wait after a minimal possible delay"
> looks somewhat strange to me, could you explain? just curious.
> 

The reason it's done that way is that if the event that causes the
relay_switch_subbuf() happens to be an event logged from schedule(), and
we directly call wake_up_interruptible() at that point, we lock up the
machine because it ends up back in schedule().  Deferring it avoids the
problem.

I don't see any problem with using a plain timer instead - I'll work up
a patch to make that change.

Tom



