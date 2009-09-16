Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbZIPSFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbZIPSFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759779AbZIPSFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:05:45 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51122 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbZIPSFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:05:45 -0400
Date: Wed, 16 Sep 2009 14:03:48 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       geofft@ksplice.com
Subject: Re: [PATCH v2] sparc: Clean up linker script using new linker script
 macros.
In-Reply-To: <20090916.103019.253722423.davem@davemloft.net>
Message-ID: <alpine.DEB.1.10.0909161332190.2942@dr-wily.mit.edu>
References: <1253119592-19598-2-git-send-email-tabbott@ksplice.com> <20090916.101924.186960949.davem@davemloft.net> <alpine.DEB.1.10.0909161322260.2942@dr-wily.mit.edu> <20090916.103019.253722423.davem@davemloft.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, David Miller wrote:

> From: Tim Abbott <tabbott@ksplice.com>
> Date: Wed, 16 Sep 2009 13:27:43 -0400 (EDT)
> 
> > On Wed, 16 Sep 2009, David Miller wrote:
> > 
> >> Can you do this cleanup without moving the relative locations of .data
> >> and .data1 sections?
> > 
> > Yes, if you just swap RW_DATA_SECTION and .data1 so it looks like
> > 
> > RW_DATA_SECTION(SMP_CACHE_BYTES, 0, THREAD_SIZE)
> > .data1 : {
> > 	*(.data1)
> > }
> > 
> > instead, that would preserve their relative locations.
> > 
> > Currently, switching to RW_DATA_SECTION would still result in a change in 
> > their relative position that .data.page_aligned and .data.nosave would be 
> > between .data and .data1 (not sure if that is relevant on sparc). (this 
> > will change when <http://lkml.org/lkml/2009/9/16/396> is merged).
> 
> I don't know which, if any, are relevant or could cause problems.

The kind of problem I've seen on other architectures is if there are 
short-range (e.g. 2-byte) relative relocations between two sections, and 
you insert a new section between them, they end up too far apart and the 
kernel fails to link.  I don't know whether the sparc architecture has 
that kind of short relocation issue, but that's what I'd be worried about 
with section order changes.

The other potential issue is sections moving past linker script defined 
symbols such as __init_end, so that the section might be allocated 
differently.  The only change of that form in this patch is that it moves 
.data.init_task before _edata, which on sparc is only used to print how 
memory is used by different data types.

The other thing I should mention is that I've not boot-tested this; I've 
only build-tested it with a sparc64 cross-compiler.  So that should be 
done before merging this.

> It's hard for me to ACK this because it's not a straight nop
> transformation, which we could at least presume would function
> properly if the macros were implemented correctly.

Would it help if I were to split the patch into first rearranging the code 
to look like the macros and then applying the macros, so that you can see 
more easily exactly what is changing?

	-Tim Abbott
