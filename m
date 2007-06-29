Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbXF2FYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbXF2FYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXF2FYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:24:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbXF2FYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:24:44 -0400
Date: Thu, 28 Jun 2007 22:24:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: clameter@sgi.com, hugh@veritas.com, James.Bottomley@steeleye.com,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
Message-Id: <20070628222424.4cbae90c.akpm@linux-foundation.org>
In-Reply-To: <20070628.220606.112621271.davem@davemloft.net>
References: <Pine.LNX.4.64.0706282119330.11676@schroedinger.engr.sgi.com>
	<20070628.212825.78710369.davem@davemloft.net>
	<Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
	<20070628.220606.112621271.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 22:06:06 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Date: Thu, 28 Jun 2007 21:39:01 -0700 (PDT)
> 
> > Hmmmm... Maybe we are creating more of a mess with this. Isnt there some 
> > other way to handle these object.
> 
> That's where I was going with the silly idea to use another
> allocator :)
> 
> Really, it would be great if we could treat kmalloc() objects
> just like real pages.

>From a high level, that seems like a bad idea.  kmalloc() gives you a
virtual address and you really shouldn't be poking around at that memory's
underlying page's pageframe metadata.

However we can of course do tasteless and weird things if the benefit is
sufficient....

>  Everything wants to do I/O on pages
> but sometimes (like the networking) you have a kmalloc
> chunk which is technically just a part of a page.

hm.  So what happens when two quite different threads of control are doing
IO against two hunks of kmalloced memory which happen to come from the same
page?  Either some (kernel-wide) locking is needed, or that pageframe needs
to be treated as readonly?

