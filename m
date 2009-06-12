Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZFLRv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZFLRv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZFLRvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:51:50 -0400
Received: from relay1.sgi.com ([192.48.179.29]:55130 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752894AbZFLRvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:51:50 -0400
Date: Fri, 12 Jun 2009 12:51:51 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 02/12] GRU - add user request to explicitly unload a gru context
Message-ID: <20090612175151.GB23235@sgi.com>
References: <20090608171648.988318000@sgi.com> <20090608171946.000713000@sgi.com> <20090608160525.86f38739.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608160525.86f38739.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 04:05:25PM -0700, Andrew Morton wrote:
> On Mon, 08 Jun 2009 12:16:50 -0500
> steiner@sgi.com wrote:
> 
> >  /*
> > + * Free all kernel contexts that are not currently in use.
> > + *   Returns 0 if all freed, else number of inuse context.
> > + */
> > +static int gru_free_kernel_contexts(void)
> > +{
> > +	struct gru_blade_state *bs;
> > +	struct gru_thread_state *kgts;
> > +	int bid, ret = 0;
> > +
> > +	for (bid = 0; bid < GRU_MAX_BLADES; bid++) {
> > +		bs = gru_base[bid];
> > +		if (!bs)
> > +			continue;
> > +		if (down_write_trylock(&bs->bs_kgts_sema)) {
> 
> trylocks are always lame - they add a rarely-executed code path where
> bugs can lurk.  They're often an admission that the locking is screwed
> up.
> 
> I don't know if the latter is true here, but it would be helpful to add
> a comment explaining what's going on, and why this unusual and
> troublesome locking primitive is being used.

Agree that trylock is frequently a crappy way to avoid a real fix
for potential ABBA deadlocks. However, in this case no potential locking inversion
is being avoided. The code in gru_free_kernel_contexts() is simply trying
to free any non-busy contexts where "busy" is defined as locked.
Contexts that are "busy" are simply skipped.

Also, this is a path that is rarely used. It exists primarily for stress testing.

I'll add comments to code to make this clearer.



> 
> > +			kgts = bs->bs_kgts;
> > +			if (kgts && kgts->ts_gru)
> > +				gru_unload_context(kgts, 0);
> > +			kfree(kgts);
> > +			bs->bs_kgts = NULL;
> > +			up_write(&bs->bs_kgts_sema);
> 
> nit: the kfree() can be moved outside the locked region.

Yuck. Done...


> 
> > +		} else {
> > +			ret++;
> > +		}
> > +	}
> > +	return ret;
> > +}

--- jack
