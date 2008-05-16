Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYEPRbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYEPRbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYEPRat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:30:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40058 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYEPRas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:30:48 -0400
Subject: Re: [PATCH] Fix DIO EIO error caused by race between
	jbd_commit_transaction() and journal_try_to_drop_buffers()
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Josef Bacik <jbacik@redhat.com>, Jan Kara <jack@suse.cz>,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1210958239.4231.34.camel@badari-desktop>
References: <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
	 <20080512155419.GD15856@duck.suse.cz>
	 <1210639184.3661.43.camel@localhost.localdomain>
	 <20080513145449.GC20806@duck.suse.cz>
	 <1210717389.3638.24.camel@localhost.localdomain>
	 <20080514170856.GH24363@duck.suse.cz>
	 <1210786872.3657.48.camel@localhost.localdomain>
	 <20080514181444.GI24363@duck.suse.cz>
	 <1210947250.3608.18.camel@localhost.localdomain>
	 <20080516150146.GA21018@unused.rdu.redhat.com>
	 <1210957894.3608.23.camel@localhost.localdomain>
	 <1210958239.4231.34.camel@badari-desktop>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 16 May 2008 10:30:35 -0700
Message-Id: <1210959035.3608.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-16 at 10:17 -0700, Badari Pulavarty wrote:

> > @@ -1713,7 +1753,31 @@ int journal_try_to_free_buffers(journal_
> >  		if (buffer_jbd(bh))
> >  			goto busy;
> >  	} while ((bh = bh->b_this_page) != head);
> > +
> >  	ret = try_to_free_buffers(page);
> > +
> > + 	/*
> > +	 * In the case of concurrent direct IO and buffered IO,
> > +	 * There are a number of places where we
> > +	 * could race with journal_commit_transaction(), the later still
> > +	 * helds the reference to the buffers to free while processing them.
> > +	 * try_to_free_buffers() failed to free those buffers,
> > +	 * resulting in an unexpected EIO error
> > +	 * returns back to the generic_file_direct_IO()
> > +	 *
> > +	 * So let's wait for the current transaction finished flush
> > +	 * dirty data buffers before we try to free those buffers
> > +	 * again. This wait is needed by direct IO code path only,
> > +	 * gfp_mask __GFP_REPEAT is passed from the direct IO code
> > +	 * path to flag if we need to wait and retry free buffers.
> > +	 */
> > +	if (ret == 0 && dio) {
> 
> drop "dio" variable and compare here, like 
> 	  if (ret == 0 && (gfp_mask & __GFP_REPEAT)
> 

Okay, will do. Also will update the patch with other format changes you
suggested.

> > +        	spin_lock(&journal->j_state_lock);
> > +		journal_wait_for_transaction_sync_data(journal);
> > +		ret = try_to_free_buffers(page);
> > +		spin_unlock(&journal->j_state_lock);
> > +	}
> 


Also, This patch changed the struct journal_s to add a new wait queue,
so that journal_try_to_free_buffers() could only need to wait for data
to be commited, rather than using j_wait_done_commit queue and wait for
the whole transaction being committed. It might break other fs  that
uses journal_s, thus not worth it. Will update the patch.

