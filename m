Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab0BRTtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:49:15 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:38108 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab0BRTtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:49:13 -0500
Date: Thu, 18 Feb 2010 13:48:37 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 34/35] x86: use num_processors for possible cpus
In-Reply-To: <4B7D782F.20102@zytor.com>
Message-ID: <alpine.DEB.2.00.1002181340380.7486@router.home>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org> <1265793639-15071-35-git-send-email-yinghai@kernel.org> <4B7C98B9.1090903@zytor.com> <4B7CA825.9090309@kernel.org> <4B7D782F.20102@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010, H. Peter Anvin wrote:

> > per_cpu setup will allocate some mem for every cpu according to possible cpus.
> >
>
> Yes, and I have repeatedly requested that we allocate the memory on the
> first up of a disabled CPU rather than eagerly, but in *most*
> configurations the amount is relatively small.

The size of the static per cpu segment is likely around 30k and you will
likely add another 30k in dynamic allocations.

As I have also repeatedly stated: Dynamic percpu data allocation when
onlining / offlining processors will complicate locking (cannot rely on
percpu be present anymore) and introduce numerous additional
hotplug notifiers into subsystems.

Newly allocating a per cpu segment also has consequences for subsystems
that dynamically allocate per cpu data (not add another cpu but
dynamically allocate data that needs to be present on all processors).
They would have to prepare the per cpu data which would create another
need for callbacks.

All of the measures necessary would result in problems of ensuring object
existence in critical code paths that use percpu data for performance
reasons.

