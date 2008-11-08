Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYKHJeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYKHJeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 04:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYKHJeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 04:34:16 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:63620 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYKHJeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 04:34:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=B8SHhs+xC/B4r1mDFhQTt6OYIQYtmZCM2+Z0MYOp+GQeMdGM4SQJt3vXqakP5/nhb8
         7okIA6xhkeQjoW1mbvOEnEDdLZ2fGTDmxopBYKJdUSBn756mN3PKMnepi/04VfRQCncS
         nqxMA5QAK4/QKssJkVitJKjq+5CaP+t+7jcws=
Message-ID: <4a4634330811080134m130468f0g34880a345ad73eb3@mail.gmail.com>
Date: Sat, 8 Nov 2008 03:34:14 -0600
From: "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Subject: dirty pages in the mapping after filemap_fdatawrite returns 0 called in cifs_flush
Cc: "Jeff Layton" <jlayton@redhat.com>,
       "Suresh Jayaraman" <sjayaraman@suse.de>,
       "Steve French" <smfrench@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 2.6.18-120.el5PAE,
if filemap_fdatawrite returns without any errors, is it not the case that
there are no more dirty pages in the mapping of this inode?
Yet pagevec_lookup_tag called after filemap_fdatawrite returns with 0, sasys so.
If filemap_fdatawrite has returned with value of 0, cifs_writepages has returned
with value of 0 as well!


 CIFS VFS: cifs_flush for 7.test has dr_pages: 6 drrc: 0
 CIFS VFS: No writable handles for inode
 CIFS VFS: cifs_flush for 13.test has dr_pages: 1 drrc: 0
 CIFS VFS: No writable handles for inode
 CIFS VFS: cifs_flush for 17.test has dr_pages: 1 drrc: 0
 CIFS VFS: No writable handles for inode



/*
 * As file closes, flush all cached write data for this inode checking
 * for write behind errors.
 */
#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 17)
int cifs_flush(struct file *file, fl_owner_t id)
#else
int cifs_flush(struct file *file)
#endif /* 2.6.17 */
{
#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
        struct inode *inode = file->f_dentry->d_inode;
#else
        struct inode *inode = file->f_path.dentry->d_inode;
#endif
        int rc = 0;
        unsigned dr_pages;
        int drrc = 0;
        pgoff_t start = 0;
        struct pagevec pvec;

        /* Rather than do the steps manually:
           lock the inode for writing
           loop through pages looking for write behind data (dirty pages)
           coalesce into contiguous 16K (or smaller) chunks to write to server
           send to server (prefer in parallel)
           deal with writebehind errors
           unlock inode for writing
           filemapfdatawrite appears easier for the time being */

        rc = filemap_fdatawrite(inode->i_mapping);
        /* reset wb rc if we were able to write out dirty pages */
        if (!rc) {
                rc = CIFS_I(inode)->write_behind_rc;
                CIFS_I(inode)->write_behind_rc = 0;
        } else {
                cERROR(1, ("cifs_flush error inode %p file %p rc %d",
inode, file, rc));
        }

        cFYI(1, ("Flush inode %p file %p rc %d", inode, file, rc));

        pagevec_init(&pvec, 0);
        dr_pages = pagevec_lookup_tag(&pvec,
                        file->f_dentry->d_inode->i_mapping, &start,
                        PAGECACHE_TAG_DIRTY, 14);
        if (dr_pages) {
                // drrc = filemap_fdatawrite(inode->i_mapping);
                cERROR(1, ("cifs_flush for %s has dr_pages: %d drrc: %d",
                        file->f_dentry->d_iname, dr_pages, drrc));
        }

        return rc;
}
