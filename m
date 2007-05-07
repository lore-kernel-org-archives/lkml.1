Return-Path: <linux-kernel-owner+w=401wt.eu-S966341AbXEGTlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966341AbXEGTlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966316AbXEGTle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:41:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42869 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966302AbXEGTld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:41:33 -0400
Message-ID: <463F80E3.8020204@zytor.com>
Date: Mon, 07 May 2007 12:41:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Execute in place
References: <200705030211.36293.a1426z@gawab.com> <200705031433.09364.a1426z@gawab.com> <463F57CB.4090301@zytor.com> <200705072237.33217.a1426z@gawab.com>
In-Reply-To: <200705072237.33217.a1426z@gawab.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> H. Peter Anvin wrote:
>> Al Boldi wrote:
>>> Isn't everything really just temporary?
>>>
>>> Would something like an mmap'd tmpfs be possible?
>> No.  tmpfs relies on being able to leave data structures in the running
>> kernel.  In particular, it has no metadata store at all.
>>
>> The needs for a persistent filesystem are very different, regardless of
>> what the underlying medium is.
> 
> Think Suspend-To-Disk; in that case tmpfs looks pretty persistent to me.
> 
> So what does STD do?  It pushes memory out to swap.

It pushes ALL of (used) memory out to swap.

> Now, tmpfs could probably do the same thing on its own either to a private 
> swap or an mmap.  I am suggesting mmap, as swap is currently really slow 
> with tmpfs, and switching it to use mmap may buy us 2 for the price of 1.

No.

First of all, it would have to map ALL of kernel memory, or you would
have to change the way things like dentries, inodes, and namespaces are
allocated in the kernel itself.

Second, you still would have no stability across kernel versions.

Third, you would have to accept total data loss on unclean shutdown,
because tmpfs doesn't care about coherency, *NOR SHOULD IT*.  This is
the fundamental reason why allocating a large swap partition and making
/tmp a tmpfs can give a *huge* performance boost, even though it still
hits disk.

What you're talking about is, *and should be*, a different filesystem.
You will relatively quickly find that you have to deal with the same
kind of stuff that you have to in any filesystem.

	-hpa
