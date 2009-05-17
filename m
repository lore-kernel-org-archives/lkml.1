Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbZEQGYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbZEQGYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 02:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZEQGYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 02:24:38 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:47224 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZEQGYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 02:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vUncVshpBKIqq+mjdOO3sIYdWyw0OeRnTYIiAyY5oO9PnLMAIwEXg3yHLLTbo8u0pa
         NYndFQKv76dud5Kn4Y+hQHjzduPZAHTyzMqebdMkpdEaoQSc1DG/kB1aIzuEAonJOHVh
         GK8rgeGsPHbLeH4pRJOL5K/2tWmwk9XKjlOJk=
MIME-Version: 1.0
In-Reply-To: <20090516221331.0a456cbb@tlielax.poochiereds.net>
References: <20090516162813.GA18098@nb-core2.darkstar.lan>
	 <20090516205558.GA20346@nb-core2.darkstar.lan>
	 <20090516221331.0a456cbb@tlielax.poochiereds.net>
Date: Sun, 17 May 2009 01:24:36 -0500
Message-ID: <524f69650905162324x249b59a0i3fb74036cd3ab53d@mail.gmail.com>
Subject: Re: [linux-cifs-client] Re: [2.6.30-rc6] cifs_close: NULL pointer 
	dereference
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org,
       Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
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
>> 46              WARN(entry->prev->next != entry,
>> (gdb) bt
>> #0  0xffffffff803574e0 in list_del (entry=0xffff8800ac184210)
>>     at /home/kronos/src/linux-2.6.git/lib/list_debug.c:46
>> #1  0xffffffff80319588 in cifs_close (inode=0xffff8800b8d5f088, file=0xffff8800ad8f6d00)
>>     at /home/kronos/src/linux-2.6.git/fs/cifs/file.c:670
>> #2  0xffffffff8029d95e in __fput (file=0xffff8800ad8f6d00)
>>     at /home/kronos/src/linux-2.6.git/fs/file_table.c:281
>> #3  0xffffffff8029da32 in fput (file=0xffff8800ac184210)
>>     at /home/kronos/src/linux-2.6.git/fs/file_table.c:227
>> #4  0xffffffff8029ad30 in filp_close (filp=0xffff8800ad8f6d00, id=0xffff880037a3e080)
>>     at /home/kronos/src/linux-2.6.git/fs/open.c:1108
>> #5  0xffffffff8029ade0 in sys_close (fd=0)
>>     at /home/kronos/src/linux-2.6.git/fs/open.c:1137
>> #6  0xffffffff802271e4 in sysenter_dispatch ()
>>     at /home/kronos/src/linux-2.6.git/arch/x86/ia32/ia32entry.S:161
>> #7  0x0000000000000000 in ?? ()
>>
>> (gdb) f 1
>> #1  0xffffffff80319588 in cifs_close (inode=0xffff8800b8d5f088, file=0xffff8800ad8f6d00)
>>     at /home/kronos/src/linux-2.6.git/fs/cifs/file.c:670
>> 670                     list_del(&pSMBFile->flist);
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
>
> Luca...thanks for the bug report and analysis. I've been able to
> reproduce this too against 3.3.2.

After reproducing the problem, I just looked at this in more detail:
the flist and tlist look like they were initialized, but the problem
is instead that they are being deleted from the wrong cifs file
struct.

Tthe create adds them to the 1st pSMBFile, the close deletes them from
the 1st pSMBFile, the subsequent open added them to the 2nd pSMBFile,
the close deleted them from the 1st pSMBfile (which oopses).

This should be straightforward to fix, but I want to talk with Shirish about it.


-- 
Thanks,

Steve
