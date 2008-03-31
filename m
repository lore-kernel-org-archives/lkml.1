Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYCaG4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYCaG4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 02:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYCaGz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 02:55:57 -0400
Received: from relay.gothnet.se ([82.193.160.251]:3703 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752832AbYCaGz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 02:55:56 -0400
Message-ID: <47F08AC1.6010406@tungstengraphics.com>
Date: Mon, 31 Mar 2008 08:54:57 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       arjan@linux.intel.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com>
In-Reply-To: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> When cpa was refactored to the new set_memory_ interfaces, it removed
> a special case fast path for AGP systems, which did a lot of page by page
> attribute changing and held the flushes until they were finished. The
> DRM memory manager also required this to get useable speeds.
>
> This introduces a new interface, which accepts an array of memory addresses
> to have attributes changed on and to flush once finished.
>
> Further changes to the AGP stack to actually use this interface will be
> published later.
>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  arch/x86/mm/pageattr-test.c  |   12 ++-
>  arch/x86/mm/pageattr.c       |  164 +++++++++++++++++++++++++++++++-----------
>  include/asm-x86/cacheflush.h |    3 +
>  3 files changed, 132 insertions(+), 47 deletions(-)
>   
...
Dave,
Nice work, but how do we handle highmem pages? I know that they don't 
need any attribute change since they're not in the kernel map, but both 
the AGP module and the DRM memory manager typically hold highmem 
addresses in their arrays, so the code should presumably detect those 
and avoid them?

Since this is an AGPgart and DRM fastpath, the interface should ideally 
be adapted to match the data structures used by those callers. The 
AGPgart module uses an array of addresses, which effectively stops it 
from using pages beyond the DMA32 limit. The DRM memory manager uses an 
array of struct page pointers, but using that was, If I understand 
things correctly, rejected.

So, if we, at some point, want to have an AGPgart module capable of 
using anything beyond the DMA32 limit we will end up with an interface 
that doesn't match neither AGPgart nor DRM, for which users the fastpath 
was originally intended.

/Thomas



