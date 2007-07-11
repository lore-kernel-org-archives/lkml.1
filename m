Return-Path: <linux-kernel-owner+w=401wt.eu-S1765383AbXGKR3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765383AbXGKR3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbXGKR3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:29:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40018 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151AbXGKR3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:29:32 -0400
Date: Wed, 11 Jul 2007 10:29:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Dilger <adilger@clusterfs.com>
Cc: Girish Shilamkar <girish@clusterfs.com>, cmm@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 8][PATCH 1/1]Add journal checksums
Message-Id: <20070711102917.88ef762a.akpm@linux-foundation.org>
In-Reply-To: <20070711130108.GB6417@schatzie.adilger.int>
References: <1183275505.4010.136.camel@localhost.localdomain>
	<20070710231601.798304e0.akpm@linux-foundation.org>
	<1184154399.3867.44.camel@dhcp4.linsyssoft.com>
	<20070711130108.GB6417@schatzie.adilger.int>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 07:01:08 -0600 Andreas Dilger <adilger@clusterfs.com> wrote:

> > > > -	/* AKPM: buglet - add `i' to tmp! */
> > > 
> > > Damn.  After, what, seven years, someone actually fixed it?
> > > 
> > > >  	for (i = 0; i < bh->b_size; i += 512) {
> > > > -		journal_header_t *tmp = (journal_header_t*)bh->b_data;
> > > > +		struct commit_header *tmp =
> > > > +			(struct commit_header *)(bh->b_data + i);
> > > >  		tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
> > > >  		tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
> > > >  		tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
> > > > +
> > > > +		if (JBD2_HAS_COMPAT_FEATURE(journal,
> > > > +					    JBD2_FEATURE_COMPAT_CHECKSUM)) {
> > > > +			tmp->h_chksum_type 	= JBD2_CRC32_CHKSUM;
> > > > +			tmp->h_chksum_size 	= JBD2_CRC32_CHKSUM_SIZE;
> > > > +			tmp->h_chksum[0] 	= cpu_to_be32(crc32_sum);
> > > > +		}
> > > >  	}
> > > 
> > > And in doing so, changed the on-disk format of the journal commit blocks.
> > > 
> > > Surely this was worth a mention in the changelog, if not a standalone patch?
> > > 
> > > I don't think this is worth doing, really.  Why not just leave the format
> > > as it was, take the loop out and run this code once rather than eight
> > > times?
> 
> Well, we aren't using the rest of the commit block in any case.  I think
> the original intention was that we'd get 8 copies of the commit block so
> we would be sure to get a good one.
> 
> I don't know whether we'd rather have 8 copies of the commit block, or
> more potential to expand the commit block?  I don't personally have any
> preference, since the checksum should be a more robust way of checking
> validity than having multiple copies, so we may as well remove the loop
> and stick with a single copy for now.

We've never altered any commit block sectors apart from the zeroeth one
(eight times) due to the above bug.  So I'd suggest that we should formalise
the old bug and leave the format as-is.  That'll leave lots of space spare in
the commit block.
