Return-Path: <linux-kernel-owner+w=401wt.eu-S939664AbXG3Tp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939664AbXG3Tp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938401AbXG3Tpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:45:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:38163 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S938970AbXG3Tph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:45:37 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX18CexNSihQCR33NYuXVyk5LbC+sTgV6BaJqxcUHj1
	CAWr6kaVIF43at
Message-ID: <46AE3F8A.6040404@gmx.net>
Date: Mon, 30 Jul 2007 21:44:10 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, dgc@sgi.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: fallocate() man page - darft 2
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124601.GA22961@amitarora.in.ibm.com> <20070714082342.174830@gmx.net> <20070716053235.GA10945@amitarora.in.ibm.com> <46A44629.3090107@gmx.net> <20070723131039.GA29198@amitarora.in.ibm.com>
In-Reply-To: <20070723131039.GA29198@amitarora.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Amit, David,

I've edited the previous version of the page, adding David's license, and
integrating Amit's comments.  I've also added a few new FIXMES.  ("FIXME
Amit" again.)

Could you please review the changes, and the FIXMEs.

Cheers,

Michael



.\" Copyright (c) 2007 Silicon Graphics, Inc. All Rights Reserved
.\" Written by Dave Chinner <dgc@sgi.com>
.\" May be distributed as per GNU General Public License version 2.
.\"
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
.\" FIXME Amit: in other words the affected byte range
.\" is the bytes from (offset) to (offset + len - 1), right?

The
.I mode
argument determines the operation to be performed on the given range.
Currently only one flag is supported for
.IR mode :
.TP
.B FALLOC_FL_KEEP_SIZE
This flag allocates and initializes to zero the disk space
within the range specified by
.I offset
and
.IR len .
After a successful call, subsequent writes into this range
are guaranteed not to fail because of lack of disk space.
Preallocating zeroed blocks beyond the end of the file
is useful for optimizing append workloads.
Preallocating blocks does not change
the file size (as reported by
.BR stat (2))
even if it is less than
.\" FIXME Amit: "offset + len" is written here.  But should it be
.\" "offset + len - 1" ?
.IR offset + len .
.\"
.\" Note from Amit Arora:
.\" There were few more flags which were discussed, but none of
.\" them have been finalized upon. Here are these flags:
.\" FA_FL_DEALLOC, FA_FL_DEL_DATA, FA_FL_ERR_FREE, FA_FL_NO_MTIME,
.\" FA_FL_NO_CTIME
.\" All of the above flags were debated upon and we can not say
.\" if any/which one of these flags will make it to the later kernels.
.PP
If
.B FALLOC_FL_KEEP_SIZE
flag is not specified in
.IR mode ,
the default behavior is almost same as when this flag is specified.
The only difference is that on success,
the file size will be changed if
.\" FIXME Amit: "offset + len" is written here.  But should it be
.\" "offset + len - 1" ?
.IR offset + len
is greater than the file size.
This default behavior closely resembles the behavior of the
.BR posix_fallocate (3)
library function,
and is intended as a method of optimally implementing that function.
.PP
Because allocation is done in block size chunks,
.BR fallocate ()
may allocate a larger range than that which was specified.
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
(If
.I fd
is a pipe or FIFO, a different error results.)
.TP
.B ENOSPC
There is not enough space left on the device containing the file
referred to by
.IR fd .
.TP
.B ESPIPE
.I fd
refers to a pipe or FIFO.
.TP
.B ENOSYS
The file system containing the file system referred to by
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
The
.I mode
is not supported by the file system containing the file referred to by
.IR fd .
.SH VERSIONS
.BR fallocate ()
.\" FIXME . To confirm that this syscall does actually get released
.\" with 2.6.23.
is available on Linux since kernel 2.6.23.
.SH CONFORMING
.BR fallocate ()
is Linux specific.
.SH SEE ALSO
.BR ftruncate (2),
.BR posix_fallocate (3),
.BR posix_fadvise (3)
