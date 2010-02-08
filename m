Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0BHJ7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:59:54 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:46179 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab0BHJ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:59:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=e3ZWPTpuOBOVpeduEu6WmK/6T3goHdUIe9vpzLpfnF4Zo+xGj9JaRiWqKwpMfx9u6T
         bnjjPFaEHeJQDuUgr/iqe7cN3jRAY9dJzYkAXNVff20QMYV1VBEcWwlep7US50JUqD9n
         hAOFCgA5ChrW8rsG+gW1OzfB+bjR4w8TbRjtw=
Date: Mon, 8 Feb 2010 10:59:45 +0100
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
Message-ID: <20100208095945.GA14740@a1.tnic>
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
References: <20100204151050.GC32711@aftab>
 <1265296432.22001.18.camel@laptop>
 <20100204155419.GD32711@aftab>
 <1265299457.22001.72.camel@laptop>
 <20100205121139.GA9044@aftab>
 <4B6C93A2.1090302@zytor.com>
 <20100206093659.GA28326@aftab>
 <4B6E1DA3.50204@zytor.com>
 <20100208092845.GB12618@a1.tnic>
 <4B6FDAED.9060204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B6FDAED.9060204@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 01:35:41AM -0800, H. Peter Anvin wrote:
> On 02/08/2010 01:28 AM, Borislav Petkov wrote:
> >
> >Well, in the second version I did replace a 'call _hweightXX' with
> >the actual popcnt opcode so the alternatives is only needed to do the
> >replacement during boot. We might just as well do
> >
> >if (X86_FEATURE_POPCNT)
> >	__hw_popcnt()
> >else
> >	__software_hweight()
> >
> >The only advantage of the alternatives is that it would save us the
> >if-else test above each time we do cpumask_weight. However, the if-else
> >approach is much more readable and obviates the need for all that macro
> >magic and taking special care of calling c function from within asm. And
> >since we do not call cpumask_weight all that often I'll honestly opt for
> >alternative-less solution...
> >
> 
> The highest performance will be gotten by alternatives, but it only
> make sense if they are inlined at the point of use... otherwise it's
> basically pointless.

The popcnt-replacement part of the alternative would be as fast as
possible since we're adding the opcode there but the slow version would
add the additional overhead of saving/restoring the registers before
calling the software hweight implementation. I'll do some tracing to see
what a change like that would cost on machines which don't have popcnt.

Let me prep another version when I get back on Wed. (currently
travelling) with all the stuff we discussed to see how it would turn.

Thanks,
Boris.
