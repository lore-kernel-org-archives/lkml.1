Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbZG2S2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbZG2S2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 14:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZG2S2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 14:28:34 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:57417 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbZG2S2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 14:28:33 -0400
From: Frans Pop <elendil@planet.nl>
To: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: [PATCH] kdesu broken
Date: Wed, 29 Jul 2009 20:28:29 +0200
User-Agent: KMail/1.9.9
Cc: alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
       hirofumi@mail.parknet.co.jp, aneesh.kumar@linux.vnet.ibm.com,
       rjw@sisk.pl, ray-lk@madrabbit.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, stern@rowland.harvard.edu
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907282146580.3161@localhost.localdomain> <20090729120704.3299ff2e@lxorguk.ukuu.org.uk> <20090729120704.3299ff2e@lxorguk.ukuu.org.uk> <200907291340.38620.gene.heskett@verizon.net>
In-reply-To: <200907291340.38620.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907292028.32320.elendil@planet.nl>
X-OriginalArrivalTime: 29 Jul 2009 18:28:32.0898 (UTC) FILETIME=[60C3CE20:01CA107A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is needed for a mistake free bisect is a 'doesn't matter as long
> as it matches' Makefile version that survives all the way through a
> bisect run.

I have a wrapper script I use for kernel builds that takes care of that 
(it also supports cross building and building some out-of-tree modules). 
Some snippets from that script below.

BISECTING=
if [ -e .git/BISECT_LOG ]; then
        BISECTING=1
fi
[...]
if [ "$BISECTING" ]; then
        # The version in the next line may need updating before a bisect
        sed -i "s/^SUBLEVEL = .*/SUBLEVEL = 31/" Makefile
        sed -i "s/^EXTRAVERSION =.*/EXTRAVERSION = -bisect/" Makefile
fi
[...]
make ...
[...]
if [ "$BISECTING" ]; then
	# Revert Makefile to avoid errors on 'git bisect good/bad'
        git checkout Makefile
fi

I use the deb-pkg target and also set the .deb package version in the 
second hunk:
KERNELDEBREVISION=$(grep "^git[- ]bisect" .git/BISECT_LOG | wc -l)

This way I end up with a nice series of packages whose numbering matches 
the steps in .git/BISECT_LOG:
linux-image-2.6.31-bisect_1_amd64.deb
linux-image-2.6.31-bisect_2_amd64.deb
linux-image-2.6.31-bisect_3_amd64.deb
...

Hope that help.

Cheers,
FJP
