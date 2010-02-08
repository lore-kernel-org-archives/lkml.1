Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab0BHQao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 11:30:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab0BHQan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 11:30:43 -0500
Subject: Re: [RFC][PATCH] perf_events: added new start/stop PMU callbacks
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <4b703875.0a04d00a.7896.ffffb824@mx.google.com>
References: <4b703875.0a04d00a.7896.ffffb824@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 17:30:11 +0100
Message-ID: <1265646612.11509.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 17:06 +0200, Stephane Eranian wrote:
> 	In certain situations, the kernel may need to stop and start the
> 	same event rapidly. The current PMU callbacks do not distinguish
> 	between stop and release  (i.e., stop + free the resource). Thus,
> 	a counter may be released, then it will be immediately re-acquired.
> 	Event scheduling will again take place with no guarantee to assign
> 	the same counter. On some processors, this may event yield to failure
> 	to assign the event back due to competion between cores.
> 
> 	This patch is adding a new pair of callback to stop and restart a
> 	counter without actually release the underlying counter resource.
> 	On stop, the counter is stopped, its values saved and that's it.
> 	On start, the value is reloaded and counter is restarted (on x86,
> 	actual restart is delayed until perf_enable()).
> 	
> 	Note this patch does not provide support for non-X86 PMU. This needs
> 	to be added.
> 
> 	Signed-off-by: Stephane Eranian <eranian@google.com>
> --

I think we can do this much easier by adding a list_head to
hw_perf_event and make event_list into a proper list, then we can remove
that funny loop on remove and instead move the event to a remove_list
when there's a put_event_constraint() method and iterate that list on
hw_perf_enable().

But before we do that, I think we need to look at the /* hardware */
part of struct hw_perf_event, and make that arch specific, we've been
growing that a lot lately and I don't think !x86 uses any of that.

