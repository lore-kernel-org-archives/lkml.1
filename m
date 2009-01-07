Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbZAGSB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbZAGSB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZAGSBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:01:14 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:61887 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZAGSBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:01:11 -0500
Subject: Re: [PATCH -v4][RFC]: mutex: implement adaptive spinning
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <alpine.LFD.2.00.0901070945450.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>
	 <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
	 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>
	 <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
	 <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>
	 <49636799.1010109@novell.com> <20090106214229.GD6741@linux.vnet.ibm.com>
	 <1231278275.11687.111.camel@twins>
	 <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
	 <1231279660.11687.121.camel@twins>
	 <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>
	 <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins>
	 <1231329783.11687.287.camel@twins>
	 <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231348801.27813.31.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901070945450.3057@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 13:00:12 -0500
Message-Id: <1231351212.27813.44.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4964EDB5.0162:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 09:50 -0800, Linus Torvalds wrote:
> 
> On Wed, 7 Jan 2009, Chris Mason wrote:
> > 
> > So far I haven't found any btrfs benchmarks where this is slower than
> > mutexes without any spinning.  But, it isn't quite as fast as the btrfs
> > spin.
> 
> Quite frankly, from our history with ext3 and other filesystems, using a 
> mutex in the filesystem is generally the wrong thing to do anyway. 
> 
> Are you sure you can't just use a spinlock, and just release it over IO? 
> The "have to do IO or extend the btree" case is usually pretty damn clear.
> 
> Because it really sounds like you're lock-limited, and you should just try 
> to clean it up. A pure "just spinlock" in the hotpath is always going to 
> be better.

There are definitely ways I can improve performance for contention in
the hot btree nodes, and I think it would be a mistake to tune the
generic adaptive locks just for my current code.

But, it isn't a bad test case to compare the spin with the new patch and
with the plain mutex.  If the adaptive code gets in, I think it would be
best for me to drop the spin.

Either way there's more work to be done in the btrfs locking code.

-chris


