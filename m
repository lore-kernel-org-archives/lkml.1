Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbZJGRLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbZJGRLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759524AbZJGRLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:11:33 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:64899 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759515AbZJGRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:11:32 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for CPU"
Date: Wed, 7 Oct 2009 19:10:52 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
References: <200910051500.55875.elendil@planet.nl> <20091005072428.16ce40e4@infradead.org> <200910061749.02805.elendil@planet.nl>
In-Reply-To: <200910061749.02805.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910071910.53907.elendil@planet.nl>
X-OriginalArrivalTime: 07 Oct 2009 17:10:53.0911 (UTC) FILETIME=[20B54E70:01CA4771]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009, Frans Pop wrote:
> I've checked for 2.6.31.1 now and iwlagn is listed high there too when
> the system is idle, but with normal values of 60-100 ms. And phy0 has
> normal values of below 10 ms.
> I've now rebooted with today's mainline git; phy0 now frequently shows
> with values of around 100 ms too (i.e. higher than last time).
>
> Both still go way down as soon as the system is given work to do.
>
> With a 5 second sleep I was unable to get any significant latencies (I
> started perf on a latencytop refresh and did a manual refresh as it
> finished to see what happened during the perf run). The perf run does
> seem to affect the latencies.
> I've uploaded a chart for a 10s sleep during which I got latencies of
> 101ms for iwlagn and 77ms for phy0:
> http://people.debian.org/~fjp/tmp/kernel/.

Mike privately sent me a script to try to capture the latencies with perf,
but the perf output does not show any high latencies at all. It looks as if
we may have found a bug in latencytop here instead.

Below a relevant quote from our private mails and the data I captured with
Mike's script.

Cheers,
FJP

On Wednesday 07 October 2009, Mike Galbraith wrote:
> On Wed, 2009-10-07 at 17:53 +0200, Frans Pop wrote:
> > I had latencytop running at the same time and that happily showed
> > values of 160 and 102 ms for iwlagn during the same period.
> > The highest values I see from your script for any process are ~12 ms.
> >
> > Does this mean there is a bug in latencytop somewhere? Or is there
> > something else going on?
>
> I suspect a bug in latencytop.. Arjan might suspect perf ;-)
>
> The only way you can get a 100+ ms latency hit on a mostly idle box is
> for there to be a problem with the clock, _and_ have multiple runnable
> heavy cpu using tasks on the runqueue so you can have a wide vruntime
> spread.  Peter's been all over the vruntime update logic, and if it or
> the clock were generally screwed, you'd see latency spikes all over
> creation.  It _could_ be some rare event though, why I hacked script
> together to chop off bite sized chunks for analysis.  Since nothing
> showed up there, and nothing's showing up here doing the same amarok+nfs
> thing, I'll place my bet on latencytop.. for now.
>
> > At the bottom a sample from your unmodified script. That one is fairly
> > typical, although it has does have about the highest value I've seen
> > for iwlagn.
>
> Yeah, looks perfectly normal.  Which leaves us at square one :-/



Typical output from perf (with fairly high phy0 and iwlagn):
 -----------------------------------------------------------------------------------------
  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |
 -----------------------------------------------------------------------------------------
  kondemand/0:282       |      2.085 ms |      123 | avg:    0.152 ms | max:    7.007 ms |
  amarokapp:5485        |    123.867 ms |      240 | avg:    0.120 ms | max:    5.260 ms |
  kondemand/1:283       |      1.977 ms |      119 | avg:    0.107 ms | max:    4.781 ms |
  phy0:2750             |      0.684 ms |       28 | avg:    0.181 ms | max:    3.921 ms |
  iwlagn:2749           |      0.668 ms |       28 | avg:    0.196 ms | max:    3.697 ms |
  Xorg:4147             |     40.570 ms |      224 | avg:    0.109 ms | max:    3.615 ms |
  kblockd/0:78          |      0.013 ms |        1 | avg:    3.121 ms | max:    3.121 ms |
  kcryptd:1520          |     64.962 ms |       11 | avg:    0.347 ms | max:    2.812 ms |
  perf:9451             |    322.937 ms |       40 | avg:    0.144 ms | max:    2.198 ms |
  :5662:5662            |     50.572 ms |      147 | avg:    0.087 ms | max:    2.141 ms |
  head:9452             |      2.589 ms |        4 | avg:    0.454 ms | max:    1.648 ms |
  :9439:9439            |      6.670 ms |      225 | avg:    0.127 ms | max:    1.574 ms |
  kicker:5451           |     24.650 ms |      102 | avg:    0.158 ms | max:    1.465 ms |
  ksysguardd:5454       |      6.614 ms |        7 | avg:    0.283 ms | max:    1.218 ms |
  :5661:5661            |      0.208 ms |        9 | avg:    0.130 ms | max:    1.024 ms |
  latencytop:7776       |      2.010 ms |        4 | avg:    0.256 ms | max:    0.980 ms |

Series of greps from that output for only iwlagn and phy0:
Oct 07 17:23:39   iwlagn:2749           |      0.721 ms |       35 | avg:    0.050 ms | max:    0.083 ms |
Oct 07 17:23:39   phy0:2750             |      0.779 ms |       35 | avg:    0.032 ms | max:    0.036 ms |
Oct 07 17:23:46   iwlagn:2749           |      0.617 ms |       32 | avg:    0.107 ms | max:    1.753 ms |
Oct 07 17:23:46   phy0:2750             |      0.783 ms |       32 | avg:    0.123 ms | max:    1.745 ms |
Oct 07 17:23:53   iwlagn:2749           |      0.629 ms |       31 | avg:    0.055 ms | max:    0.109 ms |
Oct 07 17:23:53   phy0:2750             |      0.774 ms |       31 | avg:    0.029 ms | max:    0.050 ms |
Oct 07 17:24:01   iwlagn:2749           |      0.908 ms |       35 | avg:    0.054 ms | max:    0.097 ms |
Oct 07 17:24:01   phy0:2750             |      0.839 ms |       35 | avg:    0.033 ms | max:    0.056 ms |
Oct 07 17:24:08   phy0:2750             |      0.742 ms |       32 | avg:    0.033 ms | max:    0.124 ms |
Oct 07 17:24:08   iwlagn:2749           |      0.734 ms |       32 | avg:    0.050 ms | max:    0.083 ms |
Oct 07 17:24:15   phy0:2750             |      0.963 ms |       41 | avg:    0.034 ms | max:    0.164 ms |
Oct 07 17:24:15   iwlagn:2749           |      0.721 ms |       41 | avg:    0.049 ms | max:    0.118 ms |
Oct 07 17:24:23   iwlagn:2749           |      6.434 ms |       73 | avg:    0.052 ms | max:    0.153 ms |
Oct 07 17:24:23   phy0:2750             |      0.620 ms |       22 | avg:    0.023 ms | max:    0.094 ms |
Oct 07 17:24:30   iwlagn:2749           |      0.934 ms |       38 | avg:    0.055 ms | max:    0.194 ms |
Oct 07 17:24:30   phy0:2750             |      0.941 ms |       37 | avg:    0.033 ms | max:    0.123 ms |
Oct 07 17:24:37   iwlagn:2749           |      5.324 ms |       74 | avg:    0.054 ms | max:    0.106 ms |
Oct 07 17:24:37   phy0:2750             |      0.993 ms |       36 | avg:    0.030 ms | max:    0.050 ms |
Oct 07 17:24:45   iwlagn:2749           |      0.844 ms |       36 | avg:    0.049 ms | max:    0.080 ms |
Oct 07 17:24:45   phy0:2750             |      0.770 ms |       34 | avg:    0.032 ms | max:    0.043 ms |
Oct 07 17:24:52   phy0:2750             |      0.832 ms |       36 | avg:    0.044 ms | max:    0.185 ms |
Oct 07 17:24:52   iwlagn:2749           |      0.923 ms |       36 | avg:    0.050 ms | max:    0.081 ms |
Oct 07 17:24:59   iwlagn:2749           |      0.778 ms |       35 | avg:    0.054 ms | max:    0.104 ms |
Oct 07 17:24:59   phy0:2750             |      0.778 ms |       34 | avg:    0.025 ms | max:    0.041 ms |
Oct 07 17:25:07   iwlagn:2749           |      0.854 ms |       34 | avg:    0.056 ms | max:    0.103 ms |
Oct 07 17:25:07   phy0:2750             |      0.780 ms |       34 | avg:    0.027 ms | max:    0.040 ms |
Oct 07 17:25:14   phy0:2750             |      0.762 ms |       33 | avg:    0.035 ms | max:    0.168 ms |
Oct 07 17:25:14   iwlagn:2749           |      0.853 ms |       33 | avg:    0.051 ms | max:    0.080 ms |
Oct 07 17:25:21   iwlagn:2749           |      0.892 ms |       34 | avg:    0.053 ms | max:    0.144 ms |
Oct 07 17:25:21   phy0:2750             |      0.780 ms |       34 | avg:    0.029 ms | max:    0.040 ms |
Oct 07 17:25:29   iwlagn:2749           |      0.972 ms |       39 | avg:    0.046 ms | max:    0.079 ms |
Oct 07 17:25:29   phy0:2750             |      0.843 ms |       38 | avg:    0.031 ms | max:    0.040 ms |
Oct 07 17:25:36   iwlagn:2749           |      0.896 ms |       39 | avg:    0.054 ms | max:    0.106 ms |
Oct 07 17:25:36   phy0:2750             |      0.873 ms |       37 | avg:    0.032 ms | max:    0.070 ms |
Oct 07 17:25:43   phy0:2750             |      0.919 ms |       39 | avg:    0.083 ms | max:    2.161 ms |
Oct 07 17:25:43   iwlagn:2749           |      0.950 ms |       40 | avg:    0.050 ms | max:    0.102 ms |
