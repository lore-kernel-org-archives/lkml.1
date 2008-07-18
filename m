Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYGRIK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYGRIK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYGRIKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:10:44 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:63456 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYGRIKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xnKw3pqjqDKVfS6TR9rFYOso25aE/xx81h/yWrmC+FgOc2kF9VyIo7z1rRHIhuX2pz
         DQ1X8yLxO94lLvm8oUysi4MlErFHftsRamvAY6feKql27muyqR5EFo572kmUdbRZvDeh
         USeBFI/58GODE1zF7AS8snRDziEmOI7YwjnFk=
Message-ID: <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
Date: Fri, 18 Jul 2008 10:10:40 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
Cc: jfs-discussion@lists.sourceforge.net,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1216336164.32175.3.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
	 <1216336164.32175.3.camel@norville.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 1:09 AM, Dave Kleikamp
<shaggy@linux.vnet.ibm.com> wrote:
> On Thu, 2008-07-17 at 20:35 +0200, Vegard Nossum wrote:
>> Hi,
>>
>> I got this on latest -git with an intentionally corrupted filesystem image:
>>
>> BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
>
> This assert shouldn't be here.  It would be better to handle this with
> jfs_error(), which will mark the superblock dirty, and take appropriate
> action.
>
>> Full log at http://folk.uio.no/vegardno/linux/log-1216318656.txt, but
>> I think the preceding messages are just left-overs from previous
>> mount/remount attempts. I can test patches.
>
> How about this one?  So far, compile tested only.
>
> JFS: The kernel shouldn't trap when deleting a file with nlink == 0.
>
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Thanks!

But whether it truly helped or not, I don't know. I got something different now:

jfs_unlink: dtDelete returned -116
jfs_unlink: dtDelete returned -116
------------[ cut here ]------------
kernel BUG at fs/inode.c:262!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 387, comm: jfsCommit Not tainted (2.6.26-03415-gdf3030b #45)
EIP: 0060:[<c01b96f9>] EFLAGS: 00010206 CPU: 0
EIP is at clear_inode+0x149/0x160
EAX: 00000005 EBX: f56e283c ECX: f7242fd0 EDX: 00000000
ESI: f56e2568 EDI: 00000000 EBP: f79f9f0c ESP: f79f9f04
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process jfsCommit (pid: 387, ti=f79f8000 task=f7242fd0 task.ti=f79f8000)
Stack: 00000001 f56e283c f79f9f24 c02de258 c08f7ba0 f79f9f24 c02de220 f56e283c
       f79f9f34 c01b9ba1 f56e283c 00000000 f79f9f44 c01b9d67 f56e283c 00000000
       f79f9f50 c01b8be7 f56e283c f79f9f9c c02fd5b5 f88261bc f79f9f70 c0159173
Call Trace:
 [<c02de258>] ? jfs_delete_inode+0x38/0x130
 [<c02de220>] ? jfs_delete_inode+0x0/0x130
 [<c01b9ba1>] ? generic_delete_inode+0x81/0x120
 [<c01b9d67>] ? generic_drop_inode+0x127/0x180
 [<c01b8be7>] ? iput+0x47/0x50
 [<c02fd5b5>] ? txUpdateMap+0x1d5/0x2a0
 [<c0159173>] ? lock_release_holdtime+0x83/0x120
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c02ffff1>] ? jfs_lazycommit+0xd1/0x2e0
 [<c012e940>] ? default_wake_function+0x0/0x10
 [<c02fff20>] ? jfs_lazycommit+0x0/0x2e0
 [<c014b02c>] ? kthread+0x3c/0x70
 [<c014aff0>] ? kthread+0x0/0x70
 [<c0104ddb>] ? kernel_thread_helper+0x7/0x1c
 =======================
Code: 00 f0 00 00 e9 65 ff ff ff 90 8d 83 44 02 00 00 b9 90 89 1b c0
ba 08 00 00 00 c7 04 24 02 00 00 00 e8 cc ed 58 00 e9 16 ff ff ff <0f>
0b eb fe 8d 76 00 0f 0b eb fe 8d 74 26 00 0f 0b eb fe 8d 74
EIP: [<c01b96f9>] clear_inode+0x149/0x160 SS:ESP 0068:f79f9f04
Kernel panic - not syncing: Fatal exception

...but it might just be a different error altogether.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
