Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab0CDGn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 01:43:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910Ab0CDGnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 01:43:23 -0500
Date: Wed, 3 Mar 2010 22:42:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: foo saa <foosaa@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, linux-mm@kvack.org
Subject: Re: Linux kernel - Libata bad block error handling to user mode
 program
Message-Id: <20100303224245.ae8d1f7a.akpm@linux-foundation.org>
In-Reply-To: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(lots of cc's added)

On Wed, 3 Mar 2010 23:52:20 -0500 foo saa <foosaa@gmail.com> wrote:

> hi everyone,
> 
> I am in the process of writing a disk erasure application in C. The
> program does zerofill the drive (Good or Bad) before someone destroys
> it. During the erasure process, I need to record the number of bad
> sectors during the zerofill operation.
> 
> The method used to write to the hdd involves opening the appropriate
> /dev block device using open() call with O_WRONLY flag, start issuing
> write() calls to fill the sectors. A 512 byte buffer filled with
> zero's is used. All calls are of 64bit enabled. (I am using
> _LARGEFILE64_SOURCE define).
> 
> The problem is (mostly with the bad hdd's), when the write call
> encounters a bad sector, it takes a bit longer than usual and writes
> the sector without any errors. (dmesg shows a lot of error messages
> embedded in the LIBATA error handling code!). The call never fails for
> any reason.
> 
> I am using 2.6.27-7-generic  and gcc version 4.3.2  on ubuntu 8.10. I
> have tried upto 2.6.30.10 and multiple distros with similar behavior.
> 
> Here is a summary of things I have attempted.
> 
> I know about the bad sector and it's location on the hdd, since it has
> been verified by using Windows based hex editor utilities, DOS based
> erasure applications, MHDD and many other HDD utilities.
> 
> I have tried using O_DIRECT with aligned buffers, but still could not
> identify the bad sectors during the writing process.
> 
> I have tried using fadvise, posix_fadvise functions to get of the
> caching, but still failed.
> 
> I have tried using SG_IO and SAT translation (direct ATA commands with
> device addressing) and it fails too. Raw devices is out of question
> now.
> 
> The libata is not letting / informing the user mode program (executing
> under root) about the media / write errors / bad blocks and failures,
> though it notifies the kernel and logs to syslog. It also tries to
> reallocate, softreset, hardreset the block device which is evident
> from the dmesg logs.
> 
> What has to be done for my program to identify / receive the bad block
> / sector information during the read / write process?
> 
> How can I receive the bad sector / physical and media write errors in
> my program? This is my only requirement and question.
> 
> I am currently out of options unless anyone from here can show some
> new direction!
> 
> My only option is to recompile the kernel with libata customization
> and changes according to my requirement. (Can I instruct to libata to
> skip the error handling process and pass certain errors to my
> program?).
> 
> Is this a good approach and recommended one? If not what should be
> done to achieve it? If yes, can somebody throw some light on it?
> 
> Please let me know if you have any queries in my above explanation.
> 

OK, this is bad.

Did you try running fsync() after a write(), check the return value?

I doubt if this is a VFS bug.  As O_DIRECT writes are also failing to
report errors, I'd suspect that the driver or block layers really are
failing to propagate the error back.

Do the ata guys know of a way of deliberately injecting errors to test
these codepaths?  If we don't have that, something using the
fault-injection code would be nice.  As low-level as possible,
preferably at interrupt time.
