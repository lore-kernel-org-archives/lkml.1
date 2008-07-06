Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYGFFbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYGFFbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 01:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYGFFax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 01:30:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:48492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYGFFaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 01:30:52 -0400
Date: Sat, 5 Jul 2008 22:30:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH] fix potential latency issues in JBD's journal code
Message-ID: <20080705223021.02735dc0@infradead.org>
In-Reply-To: <20080706041502.GB21990@mit.edu>
References: <20080704192929.2c4dd4ca@infradead.org>
	<20080706041502.GB21990@mit.edu>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 00:15:02 -0400
Theodore Tso <tytso@MIT.EDU> wrote:

> On Fri, Jul 04, 2008 at 07:29:29PM -0700, Arjan van de Ven wrote:
> > @@ -165,7 +165,7 @@ static void journal_do_submit_data(struct
> > buffer_head **wbuf, int bufs) for (i = 0; i < bufs; i++) {
> >  		wbuf[i]->b_end_io = end_buffer_write_sync;
> >  		/* We use-up our safety reference in submit_bh() */
> > -		submit_bh(WRITE, wbuf[i]);
> > +		submit_bh(WRITE_SYNC, wbuf[i]);
> >  	}
> >  }
> 
> So I started looking at this patch more closely when trying to
> replicate it for ext4.  Don't you want to only use WRITE_SYNC() only
> for the very last time in the loop?  Otherwise you end up unplugging
> the queue after each bufferhead, which wouldn't be a good thing,
> right?

it's debatable. Because this submit-bh() will sometimes block... it
wouldn't get IO started for that case. I think this is where I'd like
Jens to say what he thinks the rules are; clearly the elevator needs to
treat all of these guys as sync, but maybe the plugging should be ..
flexible.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
