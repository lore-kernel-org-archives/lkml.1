Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0CCNvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 08:51:31 -0500
Received: from airmail.airvana.com ([131.239.32.135]:55231 "EHLO
	airmail.wirelessworld.airvananet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754065Ab0CCNva convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:51:30 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: do_loop_readv_writev() not as described for drivers implementing only write()?
Date: Wed, 3 Mar 2010 13:51:28 -0000
Message-ID: <4B3F8896E1733D4787DDB0EA1C7FF91F011640FD@ukmail.uk.wirelessworld.airvananet.com>
In-Reply-To: <413a6a951003030411y2c11c6eaj551c26e1bed3679d@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: do_loop_readv_writev() not as described for drivers implementing only write()?
Thread-Index: Acq6yqe7RUMPvbW0SE2lYS5MuGzoVAABb5tA
References: <4B3F8896E1733D4787DDB0EA1C7FF91F01163E1D@ukmail.uk.wirelessworld.airvananet.com> <413a6a951003030411y2c11c6eaj551c26e1bed3679d@mail.gmail.com>
From: "Mike McTernan" <mmcternan@airvana.com>
To: "Daniel Baluta" <daniel.baluta@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Mar 2010 13:51:09.0825 (UTC) FILETIME=[945C2710:01CABAD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I would say that the libc enforces atomicity, but I have to dig deeper
for
> a real answer :).

If libc did do it, it would have to be fancy since readv() and writev()
are documented as being atomic between processes, as well as threads.

Still, all things being possible, I visually checked the glibc I'm
using. 

glibc-2.8/sysdeps/unix/sysv/linux/writev.c:

ssize_t
__libc_writev (fd, vector, count)
     int fd;
     const struct iovec *vector;
     int count;
{
  if (SINGLE_THREAD_P)
    return do_writev (fd, vector, count);

  int oldtype = LIBC_CANCEL_ASYNC ();

  ssize_t result = do_writev (fd, vector, count);

  LIBC_CANCEL_RESET (oldtype);

  return result;
}

So we end up in do_writev(), which is defined in the same file:

static ssize_t
do_writev (int fd, const struct iovec *vector, int count)
{
  ssize_t bytes_written;

  bytes_written = INLINE_SYSCALL (writev, 3, fd, CHECK_N (vector,
count), count);

  if (bytes_written >= 0 || errno != EINVAL || count <= UIO_FASTIOV)
    return bytes_written;

  return __atomic_writev_replacement (fd, vector, count);
}

So assuming the syscall to writev() returns >= 0 (which is true for my
driver), I can't see locking being provided here unless
LIBC_CANCEL_ASYNC is doing something spectacular which I've overlooked.

The other observation from this is that the kernel could detect a case
where writev() is not supported by a driver (i.e. write() is implemented
but aio_write() is not) and return -ENOSYS instead of calling
do_loop_readv_writev().  This would allow the libc to use it's
replacement function - __atomic_writev_replacement() in this case.  

How writev() correctly works is still a mystery to me at this point.

Regards,

Mike
