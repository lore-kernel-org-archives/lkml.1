Return-Path: <linux-kernel-owner+w=401wt.eu-S939473AbXG3TpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939473AbXG3TpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765256AbXG3To5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:44:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:55725 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756553AbXG3To4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:44:56 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX19hxogp2B5hMkNE/DckuWvqpreBYMvKrkuy6Lv0GH
	caWXXtP9AFh7yE
Message-ID: <46AE3F4C.3050505@gmx.net>
Date: Mon, 30 Jul 2007 21:43:08 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dgc@sgi.com
Subject: Re: fallocate() man page
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124601.GA22961@amitarora.in.ibm.com> <20070714082342.174830@gmx.net> <20070716053235.GA10945@amitarora.in.ibm.com> <46A44629.3090107@gmx.net> <20070723131039.GA29198@amitarora.in.ibm.com>
In-Reply-To: <20070723131039.GA29198@amitarora.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Amit.

> On Mon, Jul 23, 2007 at 08:09:45AM +0200, Michael Kerrisk wrote:
>> Amit,
>>
>> I've taken the page that you sent and made various minor formatting and
>> wording fixes.  I've also added various FIXMEs to the page.  Some of these
>> ("FIXME .") are things that I need to check up later.  Some others are
>> questions for which I need input from you, David, or someone else with the
>> relevant info (I've marked these "FIXME Amit:").  Could you please review,
>> and send a new draft of the page back to me.
> 
> Thanks for going through the manpage and improving it!
> 
> My comments are below in between <Amit> ... </Amit> tags.
> 
> Thanks!
[...]

> The
> .I mode
> argument determines the operation to be performed on the given range.
> Currently only one flag is supported for
> .IR mode :
> .TP
> .B FALLOC_FL_KEEP_SIZE
> allocates and initializes to zero the disk space within the given range.
> .\" FIXME Amit: The next two sentences seem to contradict
> .\" each other somewhat.  On the one hand, later writes
> .\" are guaranteed not to fail for lack of space; on the other
> .\" hand, the file size id not changed even if it is currently
> .\" smaller than offset+len bytes.
> .\" Could you explain this a little further.  (E.g., how does
> .\" the kernel guarantee space without changing the size
> .\" of the file?)
> .\" <Amit>
> .\"     Well, this is a feature where you can allocate/reserve space for
> .\" a file without changing the file size. This is done by allocating blocks
> .\" to the file, but still not changing the size. As mentioned below, this
> .\" helps applications that use append mode a lot. These can open
> .\" a file in append mode and start writing to "preallocated" space.
> .\" So, if someone does a stat on a file after fallocate() with this mode (where
> .\" file size is not changed), he/she will see that the st_blocks
> .\" increased, but st_size did not change.
> .\" </Amit>

Okay -- I tried rewording the text here a little to make this clearer.  Can
you review the new version to see that it's okay.

[...]

> .\" FIXME Amit: Which other flags are likely to appear
> .\" for mode, and in which kernel version are they likely?
> .\" <Amit>
> .\"    There were few more flags which were discussed, but none of
> .\" them have been finalized upon. Here are these flags:
> .\" FA_FL_DEALLOC, FA_FL_DEL_DATA, FA_FL_ERR_FREE, FA_FL_NO_MTIME, FA_FL_NO_CTIME
> .\" All of the above flags were debated upon and we can not say if any/which one
> .\" of these flags will make it to the later kernels.
> .\" </Amit>

Thanks for the info.

[...]

> .\" FIXME Amit: is it worth adding a few words to the following
> .\" sentence to say why fallocate() may allocate a larger range
> .\" than specified?
> .\" <Amit>
> .\"     The preallocation is done in block size chunks. Thus, if the last
> .\" few bytes in the range falls in a new block, this entire block gets
> .\" allocated to the file. Hence we may have slightly larger range allocated.
> .\" I have tried to add one line to explain this below. Please see if it
> .\" makes sense and is understandable. Thanks!
> .\" </Amit>

Thanks.

> .PP
> .BR fallocate ()
> may allocate a larger range than that was specified.
> .\" <Amit>
> .\" This is because allocation is done in block size chunks and hence
> .\" the allocation will automatically get block aligned.
> .\" </Amit>

I made the sentence:

    Because allocation is done in block size chunks, fallocate()
    may allocate a larger range than that which was specified.

okay?

[...]

> .TP
> .B ENODEV
> .I fd
> does not refer to a regular file or a directory.
> .TP
> .B ENOSPC
> There is not enough space left on the device containing the file
> referred to by
> .IR fd .
> .TP
> .B ESPIPE
> .I fd
> refers to a pipe of file descriptor.
> .\" FIXME Amit: ENODEV says "fd is not a file or a directory";
> .\" ESPIPE says (I had to fix the text a little) "refers to a pipe".
> .\" This doesn't make sense: if fd is a pipe, then either one
> .\" of these errors could occur.  Which is it supposed to be?
> .\" <Amit>
> .\"    This is inline with posix_fallocate manpage. If it is a pipe,
> .\" user will get ESPIPE.
> .\" </Amit>

Okay -- thanks.  I reworded the text for the ESNODEV error to make this
clearer.  (Please check the wording in the next draft.)

By the way in fs/open.c I see the comment:

        /*
         * Let individual file system decide if it supports preallocation
         * for directories or not.
         */
        if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
                goto out_fput;

But that comment doesn't seem to accord with the line of code immediately
below it (S_ISDIR() check is doene regardles of file system type).  Do I
misunderstand something -- or is the comment wrong?

[...]

> .TP
> .B EOPNOTSUPP
> .\" FIXME Amit: can you say a little more about the following error
> .\" <Amit>
> .\" How does following sound ?
> .\" 'The specified mode is not supported on the object by the file system.'
> .\" </Amit>

I made it:

    The mode is not supported by the file system containing the file
    referred to by fd.

Okay?

[...]

New version of the page on its way soon.

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.
