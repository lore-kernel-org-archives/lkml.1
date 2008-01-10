Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbYAJXF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbYAJXF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYAJXFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:05:15 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51509 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYAJXFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:05:13 -0500
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long
	delays
From: john stultz <johnstul@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tony Luck <tony.luck@intel.com>, bob.picco@hp.com,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <1200005517.30225.75.camel@localhost.localdomain>
References: <20080109232914.676624725@goodmis.org>
	 <20080109233044.288563621@goodmis.org>
	 <1199923219.6350.16.camel@localhost.localdomain>
	 <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com>
	 <1199996959.6108.18.camel@localhost.localdomain>
	 <20080110204259.GB5836@Krystal>
	 <1200000314.30225.30.camel@localhost.localdomain>
	 <20080110220012.GA9508@Krystal>
	 <1200005517.30225.75.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 15:05:06 -0800
Message-Id: <1200006307.30225.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 14:52 -0800, john stultz wrote:
> The issue is that the race isn't just between the readers and the
> writer, but that time races against writer as well. So if you don't lock
> the readers out during the write, I'm not sure how you can avoid the
> window for inconsistencies.

Maybe to state it more clearly, the issue is that in order to be atomic,
the writer must atomically access the clock, and make all the updates in
one step.

So if a reader accesses the clock after the writer accesses the clock,
but before the writer finishes the update, there is the possibility time
could go backwards.

Now, not to completely throw water on it, It is possible to set up a
bounds argument, and say as long as NTP adjustments are less then X, and
the window between the writer starting and finishing the update is less
then Y, the resulting inconsistency is limited to Z. And if Z is less
then a nanosecond, then you're ok.

However, items like virtualization and the realtime patch can cause Y to
be stretched quite a bit, so finding a way to handle that would be
needed as well.

thanks
-john


