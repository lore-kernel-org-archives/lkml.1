Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbZIBTbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbZIBTbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 15:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZIBTbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 15:31:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:21429 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZIBTbt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 15:31:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="183381145"
From: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
CC: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Date: Wed, 2 Sep 2009 12:30:59 -0700
Subject: RE: [RFC] respect the referenced bit of KVM guest pages?
Thread-Topic: [RFC] respect the referenced bit of KVM guest pages?
Thread-Index: Acofq0JJsYCqjn7dSiq9RFnUNkVjvQMUncow
Message-ID: <9EECC02A4CC333418C00A85D21E893260184184010@azsmsx502.amr.corp.intel.com>
References: <4A843B72.6030204@redhat.com> <4A843EAE.6070200@redhat.com>
 <4A846581.2020304@redhat.com> <20090813211626.GA28274@cmpxchg.org>
 <4A850F4A.9020507@redhat.com> <20090814091055.GA29338@cmpxchg.org>
 <20090814095106.GA3345@localhost> <4A856467.6050102@redhat.com>
 <20090815054524.GB11387@localhost>
 <9EECC02A4CC333418C00A85D21E89326B6611E81@azsmsx502.amr.corp.intel.com>
 <20090818022609.GA7958@localhost>
In-Reply-To: <20090818022609.GA7958@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to better understand the motivation for your make-mapped-exec-pages-first-class-citizens patch.  As I read your (very detailed!) description, you are diagnosing a threshold effect from Rik's evict-use-once-pages-first patch where if the inactive list is slightly smaller than the active list, the active list will start being scanned, pushing text (and other) pages onto the inactive list where they will be quickly kicked out to swap.

As I read Rik's patch, if the active list is one page larger than the inactive list, then a batch of pages will get moved from one to the other.  For this to have a noticeable effect on the system once the streaming is done, there must be something continuing to keep the active list larger than the inactive list.  Maybe there is a consistent percentage of the streamed pages which are use-twice. 

So, we a threshold effect where a small change in input (the size of the streaming file vs the number of active pages) causes a large change in output (lots of text pages suddenly start getting thrown out).   My immediate reaction to that is that there shouldn't be this sudden change in behavior, and that maybe there should only be enough scanning in shink_active_list to bring the two lists back to parity.  However, if there's something keeping the active list bigger than the inactive list, this will just put off the inevitable required scanning.

As for your patch, it seems like we have a problem with scanning I/O, and instead of looking at those pages, you are looking to protect some other set of pages (mapped text).  That, in turn, increases pressure on anonymous pages (which is where I came in).  Wouldn't it be a better idea to keep looking at those streaming pages and figure out how to get them out of memory quickly?

						Jeff


