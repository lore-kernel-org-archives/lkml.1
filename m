Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYJOQea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYJOQea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYJOQeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:34:23 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:28106 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752470AbYJOQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:34:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rkwbMTears0f9VUbbC5mDL1VkNdKJryPRGmbkVOA3f7azwoHseRs/rPz1o8SVLe5xCSyAKuNipiZ/Z/8WmOqM6HINBUBeZRnYBpTcRuyTzKhOqO8fi0LVmXhbnhyPjWBKUXGfvKEXWpEuCZpA/GKTbvcJbZhTHo+kzM0wyb4GGE=  ;
X-YMail-OSG: JNWKhfIVM1kdIa_zFz2OSFUQxNfnA.3_E72J9ZZjBG8VYjm58p.htXTP1mJAw3DeqZgstHntZMdUtYx86tYZCbcl2wUggkqDWl7vu1PyE7ndxi6EBcCA99drwiUuYtjIjuKnFqJyTiY.lVPHudZ7N6nkkoE47kQTENYs.e3N
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: torvalds@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [rfc] SLOB memory ordering issue
Date: Thu, 16 Oct 2008 03:34:12 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810160334.13082.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I see a possible memory ordering problem with SLOB:
In slab caches with constructors, the constructor is run
before returning the object to caller, with no memory barrier
afterwards.

Now there is nothing that indicates the _exact_ behaviour
required here. Is it at all reasonable to expect ->ctor() to
be visible to all CPUs and not just the allocating CPU?

SLAB and SLUB don't appear to have this problem. Of course,
they have per-CPU fastpath queues, so _can_ have effectively
exactly the same ordering issue if the object was brought
back into the "initialized" state before being freed, rather
than by ->ctor(). However in that case, it is at least
kind of visible to the caller.

Anyone care or think it is a problem? Should we just document
that ->ctor doesn't imply any barriers? Better ideas?

