Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYEPON4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYEPON4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYEPONs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:13:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60318 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbYEPONq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:13:46 -0400
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Jan Kara <jack@suse.cz>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080514181444.GI24363@duck.suse.cz>
References: <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
	 <20080512155419.GD15856@duck.suse.cz>
	 <1210639184.3661.43.camel@localhost.localdomain>
	 <20080513145449.GC20806@duck.suse.cz>
	 <1210717389.3638.24.camel@localhost.localdomain>
	 <20080514170856.GH24363@duck.suse.cz>
	 <1210786872.3657.48.camel@localhost.localdomain>
	 <20080514181444.GI24363@duck.suse.cz>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 16 May 2008 07:13:33 -0700
Message-Id: <1210947214.3608.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-14 at 20:14 +0200, Jan Kara wrote:
> On Wed 14-05-08 10:41:12, Mingming Cao wrote:
> > > > Bummer, we can't free buffers in ext3_launder_page() before calling
> > > > try_to_free_page, as later
> > > > invalidate_complete_page2()->try_to_free_page() expecting the page
> > > > buffers are still here, and will return EIO if it launder_page() has
> > > > already freed those buffers.:(
> > >   Are you sure? Because if bufferes are released in ext3_launder_page(),
> > > PagePrivate() has been set to 0 and we should directly fall through to
> > > releasing the page without ever calling try_to_release_page()... So I'd
> > > want to find out why PagePrivate is still set in
> > > invalidate_complete_page2().
> > > 
> > 
> > You are right. PagePrivate() is being set to 0 in drop_buffers(). 
> > 
> > The problem is do_launder_page() returns successfully if the page is not
> > dirty (our case), so ext3_launder_page() is not even get called. This
> > also explains why the log_wait_commit() approach doesn't work for me:(
>   I didn't realize PageDirty() is going to be already cleared by previous
> writes... :(
> 
> > Have to think other ways...could we pass some flag to
> > journal_try_to_free_buffers(), and ask journal_try_to_free_buffers()
> > wait for jbd commit to finish flushing the data, if the request is from
> > directo IO?
>   Well, we could do that but we'd have to change try_to_release_page() call
> to accept an extra argument which would consequently mean changing all the
> filesystems... 

Actually there is an argument gfp_mask passed to try_to_release_page()
which we could pass a special flag from direct IO that could be parsed
as direct IO request.  This would avoid changing all the filesystems and
the address space operation interface.  In fact, I don't see in-kernel
tree fs releasepage() cal back functions is using this gfp_mask, but
btrfs is using it.

> But yes, it probably makes sence because it is really
> different whether we should just release the page because of memory
> pressure or because direct IO needs to write to that area of the file.
> So adding the parameter to releasepage() callback is probably a reasonable
> thing to do.
> 
Will send a patch shortly, with that patch the test fine for about 18
hours. 


