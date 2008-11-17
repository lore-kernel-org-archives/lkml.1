Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYKQTGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYKQTGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYKQTGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:06:04 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52092 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYKQTGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:06:01 -0500
Subject: Re: [PATCH 4/4] integrity: IMA radix tree
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, zohar@us.ibm.com
In-Reply-To: <20081114141518.3a463dfe.akpm@linux-foundation.org>
References: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
	 <eb03c8958cecce6f38ff9d7ab562542ee1def143.1226547085.git.zohar@linux.vnet.ibm.com>
	 <20081114141518.3a463dfe.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 14:05:36 -0500
Message-Id: <1226948736.2927.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 14:15 -0800, Andrew Morton wrote: 
> On Wed, 12 Nov 2008 22:47:14 -0500
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > This version stores integrity information associated with an inode
> > in a radix tree in order to avoid bloating the in memory inode.
> > As entries can not be added to the radix tree at security_initcall,
> > this version removes the dual stage initialization.  Allocating and
> > freeing the memory continues to be done at inode_alloc and file_free,
> > respectively, except for inodes created before late_initcall.
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > ---
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index bc6460c..0dcdd94 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -683,9 +683,6 @@ struct inode {
> >  #ifdef CONFIG_SECURITY
> >  	void			*i_security;
> >  #endif
> > -#ifdef CONFIG_INTEGRITY
> > -	void			*i_integrity;
> > -#endif
> 
> ah, I was going to ask about that..

Hm, perhaps posting as a separate patch was not such a good idea.

> >  	void			*i_private; /* fs or device private pointer */
> >  };
> >  
> > diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
> > index f3aced4..959ae66 100644
> > --- a/security/integrity/ima/Makefile
> > +++ b/security/integrity/ima/Makefile
> > @@ -6,4 +6,4 @@
> >  obj-$(CONFIG_IMA) += ima.o
> >  
> >  ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
> > -	 ima_policy.o
> > +	 ima_policy.o ima_iint.o
> > diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> > index 9a24305..09a5e1a 100644
> > --- a/security/integrity/ima/ima.h
> > +++ b/security/integrity/ima/ima.h
> > @@ -92,7 +92,6 @@ void ima_store_measurement(void *d);
> >  void ima_template_show(struct seq_file *m, void *e,
> >  		       enum integrity_show_type show);
> >  
> > -
> >  /*
> >   * used to protect h_table and sha_table
> >   */
> > @@ -109,7 +108,7 @@ extern struct ima_h_table ima_htable;
> >  
> >  static inline unsigned long IMA_HASH_KEY(u8 *digest)
> >  {
> > -	 return(hash_long(*digest, IMA_HASH_BITS));
> > +	return (hash_long(*digest, IMA_HASH_BITS));
> 
> And I _did_ ask about that ;)
Definitely better now.

> >  }
> >  
> >  /* TPM "Glue" definitions */
> > @@ -145,11 +144,36 @@ struct ima_iint_cache {
> >  	u8 hmac[IMA_DIGEST_SIZE];
> >  	u8 digest[IMA_DIGEST_SIZE];
> >  	struct mutex mutex;
> > +	atomic_t refcount;
> >  };
> >  #define IMA_IINT_INIT		1
> >  #define IMA_MUST_MEASURE	2
> >  #define IMA_MEASURED		4
> >  
> > +void ima_iint_init(void);
> > +struct ima_iint_cache * ima_iint_lookup(struct inode *inode);
> 
> checkpatch...
> >
> > ...
> >
> > --- /dev/null
> > +++ b/security/integrity/ima/ima_iint.c
> > @@ -0,0 +1,68 @@
> > +/*
> > + * Copyright (C) 2008 IBM Corporation
> > + *
> > + * Authors:
> > + * Mimi Zohar <zohar@us.ibm.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation, version 2 of the
> > + * License.
> > + *
> > + * File: ima_iint.c
> > + *             cache integrity information associated with an inode
> > + *             using a radix tree.
> > + */
> > +#include <linux/module.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/radix-tree.h>
> > +#include "ima.h"
> > +
> > +static struct radix_tree_root ima_iint_store;
> > +DEFINE_SPINLOCK(ima_iint_lock);
> > +
> > +void ima_iint_init(void)
> > +{
> > +	INIT_RADIX_TREE(&ima_iint_store, GFP_ATOMIC);
> > +}
> 
> Use the RADIX_TREE() macro, then remove this function.

Done. Will be in next patch set.

Mimi

