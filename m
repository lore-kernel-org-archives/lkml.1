Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbZBKRa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbZBKRa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbZBKRaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:30:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45126 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbZBKRaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:30:10 -0500
Date: Wed, 11 Feb 2009 11:24:16 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Sesterhenn <snakebyte@gmx.de>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: namespaces?: bug at mm/slub.c:2750
Message-ID: <20090211172416.GA30756@us.ibm.com>
References: <20090211163753.GA29372@us.ibm.com> <20090206113556.GA3161@alice> <20090206161518.81e7d42c.akpm@linux-foundation.org> <19f34abd0902102355o5bf51096o9aa3737e87104fb9@mail.gmail.com> <20090211000740.f1de7cec.akpm@linux-foundation.org> <19f34abd0902110248n22f8de12lccfa99faafafb942@mail.gmail.com> <1538.1234371764@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538.1234371764@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> >  static void uid_hash_remove(struct user_struct *up)
> >  {
> > +	put_user_ns(up->user_ns);
> >  	hlist_del_init(&up->uidhash_node);
> >  }
> 
> Don't you need to do the hlist_del_init() first?  Otherwise, mightn't the
> put_user_ns() cause the namespace to be freed before hlist_del_init() removes
> the user_struct from it?

It's called under uidhash_lock spinlock so should be ok, but in
principle you're right so it's probably a good idea.

The main point is that without this patch, put_user_ns is done before
the hlist_del_init and *not* atomically under uidhash_lock.

thanks,
-serge
