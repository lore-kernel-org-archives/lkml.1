Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZBPU0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZBPU0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZBPU0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:26:18 -0500
Received: from cmpxchg.org ([85.214.51.133]:48804 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbZBPU0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:26:17 -0500
Date: Mon, 16 Feb 2009 21:28:22 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: Re: [patch 7/8] ecryptfs: use kzfree()
Message-ID: <20090216202822.GA2759@cmpxchg.org>
References: <20090216142926.440561506@cmpxchg.org> <20090216144726.088020837@cmpxchg.org> <20090216120204.44f78aa2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216120204.44f78aa2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 12:02:04PM -0800, Andrew Morton wrote:
> On Mon, 16 Feb 2009 15:29:33 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > --- a/fs/ecryptfs/keystore.c
> > +++ b/fs/ecryptfs/keystore.c
> > @@ -740,8 +740,7 @@ ecryptfs_write_tag_70_packet(char *dest,
> >  out_release_free_unlock:
> >  	crypto_free_hash(s->hash_desc.tfm);
> >  out_free_unlock:
> > -	memset(s->block_aligned_filename, 0, s->block_aligned_filename_size);
> > -	kfree(s->block_aligned_filename);
> > +	kzfree(s->block_aligned_filename);
> >  out_unlock:
> >  	mutex_unlock(s->tfm_mutex);
> >  out:
> > --- a/fs/ecryptfs/messaging.c
> > +++ b/fs/ecryptfs/messaging.c
> > @@ -291,8 +291,7 @@ int ecryptfs_exorcise_daemon(struct ecry
> >  	if (daemon->user_ns)
> >  		put_user_ns(daemon->user_ns);
> >  	mutex_unlock(&daemon->mux);
> > -	memset(daemon, 0, sizeof(*daemon));
> > -	kfree(daemon);
> > +	kzfree(daemon);
> >  out:
> >  	return rc;
> >  }
> 
> Except for this one and the crypto one, which might have been done for
> security reasons.

Actually, only atm is not security related and should probably be
dropped.  I didn't convert w1 for the same reason.

> Even though both of them forgot to add a comment explaining this, which
> is bad, wrong, stupid and irritating.  Sigh.

Humm, I considered

	kfree(stuff->foo);
	kzfree(stuff->secret_password);
	kfree(stuff);

self-explaining.

Comments could still be added.  Even easier, as kzfree() is easier to
grep for then a memset() + kfree() sequence ;)

	Hannes
