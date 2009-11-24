Return-Path: <linux-kernel-owner+w=401wt.eu-S932976AbZKXODm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976AbZKXODm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932916AbZKXODl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:03:41 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:40390 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbZKXODk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:03:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sZD4F2EmUzne34uVV4Wi73MmU9+PeSURiBwajFkJyB+qUqAmUlkKpLuEn+bt7BTgR3
         aHReXsf4rGNj6rBQCeKWXI17NtjuiIjpq+CjqmkpNIf0MI6nnP/xD2nGv3m2dNR7ObXl
         9OGxPBC8F0HrcF9Kv48vDmNEGmaMwkje97ePY=
MIME-Version: 1.0
In-Reply-To: <1259068293.3019.15.camel@cail>
References: <1259068293.3019.15.camel@cail>
Date: Tue, 24 Nov 2009 15:03:46 +0100
Message-ID: <4e5e476b0911240603q7df022bx5b5915aab6279537@mail.gmail.com>
Subject: Re: [PATCH 0/1] Correct sorting problem in cfq_service_tree_add
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 2:11 PM, Alan D. Brunelle <Alan.Brunelle@hp.com> wrote:
> Found this whilst reviewing the CFQ I/O scheduler code: Currently, this
> routine only sorts using the I/O priority class - it does not properly
> sort prioritized queues within a specific class. The patch changes the
> sort to utilize the full I/O priority (class & priority).

This changes mixes the interpretation of classes and levels within class.
In the original code, those different things have different meanings:
* priority class decides who can use the disk
* priority level within a class determines how much of the disk time
each queue will obtain
In your case. instead, you completely remove the second meaning, and
provide a larger number of levels to just decide the first.

>
> A simple test shows the problem & fixed results: on a 16-way box, for
> each of 12 attached disks I started up 17 processes (one process at each
> possible class/priority). Each process operated on a separate file in
> the file system. I then did two types of tests: (a) direct/synchronous
> and (b) direct/asynchronous w/ an 80/20 read/write split.
>
> I then tabulated the overall I/O performed per task: (first column is
> priority class (1==RT, 2==BE, 3==IDLE), second column is the I/O
> priority (0==highest), then two groupings of read/write data moved
> (total KiBs over a span of 120 seconds):
>
> Synchronous:
>         2.6.32-rc8     2.6.32-rc8+patch
>        Read    Write     Read    Write
>     ----------------   ----------------
> 1 0 |  311164  310760 |  424260  424116 |
> 1 1 |  129712  129792 |  390208  393232 |
> 1 2 |   72312   71284 |     448     420 |
> 1 3 |   40364   41052 |      28      20 |
> 1 4 |   26788   26352 |      28      24 |
> 1 5 |   16936   16940 |      52      32 |
> 1 6 |   11196   11140 |      28      20 |
> 1 7 |    6476    6648 |      20      28 |

The numbers for the patched kernel are bad.
All priority levels > 2 are starved. They can complete an amount of
I/O comparable with lower priority class:
> 2 0 |      24      24 |      40       8 |
> 2 1 |      24      24 |      12      36 |
> 2 2 |      20      28 |      20      28 |
> 2 3 |      28      20 |      24      24 |
> 2 4 |      28      20 |      28      20 |
> 2 5 |      28      20 |      20      28 |
> 2 6 |      24      24 |      20      28 |
> 2 7 |      24      24 |      36      12 |
>
> 3   |      36      12 |      28      20 |
>     ----------------   ----------------
> Sum    615184  614164    815300  818096
>
This is not the intended behaviour, and you don't need 14 priority
levels to get only one use the disk.

Cheers,
Corrado
