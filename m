Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861Ab0AHADe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0AHADe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536Ab0AHADd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:03:33 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53549 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab0AHADc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vQjeb6lhbF0MgzRiSrlWZcZ5/JVUTv1OuFBJSnovr6IK2wdKAuuRpVxNN+2/rwSVlP
         e0QfaFUoGIwzoWI8c9qaEyeLKLu66/QRYvkFgvUE0h0hU4GT9/5v71seQOCgUSFoWE4+
         staKhICUTjammfiiwt362qipr3ydvbvw7SIlY=
MIME-Version: 1.0
In-Reply-To: <20100107220213.GA24882@suse.de>
References: <20100106234533.GC1960@kroah.com>
	 <alpine.LNX.2.00.1001071522480.5426@er-systems.de>
	 <20100107180449.GA17495@suse.de>
	 <alpine.LNX.2.00.1001072033301.26784@er-systems.de>
	 <20100107194131.GA22983@suse.de>
	 <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
	 <alpine.LNX.2.00.1001072141340.26784@er-systems.de>
	 <20100107220213.GA24882@suse.de>
Date: Fri, 8 Jan 2010 03:03:30 +0300
Message-ID: <c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com>
Subject: Re: Linux 2.6.31.10
From: Dmitry Monakhov <rjevskiy@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Thomas Voegtle <tv@lio96.de>, Jan Kara <jack@suse.cz>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/8 Greg KH <gregkh@suse.de>:
> On Thu, Jan 07, 2010 at 09:42:52PM +0100, Thomas Voegtle wrote:
>> On Thu, 7 Jan 2010, Thomas Voegtle wrote:
>>
>>> Done, between 2.6.31.9 and 2.6.31.11
>>>
>>>
>>> c169e13a6662cbf36fc0098508e7aa31b49cbf23 is first bad commit
>>> commit c169e13a6662cbf36fc0098508e7aa31b49cbf23
>>> Author: Dmitry Monakhov <dmonakhov@openvz.org>
>>> Date:   Mon Dec 14 15:21:13 2009 +0300
>>>
>>>    quota: decouple fs reserved space from quota reservation
>>>
>>>    commit fd8fbfc1709822bd94247c5b2ab15a5f5041e103 upstream.
Ohhh No...
This is totaly my fault. after some cleanups i've forgot to test
ext3+quota scenario :( . The error is trivial, it is too sad what this
error
was found this late.'
calltrace:
->chown
    ->dquot_transfer
       ->inode_get_rsv_space
static qsize_t inode_get_rsv_space(struct inode *inode)
1378 {
1379         qsize_t ret;
<<< This is illigal to call this function from fs which has no quota
reservation support.
so we have to add simple if statment here like this  .
 if (!inode->i_sb->dq_op->get_reserved_space)
     /* quota reservation is no supported */
     return 0;
1380         spin_lock(&inode->i_lock);
1381         ret = *inode_reserved_space(inode);
1382         spin_unlock(&inode->i_lock);
1383         return ret;
1384 }

Will send patch in a minute.
>>>
>>>
>>>
>>> Reverting that patch on top of 2.6.31.11 fixes the problem for me.
>>
>>
>> Funny thing, I have the problem with 2.6.33-rc3, too:
>>
>>
>> ------------[ cut here ]------------
>> kernel BUG at fs/quota/dquot.c:1350!
>> invalid opcode: 0000 [#1]
>> last sysfs file: /sys/devices/pci0000:00/0000:00:1f.5/modalias
>>
>> Pid: 3061, comm: rpm Not tainted 2.6.33-rc3-BIG #73 P3TSSA/P3TSSA
>> EIP: 0060:[<c10c05d8>] EFLAGS: 00010246 CPU: 0
>> EIP is at inode_reserved_space+0x13/0x1b
>> EAX: cf25b5c4 EBX: cf25b5c4 ECX: 00000000 EDX: 00000000
>> ESI: cf25b5c4 EDI: 00000000 EBP: d3536ebc ESP: d3536ebc
>>  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
>> Process rpm (pid: 3061, ti=d3536000 task=d5c50000 task.ti=d3536000)
>> Stack:
>>  d3536f1c c10c246a d79a4b00 d3536edc c10a4884 d3536ef4 c10c1fea 00000000
>> <0> 00000000 00000000 00000064 cf25b5c4 cf25b5c4 d701c800 d3536f1c 00000000
>> <0> d766b000 00000000 00000000 d766b0a0 0000b140 cf25b5c4 d3536f58 ffffff86
>> Call Trace:
>>  [<c10c246a>] ? dquot_transfer+0xf2/0x48b
>>  [<c10a4884>] ? mntput_no_expire+0x19/0x6c
>>  [<c10c1fea>] ? dqget+0x210/0x260
>>  [<c10c05aa>] ? vfs_dq_transfer+0x5f/0x7a
>>  [<c10a2edd>] ? notify_change+0x177/0x25e
>>  [<c10930c8>] ? chown_common+0x5e/0x70
>>  [<c10931fe>] ? sys_lchown+0x3d/0x58
>>  [<c10212a7>] ? sysenter_do_call+0x12/0x2c
>> Code: c0 0f b6 c0 eb 02 31 c0 5b 5e 5d c3 a8 08 75 b0 eb f4 a8 08 75 c9 eb
>> d5 55 8b 90 90 00 00 00 89 e5 8b 52 24 8b 52 44 85 d2 75 04 <0f> 0b eb fe
>> ff d2 5d c3 55 89 e5 57 89 c7 56 53 83 ec 1c 8b 35
>> EIP: [<c10c05d8>] inode_reserved_space+0x13/0x1b SS:ESP 0068:d3536ebc
>> ---[ end trace 0cbcf5a4693c0845 ]---
>
> Well, that's good, at least things are now consistant :)
>
> Jan, I think this is all yours...
>
> greg k-h
>
