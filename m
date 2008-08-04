Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbYHDWPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbYHDWPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYHDWOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:14:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38883
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbYHDWOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:14:50 -0400
Date: Mon, 04 Aug 2008 15:14:48 -0700 (PDT)
Message-Id: <20080804.151448.190011603.davem@davemloft.net>
To: tony.luck@intel.com
Cc: nacc@us.ibm.com, mingo@elte.hu, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BISECTION RESULT] sched: revert cpu_clock to
 pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
From: David Miller <davem@davemloft.net>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA308329139@orsmsx505.amr.corp.intel.com>
References: <57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com>
	<20080804.150249.71509974.davem@davemloft.net>
	<57C9024A16AD2D4C97DC78E552063EA308329139@orsmsx505.amr.corp.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>
Date: Mon, 4 Aug 2008 15:10:40 -0700

> > Can you guys on IA64 possibly set ar.k3 simply to zero or to some
> > other similar value which cancels out the per-cpu computation?
> >
> > That's what sparc64 and other platforms do.
> 
> In cpu_init() we set ar.k3 to the base physical address of the percpu
> area.  The alt-dtlb miss handler uses this register to set up a
> TLB mapping from virtual address 0xffffffffffff0000 to this physical
> address.
> 
> This means that most per-cpu accesses are very cheap (as the compiler
> can use a small -ve offset from register r0 to load the virtual
> address).
> 
> Accessing ar.k3 is a bit slow ... so making the per-cpu code
> use that on every access to a per-cpu variable would be unpleasant.

I understand that you use TLB mappings.

What I'm suggesting is to very early on set ar.k3 to something which
makes accesses go through the __per_cpu image copy in the main kernel
image.

You could even set up a dummy TLB mapping during this early boot
period.

Otherwise it's just cleverness that is unique to IA64 and is going to
constantly run into issues like this.  An alternative is to implement
your own sched_clock() et al. where you can adhere to whatever special
rules your platform may have.
