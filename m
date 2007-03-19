Return-Path: <linux-kernel-owner+w=401wt.eu-S933950AbXCSOAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950AbXCSOAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 10:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933946AbXCSOAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 10:00:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:51945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933917AbXCSOAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 10:00:47 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [S390] minor fault path optimization.
Date: Mon, 19 Mar 2007 15:00:34 +0100
User-Agent: KMail/1.9.5
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, linux-arch@vger.kernel.org
References: <20070319133149.GA5781@infradead.org>
In-Reply-To: <20070319133149.GA5781@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703191500.34563.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 March 2007 14:31, Christoph Hellwig wrote:
> On Mon, Mar 19, 2007 at 02:02:06PM +0100, Martin Schwidefsky wrote:
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > [S390] minor fault path optimization.
> > 
> > The minor fault path has grown a lot in terms of cycles. In particular
> > the kprobes hook is very costly. Optimize the path to save a couple of
> > cycles. If kprobes is enabled more than 300 cycles can be avoided if 
> > kprobes_running() is false.
> 
> Actually there is a lot more fishy here.  This code is duplicated over
> every single architecture.  It uses a notifier chain that only ever has
> one actual uaesr.  It exports interfaces that are potential harmful.

Agreed, it should be fixed generically.

I think the right fix would be to make the notifier call an inline
that checks the call chain in the caller. That would be cheap enough,
except for the cache line that might need to be referenced.

For the cache line the short term fix would be to find some other
global cache line that is referenced in the fault path anyways and put
it on the same (e.g. by just putting the variable next to it or
using a shared structure) 

Longer term might be something like Ben LaHaise's patch that can patch
code inline for rarely-read globals.

> Please do the right thing to optimize this instead and rip out the brandead
> notifier chain mechanisms and directly call into the krobes handler if
> kprobes are active, 

No, we should keep the debugger hooks here. Otherwise there will be a zillion
external patches patches code in at these places for the various debuggers,
resulting in a merge nightmare for lots of people.

-Andi
