Return-Path: <linux-kernel-owner+w=401wt.eu-S1753287AbZIKGDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbZIKGDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZIKGDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:03:32 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:2260 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbZIKGD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:03:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKaFqUqrR7O6/2dsb2JhbADESYhGAZAvBYQY
X-IronPort-AV: E=Sophos;i="4.44,369,1249257600"; 
   d="scan'208";a="240310677"
From: Roland Dreier <rdreier@cisco.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jsquyres@cisco.com, linux-rdma@vger.kernel.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com>
	<20090911145036.DB65.A69D9226@jp.fujitsu.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 10 Sep 2009 23:03:25 -0700
In-Reply-To: <20090911145036.DB65.A69D9226@jp.fujitsu.com> (KOSAKI Motohiro's
	message of "Fri, 11 Sep 2009 14:56:13 +0900 (JST)")
Message-ID: <adatyzahvbm.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Sep 2009 06:03:25.0742 (UTC) FILETIME=[93662CE0:01CA32A5]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Can I this version already solved fork() + COW issue? if so, could you
 > please explain what happen at fork. Obviously RDMA point to either parent
 > or child page, not both. but Corrent COW rule is, first touch process
 > get copyed page and other process still own original page. I think it's 
 > unpecected behavior form RDMA.

No, ummunotify doesn't really help that much with fork() + COW.  If a
parent forks and then touches pages that are actively in use for RDMA,
then of course they get COWed and RDMA goes to the wrong memory (from
the point of view of the parent).

ummunotify does deal with the case where a process forks and touches
memory that was used for RDMA but no longer is -- in that case, the MPI
library has a chance to flush its registration cache because it will get
a ummunotify event invalidating the old mapping.

The real purpose of ummunotify is to allow MPI implementations to cache
registrations, even when the MPI library is used with an application
that does funny things for allocation (mmap()/munmap() or brk(), etc).

 - Roland
