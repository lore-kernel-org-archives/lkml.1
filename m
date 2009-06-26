Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbZFZU5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbZFZU5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 16:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZFZU44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 16:56:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbZFZU4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 16:56:55 -0400
Date: Fri, 26 Jun 2009 13:54:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: cl@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       ntl@pobox.com, mel@csn.ul.ie, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       rusty@rustcorp.com.au, steiner@sgi.com, rientjes@google.com,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] x86: only clear node_states for 64bit
Message-Id: <20090626135428.d8f88a70.akpm@linux-foundation.org>
In-Reply-To: <4A3FA58A.3010909@kernel.org>
References: <4A05269D.8000701@kernel.org>
	<20090512111623.GG25923@csn.ul.ie>
	<4A0A64FB.4080504@kernel.org>
	<20090513145950.GB28097@csn.ul.ie>
	<4A0C4910.7090508@kernel.org>
	<4A0C4A2A.6080009@kernel.org>
	<20090514095414.ba8356e5.akpm@linux-foundation.org>
	<4A0C4F67.5080802@kernel.org>
	<20090514102554.b3a36f19.akpm@linux-foundation.org>
	<4A0C563A.3020100@kernel.org>
	<4A2758CB.9090404@kernel.org>
	<alpine.DEB.1.10.0906041236520.5377@gentwo.org>
	<4A27FAD4.2010104@kernel.org>
	<alpine.DEB.1.10.0906041309230.8080@gentwo.org>
	<4A2803D1.4070001@kernel.org>
	<m3bpokiv0u.fsf@pobox.com>
	<4A3B49BA.40100@kernel.org>
	<m3prd0havh.fsf@pobox.com>
	<4A3D7419.8040305@kernel.org>
	<m3my807ug3.fsf@pobox.com>
	<4A3FA58A.3010909@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 08:38:50 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> Nathan reported that
> | commit 73d60b7f747176dbdff826c4127d22e1fd3f9f74
> | Author: Yinghai Lu <yinghai@kernel.org>
> | Date:   Tue Jun 16 15:33:00 2009 -0700
> |
> |    page-allocator: clear N_HIGH_MEMORY map before we set it again
> |    
> |    SRAT tables may contains nodes of very small size.  The arch code may
> |    decide to not activate such a node.  However, currently the early boot
> |    code sets N_HIGH_MEMORY for such nodes.  These nodes therefore seem to be
> |    active although these nodes have no present pages.
> |    
> |    For 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too
> 
> the cpuset.mems cgroup attribute on an i386 kvm guest
> 
> fix it by only clearing node_states[N_NORMAL_MEMORY] for 64bit only.
> and need to do save/restore for that in find_zone_movable_pfn
> 

There appear to be some words omitted from this changelog - it doesn't
make sense.

I think that perhaps a line got deleted before "the cpuset.mems cgroup
...".  That was the line which actualy describes the bug which we're
fixing.  Or perhaps it was a single word?  "zeroes".


I did this:

Nathan reported that
: 
: | commit 73d60b7f747176dbdff826c4127d22e1fd3f9f74
: | Author: Yinghai Lu <yinghai@kernel.org>
: | Date:   Tue Jun 16 15:33:00 2009 -0700
: |
: |    page-allocator: clear N_HIGH_MEMORY map before we set it again
: |
: |    SRAT tables may contains nodes of very small size.  The arch code may
: |    decide to not activate such a node.  However, currently the early boot
: |    code sets N_HIGH_MEMORY for such nodes.  These nodes therefore seem to be
: |    active although these nodes have no present pages.
: |
: |    For 64bit N_HIGH_MEMORY == N_NORMAL_MEMORY, so that works for 64 bit too
: 
: unintentionally and incorrectly clears the cpuset.mems cgroup attribute on
: an i386 kvm guest
: 
: Fix this by only clearing node_states[N_NORMAL_MEMORY] for 64bit only. 
: and need to do save/restore for that in find_zone_movable_pfn

Please check whether that is correct.  If not, how should it be changed?

