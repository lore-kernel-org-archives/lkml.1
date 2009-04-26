Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZDZRWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZDZRWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 13:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZDZRWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 13:22:25 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:50987 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbZDZRWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 13:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=th8ZwtfzrB27byH8sWRBGeGITICELytUCPuJ43RZPnrPavVLarix7yp5AkAV9Gr2P0
         fxhNKBXkKx0y/VmnkANz4deBIvQhW1F4PtNAxuWCUE28Nnbci45QyLf7iLnMR4LK/Iys
         /9pgR/e7w7AG8qWd1fxbqH1l0900OlRGAeCQ0=
Message-ID: <49F49835.8090807@gmail.com>
Date: Sun, 26 Apr 2009 19:21:57 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] fs: add roundup_to_blocksize and bytes_to_blocks helper
 functions
References: <49EB7087.70302@gmail.com> <20090422141035.efbb1540.akpm@linux-foundation.org>
In-Reply-To: <20090422141035.efbb1540.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton pisze:
> On Sun, 19 Apr 2009 20:42:15 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
>> bytes_to_blocks is open coded in more than 30 places
>> roundup_to_blocksize is open coded in more than 15 places
>>
> 
> It would be nice to document these a bit.  Kernel-wide helpers..

ok

>
>> ---
>>  include/linux/fs.h |   12 ++++++++++++
>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index e766be0..1b4e5b6 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -2451,5 +2451,17 @@ int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
>>  
>>  int get_filesystem_list(char * buf);
>>  
>> +static inline
>> +unsigned long long roundup_to_blocksize(unsigned long long bytes, struct super_block *sb)
>> +{
>> +	return (bytes + sb->s_blocksize - 1) & ~(sb->s_blocksize - 1);
> 
> This is ALIGN(bytes, sb->s_blocksize).  Dunno if that's any clearer though.

thanks, I didn't know about it

>> +}
>> +
>> +static inline
>> +blkcnt_t bytes_to_blocks(unsigned long long bytes, struct super_block *sb)
>> +{
>> +	return (bytes + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
>> +}
> 
> I wonder whether `unsigned long long' was the best choice of type here.
> 
> Probably `bytes' should be loff_t.

loff_t is long long.

So bytes_to_blocks(-6000, sb/*bs=4096, bsb=12*/) would return 4503599627370495

> roundup_to_blocksize() could/should return loff_t too, I think.

And roundup_to_blocksize(-6000, sb/*bs=4096, bsb=12*/) would return -4096

Bit surprising ;)

> roundup_to_blocksize() isn't a terribly good name, IMO.  The name
> conveys no sense of what the function returns.  It _sounds_ like it
> returns a "block size".  But it doesn't - it returns a loff_t. 
> round_up_file_offset_to_block_size() is a bit long though :(

I can't find any better name, sorry.

Marcin

