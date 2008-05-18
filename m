Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbYERPmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbYERPmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 11:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbYERPmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 11:42:46 -0400
Received: from ns1.codewiz.org ([89.97.188.34]:57538 "EHLO trinity.develer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbYERPmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 11:42:45 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 May 2008 11:42:44 EDT
Message-ID: <48304CE2.1090808@codewiz.org>
Date: Sun, 18 May 2008 17:36:02 +0200
From: Bernie Innocenti <bernie@codewiz.org>
Organization: Codewiz - http://www.codewiz.org/
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>, ext3-users@redhat.com,
       ext2-devel@lists.sourceforge.net, Stefano Fedrigo <aleph@develer.com>
Subject: ext3_dx_add_entry: Directory index full!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.24.4-64.fc8, I createed and mounted a filesystem like this:

  mke2fs -m0 -b 1024 -R stride=64 -I 128 -i 2048 -j  -L mail -O dir_index,sparse_super -v /dev/sdc1
  mount -t ext3 -o noatime,data=writeback,nosuid,usrquota /dev/sdc1 /mail

Then I copied a directory with 200K small files into it:

  cp -a home/simone/Maildir/YouHaveJunkSir /mail/
  [...]
  cp: cannot create regular file `/mnt/YouHaveJunkSir/1174170042.20731_2.trinity.develer.com:2,b': No space left on device
  cp: cannot create regular file `/mnt/YouHaveJunkSir/1186341042.8337_2.trinity.develer.com:2,': No space left on device
  cp: cannot create regular file `/mnt/YouHaveJunkSir/1209101786.3888_2.trinity.develer.com:2,': No space left on device

The kernel logs are also scary:

  EXT3-fs warning (device sdc1): ext3_dx_add_entry: Directory index full!
  EXT3-fs warning (device sdc1): ext3_dx_add_entry: Directory index full!
  [...]

The failing check looks like this:

        if (levels && (dx_get_count(frames->entries) ==
                   dx_get_limit(frames->entries))) {
            ext3_warning(sb, __FUNCTION__,
                     "Directory index full!");
            err = -ENOSPC;
            goto cleanup;
        }

The limit is set in make_indexed_dir():

  dx_set_limit (entries, dx_root_limit(dir, sizeof(root->info)));

with this helper function:

  static inline unsigned dx_root_limit (struct inode *dir, unsigned infosize)
  {
      unsigned entry_space = dir->i_sb->s_blocksize - EXT3_DIR_REC_LEN(1) -
          EXT3_DIR_REC_LEN(2) - infosize;
      return 0? 20: entry_space / sizeof(struct dx_entry);
  }

Am I reading the above code correctly?  Why does it always return
20 no matter what?


Some background: I'm moving users' Maildirs to a separate filesystem tuned
for small files to increase performance.  One of our users intentionally
collected spam for 5 years in one folder and likes it this way.
We could easily work it around, but first I'd like to understand whether
the particular parameters we used trigger a bug in ext3 or if we're just
hitting a (possibly undocumented) limit.

-- 
   \___/
  _| X |  Bernie Innocenti - http://www.codewiz.org/
  \|_O_|  "It's an education project, not a laptop project!"
