Return-Path: <linux-kernel-owner+w=401wt.eu-S1765607AbYD2QEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765607AbYD2QEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYD2QEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:04:35 -0400
Received: from mx1.suse.de ([195.135.220.2]:57026 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbYD2QEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:04:34 -0400
Date: Tue, 29 Apr 2008 18:04:31 +0200
From: Jan Blunck <jblunck@suse.de>
To: bsn.0007@gmail.com
Cc: libc-alpha@sourceware.org, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Ulrich Drepper <drepper@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 0/2] Union Mount: Directory listing in glibc
Message-ID: <20080429160431.GY30780@bolzano.suse.de>
References: <20080429133201.GA9938@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429133201.GA9938@localhost.localdomain>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, bsn.0007@gmail.com wrote:

> The RFC discussed about the information glibc readdir needs to get about
> union mounted directories and I have assumed the following information
> to be available from the kernel for this implementation.
> 
> - Kernel would return all the dirents (including duplicates and whiteouts)
> starting from the topmost directory of the union.
> 
> - Indication that this directory is a union mounted directory
> 	I have assumed that kernel would return a "." whiteout as the first
> directory entry of the union. This would tell glibc readdir(3) that it is
> working with a union mounted directory and it needs to do duplicate
> elimination and whiteout suppression. It starts building a dirent cache
> for this purpose.

IIRC the intention was to emit a "." whiteout when "changing" from one
directory to the next. That means when the first directory is completely read
the whiteout is emitted. After that glibc knows to start duplicate
removal.

> Ulrich had suggested that we could use the fstat call to recognize union
> mounts. But looking at the stat structure from stat(2), it was not obvious
> as to which field in there could be used for this purpose. Hence for this
> prototype implementation, I decided to go with what Al Viro suggested, which
> is about using a "." whiteout.
> 
> - Indication that kernel is done with returning entries from the topmost
> directory.
> 	I have assumed that kernel would return a "." whiteout at the beginning
> of each directory of the union. So when glibc gets a 2nd "." whiteout, it
> will start performing duplicate elimination.

See above

> - Whiteout indication
> 	glibc will depend on dirent->d_type to be set to DT_WHT on a whiteout
> file.

Which makes the new filetype very much visible to the userspace but maybe that
is the price we have to pay.

> Compatibility issues
> --------------------
> There are many versions of dirent structure in glibc and I have tried my
> best to take care of compatibility issues. But I have not really tested
> readdir64 or old_readdir64. Also atleast one version of dirent structure
> doesn't have d_type field and my whiteout suppression logic depends on it
> and uses it in the generic __READDIR routine which gets used by various
> version of readdir and I think this would break that readdir version which
> uses dirent structure w/o d_type. I will be taking care of such compatibility
> issues more cleanly/thoroughly in subsequent posts.

We don't support union mounts on older kernels. Newer kernels return
d_type. So I think we don't have a problem.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
