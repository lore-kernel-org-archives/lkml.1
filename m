Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbYIWLBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbYIWLBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYIWLBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:01:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49762 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYIWLBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:01:21 -0400
Date: Tue, 23 Sep 2008 20:00:51 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: do_generic_file_read() never gets a NULL 'filp' argument
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Hellwig <hch@infradead.org>,
       Krishna Kumar <krkumar2@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080922103635.77d795e4.akpm@linux-foundation.org>
References: <20080922083945.GA12658@infradead.org> <20080922103635.77d795e4.akpm@linux-foundation.org>
Message-Id: <20080923193329.F8EA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> > > > The 'filp' argument to do_generic_file_read() is never NULL.
> > > 
> > > How did you verify this?
> > > 
> > > NFS used to like passing NULL file*'s into VFS functions.  I don't
> > > recall whether it affected do_generic_file_read().
> > 
> > The only thing nfsd passed a NULL file pointer in is ->fsync on
> > directories.
> 
> NFS, not NFSD.  It was page_cache_read(), iirc.

Is it important?
Cristoph wrote following decision reason at last mail.
I believe he was right.

> If anyone did pass a NULL file pointer into
> do_generic_file_read it would oops in it's very first line of code.


IOW, do_generic_file_read() has following calling hieralcy.

generic_file_aio_read()
  +- do_generic_file_read()

and fs/nfs/file.c has

	const struct file_operations nfs_file_operations = {
	        .llseek         = nfs_file_llseek,
	        .read           = do_sync_read,
	        .write          = do_sync_write,
	        .aio_read       = nfs_file_read,
	        .aio_write      = nfs_file_write,

So, nfs doesn't use generic_file_aio_read.
it directly indicate nfs doesn't use do_generic_file_read().

in the other hand, page_cache_read() has following calling hieralcy.

filemap_fault()
  +- page_cache_read()
      +- a_ops->readpage()

So, page_cache_read is mmap() related helper function and
do_generic_file_read is read() related helper function.
they are independent IMHO.


