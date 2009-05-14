Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZENIUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZENIUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 04:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZENIUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 04:20:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36022 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZENIUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 04:20:31 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Robin Holt <holt@sgi.com>
In-Reply-To: <4A0ADD88.9080705@redhat.com>
References: <20090513120729.5885.A69D9226@jp.fujitsu.com> <4A0ADD88.9080705@redhat.com>
Message-Id: <20090514170721.9B75.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 May 2009 17:20:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to Robin)

> KOSAKI Motohiro wrote:
> > Subject: [PATCH] zone_reclaim_mode is always 0 by default
> > 
> > Current linux policy is, if the machine has large remote node distance,
> >  zone_reclaim_mode is enabled by default because we've be able to assume to 
> > large distance mean large server until recently.
> > 
> > Unfrotunately, recent modern x86 CPU (e.g. Core i7, Opeteron) have P2P transport
> > memory controller. IOW it's NUMA from software view.
> > 
> > Some Core i7 machine has large remote node distance and zone_reclaim don't
> > fit desktop and small file server. it cause performance degression.
> > 
> > Thus, zone_reclaim == 0 is better by default. sorry, HPC gusy. 
> > you need to turn zone_reclaim_mode on manually now.
> 
> I'll believe that it causes a performance regression with the
> old zone_reclaim behaviour, however the way you tweaked
> zone_reclaim should make it behave a lot better, no?

Unfortunately no.
zone reclaim has two weakness by design.

1.
zone reclaim don't works well when workingset size > local node size.
but it can happen easily on small machine.
if it happen, zone reclaim drop own process's memory.

Plus, zone reclaim also doesn't fit DB server. its process has large
workingset.


2.
zone reclaim have inter zone balancing issue.

example: x86_64 2node 8G machine has following zone assignment

   zone 0 (DMA32):  3GB
   zone 0 (Normal): 1GB
   zone 1 (Normal): 4GB

if the page is allocated from DMA32, you are lucky. DMA32 isn't reclaimed
so freqently. but if from zone0 Normal, you are unlucky.
it is very frequent reclaimed although it is small than other zone.


I know my patch change large server default. but I believe linux
default kernel parameter adapt to desktop and entry machine.



