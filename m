Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbYHEXHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbYHEXHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbYHEXFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:05:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59677 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754694AbYHEXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:05:26 -0400
Date: Tue, 5 Aug 2008 18:05:21 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
Message-Id: <20080805180521.be7010e1.pj@sgi.com>
In-Reply-To: <4898B873.6000308@qualcomm.com>
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
	<20080802063900.6615e5ca.pj@sgi.com>
	<48948C3A.6050805@qualcomm.com>
	<20080802225127.2b0d138b.pj@sgi.com>
	<4895F3ED.4020805@qualcomm.com>
	<20080804010033.0d1b0549.pj@sgi.com>
	<48977E81.4040207@qualcomm.com>
	<20080804225636.541527e8.pj@sgi.com>
	<4898B873.6000308@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> It could I guess. But the questions is why ?
> I mean the only reason we've introduced workqueue is because lock 
> nesting got too complicated. Otherwise in all those paths we're already 
> in a process context and there is no need to schedule a workqueue.

My priorities are different than yours.

You look at a code path that, in some cases, is more involved than
necessary, and recommend providing an alternative code path, for
the cases that can get by executing (significantly) fewer CPU cycles.

I look at the number of code paths, lines of code, duplicated code
and number of tests and conditions in the source code, and ask how
to reduce them.  I want the least amount of source code, the fewest
alternative paths through that code, the smallest number of logical
tests and code variants, the least amount of code duplication.

The key in this case is that I prefer having just one code path by
which all rebuilds of sched domains are done.  Since that rebuild must
be asynchronous for some cases (to avoid ABBA lock nesting problems)
therefore let all sched domains be done by that async path.

The fewer the number of code path variants, the easier it is to
understand the code, and the harder it is to break the code.

Except for frequently executed code paths, which this surely is not,
minimizing software maintenance costs is far more important to me than
minimizing CPU cycles.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
