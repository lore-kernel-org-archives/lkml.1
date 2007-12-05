Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXLERWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXLERWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXLERWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:22:14 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40526 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbXLERWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:22:13 -0500
Subject: Re: [RFC PATCH 0/5] Union Mount: A Directory listing approach with
	lseek support
From: Dave Hansen <haveblue@us.ibm.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>
In-Reply-To: <20071205143718.GC2471@in.ibm.com>
References: <20071205143718.GC2471@in.ibm.com>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 09:21:58 -0800
Message-Id: <1196875318.18685.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-05 at 20:07 +0530, Bharata B Rao wrote:
> In this approach, the cached dirents are given offsets in the form of
> linearly increasing indices/cookies (like 0, 1, 2,...). This helps us to
> uniformly define offsets across all the directories of the union
> irrespective of the type of filesystem involved. Also this is needed to
> define a seek behaviour on the union mounted directory. This cache is stored
> as part of the struct file of the topmost directory of the union and will
> remain as long as the directory is kept open. 

That's a little brute force, don't you think?  Especially the memory
exhaustion seems to really make this an undesirable approach.

I think the key here is what kind of consistency we're trying to
provide.  If a directory is being changed underneath a reader, what
kinds of guarantees do they get about the contents of their directory
read?  When do those guarantees start?  Are there any at open() time?

Rather than give each _dirent_ an offset, could we give each sub-mount
an offset?  Let's say we have three members comprising a union mount
directory.  The first has 100 dirents, the second 200, and the third
10,000.  When the first readdir is done, we populate the table like
this:

	mount_offset[0] = 0;
	mount_offset[1] = 100;
	mount_offset[2] = 300;

If someone seeks back to 150, then we subtrack the mount[1]'s offset
(100), and realize that we want the 50th dirent from mount[1].

I don't know whether we're bound to this:

http://www.opengroup.org/onlinepubs/007908775/xsh/readdir.html
        
        "If a file is removed from or added to the directory after the
        most recent call to opendir() or rewinddir(), whether a
        subsequent call to readdir() returns an entry for that file is
        unspecified."

But that would seem to tell me that once you populate a table such as
the one I've described and create it at open(dir) time, you don't
actually ever need to update it.

The storage for this is only comparable to the number of mounts that you
have.  One issue comes if we manage to overflow our data types with too
many entries in too many submounts.  But, I guess we can just truncate
the directory in that case.  

-- Dave

