Return-Path: <linux-kernel-owner+w=401wt.eu-S1946368AbXBILSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946368AbXBILSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 06:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946370AbXBILSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 06:18:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:36239 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946368AbXBILSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 06:18:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,306,1167638400"; 
   d="scan'208"; a="194871245:sNHT26194434"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH] aio: fix kernel bug when page is  temporally busy
Date: Fri, 9 Feb 2007 14:18:14 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC8049D0@mssmsx411>
In-Reply-To: <20070209110555.GA11232@in.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] aio: fix kernel bug when page is  temporally busy
Thread-Index: AcdMOYfLvt307/lxQHGlGeLfBz18AAAAmcZQ
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: <suparna@in.ibm.com>, "Jiri Kosina" <jikos@jikos.cz>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "linux-aio" <linux-aio@kvack.org>,
       "Zach Brown" <zach.brown@oracle.com>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Badari Pulavarty" <pbadari@us.ibm.com>, "Jan Kara" <jack@suse.cz>
X-OriginalArrivalTime: 09 Feb 2007 11:18:20.0003 (UTC) FILETIME=[00E3DB30:01C74C3C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>noone seems to be setting the error values to EIOCBRETRY
> We'd want retries to act only on the remaining bytes which haven't
been
> transferred as yet, so even in the EIOCBRETRY...

OK. But any variable is not set to EIOCBRETRY  in 2.6.14, 2.6.19,
2.6.20.
Is it correct?

Leonid 

-----Original Message-----
From: Suparna Bhattacharya [mailto:suparna@in.ibm.com] 
Sent: Friday, February 09, 2007 2:06 PM
To: Jiri Kosina
Cc: Andrew Morton; Ananiev, Leonid I; linux-kernel@vger.kernel.org;
linux-aio; Zach Brown; Chris Mason; Badari Pulavarty; Jan Kara
Subject: Re: [PATCH] aio: fix kernel bug when page is temporally busy

On Fri, Feb 09, 2007 at 11:40:27AM +0100, Jiri Kosina wrote:
> On Fri, 9 Feb 2007, Andrew Morton wrote:
>  
> > > @@ -1204,7 +1204,7 @@ generic_file_aio_read(struct kiocb *iocb,
const struct iovec *iov,
> > >
do_generic_file_read(filp,ppos,&desc,file_read_actor);
> > >  			retval += desc.written;
> > >  			if (desc.error) {
> > > -				retval = retval ?: desc.error;
> > > +				retval = desc.error;
> > >  				break;
> > >  			}
> > Nope.  On error the read() syscall must return the number of bytes
which
> > were successfully read.
>  
> You are right. 
>  
> In current mainline this even is not a problem, because noone seems to
be 
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
