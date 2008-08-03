Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbYHCMuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbYHCMuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 08:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYHCMt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 08:49:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:30476 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbYHCMtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 08:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=OKtuqcfyFjfbu89gXZNjLL02km/eUhqGldiJc+S8IqWM8exPgl2rNcmSoEkIO8eCsd
         VJNercNlbaEs3BWbBC/dq1/flSP755/iL8HX4No5bDwU2cGVUsYLLi7n51FQW+1YNG5s
         2zSAC5l3anEJgZ7NUfH47hMr0rkxxzLU3zlJM=
Message-ID: <4895A96E.2040303@gmail.com>
Date: Sun, 03 Aug 2008 19:49:50 +0700
From: Hong Tran Duc <hongtd2k@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Oops when read/write or mount/unmount continuously ~ 600.000 times
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I’m using kernel 2.4.20 with fully preemptive enable (patch & set the 
CONFIG option). My CPU is PowerPC 750FX, HDD 80GB, RAM 512,

I got many Oops when try to mount/unmount or read/write on ATA HDD 
continuously about 600.000 times (in several hours). Oops often occurred 
when CPU trap SIGSEGV or SIGILL, sometime on page management module, 
sometimes on scheduler, block I/O manipulation, filesystem.

The most frequently happened on:
Block I/O : make_request, generic_make_request, submit_bh, bdfind, bmap, 
__wait_on_buffer ..
Filesystem: journal_commit_transaction, kill_super, invalidate_inode, 
invalidate_list ..

The reasons is almost linked list on those function was broken. Ex: 
linkedlist->next linkedlist->prev = NULL or set to invalid address.
In the situation SIGILL, the instruction pointer (NIP) is same as the 
return address register (LR).

The newest Oops, I got on function __wait_on_buffer(). The main 
sequences of __wait_on_buffer() are:
1. put_bh -> atomic_inc(bh->b_count);
2. add wait queue
3. loop: do some thing task manipulation, call *schedule()*
4. remove wait queue
5. get_bh -> atomic_dec(bh->b_count); *<- Got Oops here, SEGV because 
bh->b_count = R25 = 0x02 *

After analysis assembly code (I upload on pastebin bellow) at this 
point, I found that:
* At the point (1) -> address of bh->b_count stored in register r25.
* The point from (2) ->(4) all of affect to register 25 will be restored 
from stack (r25 act as non violent register in gcc ABI).
* An step 5, *r25 = 0x02 ??? I don’t know why r25 is changed ? May be 
stack on somewhere was corrupted ?*

This Oops is very difficult to replicate (about 2 hours run stress test 
program). I try to increase/reduce the HZ 10 times, but the frequency of 
bug is no change. And, I tried on ext2/ext3, it’s same result.

I’m really confusing now, I don’t know where the real problem is, and 
what is effected with the frequency of Oops, how to debug and figure 
this bug ?

I post my situation to this ML and hope to get some advice from you,

Some Oops, I uploaded on pastebin here:
http://vnoss.net/p/5783
http://vnoss.net/p/5785

Sources and assembly of __wait_on_buffer()
http://vnoss.net/p/5784


Thanks for your help,

-- 
nm.

GPG Key ID: 0xDD253B25
Fingerprint: 2B17 D64A 9561 A443 2ABC 1302 4641 D0B7 DD25 3B25

