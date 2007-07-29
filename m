Return-Path: <linux-kernel-owner+w=401wt.eu-S1765744AbXG2RHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765744AbXG2RHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 13:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764497AbXG2RHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 13:07:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45616 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764417AbXG2RG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 13:06:59 -0400
Date: Sun, 29 Jul 2007 19:06:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: SD still better than CFS for 3d   ?(was Re: 2.6.23-rc1)
Message-ID: <20070729170641.GA26220@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185536610.502.8.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Kasper Sandberg <lkml@metanurb.dk> wrote:

> Im still not so keen about this, Ingo never did get CFS to match SD in 
> smoothness for 3d applications, where my test subjects are quake(s), 
> world of warcraft via wine, unreal tournament 2004. [...]

here's an update: checking whether Wine could be a factor in your 
problem i just tested latest CFS against latest SD with a 3D game 
running under Wine: v2.6.22-ck1 versus v2.6.22-cfsv19 (to get the
most comparable kernel), using Quake 3 Arena Demo under Wine (0.9.41). 
Here are the results in a pretty graph:

   http://people.redhat.com/mingo/misc/cfs-vs-sd-wine-quake.jpg

or, in text:

         2.6.22-ck1                         2.6.22-cfs-v19
   ------------------------            ------------------------
   quake + 0 loops | 41 fps            quake + 0 loops | 41 fps
   quake + 1 loop  |  3 fps            quake + 1 loop  | 41 fps
   quake + 2 loops |  2 fps            quake + 2 loops | 32 fps
   quake + 3 loops |  1 fps            quake + 3 loops | 24 fps
   quake + 4 loops |  0 fps            quake + 4 loops | 20 fps
   quake + 5 loops |  0 fps            quake + 5 loops | 16 fps

Quake3-under-Wine behavior under SD/-ck: framerate breaks down massively 
during any kind of load. The game is completely unusable with 1 CPU loop 
running already!

Quake3-under-Wine behavior under CFS: framerate goes down gently with 
load, gameplay remains smooth. Framerate is still pretty acceptable and 
the game is playable even with a 500% CPU overload. The graph looks good 
and the framerate reduction goes roughly along the expected 1/n 
'fairness curve' - so it all looks pretty healthy. [Note: quake3 keeps 
its fully 41 fps even with 1 competing loop running on the CPU due to 
"sleeper fairness".]

[ i've re-tested this using other SD and ck versions and other CFS 
  versions such as v2.6.23-rc1 and the results are the same. To get the 
  fps result i started a simple game scene: Single Player /
  Q3DM1 / I Can Win, turned on the fps display of Quake3, and did not 
  move the player at all, just looked at the framerate that is 
  displayed. (i also tried other scenes and other gameplay sections and 
  they all behave consistently with the above results.) The system was
  otherwise completely idle. While i trust these numbers take them with 
  a grain of salt, i'm obviously not neutral in this thing :-) ]

so Kasper, i'll definitely need your help in tracking down your 3D 
smoothness problem under CFS. I have the feeling that it could be some 
odd factor that only hits your system, and once we've tracked that down 
there will be a simple solution that does not affect the totality of the 
scheduler. So far only you have reported any 3D game smoothness problem 
against recent CFS versions. (all 3D feedback has been positive, and 
that includes a number of gamers as well. Most of the 3D smoothness 
problems were fixed in CFS v13..v15 and it has not been reported to have 
regressed since then.)

	Ingo
