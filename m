Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYFWLqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYFWLqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYFWLql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:46:41 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:21253 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752313AbYFWLqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:46:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tBlywanfh17SN5dgimZW0IVvsP15GkyXvrMp9J+5E8c/LELDTRm45RCdHm4B70fUYtNiHvUOT9AX6+b2z1ratnCKA2VDsoSo+/lQoP8U4WwejFdEGzyuKiPpPtmUzyAu+04jgnP6wWq7WwLXeZBGlgpmqrrjDshQ0OtXn1eSnFQ=  ;
X-YMail-OSG: XPhvCX0VM1mFiLN0KJ1nCTPjOBk3WkPv..eR3P4Hsnyb4ti5vTtX3N.EsOPti_UzivxTw2exyqg2B19Ipdnhj5f9fT3iZCpQfUzw.qwZ.G8aqrO5FvEM7VEmPcKwbr7isOQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [RFC][PATCH] ext3: don't read inode block if the buffer has a write error
Date: Mon, 23 Jun 2008 21:46:27 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@sun.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
References: <485F8822.5030205@hitachi.com>
In-Reply-To: <485F8822.5030205@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806232146.28379.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 21:25, Hidehiro Kawai wrote:
> A transient I/O error can corrupt inode data.  Here is the scenario:
>
> (1) update inode_A at the block_B
> (2) pdflush writes out new inode_A to the filesystem, but it results
>     in write I/O error, at this point, BH_Uptodate flag of the buffer
>     for block_B is cleared and BH_Write_EIO is set
> (3) create new inode_C which located at block_B, and
>     __ext3_get_inode_loc() tries to read on-disk block_B because the
>     buffer is not uptodate
> (4) if it can read on-disk block_B successfully, inode_A is
>     overwritten by old data
>
> This patch makes __ext3_get_inode_loc() not read the inode block if
> the buffer has BH_Write_EIO flag.  In this case, the buffer should
> have the latest information, so setting the uptodate flag to the
> buffer (this avoids WARN_ON_ONCE() in mark_buffer_dirty().)
>
> According to this change, we would need to test BH_Write_EIO flag for
> the error checking.  Currently nobody checks write I/O errors on
> metadata buffers, but it will be done in other patches I'm working on.

IMO there is a problem with all the buffer head and pagecache error
handling in that uptodate gets cleared on write errors. This is not
only wrong (because the in-memory copy continues to contain the most
uptodate copy), but it will trigger assertions all over the mm and
buffer code AFAIKS.

I don't know why it was done like this, or if anybody actually tested
any of it, but AFAIKS the best way to fix this is to simply not
clear any uptodate bits upon write errors.
