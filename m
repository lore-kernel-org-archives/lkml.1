Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYKWDzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYKWDzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 22:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYKWDzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 22:55:43 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:33285 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbYKWDzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 22:55:42 -0500
X-Greylist: delayed 3017 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Nov 2008 22:55:42 EST
Message-ID: <4928C88B.3040101@lougher.demon.co.uk>
Date: Sun, 23 Nov 2008 03:05:47 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: adilger@sun.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Zero-clearing all zero-clearable bytes.
References: <200811221236.FJE81778.LtMHOQFJFVFSOO@I-love.SAKURA.ne.jp>	<20081122174406.GQ3186@webber.adilger.int> <200811230915.CII90122.SFtOMFQHOVLOFJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200811230915.CII90122.SFtOMFQHOVLOFJ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Hello.
> 
> Andreas Dilger wrote:
>> Why would you fill the buffer with 0xff instead of 0?
>> In fact no such program is needed, just "dd if=/dev/zero of=/{fs}/tmp"
>> and then delete the file.
>>
> To avoid that the /{fs}/tmp is created as a sparse file.
> 

Most filesystems will not create a sparse file if zero-byte filled 
blocks are written.  To create a sparse file you normally have to seek 
beyond the file end and then write blocks, leaving a hole in-between the 
positions.

The information from stat can tell you if a file has been stored 
sparsely, because the blocks used count will be less than the file size 
suggests.

For example:

$ dd if=/dev/zero of=small-file bs=512 count=16
16+0 records in
16+0 records out
8192 bytes (8.2 kB) copied, 0.000187744 seconds, 43.6 MB/s
phillip@dylan:/tmp$ stat small-file
   File: `small-file'
   Size: 8192            Blocks: 16         IO Block: 4096   regular file
Device: 801h/2049d      Inode: 847831      Links: 1

The zero filled file uses 16 blocks (16 * 512 bytes = 8K), and so we 
know it isn't sparsely stored.

You can get dd to seek a number of blocks into the output file before 
writing, this will create a sparse file...

$ dd if=/dev/zero of=small-file bs=512 count=16 seek=16
16+0 records in
16+0 records out
8192 bytes (8.2 kB) copied, 0.000212609 seconds, 38.5 MB/s
phillip@dylan:/tmp$ stat small-file
   File: `small-file'
   Size: 16384           Blocks: 16         IO Block: 4096   regular file
Device: 801h/2049d      Inode: 847831      Links: 1

A 16K file is only using 16 blocks, and so 8K is stored sparsely.

Phillip
