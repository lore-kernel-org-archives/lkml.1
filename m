Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYE3KMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYE3KMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 06:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYE3KMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 06:12:33 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37540 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbYE3KMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 06:12:32 -0400
Date: Fri, 30 May 2008 15:51:21 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl, pj@sgi.com,
       Balbir Singh <balbir@in.ibm.com>, aneesh.kumar@linux.vnet.ibm.com
Subject: Re: fair group scheduler not so fair?
Message-ID: <20080530102121.GG12836@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <4834B75A.40900@nortel.com> <20080527171528.GD30285@linux.vnet.ibm.com> <483C4F5A.2010104@nortel.com> <20080528163318.GG30285@linux.vnet.ibm.com> <483DA5E7.5050600@nortel.com> <20080529164607.GC12836@linux.vnet.ibm.com> <483F207D.4010908@nortel.com> <20080530064324.GA29381@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530064324.GA29381@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 12:13:24PM +0530, Dhaval Giani wrote:
> > Also, although the long-term results are good, the shorter-term fairness 
> > isn't great.  Is there a tuneable that would allow for a tradeoff between 
> > performance and fairness?  I have people that are looking for within 4% 
> > fairness over a 1sec interval.
> >
> 
> How fair does smp fairness look for a !group scenario? I don't expect
> group schould be able to do much better.

Just tested this combo for !group case:

	1 nice0 (weight = 1024)
	2 nice3 (each weight = 526)
	3 nice5 (each weight = 335)

You'd expect nice0 to get (on a 2 cpu system):

	2 * 1024 / (1024 + 2*526 + 3*335) = 66.47

This is what I see over a 10sec interval (error = 6%):

 4386 root      20   0  1384  228  176 R 60.4  0.0   3:06.75  1 nice0
 4387 root      23   3  1384  232  176 R 37.9  0.0   1:57.03  0 nice3
 4388 root      23   3  1384  228  176 R 37.9  0.0   1:57.24  0 nice3
 4390 root      25   5  1384  228  176 R 24.1  0.0   1:14.62  0 nice5
 4391 root      25   5  1384  228  176 R 19.8  0.0   1:01.26  1 nice5
 4389 root      25   5  1384  228  176 R 19.7  0.0   1:01.12  1 nice5

Over 120sec interval (error still as high as 6%):

 4386 root      20   0  1384  228  176 R 60.4  0.0   6:13.95  1 nice0
 4388 root      23   3  1384  228  176 R 37.9  0.0   3:54.69  0 nice3
 4387 root      23   3  1384  232  176 R 37.9  0.0   3:54.44  0 nice3
 4390 root      25   5  1384  228  176 R 24.2  0.0   2:29.45  0 nice5
 4391 root      25   5  1384  228  176 R 19.8  0.0   2:02.56  1 nice5
 4389 root      25   5  1384  228  176 R 19.8  0.0   2:02.44  1 nice5

The high error could be because of interference from other tasks. Anyway I 
dont think !group case is better at achieving fairness over shorter
intervals.


-- 
Regards,
vatsa
