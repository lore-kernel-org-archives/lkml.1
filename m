Return-Path: <linux-kernel-owner+w=401wt.eu-S966591AbXFGW7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966591AbXFGW7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933414AbXFGW7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:59:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:21799 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374AbXFGW7B (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J4CCAvT1B+hKFpjv+EbyRGYStoZmIZqKH20YIRG3IHUSfbRIbmyjlHvYmg8GmAYW1sZ9g+ph59E1jTtNRHgp/E6l9jjGjH1hjSMKzCaz6tTJWgfvddzke4QSeiKEHHOQPv4HFVwUNeaCcwzOqVQk0r2r7S4E8sBML/j9YBS8iMM=
Message-ID: <6934efce0706071559j24978c15kc42914677dc8408e@mail.gmail.com>
Date: Thu, 7 Jun 2007 15:59:00 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Jared Hulbert" <jaredeh@gmail.com>, carsteno@de.ibm.com,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       "Richard Griffiths" <res07ml0@verizon.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
In-Reply-To: <20070607211519.GA22348@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com>
	 <46641472.3080802@de.ibm.com>
	 <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com>
	 <20070606113351.GA11701@infradead.org>
	 <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com>
	 <20070606161621.GA20247@infradead.org>
	 <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com>
	 <20070607193707.GA17144@infradead.org>
	 <6934efce0706071411y6d184629i5ce0694175bef164@mail.gmail.com>
	 <20070607211519.GA22348@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If if were actually talking about complex filesystem I'd agree.  But
> the cramfs xip patch posted here touches about 2/3 of the number of
> lines that cramfs has in total.

Fair enough.  But look at the complexity rather than number of lines.
It adds tedium to the cramfs_fill_super and one extra level of
indirection to a hand full of ops like mmap() and cramfs_read().  But
the changes to the real meat of cramfs, cramfs_readpage(), are limited
to the XIP changes, which I want on block devices anyway.

So if we did fork cramfs I would submit a simple patch to cramfs for
XIP support on block devices and I would submit a patch for a new
filesystem, cramfs-linear.  Cramfs-linear would have an exact copy of
1/3 of the cramfs code such as cramfs_readpage(), it would use the
same headers, and it would use the same userspace tools.

This fork is what the community wants?  Speak up!

>And cramfs is not exactly the best base to start with..

This is a moot point, there is a significant installed base issue.
There are lots of cramfs-linear-xip based systems in existance with
can't be easily ported to newer kernel because of a lack of support.

> > This is nirvana.   But it is not the goal of the patches in question.
> > In fact there are several use cases that don't need and don't value
> > the writeability and don't need therefore the overhead.  It is a long
> > term goal never the less.
>
> With the filemap_xip.c helpers adding xip support to any filesystem
> is pretty trivial for the highlevel filesystem operations.  The only
> interesting bit is the lowlevel code (the get_xip_page method and
> the others Carsten mentioned), but we need to do these lowlevel
> code in a generic and proper way anyway.

It's not that trivial.  The filesystem needs to meet several
requirements such as, having data nodes that are page aligned.
Anytime any changes are made to any page in the underlying Flash block
or if the Flash physical partition goes out of read mode you've got to
hide that from userspace or otherwise deal with it.  A filesystem that
doesn't understand these subtle hardware requirements would either not
work at all, have lots of deadlock issues, or at least have terrible
performance problems.  Nevertheless I supose a simple, but invasive,
hack could likely produce a worthwhile proof of concept.

I think this is worthy of it's own thread....

> I'll try to hack up an xip prototype for jffs2 next week.

Very cool.  I can't wait to see what you have in mind.  But remember
this doesn't solve the problem of the huge installed base of
cramfs-linear-xip images.

Gee I think it seems logfs would be a better choice.  Jffs2 and
ubifs(jffs3) for that matter combine node and node header in series
which means your data nodes aren't aligned to page boundarys. Logfs
nodes could be more easily aligned.
