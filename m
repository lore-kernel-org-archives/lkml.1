Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbXCTPLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbXCTPLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933601AbXCTPLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:11:04 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41581 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933609AbXCTPLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:11:01 -0400
Date: Tue, 20 Mar 2007 08:09:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@muc.de>,
       David Miller <davem@davemloft.net>, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, anthony@codemonkey.ws, netdev@vger.kernel.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
In-Reply-To: <45FF770C.7050301@goop.org>
Message-ID: <Pine.LNX.4.64.0703200805450.6730@woody.linux-foundation.org>
References: <20070316.023331.59468179.davem@davemloft.net>  <45FB005D.9060809@goop.org>
  <1174127638.8897.75.camel@localhost.localdomain>  <20070318.003309.71088169.davem@davemloft.net>
  <20070318120814.GA45869@muc.de>  <1174272469.11680.23.camel@localhost.localdomain>
  <m1648xxf93.fsf@ebiederm.dsl.xmission.com> 
 <Pine.LNX.4.64.0703191134190.6730@woody.linux-foundation.org>
 <1174348905.11680.54.camel@localhost.localdomain> <45FF4043.4000805@vmware.com>
 <45FF770C.7050301@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Mar 2007, Jeremy Fitzhardinge wrote:
>
> Zachary Amsden wrote:
> > For VMI, the default clobber was "cc", and you need a way to allow at
> > least that, because saving and restoring flags is too expensive on x86.
> 
> According to lore (Andi, I think), asm() always clobbers cc. 

On x86, yes. Practically any instruction will clobber cc anyway, so it's 
the default.

Although the gcc guys have occasionally been suggesting we should set it 
in our asms.

> Actually, it still does need a temp register.  The sequence for cli is:
> 
>     mov %fs:xen_vcpu, %eax
>     movb $1,1(%eax)

We should just do this natively. There's been several tests over the years 
saying that it's much more efficient to do sti/cli as a simple store, and 
handling the "oops, we got an interrupt while interrupts were disabled" as 
a special case.

I have this dim memory that ARM has done it that way for a long time 
because it's so expensive to do a "real" cli/sti.

And I think -rt does it for other reasons. It's just more flexible.

		Linus

