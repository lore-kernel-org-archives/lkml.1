Return-Path: <linux-kernel-owner+w=401wt.eu-S1422860AbXBILAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422860AbXBILAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422998AbXBILAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:00:37 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49718 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422860AbXBILAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:00:35 -0500
Date: Fri, 9 Feb 2007 16:35:55 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       linux-kernel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] aio: fix kernel bug when page is  temporally busy
Message-ID: <20070209110555.GA11232@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <B41635854730A14CA71C92B36EC22AAC8048C3@mssmsx411> <Pine.LNX.4.64.0702091042330.25686@twin.jikos.cz> <20070209021444.2213deb6.akpm@linux-foundation.org> <Pine.LNX.4.64.0702091137530.25686@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702091137530.25686@twin.jikos.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 11:40:27AM +0100, Jiri Kosina wrote:
> On Fri, 9 Feb 2007, Andrew Morton wrote:
>  
> > > @@ -1204,7 +1204,7 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
> > >  			do_generic_file_read(filp,ppos,&desc,file_read_actor);
> > >  			retval += desc.written;
> > >  			if (desc.error) {
> > > -				retval = retval ?: desc.error;
> > > +				retval = desc.error;
> > >  				break;
> > >  			}
> > Nope.  On error the read() syscall must return the number of bytes which
> > were successfully read.
>  
> You are right. 
>  
> In current mainline this even is not a problem, because noone seems to be 
> setting the error values to EIOCBRETRY. But it still stinks a bit, as 
> there are tests for EIOCBRETRY.

We'd want retries to act only on the remaining bytes which haven't been
transferred as yet, so even in the EIOCBRETRY case the right thing to do
is to return the number of bytes that were successfully read without
blocking. The high level AIO code (see aio_rw_vect_rety) has the ability
to handle this.

So this is still correct.

Is there a real bug that you are seeing here ?

Regards
Suparna

>  
> -- 
> Jiri Kosina
>  
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

