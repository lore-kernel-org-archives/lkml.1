Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbYJaTsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbYJaTsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYJaTsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:48:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34997 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYJaTsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:48:37 -0400
Subject: Re: [PATCH 2/3] integrity: Linux Integrity Module(LIM)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1225471902.12673.415.camel@nimitz>
References: <cover.1223869200.git.zohar@localhost.localdomain>
	 <7c05f813215804a30d03821fd8e251b250d0e000.1223869200.git.zohar@localhost.localdomain>
	 <20081014132823.GA18474@infradead.org> <1225471902.12673.415.camel@nimitz>
Content-Type: text/plain
Date: Fri, 31 Oct 2008 15:48:34 -0400
Message-Id: <1225482514.21941.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-31 at 09:51 -0700, Dave Hansen wrote: 
> On Tue, 2008-10-14 at 09:28 -0400, Christoph Hellwig wrote:
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -683,6 +683,9 @@ struct inode {
> > >  #ifdef CONFIG_SECURITY
> > >       void                    *i_security;
> > >  #endif
> > > +#ifdef CONFIG_INTEGRITY
> > > +     void                    *i_integrity;
> > > +#endif
> > 
> > Sorry, but as said before bloating the inode for this is not an option.
> > Please use something like the MRU approach I suggested in the last
> > review round.

I am working on using a radix tree to store the i_integrity information,
as Christoph suggested. Initially the measurements were awful, but after
fixing the locking and removing an unnecessary sychronize_rcu, I'm not
seeing a major performance hit. 

> Why don't we just have a 'void *i_lots_of_bloat field', and let the
> security folks stick whatever they want in it?  They can trade their
> i_security space for a new one.  I know we want to conceptually separate
> security from integrity, so let's separate it:
> 
> struct i_bloat_inodes {
> #ifdef CONFIG_SECURITY
> 	void                    *i_security;
> #endif
> #ifdef CONFIG_INTEGRITY
> 	void                    *i_integrity;
> #endif
> };

I'm not sure that the LSM people would be too happy.  If using the radix
tree does not pan out, then we will have to look into this option.

> By the way, if there's no TPM hardware, why would I want i_integrity
> anyway?

> -- Dave

The integrity framework is for collecting, appraising, and storing
integrity information.  Integrity measurements today are mainly file
measurements, but the framework allows for other types of integrity
measurements. Some types of integrity measurements, might only require
collecting and appraising, but not storing, so a TPM would not be
required.

Mimi

