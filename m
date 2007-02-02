Return-Path: <linux-kernel-owner+w=401wt.eu-S1946028AbXBBSyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946028AbXBBSyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 13:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946029AbXBBSyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 13:54:32 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:10894 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946028AbXBBSyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 13:54:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=uKZZLlKcave/FyPaNdWBz/VeBvxQ4hHKGmz+eYi78hGQuDlUAmbqZ3rHjpvBff6Fkb/bw0vrr4mg6AK7mLgcCUgSLuC8x3N1yia6Cu0FdmW9jF0MgYUddEF0Z7uzpwicVKZXEp77I4+v2riO6uCMLYltg9GZbtcrmMVwCjGAVVE=
Message-ID: <e7ca40f70702021054o49bee8fck5a5a38a84cd1e6e1@mail.gmail.com>
Date: Fri, 2 Feb 2007 13:54:31 -0500
From: "Aaron Wiebe" <epiphani@powertrip.net>
To: linux-kernel@vger.kernel.org
Subject: uninterruptable fcntl calls
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 58ad3f43f5d629af
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I've run into a situation where fcntl F_SETLKW calls lock up nearly
completely.  I've tried several approaches to handle this case, and
have yet to come up with some method of handling this.  I've never
really ventured outside userspace, so I'm turning to this list to try
and get a handle on this.

Over NFSv3 udp, this situation takes place VERY rarely, however with
the volume I do, its creating a problem.

In short, I am attempting to read or write lock, and the call hangs to
the point where a sigkill is not captured - no signal is.  I've tried
alarming out and I've tried switching the socket to nonblocking -
nothing I can think of prevents or even allows me to handle the case.
I understand NFS locking can be rather sketchy at times - but all I
need is the ability to handle the case.

I can force the process to die by sending a sigkill, then stracing.
The strace reports the process as sigstop, then processes the kill
signal.

All I need here is a method of capturing this case.  I can "repair"
the stuck lock by regenerating the file, but I can't capture the case
in order to handle this in code.

Any help would be useful - I am currently running 2.6.15.6 compiled
with the NFS patches from linux-nfs.org, but this case was happening
before applying those patches.  I'd be happy to provide any more
information nessecary.  I've been struggling with this one for a few
months now.

Thanks,
-Aaron


Straces:

rt_sigaction(SIGALRM, {0xb7f56640, [ALRM], 0}, {SIG_DFL}, 8) = 0
alarm(120)                              = 0
fcntl64(3, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=0, len=0}
[hangs]

Or:

fcntl64(3, F_GETFL)                     = 0x8002 (flags O_RDWR|O_LARGEFILE)
fcntl64(3, F_SETFL, O_RDWR|O_NONBLOCK|O_LARGEFILE) = 0
fcntl64(3, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=0, len=0}



Code used for locking:

static int db_lock(int fd, int type)
{
    struct flock fl;
    struct timespec *tv = (struct timespec *) malloc(sizeof(struct timespec));
    int ret, c = 0;

    if(!(fd > 0))
        return -1;

#ifdef SIGALRM_HACK
    /* after two minutes, wig out */
    sigalrm_set();
    alarm(120);
#endif

    fl.l_whence = SEEK_SET;
    fl.l_start = 0;
    fl.l_len = 0;
    fl.l_type = type;

#ifdef NONBLOCKING_HACK
    set_nonblocking(fd);
#endif

    while((ret = fcntl(fd, F_SETLKW, &fl)) < 0)
    {
        c++;
        if(c > 600)
        {
            /* we've been waiting for 60 seconds... */
            my_error("stuck on fcntl request, aborting");
            return -1;
        }
        tv->tv_nsec = 100;   /* 10th of a second wait */
        tv->tv_sec = 0;
        nanosleep(tv, NULL);
    }
    free(tv);
#ifdef SIGALRM_HACK
    sigalrm_unset();
#endif
#ifdef NONBLOCKING_HACK
    unset_nonblocking(fd);
#endif
    return ret;
}
