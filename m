Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbYKURjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbYKURjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbYKURi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:38:56 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47656 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbYKURiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:38:55 -0500
Subject: Re: [PATCH 3/4] integrity: IMA as an integrity service provider
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <1227231596.2819.102.camel@localhost.localdomain>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
	 <342f87b65eae2369d96501d8d4935d6be0f46678.1227137423.git.zohar@linux.vnet.ibm.com>
	 <1227216141.11607.22.camel@nimitz>
	 <1227231596.2819.102.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 09:38:50 -0800
Message-Id: <1227289130.11607.30.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 20:39 -0500, Mimi Zohar wrote:
> On Thu, 2008-11-20 at 13:22 -0800, Dave Hansen wrote: 
> > On Thu, 2008-11-20 at 11:43 -0500, Mimi Zohar wrote:
> > > 
> > > +       /* Invalidate PCR, if a measured file is already open for read
> > > */
> > > +       if ((mask == MAY_WRITE) || (mask == MAY_APPEND)) {
> > > +               int mask_sav = data->mask;
> > > +               int rc;
> > > +
> > > +               data->mask = MAY_READ;
> > > +               rc = ima_must_measure(&idata);
> > > +               if (!rc) {
> > > +                       if (atomic_read(&(data->dentry->d_count)) - 1 >
> > > +                           atomic_read(&(inode->i_writecount)))
> > > +                               ima_add_violation(inode, data->filename,
> > > +                                                 "invalid_pcr", "ToMToU");
> > > +               }
> > > +               data->mask = mask_sav;
> > > +               goto out;
> > > +       }
> > 
> > Following up on Christoph's comment...
> > 
> > I'm worried that this calculation isn't very precise.  The calculation
> > that you're trying to come up with here is the number of opens (d_count)
> > vs. the number of writers (i_writecount).  When they don't match, you
> > know that the new open is the first write, and you must 'invalidate the
> > PCR'?
> > 
> > There are a number of things that elevate d_count, and it is a lot more
> > than just an open() that can do it.  Is that OK?
> 
> >From an integrity perspective, a file measurement might be invalidated
> unnecessarily, but it is safe. For any file when opened for write, while
> having an existing reader, will cause the file measurement to be
> invalidated. Can you give examples of things, other than open(), that
> elevate d_count?

Just do a little search for dget().  There are plenty of places that
we'll do a lookup (and a dget), realize that we can't complete an
operation (say O_RDWR on a 400 file), then dput() the dentry.  If you
look at dput at the wrong time, you could mistake that for an *actual*
open.

Are you holding any locks here?  If not, it is completely conceivable
that you do the atomic_read(d_count)=100, then by the time you do the
aomtic_read(i_writecount), 90 of those references have been dput()'d.  

> Is there a different, better way to determine if there are any readers?

I think you're looking at it from the wrong angle.  If you have a
writer, does it matter whether there are any readers?  You should just
unconditionally invalidate the integrity measurement.

-- Dave

