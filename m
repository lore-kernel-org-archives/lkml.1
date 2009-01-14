Return-Path: <linux-kernel-owner+w=401wt.eu-S1759763AbZANGDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763AbZANGDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759269AbZANGCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:02:50 -0500
Received: from mail.gmx.net ([213.165.64.20]:34526 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758895AbZANGCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:02:49 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/f3rxQ0tDf/vUurgJ+hC2LvL87WJe+6E6DB7KxaA
	bjHA014268ClZ2
Subject: Re: [BUG] How to get real-time priority using idle priority
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Brian Rogers <brian@xyzw.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090114053106.GA10410@elte.hu>
References: <4969D0D7.2060401@xyzw.org>
	 <1231736941.6003.7.camel@marge.simson.net>
	 <1231765433.5789.35.camel@marge.simson.net> <20090112131406.GB670@elte.hu>
	 <496BE8F6.1040308@xyzw.org> <1231815523.5899.7.camel@marge.simson.net>
	 <1231910014.610.14.camel@marge.simson.net> <20090114053106.GA10410@elte.hu>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 07:02:45 +0100
Message-Id: <1231912965.956.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 06:31 +0100, Ingo Molnar wrote:
> What about increasing the weight of SCHED_IDLE tasks from 1 to 2 or 3? 
> That still makes them mega-nice (which is more than enough), but should 
> make the math a lot less borderline.

The weight is currently 2, inv_weight is 1 << 31, which is correct.

I implemented the advance min_vruntime at nice 0 thing, and that seems
to work fine.  SCHED_IDLE tasks slam right as they execute, but check
out how _far_ right they slam.  This was with the build pinned to cpu 3,
so no migration issues.  I'll try weight of 3.

cfs_rq[3]:
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 281842722.745713
  .min_vruntime                  : 370490.315434
  .max_vruntime                  : 281843966.887081
  .spread                        : 1244.141368
  .spread0                       : 85467.080507
  .nr_running                    : 6
  .load                          : 12
  .nr_spread_over                : 0

rt_rq[3]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            make 29977 281843914.902150       171   120               0               0               0.000000               0.000000               0.000000
            make 30530 281842722.745713         6   120               0               0               0.000000               0.000000               0.000000
             gcc 30584 281843921.282161         1   120               0               0               0.000000               0.000000               0.000000
              sh 30590 281843966.887081         2   120               0               0               0.000000               0.000000               0.000000
             gcc 30591 281843882.274316         1   120               0               0               0.000000               0.000000               0.000000
R            cc1 30592    372734.946902         5   120               0               0               0.000000               0.000000               0.000000



