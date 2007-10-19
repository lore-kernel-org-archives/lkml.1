Return-Path: <linux-kernel-owner+w=401wt.eu-S934445AbXJSHIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbXJSHIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbXJSHIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:08:00 -0400
Received: from smtp.nokia.com ([131.228.20.171]:28807 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbXJSHH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:07:58 -0400
Message-ID: <471857B1.8090709@yandex.ru>
Date: Fri, 19 Oct 2007 10:07:29 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: is the inode an orphan?
References: <47179CAE.6010806@yandex.ru> <20071018180152.GO8181@ftp.linux.org.uk>
In-Reply-To: <20071018180152.GO8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Oct 2007 07:07:41.0396 (UTC) FILETIME=[BD478940:01C8121E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Define orphan.  It might very well be still opened after the only link
> to it had been removed and you still will get IO on it.

Well, in the mail I called files like open/unlink the last link/do some I/O 
orphans. Let me shortly describe the problem I'm trying to solve.

In our FS when we're in ->unlink() and i_nlink becomes 0, we have to record 
this inode in the table of orphans, and remove it from there in 
->delete_inode(). This is needed to be able to dispose of orphans in case of an 
unclean reboot on the next mount. AFAIK, ext3 has something similar. I just 
figured that this could be optimized - in most cases ->delete_inode() is called 
right after ->unlink(), and I wanted to avoid putting the inode to the orphan 
table in those cases.

I.e., if one just does "unlink file", then it is not going to be an orphan. And 
most cases are like this. It is rather rare to open a file, unlink it, and keep 
utilizing it.

So my question was - while I'm in ->unlink(), how do I figure out that this is 
not an orphan. So I was thinking about

if (atomic_read(&inode->i_count) == 2)

then this is not an orphan and ->delete_inode() will be called straight away 
(i_nlink is assumed to be 0).

But I've now also figured that ->unlink() may race with write-back, and there 
might be a write-back I/O between ->unlink() (and during it) and 
->delete_inode(), even though the user-space does not have the file in question 
opened.

So, at the moment, AFAIU

if (atomic_read(&inode->i_count) == 2 && !(inode->i_state & I_DIRTY))

then there won't be any I/O on the inode between ->unlink() and ->delete_inode 
i_nlink is assumed to be 0). Is that right, safe and acceptable to use such 
checks in ->unlink() for optimization?

P.S. the code and short description of the FS I refer is here: 
http://www.linux-mtd.infradead.org/doc/ubifs.html

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
