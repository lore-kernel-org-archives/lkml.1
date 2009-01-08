Return-Path: <linux-kernel-owner+w=401wt.eu-S1762306AbZAHUAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbZAHUAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZAHT7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:59:54 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:54968 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbZAHT7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:59:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SG4jlFD62dA29LtU+vwc9rtM7fV3/bEZ62tQoMTJVyalhgd/7dnjosvA0Z6R0+fZM0
         OV84s2PGgS69tV7idXJ4/oV52UbZY6NiMyEvZBUkkNe3dCfeF+12jr7VCVZMc+CvtYSi
         sQOkp8mRqsJ2WxIQVDp6m6woDpjr3oS8xJ6CM=
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <20090108183306.GA22916@elte.hu>
References: <1231365115.11687.361.camel@twins>
	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
	 <1231366716.11687.377.camel@twins>
	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	 <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	 <1231434515.14304.27.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	 <20090108183306.GA22916@elte.hu>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 11:59:46 -0800
Message-Id: <1231444786.5715.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 19:33 +0100, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:

<snip>

> > 
> > Ingo - I think we need to remove that crap again. Because gcc gets the 
> > inlining horribly horribly wrong. As usual.
> 
> Apparently it messes up with asm()s: it doesnt know the contents of the 
> asm() and hence it over-estimates the size [based on string heuristics] 
> ...

<snip>

> That win is mixed in slowpath and fastpath as well.
> 
> I see three options:
> 
>  - Disable CONFIG_OPTIMIZE_INLINING=y altogether (it's already 
>    default-off)

I'd like to see this, leave all the heuristics out of it, if I say inline, I
don't mean _maybe_, I mean you'd better damn well inline it.  On the other
hand, alpha seems to be hand-disabling the inline means __always_inline
in their arch headers, so if this option is kept, it should be enabled
on alpha as that is the current state of play there and get rid of that
arch-private bit.

> 
>  - Change the asm() inline markers to something new like asm_inline, which
>    defaults to __always_inline.

I'd suggest just making inline always mean __always_inline.  And get to
work removing inline from functions in C files.  This is probably also the
better choice to keep older gccs producing decent code.

> 
>  - Just mark all asm() inline markers as __always_inline - realizing that 
>    these should never ever be out of line.
> 
> We might still try the second or third options, as i think we shouldnt go 
> back into the business of managing the inline attributes of ~100,000 
> kernel functions.

Or just make it clear that inline shouldn't (unless for a very good reason)
_ever_ be used in a .c file.

Cheers,

Harvey

