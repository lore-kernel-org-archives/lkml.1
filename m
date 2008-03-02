Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYCBHKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYCBHKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 02:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYCBHKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 02:10:36 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:17672 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYCBHKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 02:10:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AM/QrpEbPQQflX257ZBZhkVDL8bku9UVdrf9YFPFWHJ3Ar83MgHxud7HNqJlb2CHqkKNYImzq91N4oujn/mSlR45HKJopiFEChVgP5+/EBWSPbTtHEqyBTwX2d08vHonPnIKLlcTu4FghFJ8mXNgjlG2NFX54yYxi6FcVBZ0hWw=
Message-ID: <804dabb00803012310s7b76e09bqc6d96c25e0618cf9@mail.gmail.com>
Date: Sun, 2 Mar 2008 15:10:35 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Unmatched semaphore usage in fs/super.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pardon me if wrong.   In fs/super.c, I saw a down_read()
without a matching (when sb->s_root is non-zero) up_read() as shown
below:

/**
 *      get_super - get the superblock of a device
 *      @bdev: device to get the superblock for
 *
 *      Scans the superblock list and finds the superblock of the file system
 *      mounted on the device given. %NULL is returned if no match is found.
 */

struct super_block * get_super(struct block_device *bdev)
{
       struct super_block *sb;

       if (!bdev)
               return NULL;

       spin_lock(&sb_lock);
rescan:
       list_for_each_entry(sb, &super_blocks, s_list) {
               if (sb->s_bdev == bdev) {
                       sb->s_count++;
                       spin_unlock(&sb_lock);
                       down_read(&sb->s_umount);
                       if (sb->s_root)
                               return sb;
                       up_read(&sb->s_umount);
                       /* restart only when sb is no longer on the list */
                       spin_lock(&sb_lock);
                       if (__put_super_and_need_restart(sb))
                               goto rescan;
               }
       }
       spin_unlock(&sb_lock);
       return NULL;
}

Neither did the get_super() caller remember and correct the semaphore
either.   Is this a problem?
