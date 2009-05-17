Return-Path: <linux-kernel-owner+w=401wt.eu-S1751499AbZEQOkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbZEQOkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 10:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZEQOkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 10:40:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:4717 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZEQOko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 10:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SvA15aACI79+IStKSHyqTnKy+7c4xPGDbLhX1KaundwfsPh/L86FFv+lEoe9s+T+mc
         0zyzn0OeMs2yjcTFesDH/7vtnnntBjShXfWGKEXd+cuXDSR3PrrAI9KVFU7c2YgZa7Ht
         psg0BO7dt312g/EkNu+ecGRMST9wa3TI//77Y=
MIME-Version: 1.0
In-Reply-To: <20090516221331.0a456cbb@tlielax.poochiereds.net>
References: <20090516162813.GA18098@nb-core2.darkstar.lan>
	 <20090516205558.GA20346@nb-core2.darkstar.lan>
	 <20090516221331.0a456cbb@tlielax.poochiereds.net>
Date: Sun, 17 May 2009 09:40:44 -0500
Message-ID: <4a4634330905170740m180f451dg9e16a3886f2af298@mail.gmail.com>
Subject: Re: [linux-cifs-client] Re: [2.6.30-rc6] cifs_close: NULL pointer 
	dereference
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 9:13 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Sat, 16 May 2009 22:55:58 +0200
> Luca Tettamanti <kronos.it@gmail.com> wrote:
>
>> On Sat, May 16, 2009 at 06:28:13PM +0200, Luca Tettamanti wrote:
>> > Hello,
>> > I just hit a NULL pointer dereference in cifs_close while accessing a file on a
>> > remote Samba shared directory.
>> [...]
>> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>> > IP: [<ffffffffa05f105c>] cifs_close+0x1c1/0x2e8 [cifs]
>>
>> Ok, I've reproduced this on a machine with a serial port :)
>>
>> 0xffffffff803574e0 in list_del (entry=0xffff8800ac184210)
>> at /home/kronos/src/linux-2.6.git/lib/list_debug.c:46
>> 46              WARN(entry->prev->next != entry,
>> (gdb) bt
>> #0  0xffffffff803574e0 in list_del (entry=0xffff8800ac184210)
>>     at /home/kronos/src/linux-2.6.git/lib/list_debug.c:46
>> #1  0xffffffff80319588 in cifs_close (inode=0xffff8800b8d5f088, file=0xffff8800ad8f6d00)
>>     at /home/kronos/src/linux-2.6.git/fs/cifs/file.c:670
>> #2  0xffffffff8029d95e in __fput (file=0xffff8800ad8f6d00)
>>     at /home/kronos/src/linux-2.6.git/fs/file_table.c:281
>> #3  0xffffffff8029da32 in fput (file=0xffff8800ac184210)
>>     at /home/kronos/src/linux-2.6.git/fs/file_table.c:227
>> #4  0xffffffff8029ad30 in filp_close (filp=0xffff8800ad8f6d00, id=0xffff880037a3e080)
>>     at /home/kronos/src/linux-2.6.git/fs/open.c:1108
>> #5  0xffffffff8029ade0 in sys_close (fd=0)
>>     at /home/kronos/src/linux-2.6.git/fs/open.c:1137
>> #6  0xffffffff802271e4 in sysenter_dispatch ()
>>     at /home/kronos/src/linux-2.6.git/arch/x86/ia32/ia32entry.S:161
>> #7  0x0000000000000000 in ?? ()
>>
>> (gdb) f 1
>> #1  0xffffffff80319588 in cifs_close (inode=0xffff8800b8d5f088, file=0xffff8800ad8f6d00)
>>     at /home/kronos/src/linux-2.6.git/fs/cifs/file.c:670
>> 670                     list_del(&pSMBFile->flist);
>>
>> (gdb) p *&pSMBFile->flist
>> $2 = {next = 0x0, prev = 0x0}
>>
>> (gdb) p *&pSMBFile->tlist
>> $5 = {next = 0x0, prev = 0x0}
>>
>> So both flist and tlist were not initilized in cifs_open.
>>
>> The content of the whole pSMBFile structure:
>>
>> (gdb) p *pSMBFile
>> $6 = {tlist = {next = 0x0, prev = 0x0}, flist = {next = 0x0, prev = 0x0}, uid = 0, pid = 5322, netfid = 13880,
>>   pfile = 0xffff8800ad8f6d00, pInode = 0xffff8800b8d5f088, lock_mutex = {count = {counter = 1}, wait_lock = {raw_lock = {
>>         slock = 514}, magic = 3735899821, owner_cpu = 4294967295, owner = 0xffffffffffffffff, dep_map = {
>>         key = 0xffffffff806a5c98, class_cache = 0x0, name = 0xffffffff80537308 "&lock->wait_lock"}}, wait_list = {
>>       next = 0xffff8800ac184278, prev = 0xffff8800ac184278}, owner = 0x0, name = 0x0, magic = 0xffff8800ac184240, dep_map = {
>>       key = 0xffffffff80d7ff50, class_cache = 0xffffffff80835400, name = 0xffffffff8054cdfa "&private_data->lock_mutex"}},
>>   llist = {next = 0xffff8800ac1842b8, prev = 0xffff8800ac1842b8}, closePend = true, invalidHandle = false,
>>   messageMode = false, wrtPending = {counter = 0}, fh_mutex = {count = {counter = 1}, wait_lock = {raw_lock = {slock = 0},
>>       magic = 3735899821, owner_cpu = 4294967295, owner = 0xffffffffffffffff, dep_map = {key = 0xffffffff806a5c98,
>>         class_cache = 0x0, name = 0xffffffff80537308 "&lock->wait_lock"}}, wait_list = {next = 0xffff8800ac184308,
>>       prev = 0xffff8800ac184308}, owner = 0x0, name = 0x0, magic = 0xffff8800ac1842d0, dep_map = {key = 0xffffffff80d7ff58,
>>       class_cache = 0x0, name = 0xffffffff8054cde2 "&private_data->fh_mutex"}}, srch_inf = {index_of_last_entry = 0,
>>     entries_in_buffer = 0, info_level = 0, resume_key = 0, ntwrk_buf_start = 0x0, srch_entries_start = 0x0, last_entry = 0x0,
>>     presume_name = 0x0, resume_name_len = 0, endOfSearch = false, emptyDir = false, unicode = false, smallBuf = false}}
>>
>
> Luca...thanks for the bug report and analysis. I've been able to
> reproduce this too against 3.3.2. The attached patch reverts the open
> with lookup intent functionality that was added at the beginning of the
> 2.6.30 cycle. This fixes the problem for me.
>
> Steve and Shirish...given that we've already seen a couple of
> regressions from these patches, I'd like to see them reverted until
> they have been better tested.
>
> --
> Jeff Layton <jlayton@redhat.com>
>

Does this happen inspite of the patch 90e4ee5d311d4e0729daa676b1d7f754265b5874
