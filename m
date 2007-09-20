Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbXITWEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbXITWEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbXITWD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:03:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45282 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbXITWDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:03:55 -0400
Date: Thu, 20 Sep 2007 17:03:52 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [PATCH 8/11] eCryptfs: Convert mmap functions to use persistent file
Message-ID: <20070920220352.GC8496@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com> <20070917215016.GP13679@halcrow.austin.ibm.com> <20070919225057.56444769.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919225057.56444769.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 10:50:57PM -0700, Andrew Morton wrote:
> On Mon, 17 Sep 2007 16:50:16 -0500 Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> > +ecryptfs_copy_up_encrypted_with_header(struct page *page,
> > +				       struct ecryptfs_crypt_stat *crypt_stat)
> > +{
...
> > +			flush_dcache_page(page);
> > +			if (rc) {
> > +				ClearPageUptodate(page);
> > +				printk(KERN_ERR "%s: Error reading xattr "
> > +				       "region; rc = [%d]\n", __FUNCTION__, rc);
> > +				goto out;
> > +			}
> > +			SetPageUptodate(page);
> 
> I don't know what sort of page `page' refers to here, but normally we only
> manipulate the page uptodate status under lock_page().

This is the page that eCryptfs gets via
ecryptfs_aops->ecryptfs_readpage(), so this should be okay. The
comment should make the fact that the page is locked explicit.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>

---
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 04103ff..c6a8a33 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -111,7 +111,7 @@ static void set_header_info(char *page_virt,
  * ecryptfs_copy_up_encrypted_with_header
  * @page: Sort of a ``virtual'' representation of the encrypted lower
  *        file. The actual lower file does not have the metadata in
- *        the header.
+ *        the header. This is locked.
  * @crypt_stat: The eCryptfs inode's cryptographic context
  *
  * The ``view'' is the version of the file that userspace winds up
