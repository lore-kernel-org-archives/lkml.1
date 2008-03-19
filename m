Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbYCSTaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbYCSTaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYCST0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:26:14 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:62420 "EHLO
	viefep23-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753540AbYCST0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:26:04 -0400
Subject: Re: volanoMark 12% regression with 2.6.25-rc6
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1205894373.3215.621.camel@ymzhang>
References: <1205831650.3215.569.camel@ymzhang>
	 <20080318195807.GA26887@elte.hu>  <1205871732.6487.6.camel@lappy>
	 <1205894373.3215.621.camel@ymzhang>
Content-Type: text/plain
Date: Wed, 19 Mar 2008 15:01:39 +0100
Message-Id: <1205935299.8514.380.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-19 at 10:39 +0800, Zhang, Yanmin wrote:
> On Tue, 2008-03-18 at 21:22 +0100, Peter Zijlstra wrote:
> > On Tue, 2008-03-18 at 20:58 +0100, Ingo Molnar wrote:
> > > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > > 
> > > > Comparing with 2.6.25-rc5, volanoMark has 12% regression with 
> > > > 2.6.25-rc6 on my 8-core stoakley.
> > > 
> > > could you try sched/latest please? You can pick it up via:
> > > 
> > >   http://people.redhat.com/mingo/sched-devel.git/README
> > 
> > Yanmin, how do you use volanomark; I got it from:
> > 
> >   http://www.volano.com/benchmarks.html
> > 
> > and am using java-1.6.0-openjdk.x86_64
> > I installed it /dev/shm/vmark to avoid disk io ruining anying
> volanoMark doesn't have much disk I/O when running.
> 
> > 
> > But I'm getting very fluctuating results, from ~43000 msgs/s to 52000
> > msgs/s.
> > 
> > This makes it very hard to 'trust' this benchmark, let alone determine a
> > regression.
> 
> Mostly, you need change startup.sh. I attach my startup.sh for your reference.
> I use jrockit-R27.3.1-jre1.5.0_11.
> 
> The steps to run it:
> export JAVA_HOME=XXX_your_java_home
> export LOOP_CLIENT_COUNT=25000
> export LOOP_CLIENT_REPEAT_TIMES=3
> export java_option="-Xmx1500m -Xms1500m -Xns750m -XXaggressive -XXlazyUnlocking -Xgc:genpar -XXtlasize:min=16k,preferred=64k"
> ../loopserver.sh bea50 &
> sleep 5# wait for server to be ready
> loopclient.sh bea50
> 
> You can set LOOP_CLIENT_REPEAT_TIMES=1 to run it quickly.
> 
> I enclose above steps into my scripts and just copy it out for your reference.

Thanks, I reduced COUNT to 2500, otherwise it took ages on my slowly
machine :-) Also, I don't have jrocket, so I stuck with openjdk as that
is the official open source JRE (afaik).

Using the below patch, I get:

sched_features=319:
Average throughput = 65984 messages per second
Average throughput = 64568 messages per second
Average throughput = 66059 messages per second

sched_features=63:
Average throughput = 52536 messages per second
Average throughput = 53592 messages per second
Average throughput = 51705 messages per second

Which seems to suggest the current code does better for me.

(fwiw this is with compat_yield=0)

sched_features=319, sched_compat_yield=1:
Average throughput = 47669 messages per second
Average throughput = 47435 messages per second
Average throughput = 47120 messages per second

[ this is in stark contradiction to all these Java _needs_
  compat_yield=1 stories I keep hearing.. ]

This is on a single dual core opteron.

So given these numbers, I'm inclined to say openjdk is a better behaving
JRE than jrocket - but what do I know about these things :-)

---

diff --git a/kernel/sched.c b/kernel/sched.c
index cc47766..32363cc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -714,6 +714,7 @@ enum {
 	SCHED_FEAT_SYNC_WAKEUPS		= 32,
 	SCHED_FEAT_HRTICK		= 64,
 	SCHED_FEAT_DOUBLE_TICK		= 128,
+	SCHED_FEAT_NORMALIZED_SLEEPER	= 256,
 };
 
 const_debug unsigned int sysctl_sched_features =
@@ -724,7 +725,8 @@ const_debug unsigned int sysctl_sched_features =
 		SCHED_FEAT_CACHE_HOT_BUDDY	* 1 |
 		SCHED_FEAT_SYNC_WAKEUPS		* 1 |
 		SCHED_FEAT_HRTICK		* 0 |
-		SCHED_FEAT_DOUBLE_TICK		* 0;
+		SCHED_FEAT_DOUBLE_TICK		* 0 |
+		SCHED_FEAT_NORMALIZED_SLEEPER	* 1;
 
 #define sched_feat(x) (sysctl_sched_features & SCHED_FEAT_##x)
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fd01aab..3dc4a1a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -501,8 +501,11 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS)) {
-			vruntime -= calc_delta_fair(sysctl_sched_latency,
-						    &cfs_rq->load);
+			if (sched_feat(NORMALIZED_SLEEPER))
+				vruntime -= calc_delta_fair(sysctl_sched_latency,
+						&cfs_rq->load);
+			else
+				vruntime -= sysctl_sched_latency;
 		}
 
 		/* ensure we never gain time by being placed backwards. */


