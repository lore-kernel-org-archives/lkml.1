Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbYFRXPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbYFRXPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 19:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYFRXPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 19:15:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47175 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbYFRXPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 19:15:24 -0400
Date: Thu, 19 Jun 2008 01:14:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: David Miller <davem@davemloft.net>, vgusev@openvz.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, mcmanus@ducksong.com,
       ilpo.jarvinen@helsinki.fi, kuznet@ms2.inr.ac.ru, xemul@openvz.org
Subject: Re: [E1000-devel] [TCP]: TCP_DEFER_ACCEPT causes leak sockets
Message-ID: <20080618231436.GA12886@elte.hu>
References: <20080617083220.GA11393@elte.hu> <20080617.020840.169830916.davem@davemloft.net> <20080617092706.GB20621@elte.hu> <20080617.022909.173003136.davem@davemloft.net> <20080617093929.GA10334@elte.hu> <48595910.8000905@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48595910.8000905@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> You only complain and do not provide a single solution to your 
> problem. [...]

i have reported the problem and even provided a fix.

I have triggered an e1000/e1000e related problem that got introduced in 
the v2.6.25 merge window - one of my testboxes came up with no 
networking and it took me an hour to figure out why. (i wasnt 
particularly focusing on e1000, i just happened to hit that bug in 9 
million lines of Linux kernel code)

I have reported it here, two and a half months ago:

    http://lkml.org/lkml/2008/4/8/256

I even showed you which commit introduced the problem and gave you a 
oneliner fix that i tested (it solved the problem):

    http://bugzilla.kernel.org/attachment.cgi?id=15704&amp;action=view

You were Cc:-ed to that. (attached below again for reference) The bug 
was added to the regression list of v2.6.25. I never expected to spend 
more than 10 minutes on this problem once i found out what's happening - 
we fix dozens of bugs like this per stable kernel release.

I just checked latest -git, my fix is still not upstream (or any 
equivalent solution - i really dont mind how it's solved and i'm not 
maintaining this code).

no alternative patch was sent to me - i offered to test any solution 
back then.

FYI, since i first reported it i've been hit by that problem roughly a 
dozen times. (it happened sporadically so i forgot about it - until i 
again had a system come up with no networking.) It caused me lost time 
and lost work that could have been spent on better things.

	Ingo

------------------------>
Subject: e1000=y && e1000e=m regression fix
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 09 21:09:35 CEST 2008

fix a regression from v2.6.24: do not transfer the e1000e PCI IDs from 
e1000 to e1000e if e1000 is built-in and e1000e is a module.

Built-in drivers take precedence over modules in many ways - and in this 
case it's clear that the user intended the e1000 driver to be the 
primary one. "Silently change behavior and break existing configs" is 
never a good migration strategy. Most users will use distro kernels that 
are not affected by this problem at all - nor are they affected by this 
patch - but this problem can hit users and developers who build their 
kernels themselves and migrate from v2.6.24 to v2.6.25.

this fixes: http://bugzilla.kernel.org/show_bug.cgi?id=10427

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/drivers/net/Kconfig
===================================================================
--- linux-x86.q.orig/drivers/net/Kconfig
+++ linux-x86.q/drivers/net/Kconfig
@@ -2022,7 +2022,7 @@ config E1000E
 	  will be called e1000e.
 
 config E1000E_ENABLED
-	def_bool E1000E != n
+	def_bool E1000E = y || ((E1000E != n) && (E1000 = E1000E))
 
 config IP1000
 	tristate "IP1000 Gigabit Ethernet support"
