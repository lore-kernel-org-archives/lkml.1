Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZAIGBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZAIGBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZAIGBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:01:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756911AbZAIGBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:01:15 -0500
Date: Thu, 8 Jan 2009 22:00:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-Id: <20090108220028.3b73a509.akpm@linux-foundation.org>
In-Reply-To: <20090109033531.GR496@one.firstfloor.org>
References: <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	<1231408718.11687.400.camel@twins>
	<20090108141808.GC11629@elte.hu>
	<1231426014.11687.456.camel@twins>
	<alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	<1231434515.14304.27.camel@think.oraclecorp.com>
	<alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	<20090108183306.GA22916@elte.hu>
	<1231444786.5715.8.camel@brick>
	<4966ABF9.9080409@zytor.com>
	<20090109033531.GR496@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 04:35:31 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> On Thu, Jan 08, 2009 at 05:44:25PM -0800, H. Peter Anvin wrote:
> > Harvey Harrison wrote:
> > >>
> > >> We might still try the second or third options, as i think we shouldnt go 
> > >> back into the business of managing the inline attributes of ~100,000 
> > >> kernel functions.
> > > 
> > > Or just make it clear that inline shouldn't (unless for a very good reason)
> > > _ever_ be used in a .c file.
> > > 
> > 
> > The question is if that would produce acceptable quality code.  In
> > theory it should, but I'm more than wondering if it really will.
> 
> I actually often use noinline when developing code simply because it 
> makes it easier to read oopses when gcc doesn't inline ever static
> (which it normally does if it only has a single caller). You know
> roughly where it crashed without having to decode the line number.
> 
> I believe others do that too, I notice it's all over btrfs for example.
> 

Plus there is the problem where

foo()
{
	char a[1000];
}

bar()
{
	char a[1000];
}

zot()
{
	foo();
	bar();
}

uses 2000 bytes of stack.

Fortunately scripts/checkstack.pl can find these.

If someone runs it.

With the right kconfig settings.

And with the right compiler version.
