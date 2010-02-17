Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab0BQONv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 09:13:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509Ab0BQONu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 09:13:50 -0500
Subject: Re: [Cluster-devel] dlm: Remove/bypass astd
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
       Joel Becker <joel.becker@oracle.com>
In-Reply-To: <4B7BF28E.5060405@redhat.com>
References: <1266413019.2907.27.camel@localhost>
	 <4B7BF28E.5060405@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 17 Feb 2010 14:17:03 +0000
Message-ID: <1266416223.2907.40.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2010-02-17 at 13:43 +0000, Christine Caulfield wrote:
> One of the reasons that ASTs are delivered in a separate thread was to 
> allow ASTs do do other locking operations without causing a deadlock. 
> eg. it would allow locks to be dropped or converted inside a blocking 
> AST callback routine.
> 
Hmm... GFS2 doesn't require that at all, nor is it ever likely to since
we have the glock layer to deal with that. I've looked at the OCFS2 code
and I don't think they need it either - maybe Mark or Joel can confirm
that for certain. Those are the only two users at the moment.

If it were to be the case that locking operations were being done in the
context of the astd thread, the performance would be pretty poor since
its a single thread no matter how many locks and lock spaces are in use.
The only reasonable use for such a thing would also involve having to
deal with the cache control for the locked object too (which for all
current cases means disk I/O and/or cache invalidation), which would
then also be limited to this single thread.

> So maybe either the new code already allows for this or it's 
> functionality that's not needed in the kernel. It should still be an 
> option for userspace applications, but that's a different story 
> altogether, of course
> 
> Chrissie
> 
Yes, I've left the userspace interface code alone for now. That
continues to work in the original way. My main concern is with the
kernel interface at the moment,

Steve.

> On 17/02/10 13:23, Steven Whitehouse wrote:
> >
> > While investigating Red Hat bug #537010 I started looking at the dlm's astd
> > thread. The way in which the "cast" and "bast" requests are queued looked
> > as if it might cause reordering since the "bast" requests are always
> > delivered after any pending "cast" requests which is not always the
> > correct ordering. This patch doesn't fix that bug, but it will prevent any
> > races in that bit of code, and the performance benefits are also well
> > worth having.
> >
> > I noticed that astd seems to be extraneous to requirements. The notifications
> > to astd are already running in process context, so they could be delivered
> > directly. That should improve smp performance since all the notifications
> > would no longer be funneled through a single thread.
> >
> > Also, the only other function of astd seemed to be stopping the delivery
> > of these notifications during recovery. Since, however, the notifications
> > which are intercepted at recovery time are neither modified, nor filtered
> > in any way, the only effect is to delay notifications for no obvious reason.
> >
> > I thought that probably removing the astd thread and delivering the "cast"
> > and "bast" notifications directly would improve performance due to the
> > elimination of a scheduling delay. I wrote a small test module which
> > creates a dlm lock space, and does 100,000 NL ->  EX ->  NL lock conversions.
> >
> > Having run this test 10 times each on a 2.6.33-rc8 kernel and then the modified
> > kernel including this patch, I got the following results:
> >
> > Original: Avg time 24.62 us per conversion (NL ->  EX ->  NL)
> > Modified: Avg time 9.93 us per conversion
> >
> > Which is a fairly dramatic speed up. Please consider applying this patch.
> > I've tested it in both clustered and single node GFS2 configurations. The test
> > figures are from a single node configuration which was a deliberate choice
> > in order to avoid any effects of network latency.
> >
> > Signed-off-by: Steven Whitehouse<swhiteho@redhat.com>
> > ---


