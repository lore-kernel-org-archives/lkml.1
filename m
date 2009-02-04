Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZBDCtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZBDCtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZBDCs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:48:56 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:51306 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZBDCsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:48:55 -0500
Message-ID: <498901E7.4050405@cosmosbay.com>
Date: Wed, 04 Feb 2009 03:48:07 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org, oleg@redhat.com, viro@ZenIV.linux.org.uk,
       David Miller <davem@davemloft.net>, hch@lst.de,
       linux-api@vger.kernel.org, mpm@selenic.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org> <4988BD4E.8080206@cosmosbay.com> <alpine.DEB.1.10.0902031446280.23050@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0902031446280.23050@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 04 Feb 2009 03:48:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
> On Tue, 3 Feb 2009, Eric Dumazet wrote:
> 
>> Andrew Morton a écrit :
>>> On Mon,  2 Feb 2009 11:20:09 -0700
>>> Jonathan Corbet <corbet@lwn.net> wrote:
>>>
>>>> Matt Mackall suggested converting epoll's ep_lock to a bitlock as a way of
>>>> saving space in struct file.  This patch makes that change.
>>> hrm.  bit_spin_lock() makes people upset (large penguiny people).  iirc
>>> it doesn't have all the correct/well-understood memory/compiler
>>> ordering semantics which spinlocks have.  And lockdep doesn't know about
>>> it.
>>>
>> In a previous attempt (2005), I suggested using a single global lock.
>>
>> http://search.luky.org/linux-kernel.2005/msg50862.html
>>
>> Probably an array of hashed spinlocks would be more than enough.
> 
> That could be done, although I'm not sure it's worth going that way to 
> save 4 bytes. The effective saving rate is not even 4/sizeof(struct file) 
> since struct file never comes alone, and when you allocate a struct file 
> you always carry more allocations behind (at least for the cases where you 
> tend to have a lot of them around, so size would matter).
> The add/remove path in epoll is not a super-hot one, so it could be done. 
> I dunno how this change matter with the patchset though.

Back in 2005, I saved 4 bytes per file, and because of HWCACHE alignment, sizeof(struct file)
shrinked by 64 bytes. With more than 1.000.000 sockets opened on a busy server, it saved
64 MB of ram. At that time, this mattered (8GB of ram), but in 2009, 64 MB is so small
I dont care anymore about sizeof(struct file)

AFAIK, I just checked on x86_64 and got : sizeof(struct file)=0xc0 , so thats perfect :)

(Only thing I still do is to move private_data in the first cache line of struct file, because
it speedups a lot socket operation, when dealing with 1.000.000 sockets : one cache line miss
avoided per socket syscall)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..03b2227 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -842,6 +842,8 @@ struct file {
 #define f_dentry       f_path.dentry
 #define f_vfsmnt       f_path.mnt
        const struct file_operations    *f_op;
+       /* needed for tty driver, and maybe others */
+       void                    *private_data;
        atomic_long_t           f_count;
        unsigned int            f_flags;
        fmode_t                 f_mode;
@@ -854,8 +856,6 @@ struct file {
 #ifdef CONFIG_SECURITY
        void                    *f_security;
 #endif
-       /* needed for tty driver, and maybe others */
-       void                    *private_data;

 #ifdef CONFIG_EPOLL
        /* Used by fs/eventpoll.c to link all the hooks to this file */


