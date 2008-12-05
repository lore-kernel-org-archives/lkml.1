Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYLEWds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYLEWds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYLEWdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:33:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50667 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYLEWdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:33:39 -0500
Date: Fri, 5 Dec 2008 22:33:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 3/6] integrity: IMA as an integrity service provider
Message-ID: <20081205223335.GJ28946@ZenIV.linux.org.uk>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com> <5bea2422d059b97475d735feb9feb78b57ec8eca.1228253619.git.zohar@linux.vnet.ibm.com> <1228260925.2971.240.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228260925.2971.240.camel@nimitz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 03:35:25PM -0800, Dave Hansen wrote:

> 
> > +		int rc;
> > +
> > +		mdata.mask = MAY_READ;
> > +		rc = ima_must_measure(&mdata);
> > +		if (!rc || rc == -EEXIST) {
> > +			if (atomic_read(&(path->dentry->d_count)) - 1 >
> > +			    atomic_read(&(mdata.inode->i_writecount)))
> > +				ima_add_violation(mdata.inode,
> > +						  path->dentry->d_name.name,
> > +						  "invalid_pcr", "ToMToU");
> > +		}
> > +		return 0;
> > +	}
> 
> 
> I have memories of talking about this bit.  I was confused and you
> explained it to me, but it still isn't explained in the code. :(  Again,
> I'm not convinced that this works.  Can the code convince me, or should
> I go digging in my inbox?

This bit is crap, plain and simple.  d_count doesn't work as a proxy for
"how many times had we opened this file".  At all.

a) stat(2) and just about anything else that looks funny at the pathname
will bump d_count.

b) there may be several links to given file; all will share inode and have
different dentries.

In other words, result of that comparison happens to be junk.
