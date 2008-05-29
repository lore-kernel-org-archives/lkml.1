Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYE2IqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYE2IqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYE2Ips
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:45:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52047 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbYE2Ipr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:45:47 -0400
Date: Thu, 29 May 2008 10:45:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080529084524.GA24892@elte.hu>
References: <20080526115628.GA31316@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526115628.GA31316@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> in an overnight -tip testruns that is based on recent -git i got two 
> stuck TCP connections:
> 
> Active Internet connections (w/o servers)
> Proto Recv-Q Send-Q Local Address               Foreign Address             State      
> tcp        0 174592 10.0.1.14:58015             10.0.1.14:3632              ESTABLISHED 
> tcp    72134      0 10.0.1.14:3632              10.0.1.14:58015             ESTABLISHED 

update: in the past 5 days of -tip testing i've gathered about 10 
randconfig kernel configs that all produced such failures.

Since the bug itself is very elusive (it takes up to 50 boot + 
kernel-rebuild-via-distccc iterations to trigger) bisection was still 
not an option - but with 10 configs statistical analysis of the configs 
is now possible.

I made a histogram of all kernel options present in those configs, and 
one networking related kernel option stood out:

      5 CONFIG_TCP_CONG_ADVANCED=y
      6 CONFIG_INET_TCP_DIAG=y
      6 CONFIG_TCP_MD5SIG=y
      9 CONFIG_TCP_CONG_CUBIC=y

that code is called in the bootlogs:

> [   13.279410] calling  cubictcp_register+0x0/0x80
> [   13.279412] TCP cubic registered

the likelyhood of CONFIG_TCP_CONG_CUBIC=y being enabled in my randconfig 
runs is 75%. The likelyhood of CONFIG_TCP_CONG_CUBIC=y being enabled in 
10 configs in a row is 0.75^10, or 5.6%. So statistical analysis can say 
it with a 95% confidence that the presence of this option correlates to 
the hung sockets.

i have started testing this theory now, via the patch below, which turns 
off TCP_CONG_CUBIC. It will take about 50 bootups on the affected 
testsystems to confirm. (it will take a couple of hours today as not all 
testsystems show these hung socket symptoms)

distributions enable TCP_CONG_CUBIC by default:

  $ grep CUBIC /boot/config-2.6.24.7-92.fc8
  CONFIG_TCP_CONG_CUBIC=y
  CONFIG_DEFAULT_CUBIC=y

which would explain why Arjan and Peter triggered similar hangs as well.

	Ingo

---------------------->
Subject: qa: no TCP_CONG_CUBIC
From: Ingo Molnar <mingo@elte.hu>
Date: Thu May 29 09:45:51 CEST 2008

---
 net/ipv4/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

Index: tip/net/ipv4/Kconfig
===================================================================
--- tip.orig/net/ipv4/Kconfig
+++ tip/net/ipv4/Kconfig
@@ -454,6 +454,8 @@ config TCP_CONG_BIC
 config TCP_CONG_CUBIC
 	tristate "CUBIC TCP"
 	default y
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT
 	---help---
 	This is version 2.0 of BIC-TCP which uses a cubic growth function
 	among other techniques.
@@ -608,6 +610,8 @@ endif
 config TCP_CONG_CUBIC
 	tristate
 	depends on !TCP_CONG_ADVANCED
+	depends on BROKEN_BOOT_ALLOWED
+	select BROKEN_BOOT
 	default y
 
 config DEFAULT_TCP_CONG
