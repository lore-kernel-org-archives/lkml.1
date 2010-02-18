Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab0BRCWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:22:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755461Ab0BRCWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:22:49 -0500
Date: Wed, 17 Feb 2010 18:22:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Grant Likely <grant.likely@secretlab.ca>
cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Andrea Righi <righi.andrea@gmail.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: __weak vs ifdef
In-Reply-To: <fa686aa41002171807s71ac7176l769d78e2bb5d9a1@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1002171819020.4141@localhost.localdomain>
References: <20080725083943.GC19310@cs181140183.pp.htv.fi>  <20080725015537.564e3397.akpm@linux-foundation.org> <20080725091455.GD19310@cs181140183.pp.htv.fi>  <20080725092748.GF19310@cs181140183.pp.htv.fi> <20080725023455.dde3eb27.akpm@linux-foundation.org>
  <20080725122454.GE6701@parisc-linux.org> <alpine.LFD.1.10.0807261221480.4188@nehalem.linux-foundation.org> <fa686aa41002171807s71ac7176l769d78e2bb5d9a1@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Feb 2010, Grant Likely wrote:
> 
> Question.  If I use this pattern, and use the __weak attribute on core
> code functions wrapped with a #ifndef, then how does it mesh with
> EXPORT_SYMBOL*() statements?

You can't. Or at least not the traditional way, which is to put the 
EXPORT_SYMBOL next to the definition of what gets exported.

If you use __weak, you need to make sure that all users of said weak 
symbol are in another file. There are some compiler and/or binutils bugs 
with using weak symbols in the same translation unit, so the rule is that 
a weak definition hes to be somewhere else from the use - including 
EXPORT_SYMBOL.

> I also assume that at the core code site, the EXPORT_SYMBOL() must
> appear inside the #ifndef block so that a #define override doesn't
> break things.  Correct?

See above. You can't put it inside the _same_ #ifndef block. You'd have to 
put it in a different file, but yes, inside an ifndef. At which point the 
linker will just pick the right definition.

However, in general, this probably gets ugly enough that the whole __weak 
thing is not great for exported stuff. It's likely mostly useful for some 
"generic" arch functionality that is always compiled in.

		Linus
