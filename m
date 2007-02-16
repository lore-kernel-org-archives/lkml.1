Return-Path: <linux-kernel-owner+w=401wt.eu-S1945904AbXBPPOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945904AbXBPPOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945907AbXBPPOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:14:19 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35325 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945904AbXBPPOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:14:18 -0500
Date: Fri, 16 Feb 2007 18:06:19 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Michael Holzheu <holzheu2@linux.vnet.ibm.com>
Cc: akpm@osdl.org, mschwid2@de.ltcfwd.linux.ibm.com, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Using kevent for event logging?
Message-ID: <20070216150618.GA25878@2ka.mipt.ru>
References: <20070216155708.589cd47a.holzheu2@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070216155708.589cd47a.holzheu2@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 16 Feb 2007 18:06:21 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 03:57:08PM +0100, Michael Holzheu (holzheu2@linux.vnet.ibm.com) wrote:
> Hallo Evgeniy,

Hi Michael.

> On s390 we are looking for a good mechanism to notify userspace
> about kernel events. Currently such events are handled with printks
> in most cases. There are automation tools, which want to automatically
> react on kernel events. To get the event information, these tools are
> parsing printks, which is not a really good mechanism for that
> purpose.
> 
> When I read about kevents, I was wondering, if it could be used to solve
> this problem. E.g. it would be possible to put an event number into a
> kevent and provide another interface to get the complete event data.
> 
> Do you think, that kevent could be used for this purpose?

You will need to have implemented two types of operations - userspace
daemon, which will request some notifications (i.e. notify me when event
type:1, event:2 is ready), and that one which will mark such requests as
ready.

For exactly your purpose I would use userspace kevent notifications - 
although in documentation I say that such notifications can be
marked from userspace, you can mark them as ready from kernel too
(obviously, since kevent is kernel mechanism).

You can also create own kevent notification type and storage (userspace
notification requests are stored in the main kevent queue (kevent_user))
and compile them only for s390 arch and thus do not overlap with
possible usage of userspace notifications.

As another tool to do the same I would suggest netlink (raw netlink
usage is not appreciated, but instead you can use connector or
gennetlink).

Kevent is much more lightweight especially when event is marked as ready
compared to netlink allocation. From the other point, kevent requires
some requests from userspace which can be marked as ready, while netlink
allows to generate them from 'void' (i.e. withoug userspace creating
request).

> Michael

-- 
	Evgeniy Polyakov
