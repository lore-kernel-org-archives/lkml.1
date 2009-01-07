Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbZAGVsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbZAGVsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZAGVrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:47:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbZAGVrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:47:51 -0500
Date: Wed, 7 Jan 2009 13:47:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, matthew@wil.cx, rostedt@goodmis.org,
       peterz@infradead.org, paulmck@linux.vnet.ibm.com, ghaskins@novell.com,
       andi@firstfloor.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
       pmorreale@novell.com, SDietrich@novell.com
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Message-Id: <20090107134715.9c5e139e.akpm@linux-foundation.org>
In-Reply-To: <20090107213222.GE4597@elte.hu>
References: <1231281801.11687.125.camel@twins>
	<1231283778.11687.136.camel@twins>
	<1231329783.11687.287.camel@twins>
	<alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	<1231347442.11687.344.camel@twins>
	<alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	<alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	<alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	<20090107210923.GV2002@parisc-linux.org>
	<alpine.LFD.2.00.0901071314490.3057@localhost.localdomain>
	<20090107213222.GE4597@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 22:32:22 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> > We could do the whole "oldfs = get_fs(); set_fs(KERNEL_DS); .. 
> > set_fs(oldfs);" crud, but it would probably be better to just add an 
> > architected accessor. Especially since it's going to generally just be a
> > 
> > 	#define get_kernel_careful(val,p) __get_user(val,p)
> > 
> > for most architectures.
> > 
> > We've needed that before (and yes, we've simply mis-used __get_user() on 
> > x86 before rather than add it).
> 
> for the oldfs stuff we already have probe_kernel_read(). OTOH, that 
> involves pagefault_disable() which is an atomic op

tisn't.  pagefault_disable() is just preempt_count()+=1;barrier() ?

Am suspecting that you guys might be over-optimising this
contended-path-were-going-to-spin-anyway code?
