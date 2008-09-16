Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYIPWKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYIPWKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYIPWJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:09:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42959 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYIPWJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:09:55 -0400
Date: Tue, 16 Sep 2008 17:09:12 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v5][PATCH 7/8] Infrastructure for shared objects
Message-ID: <20080916220912.GA21663@us.ibm.com>
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu> <1221347167-9956-8-git-send-email-orenl@cs.columbia.edu> <20080916205459.GA7644@us.ibm.com> <48D026ED.3080109@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D026ED.3080109@cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> 
> 
> Serge E. Hallyn wrote:
> > Quoting Oren Laadan (orenl@cs.columbia.edu):
> >> Infrastructure to handle objects that may be shared and referenced by
> >> multiple tasks or other objects, e..g open files, memory address space
> >> etc.
> >>
> >> The state of shared objects is saved once. On the first encounter, the
> >> state is dumped and the object is assigned a unique identifier (objref)
> >> and also stored in a hash table (indexed by its physical kenrel address).
> >> >From then on the object will be found in the hash and only its identifier
> >> is saved.
> >>
> >> On restart the identifier is looked up in the hash table; if not found
> >> then the state is read, the object is created, and added to the hash
> >> table (this time indexed by its identifier). Otherwise, the object in
> >> the hash table is used.
> >>
> >> Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
> > 
> > Acked-by: Serge Hallyn <serue@us.ibm.com>
> > 
> > Thanks, Oren, I actually think this is quite nice and readable.
> > 
> > Though three questions below.  First one is, since you've mentioned
> > having multiple threads doing checkpoint, won't you need some locking?
> 
> yes.
> 
> > I assume that's coming in later patches if/when needed?
> 
> yes.
> 
> [...]
> 
> >> +++ b/checkpoint/objhash.c
> >> @@ -0,0 +1,237 @@
> >> +/*
> >> + *  Checkpoint-restart - object hash infrastructure to manage shared objects
> >> + *
> >> + *  Copyright (C) 2008 Oren Laadan
> >> + *
> >> + *  This file is subject to the terms and conditions of the GNU General Public
> >> + *  License.  See the file COPYING in the main directory of the Linux
> >> + *  distribution for more details.
> >> + */
> >> +
> >> +#include <linux/kernel.h>
> >> +#include <linux/file.h>
> >> +#include <linux/hash.h>
> >> +#include <linux/checkpoint.h>
> >> +
> >> +struct cr_objref {
> >> +	int objref;
> >> +	void *ptr;
> >> +	unsigned short type;
> > 
> > What is the point of the 'type'?
> > 
> > By that I mean: is it meant to catch bugs in the implementation, or bad
> > checkpoint images?
> 

...

> There are different functions to inc/dec the reference count of objects
> of different types. '->type' keeps track of the type of the object, so
> we know which function to call. (At this point, we only track shared
> 'struct file' so it isn't that clear from the code).

Doh, right.

> 
> > 
> >> +	unsigned short flags;
> >> +	struct hlist_node hash;
> >> +};
> >> +
> >> +struct cr_objhash {
> >> +	struct hlist_head *head;
> >> +	int objref_index;
> > 
> > What exactly will objref_index be used for?  I don't see any real
> > usage here or in your later patches.
> > 
> 
> 'objref_index' is a counter used to assign unique identifiers (objref)
> to objects as they are added to the hash table. It is incremented with
> every object that joins the hash table (and the old value is used as
> the objref of that object). It is used in cr_obj_new().

If you were to rename objref_index to next_free_ref, I think that'd
be helpful.  (I also don't think 'obj' should in the name at all, and
you should just s/objref/id/, but that's really too much pain)

thanks,
-serge
