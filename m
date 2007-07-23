Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbXGWNKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbXGWNKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758381AbXGWNKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:10:40 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58408 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758338AbXGWNKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:10:30 -0400
Date: Mon, 23 Jul 2007 18:40:39 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dgc@sgi.com
Subject: Re: fallocate() man page
Message-ID: <20070723131039.GA29198@amitarora.in.ibm.com>
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124601.GA22961@amitarora.in.ibm.com> <20070714082342.174830@gmx.net> <20070716053235.GA10945@amitarora.in.ibm.com> <46A44629.3090107@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A44629.3090107@gmx.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, Jul 23, 2007 at 08:09:45AM +0200, Michael Kerrisk wrote:
> Amit,
> 
> I've taken the page that you sent and made various minor formatting and
> wording fixes.  I've also added various FIXMEs to the page.  Some of these
> ("FIXME .") are things that I need to check up later.  Some others are
> questions for which I need input from you, David, or someone else with the
> relevant info (I've marked these "FIXME Amit:").  Could you please review,
> and send a new draft of the page back to me.

Thanks for going through the manpage and improving it!

My comments are below in between <Amit> ... </Amit> tags.

Thanks!
--
Regards,
Amit Arora



.\" FIXME Amit: I need author and license information for this page.
.\" <Amit>
.\"    David Chinner is the original author, hence he can help with this.
.\" </Amit>
.TH FALLOCATE 2 2007-07-20 "Linux" "Linux Programmer's Manual"
.SH NAME
fallocate \- manipulate file space
.SH SYNOPSIS
.nf
.\" FIXME . eventually this #include will probably be something
.\" different when support is added in glibc.
.B #include <linux/falloc.h>
.PP
.BI "long fallocate(int " fd ", int " mode ", loff_t " offset \
", loff_t " len ");
.\" FIXME . check later what feature text macros are  required in
.\" glibc
.SH DESCRIPTION
.BR fallocate ()
allows the caller to directly manipulate the allocated disk space
for the file referred to by
.I fd
for the byte range starting at
.I offset
and continuing for
.I len
bytes.

The
.I mode
argument determines the operation to be performed on the given range.
Currently only one flag is supported for
.IR mode :
.TP
.B FALLOC_FL_KEEP_SIZE
allocates and initializes to zero the disk space within the given range.
.\" FIXME Amit: The next two sentences seem to contradict
.\" each other somewhat.  On the one hand, later writes
.\" are guaranteed not to fail for lack of space; on the other
.\" hand, the file size id not changed even if it is currently
.\" smaller than offset+len bytes.
.\" Could you explain this a little further.  (E.g., how does
.\" the kernel guarantee space without changing the size
.\" of the file?)
.\" <Amit>
.\"     Well, this is a feature where you can allocate/reserve space for
.\" a file without changing the file size. This is done by allocating blocks
.\" to the file, but still not changing the size. As mentioned below, this
.\" helps applications that use append mode a lot. These can open
.\" a file in append mode and start writing to "preallocated" space.
.\" So, if someone does a stat on a file after fallocate() with this mode (where
.\" file size is not changed), he/she will see that the st_blocks
.\" increased, but st_size did not change.
.\" </Amit>
After a successful call,
subsequent writes are guaranteed not to fail because
of lack of disk space.
Even if the size of the file is less than
.IR offset + len ,
the file size is not changed.
This allows allocation of zeroed blocks beyond
the end of file and is useful for optimizing append workloads.
.\" FIXME Amit: Which other flags are likely to appear
.\" for mode, and in which kernel version are they likely?
.\" <Amit>
.\"    There were few more flags which were discussed, but none of
.\" them have been finalized upon. Here are these flags:
.\" FA_FL_DEALLOC, FA_FL_DEL_DATA, FA_FL_ERR_FREE, FA_FL_NO_MTIME, FA_FL_NO_CTIME
.\" All of the above flags were debated upon and we can not say if any/which one
.\" of these flags will make it to the later kernels.
.\" </Amit>
.PP
If
.B FALLOC_FL_KEEP_SIZE
flag is not specified in
.IR mode ,
the default behavior is almost same as when this flag is specified.
The only difference is that on success,
the file size will be changed if the
.IR offset + len
is greater than the file size.
This default behavior closely resembles the behavior of the
.BR posix_fallocate (3)
library function,
and is intended as a method of optimally implementing that function.
.\" FIXME Amit: is it worth adding a few words to the following
.\" sentence to say why fallocate() may allocate a larger range
.\" than specified?
.\" <Amit>
.\"     The preallocation is done in block size chunks. Thus, if the last
.\" few bytes in the range falls in a new block, this entire block gets
.\" allocated to the file. Hence we may have slightly larger range allocated.
.\" I have tried to add one line to explain this below. Please see if it
.\" makes sense and is understandable. Thanks!
.\" </Amit>
.PP
.BR fallocate ()
may allocate a larger range than that was specified.
.\" <Amit>
.\" This is because allocation is done in block size chunks and hence
.\" the allocation will automatically get block aligned.
.\" </Amit>
.SH RETURN VALUE
.BR fallocate ()
returns zero on success, or an error number on failure.
Note that
.\" FIXME . the library wrapper function will do the right
.\" thing, returning -1 on error and setting errno.
.I errno
is not set.
.SH ERRORS
.TP
.B EBADF
.I fd
is not a valid file descriptor, or is not opened for writing.
.TP
.B EFBIG
.IR offset + len
exceeds the maximum file size.
.TP
.B EINVAL
.I offset
was less than 0, or
.I len
was less than or equal to 0.
.TP
.B ENODEV
.I fd
does not refer to a regular file or a directory.
.TP
.B ENOSPC
There is not enough space left on the device containing the file
referred to by
.IR fd .
.TP
.B ESPIPE
.I fd
refers to a pipe of file descriptor.
.\" FIXME Amit: ENODEV says "fd is not a file or a directory";
.\" ESPIPE says (I had to fix the text a little) "refers to a pipe".
.\" This doesn't make sense: if fd is a pipe, then either one
.\" of these errors could occur.  Which is it supposed to be?
.\" <Amit>
.\"    This is inline with posix_fallocate manpage. If it is a pipe,
.\" user will get ESPIPE.
.\" </Amit>
.TP
.B ENOSYS
The filesystem containing the file system referred to by
.I fd
does not support this operation.
.TP
.B EINTR
A signal was caught during execution.
.TP
.B EIO
An I/O error occurred while reading from or writing to a file system.
.TP
.B EOPNOTSUPP
.\" FIXME Amit: can you say a little more about the following error
.\" <Amit>
.\" How does following sound ?
.\" 'The specified mode is not supported on the object by the file system.'
.\" </Amit>
The
.I mode
is not supported on the file descriptor.
.SH VERSIONS
.BR fallocate ()
.\" FIXME . To confirm that this syscall does actually get released
.\" with 2.6.23.
is available since on Linux since kernel 2.6.23.
.SH CONFORMING
.BR fallocate ()
is Linux specific.
.SH SEE ALSO
.BR ftruncate (2),
.BR posix_fallocate (3),
.BR posix_fadvise (3)

