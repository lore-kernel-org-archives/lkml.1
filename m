Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbXF2Fpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbXF2Fpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXF2Fpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:45:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbXF2Fpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:45:35 -0400
Date: Thu, 28 Jun 2007 22:45:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: clameter@sgi.com, hugh@veritas.com, James.Bottomley@steeleye.com,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
Message-Id: <20070628224519.1a3319c3.akpm@linux-foundation.org>
In-Reply-To: <20070628.223734.21928089.davem@davemloft.net>
References: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
	<20070628.220606.112621271.davem@davemloft.net>
	<20070628222424.4cbae90c.akpm@linux-foundation.org>
	<20070628.223734.21928089.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 22:37:34 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 28 Jun 2007 22:24:24 -0700
> 
> > So what happens when two quite different threads of control are doing
> > IO against two hunks of kmalloced memory which happen to come from the same
> > page?  Either some (kernel-wide) locking is needed, or that pageframe needs
> > to be treated as readonly?
> 
> Or you put an atomic_t at the beginning or tail of every SLAB
> object.  It's a space cost not a runtime cost for the common
> case which is:
> 
> 	smp_rmb();
> 	if (atomic_read(&slab_obj->count) == 1)
> 		really_free_it();
> 	else if (atomic_dec_and_test(...))
> 
> Note I don't like this variant either. :)

but, but...  Christoph said 'The dma layer may then perform operations on
the "slab page'.

If those operations involve modifying that slab page's pageframe then what
stops concurrent dma'ers from stomping on each other's changes?  As in:
why aren't we already buggy?

If those operations _don't_ involve modifying the pageframe (hopes this is
true) then we're read-only and things become much easier?
