Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0BQU32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:29:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab0BQU31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:29:27 -0500
Date: Wed, 17 Feb 2010 15:29:20 -0500
From: David Teigland <teigland@redhat.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: dlm: Remove/bypass astd
Message-ID: <20100217202920.GB29576@redhat.com>
References: <1266413019.2907.27.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266413019.2907.27.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 01:23:39PM +0000, Steven Whitehouse wrote:
> 
> While investigating Red Hat bug #537010 I started looking at the dlm's astd
> thread. The way in which the "cast" and "bast" requests are queued looked
> as if it might cause reordering since the "bast" requests are always
> delivered after any pending "cast" requests which is not always the
> correct ordering. This patch doesn't fix that bug, but it will prevent any
> races in that bit of code, and the performance benefits are also well
> worth having.
> 
> I noticed that astd seems to be extraneous to requirements. The notifications
> to astd are already running in process context, so they could be delivered
> directly. That should improve smp performance since all the notifications
> would no longer be funneled through a single thread.
> 
> Also, the only other function of astd seemed to be stopping the delivery
> of these notifications during recovery. Since, however, the notifications
> which are intercepted at recovery time are neither modified, nor filtered
> in any way, the only effect is to delay notifications for no obvious reason.
> 
> I thought that probably removing the astd thread and delivering the "cast"
> and "bast" notifications directly would improve performance due to the
> elimination of a scheduling delay. I wrote a small test module which
> creates a dlm lock space, and does 100,000 NL -> EX -> NL lock conversions.
> 
> Having run this test 10 times each on a 2.6.33-rc8 kernel and then the modified
> kernel including this patch, I got the following results:
> 
> Original: Avg time 24.62 us per conversion (NL -> EX -> NL)
> Modified: Avg time 9.93 us per conversion
> 
> Which is a fairly dramatic speed up. Please consider applying this patch.
> I've tested it in both clustered and single node GFS2 configurations. The test
> figures are from a single node configuration which was a deliberate choice
> in order to avoid any effects of network latency.

Wow, there's no chance I'm going to even consider something like this.
This would be a huge change in how the dlm has always operated, and would
surely introduce very serious and hard to identify bugs (and ones that may
not appear for a long time afterward).  Given that there's *no problem* with
the current method that has worked well for years, any change would be
completely crazy.

Dave

