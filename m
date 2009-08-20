Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZHTQGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZHTQGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZHTQGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZHTQGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:06:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0908200816090.3158@localhost.localdomain>
References: <alpine.LFD.2.01.0908200816090.3158@localhost.localdomain> <20090820104956.29972.92662.stgit@warthog.procyon.org.uk> <20090820105001.29972.33221.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Use the cut_here() function in AFS, CacheFiles, FS-Cache and RxRPC
Date: Thu, 20 Aug 2009 17:06:31 +0100
Message-ID: <6149.1250784391@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> instead. And yes, in the long run, I really think we should just extend 
> the current BUG() reporting to have that kind of semantics, but I think 
> your "cut_here()" thing is a horrible hack.

What about situations where I want to print quite a lot of information, say
several lines' worth?

For instance, if you look at cachefiles_mark_object_active() in
fs/cachefiles/namei.c, you'll see something like (which extended by one of my
patches):

wait_for_old_object:
	if (xobject->fscache.state < FSCACHE_OBJECT_DYING) {
		unsigned keylen;
		u8 *keybuf;

		printk(KERN_ERR "\n");
		printk(KERN_ERR "CacheFiles: Error:"
		       " Unexpected object collision\n");
		printk(KERN_ERR "xobject: OBJ%x\n",
		       xobject->fscache.debug_id);
		printk(KERN_ERR "xobjstate=%s\n",
		       fscache_object_states[xobject->fscache.state]);
		printk(KERN_ERR "xobjflags=%lx\n", xobject->fscache.flags);
		printk(KERN_ERR "xobjevent=%lx [%lx]\n",
		       xobject->fscache.events, xobject->fscache.event_mask);
		printk(KERN_ERR "xops=%u inp=%u exc=%u\n",
		       xobject->fscache.n_ops, xobject->fscache.n_in_progress,
		       xobject->fscache.n_exclusive);
		printk(KERN_ERR "xcookie=%p [pr=%p nd=%p fl=%lx]\n",
		       xobject->fscache.cookie,
		       xobject->fscache.cookie->parent,
		       xobject->fscache.cookie->netfs_data,
		       xobject->fscache.cookie->flags);
		printk(KERN_ERR "xparent=%p\n",
		       xobject->fscache.parent);
		printk(KERN_ERR "object: OBJ%x\n",
		       object->fscache.debug_id);
		printk(KERN_ERR "cookie=%p [pr=%p nd=%p fl=%lx]\n",
		       object->fscache.cookie,
		       object->fscache.cookie->parent,
		       object->fscache.cookie->netfs_data,
		       object->fscache.cookie->flags);
		printk(KERN_ERR "parent=%p\n",
		       object->fscache.parent);

		keybuf = kmalloc(512, GFP_NOIO);
		if (keybuf) {
			struct fscache_cookie *cookie;
			unsigned loop;

			cookie = object->fscache.cookie;
			keylen = cookie->def->get_key(cookie->netfs_data,
						      keybuf, 512);
			printk(KERN_ERR "okey=[%u] '", keylen);
			for (loop = 0; loop < keylen; loop++)
				printk("%02x", keybuf[loop]);
			printk("'\n");

			cookie = xobject->fscache.cookie;
			keylen = cookie->def->get_key(cookie->netfs_data,
						      keybuf, 512);
			printk(KERN_ERR "xkey=[%u] '", keylen);
			for (loop = 0; loop < keylen; loop++)
				printk("%02x", keybuf[loop]);
			printk("'\n");

			kfree(keybuf);
		}

		BUG();

With the cut_here() approach, I could put a cut_here() just inside the if-body,
but doing it with your approach and putting the whole lot in one format string
would also be pretty horrible, and risks overrunning the printk buffer.

David

