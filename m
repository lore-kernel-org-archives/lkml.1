Return-Path: <linux-kernel-owner+w=401wt.eu-S1030770AbXCTACQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030770AbXCTACQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030769AbXCTACQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:02:16 -0400
Received: from ozlabs.org ([203.10.76.45]:42898 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030761AbXCTACO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:02:14 -0400
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
	callsites to make them patchable
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@muc.de>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, anthony@codemonkey.ws,
       netdev@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703191134190.6730@woody.linux-foundation.org>
References: <20070316.023331.59468179.davem@davemloft.net>
	 <45FB005D.9060809@goop.org>
	 <1174127638.8897.75.camel@localhost.localdomain>
	 <20070318.003309.71088169.davem@davemloft.net>
	 <20070318120814.GA45869@muc.de>
	 <1174272469.11680.23.camel@localhost.localdomain>
	 <m1648xxf93.fsf@ebiederm.dsl.xmission.com>
	 <Pine.LNX.4.64.0703191134190.6730@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 11:01:45 +1100
Message-Id: <1174348905.11680.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 11:38 -0700, Linus Torvalds wrote:
> 
> On Mon, 19 Mar 2007, Eric W. Biederman wrote:
> > 
> > True.  You can use all of the call clobbered registers.
> 
> Quite often, the biggest single win of inlining is not so much the code 
> size (although if done right, that will be smaller too), but the fact that 
> inlining DOES NOT CLOBBER AS MANY REGISTERS!

Thanks Linus.

*This* was the reason that the current hand-coded calls only clobber %
eax.  It was a compromise between native (no clobbers) and others (might
need a reg).

Now, since we decided to allow paravirt_ops operations to be normal C
(ie. the patching is optional and done late), we actually push and pop %
ecx and %edx.  This makes the call site 10 bytes long, which is a nice
size for patching anyway (enough for a movl $0, <addr>, a-la lguest's
cli, or movw $0, %gs:<addr> if we supported SMP).

The current 6 paravirt ops which are patched cover the vast majority of
calls (until the Xen patches, then we need ~4 more?).  Jeremy chose to
expand patching to cover *all* paravirt ops, rather than just the new
hot ones, and that's where we tipped over the ugliness threshold.

Cheers,
Rusty.

