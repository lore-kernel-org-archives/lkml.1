Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbZDOXX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbZDOXX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZDOXXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:23:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58628 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZDOXXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:23:14 -0400
Date: Thu, 16 Apr 2009 01:21:34 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       chrisw@redhat.com, mtosatti@redhat.com, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-ID: <20090415232134.GB4524@random.random>
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com> <1239249521-5013-2-git-send-email-ieidus@redhat.com> <1239249521-5013-3-git-send-email-ieidus@redhat.com> <1239249521-5013-4-git-send-email-ieidus@redhat.com> <1239249521-5013-5-git-send-email-ieidus@redhat.com> <20090414150929.174a9b25.akpm@linux-foundation.org> <49E661A5.8050305@redhat.com> <20090415155058.9e4635b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415155058.9e4635b2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 03:50:58PM -0700, Andrew Morton wrote:
> an optional thing and can even be modprobed, that doesn't work.  And
> having a driver in mm/ which can be modprobed is kinda neat.

Agreed. I think madvise with all its vma split requirements and
ksm-unregistering invoked at vma destruction time (under CONFIG_KSM ||
CONFIG_KSM_MODULE) is clean approach only if ksm is considered a piece
of the core kernel VM. As long as only certain users out there use ksm
(i.e. only virtualization servers and LHC computations) the pseduochar
ioctl interface keeps it out of the kernel, so core kernel MM API
remains almost unaffected by ksm.

It's kinda neat it's external as self-contained module, but the whole
point is that to be self-contained it has to use ioctl.

Another thing is that madvise usually doesn't require mangling sysfs
to be effective. madvise without enabling ksm with sysfs would be
entirely useless. So doing it as madvise that returns success and has
no effect unless 'root' does something, is kind of weird.

Thinking about the absolute worst case: if this really turns out to be
wrong decision, simply /dev/ksm won't exist anymore and no app could
ever break as they will graceful handle the missing pseudochar. They
won't run the ioctl and just continue like if ksm.ko wasn't loaded. As
there are only a few (but critically important) apps using KSM,
converting them to fallback on madvise is a few liner trivial change
(kvm-userland will have 10 more lines to keep opening /dev/ksm before
calling madvise if we ever later decide KSM has to become a VM core
kernel functionality with madvise or its own per-arch syscall).
