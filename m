Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbZCCA0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbZCCA0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbZCCAZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:25:53 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:18463 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZCCAZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:25:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sBBVChZMZqnoDjsjLdoo9+OQ8OSj/3oYpXOmsydbNKsZPUNsFf8Lp5ltp0saZsPsye
         jpLeiR/UEfUhPxij5OaUAL+MyR2KN7GhjgTvlG5/pmj4JO5e64zbSwzTjDufHHX6ZcFi
         eH+eHd9mtcXegcfFh7Ngy6tGZq8CXUXxFDQLI=
Subject: Re: [PATCH 1/2] byteorder: add load/store_{endian} API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <alpine.LFD.2.00.0903021613590.3111@localhost.localdomain>
References: <1236038817.5756.11.camel@brick>
	 <alpine.LFD.2.00.0903021613590.3111@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 16:25:44 -0800
Message-Id: <1236039944.5756.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 16:15 -0800, Linus Torvalds wrote:
> 
> On Mon, 2 Mar 2009, Harvey Harrison wrote:
> > 
> > store_le16 is a new API and is added to be symmetric with the unaligned
> > functions.
> 
> This seems to be expressly designed to be unsafe, in that it casts the 
> thing to the right type, making it impossible for sparse to warn about 
> bad byteorder use.
> 

Unfortunately yes, hopefully you have a solution for the problem I ran
into with this part:

This was added to be symmetric with the unaligned store API, and replace
code doing

*(__le16 *)ptr = cpu_to_le16(val);

So existing code is casting already in most of the places this could be
used.  And although this could be made a static inline and get the sparse
checking, we lose one of the big advantages of the open-coding - constants
are byteswapped at compile time.  Although gcc (4.4) grew support for __builtin_constant_p
in static inlines, older gcc's don't, so we would lose that with essentially
all current compilers.

So the option was to make it a static inline and get the sparse checking, or
add the cast in the macro and lose sparse checking but preserve the compile-time
swapping...maybe I chose poorly.

Thoughts?

Harvey

