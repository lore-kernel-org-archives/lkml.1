Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZEPU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZEPU4T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 16:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZEPU4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 16:56:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:35971 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZEPU4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 16:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vr77jNf0llPLnPFwHW9KO50vWRj2wUTn0bs8IjFU3MF6AzqPm66WyEhOwhlDDba1Md
         4/ULL1c7s+tet/a+SmDfsOHdDCjl4OkgkAofEko7Ehe7qL4dhApiqXnsQQf3p8x0mcmr
         DrRNrsIH3r7hkELVie9rHHXlKjMbW9GkmbFRg=
Date: Sat, 16 May 2009 22:55:58 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org
Subject: Re: [2.6.30-rc6] cifs_close: NULL pointer dereference
Message-ID: <20090516205558.GA20346@nb-core2.darkstar.lan>
References: <20090516162813.GA18098@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090516162813.GA18098@nb-core2.darkstar.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 06:28:13PM +0200, Luca Tettamanti wrote:
> Hello,
> I just hit a NULL pointer dereference in cifs_close while accessing a file on a
> remote Samba shared directory.
[...]
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffffa05f105c>] cifs_close+0x1c1/0x2e8 [cifs]

Ok, I've reproduced this on a machine with a serial port :)

0xffffffff803574e0 in list_del (entry=0xffff8800ac184210)
at /home/kronos/src/linux-2.6.git/lib/list_debug.c:46
46              WARN(entry->prev->next != entry,
(gdb) bt
#0  0xffffffff803574e0 in list_del (entry=0xffff8800ac184210)
    at /home/kronos/src/linux-2.6.git/lib/list_debug.c:46
#1  0xffffffff80319588 in cifs_close (inode=0xffff8800b8d5f088, file=0xffff8800ad8f6d00)
    at /home/kronos/src/linux-2.6.git/fs/cifs/file.c:670
#2  0xffffffff8029d95e in __fput (file=0xffff8800ad8f6d00)
    at /home/kronos/src/linux-2.6.git/fs/file_table.c:281
#3  0xffffffff8029da32 in fput (file=0xffff8800ac184210)
    at /home/kronos/src/linux-2.6.git/fs/file_table.c:227
#4  0xffffffff8029ad30 in filp_close (filp=0xffff8800ad8f6d00, id=0xffff880037a3e080)
    at /home/kronos/src/linux-2.6.git/fs/open.c:1108
#5  0xffffffff8029ade0 in sys_close (fd=0) 
    at /home/kronos/src/linux-2.6.git/fs/open.c:1137
#6  0xffffffff802271e4 in sysenter_dispatch ()
    at /home/kronos/src/linux-2.6.git/arch/x86/ia32/ia32entry.S:161
#7  0x0000000000000000 in ?? ()

(gdb) f 1
#1  0xffffffff80319588 in cifs_close (inode=0xffff8800b8d5f088, file=0xffff8800ad8f6d00)
    at /home/kronos/src/linux-2.6.git/fs/cifs/file.c:670
670                     list_del(&pSMBFile->flist);

(gdb) p *&pSMBFile->flist
$2 = {next = 0x0, prev = 0x0}

(gdb) p *&pSMBFile->tlist
$5 = {next = 0x0, prev = 0x0}

So both flist and tlist were not initilized in cifs_open.

The content of the whole pSMBFile structure:

(gdb) p *pSMBFile
$6 = {tlist = {next = 0x0, prev = 0x0}, flist = {next = 0x0, prev = 0x0}, uid = 0, pid = 5322, netfid = 13880,
  pfile = 0xffff8800ad8f6d00, pInode = 0xffff8800b8d5f088, lock_mutex = {count = {counter = 1}, wait_lock = {raw_lock = {
        slock = 514}, magic = 3735899821, owner_cpu = 4294967295, owner = 0xffffffffffffffff, dep_map = {
        key = 0xffffffff806a5c98, class_cache = 0x0, name = 0xffffffff80537308 "&lock->wait_lock"}}, wait_list = {
      next = 0xffff8800ac184278, prev = 0xffff8800ac184278}, owner = 0x0, name = 0x0, magic = 0xffff8800ac184240, dep_map = {
      key = 0xffffffff80d7ff50, class_cache = 0xffffffff80835400, name = 0xffffffff8054cdfa "&private_data->lock_mutex"}},
  llist = {next = 0xffff8800ac1842b8, prev = 0xffff8800ac1842b8}, closePend = true, invalidHandle = false,
  messageMode = false, wrtPending = {counter = 0}, fh_mutex = {count = {counter = 1}, wait_lock = {raw_lock = {slock = 0},
      magic = 3735899821, owner_cpu = 4294967295, owner = 0xffffffffffffffff, dep_map = {key = 0xffffffff806a5c98,
        class_cache = 0x0, name = 0xffffffff80537308 "&lock->wait_lock"}}, wait_list = {next = 0xffff8800ac184308,
      prev = 0xffff8800ac184308}, owner = 0x0, name = 0x0, magic = 0xffff8800ac1842d0, dep_map = {key = 0xffffffff80d7ff58,
      class_cache = 0x0, name = 0xffffffff8054cde2 "&private_data->fh_mutex"}}, srch_inf = {index_of_last_entry = 0,
    entries_in_buffer = 0, info_level = 0, resume_key = 0, ntwrk_buf_start = 0x0, srch_entries_start = 0x0, last_entry = 0x0,
    presume_name = 0x0, resume_name_len = 0, endOfSearch = false, emptyDir = false, unicode = false, smallBuf = false}}


Luca
