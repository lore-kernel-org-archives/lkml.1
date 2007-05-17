Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbXEQLxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbXEQLxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 07:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbXEQLwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 07:52:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:7430 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbXEQLwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 07:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=uN6eGTc7LoouYHP2mqZYlWZSJqDGwFeUJDNoIWIWHzGkFMgYBlX2L4VGcLjk7QD1huCVt4ivxwPEO1vh/ZND8YYxzvRlot40zilB46PrQwmcyfk3W4O0stZzmnR6L21raO4G14ohmiUBjeUmA9xrPet9ZNphI79/Sx7yUwirjuQ=
Message-ID: <6ec7a4340705170452y2cf308fem1bad3a189b42d48b@mail.gmail.com>
Date: Thu, 17 May 2007 19:52:50 +0800
From: "Xu CanHao" <xucanhao@gmail.com>
To: chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 17, 5:10 am, Chris Mason <chris.ma...@oracle.com> wrote:
> On Wed, May 16, 2007 at 01:37:26PM -0700, Andrew Morton wrote:
> > On Wed, 16 May 2007 16:14:14 -0400
> > Chris Mason <chris.ma...@oracle.com> wrote:
>
> > > On Wed, May 16, 2007 at 01:04:13PM -0700, Andrew Morton wrote:
> > > > > The good news is that if you let it run long enough, the times
> > > > > stabilize.  The bad news is:
>
> > > > > create dir kernel-86 222MB in 15.85 seconds (14.03 MB/s)
> > > > > create dir kernel-87 222MB in 28.67 seconds (7.76 MB/s)
> > > > > create dir kernel-88 222MB in 18.12 seconds (12.27 MB/s)
> > > > > create dir kernel-89 222MB in 19.77 seconds (11.25 MB/s)
>
> > > > well hang on.  Doesn't this just mean that the first few runs were writing
> > > > into pagecache and the later ones were blocking due to dirty-memory limits?
>
> > > > Or do you have a sync in there?
>
> > > There's no sync,  but if you watch vmstat you can clearly see the log
> > > flushes, even when the overall create times are 11MB/s.  vmstat goes
> > > 30MB/s -> 4MB/s or less, then back up to 30MB/s.
>
> > How do you know that it is a log flush rather than, say, pdflush
> > hitting the blockdev inode and doing a big seeky write?
>
> I don't...it gets especially tricky because ext3_writepage starts
> a transaction, and so pdflush does hit the log flushing code too.
>
> So, in comes systemtap.  I instrumented submit_bh to look for seeks
> (defined as writes more than 16 blocks apart) when the process was
> inside __log_wait_for_space.  The probe is attached, it is _really_
> quick and dirty because I'm about to run out the door.
>
> Watching vmstat, every time the __log_wait_for_space hits lots of seeks,
> vmstat goes into the 2-4MB/s range.  Not a scientific match up, but
> here's some sample output:
>
> 7824 ext3 done waiting for space total wrote 3155 blocks seeks 2241
> 7827 ext3 done waiting for space total wrote 855 blocks seeks 598
> 7827 ext3 done waiting for space total wrote 2547 blocks seeks 1759
> 7653 ext3 done waiting for space total wrote 2273 blocks seeks 1609
>
> I also recorded the total size of each seek, 66% of them where 6000
> blocks or more.
>
> -chris
>
> [jbd.tap]
>
> global in_process
> global writers
> global last
> global seeks
>
> probe kernel.function("__log_wait_for_space@fs/jbd/checkpoint.c") {
>     printf("%d ext3 waiting for space\n", pid())
>     p = pid()
>     writers[p] = 0
>     in_process[p] = 1
>     last[p] = 0
>     seeks[p] = 0
>
> }
>
> probe kernel.function("__log_wait_for_space@fs/jbd/checkpoint.c").return {
>     p = pid()
>     in_process[p] = 0
>     printf("%d ext3 done waiting for space total wrote %d blocks seeks %d\n", p,
>           writers[p], seeks[p])
>
> }
>
> probe kernel.function("submit_bh") {
>     p = pid()
>     in_proc = in_process[p]
>     if (in_proc != 0) {
>         writers[p] += 1
>         block = $bh->b_blocknr
>         last_block = last[p]
>         diff = 0
>         if (last_block != 0) {
>             if (last_block < block && block - last_block > 16) {
>                 diff = block - last_block
>             }
>             if (last_block > block && last_block - block > 16) {
>                 diff = last_block - block
>             }
>         }
>
>         last[p] = block
>         if (diff != 0) {
>             printf("seek log write pid %d last %d this %d diff %d\n",
>                        p, last_block, block, diff);
>             seeks[p] += 1
>         }
>     }
>
> }

To Chris Mason:

I see that your file-system aging methodology is much the same as
here: http://defragfs.sourceforge.net/theory.html

Would it be useful to you?
