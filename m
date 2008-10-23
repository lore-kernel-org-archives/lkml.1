Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYJWRzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYJWRzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYJWRzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:55:35 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:59810 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYJWRze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=W8lXMk/LYqmi/8ySN8w4jkjPdjOURGtZAC2XFMGNoKbYal2lucZ349TaheEIHBrpMN
         En+y/hUQakTJttZgyVCTMKDhRUePdDUEsXJ1KAKzNPq+5x5BeZE0wV3XsPYv5+x68jwm
         VtFCMV94UWnZjUXqAbxx31vJKeUce6Mqan0sE=
Message-ID: <431757fd0810231055m4b697888j9132f7183a2318c@mail.gmail.com>
Date: Thu, 23 Oct 2008 10:55:32 -0700
From: "Manish Lachwani" <mlachwani@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: oops in file_storage.c
Cc: "USB list" <linux-usb@vger.kernel.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0810231238550.2453-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <431757fd0810230835m454a18bav24347e4851b7cb85@mail.gmail.com>
	 <Pine.LNX.4.44L0.0810231238550.2453-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Yes, I am trying out the changes below. Will let you know how it goes.
If it works well, I will send an updated patch.

diff --git a/drivers/usb/gadget/file_storage.c
b/drivers/usb/gadget/file_storage.c
index 3e807f0..844f992 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -1927,26 +1927,11 @@ static int do_write(struct fsg_dev *fsg)
 static int fsync_sub(struct lun *curlun)
 {
        struct file     *filp = curlun->filp;
-       struct inode    *inode;
-       int             rc, err;

        if (curlun->ro || !filp)
                return 0;
-       if (!filp->f_op || !filp->f_op->fsync)
-               return -EINVAL;

-       inode = filp->f_path.dentry->d_inode;
-       mutex_lock(&inode->i_mutex);
-       rc = filemap_fdatawrite(inode->i_mapping);
-       err = filp->f_op->fsync(filp, filp->f_path.dentry, 1);
-       if (!rc)
-               rc = err;
-       err = filemap_fdatawait(inode->i_mapping);
-       if (!rc)
-               rc = err;
-       mutex_unlock(&inode->i_mutex);
-       VLDBG(curlun, "fdatasync -> %d\n", rc);
-       return rc;
+       return do_fsync(filp, 0);
 }

 static void fsync_all(struct fsg_dev *fsg)
diff --git a/fs/sync.c b/fs/sync.c
index e700eb1..53ff1f3 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -111,6 +111,7 @@ long do_fsync(struct file *file, int datasync)
 out:
        return ret;
 }
+EXPORT_SYMBOL(do_fsync);

 static long __do_fsync(unsigned int fd, int datasync)
 {






On Thu, Oct 23, 2008 at 9:46 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 23 Oct 2008, Manish Lachwani wrote:
>
>> Hi Alan,
>>
>> >
>> > Hmm.  On my system (2.6.27) the code has moved to fs/sync.c/do_fsync(),
>> > and it has changed a fair amount.  Maybe file_storage.c should be
>> > changed to match.
>>
>> I have the latest git checkout of
>> http://www.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>> and it seems that do_fsync() is still quite similar to fsync_sub().
>> Also, I checked older trees like 2.6.22 and do_fsync() is still in
>> fs/sync.c
>
> That just goes to show how old file_storage.c is.
>
>> > In fact, the easiest approach would be to EXPORT do_fsync() and then
>> > call it directly.  I don't know whether people would like this, though.
>> >
>>
>> I could try this. But I don't see much difference b/w do_fsync() and
>> fsync_sub(). However in do_fsync(), filemap_fdatawrite() is called
>> before the mutex_lock() and filemap_fdatawait() is called after the
>> mutex_unlock().
>>
>> Here is do_fsync() -
>>
>> long do_fsync(struct file *file, int datasync)
>> {
>>         int ret;
>>         int err;
>>         struct address_space *mapping = file->f_mapping;
>
> file_storage does
>
>                inode = filp->f_path.dentry->d_inode;
>
> instead, and uses inode in place of mapping->host and inode->i_mapping
> in place of mapping.  Should this be changed?  I have no idea, beyond
> feeling that the core kernel code has got to be more up-to-date.  Same
> goes for the ordering of the locks and the filemap_* calls.
>
>>         if (!file->f_op || !file->f_op->fsync) {
>>                 /* Why?  We can still call filemap_fdatawrite */
>>                 ret = -EINVAL;
>>                 goto out;
>>         }
>>
>>         ret = filemap_fdatawrite(mapping);
>>
>>         /*
>>          * We need to protect against concurrent writers, which could cause
>>          * livelocks in fsync_buffers_list().
>>          */
>>         mutex_lock(&mapping->host->i_mutex);
>>         err = file->f_op->fsync(file, file->f_path.dentry, datasync);
>>         if (!ret)
>>                 ret = err;
>>         mutex_unlock(&mapping->host->i_mutex);
>>         err = filemap_fdatawait(mapping);
>>         if (!ret)
>>                 ret = err;
>> out:
>>         return ret;
>> }
>
> If the EXPORT route is acceptable, I'd prefer to use it.
>
> Alan Stern
>
>
