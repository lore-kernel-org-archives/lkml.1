Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0BHJ2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:28:53 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:46658 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab0BHJ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:28:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=FBYKkqqXRaKg2rWc5sV778+Q0yhheDt10cdabg+W7e38bO1DpIRWxZIQS5tfhbkVp2
         o6E62EyJLhkEY73PNdJ60aOB3o8FmHlx1ELRjWHMAvg+uoqxNEn6n4la90PsgeLmV1f8
         Knli+UzYywUaSl89/JhmOfoXaW4Dq/Am8xOG4=
Date: Mon, 8 Feb 2010 10:28:45 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
Message-ID: <20100208092845.GB12618@a1.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Jamie Lokier <jamie@shareable.org>,
	Roland Dreier <rdreier@cisco.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
References: <1265222875.24455.1020.camel@laptop>
 <4B69D362.10608@zytor.com>
 <20100204151050.GC32711@aftab>
 <1265296432.22001.18.camel@laptop>
 <20100204155419.GD32711@aftab>
 <1265299457.22001.72.camel@laptop>
 <20100205121139.GA9044@aftab>
 <4B6C93A2.1090302@zytor.com>
 <20100206093659.GA28326@aftab>
 <4B6E1DA3.50204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B6E1DA3.50204@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 05:55:47PM -0800, H. Peter Anvin wrote:
> > Well, the example Brian pointed me to - __mutex_fastpath_lock - lists
> > the full set of clobbered registers. Please elaborate on the assembly
> > wrapper for the function, wouldn't I need to list all the clobbered
> > registers there too or am I missing something?
> > 
> 
> The notion there would be that you do push/pop in the assembly wrapper.

Oh yes, something similar to SAVE/RESTORE_ALL in
<arch/x86/kernel/entry_32.S> could work. Good idea!

> >> d) On the other hand, you do *not* need a "memory" clobber.
> > 
> > Right, in this case we have all non-barrier like inlines so no memory
> > clobber, according to the comment above alternative() macro.
> 
> OK, I'm missing something here.
> 
> A few more notions:
> 
> a. This is exactly the kind of code where you don't want to put
> "volatile" on your asm statement, because it's a pure compute.
> 
> b. It is really rather pointless to go through the whole alternatives
> work if you are then going to put it inside a function which isn't an
> inline ...

Well, in the second version I did replace a 'call _hweightXX' with
the actual popcnt opcode so the alternatives is only needed to do the
replacement during boot. We might just as well do

if (X86_FEATURE_POPCNT)
	__hw_popcnt()
else
	__software_hweight()

The only advantage of the alternatives is that it would save us the
if-else test above each time we do cpumask_weight. However, the if-else
approach is much more readable and obviates the need for all that macro
magic and taking special care of calling c function from within asm. And
since we do not call cpumask_weight all that often I'll honestly opt for
alternative-less solution...

Hmm...

Thanks,
Boris.
