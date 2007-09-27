Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbXI0MW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbXI0MW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXI0MWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:22:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:57281 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752909AbXI0MWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:22:16 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1/fmhNxAgDfeiIyNlHzb9JpMMZ5M8lDSSY4UCH7KI
	FYJnXdlDk28Noa
Message-ID: <46FB9FE2.7090201@gmx.net>
Date: Thu, 27 Sep 2007 14:19:46 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Ulrich Drepper <drepper@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       geoff@gclare.org.uk, Christoph Hellwig <hch@lst.de>
Subject: signalfd_siginfo field names -- revisited
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

(We started discussing this quite a while back, and you then seemed
positively disposed to my idea below, but then holidays intervened, so I'm
resending this slightly revised version of my earlier mail.)

The signalfd_siginfo structure is defined as:

struct signalfd_siginfo {  /* Analog in siginfo_t */
    uint32_t  signo;       /* si_signo */
    int32_t   err;         /* si_errno */
    int32_t   code;        /* si_code */
    uint32_t  pid;         /* si_pid */
    uint32_t  uid;         /* si_uid */
    int32_t   fd;          /* si_fd */
    uint32_t  tid;         /* si_tid */
    uint32_t  band;        /* si_band */
    uint32_t  overrun;     /* si_overrun */
    uint32_t  trapno;      /* si_trapno */
    int32_t   status;      /* si_status */
    int32_t   svint;       /* si_int */
    uint64_t  svptr;       /* si_ptr */
    uint64_t  utime;       /* si_utime */
    uint64_t  stime;       /* si_stime */
    uint64_t  addr;        /* si_addr */
    uint28_t  pad[X];  /* Pad size to 128 bytes (allow space
                          additional fields in the future) */
};

I think these field names are a little unfortunate -- e.g., si_errno --> err.

The reason they're unfortunate is that it makes it difficult to grep source
code for related fields -- e.g., I might be interested in the "errno"
fields that appear both in siginfo_t structures and in signalfd_siginfo
structures, but these renamings make it very difficult to grep for
instances in both of these structures.

At the moment, this problem only affects kernel source code, but of course
if the kernel definition is carried through to glibc, then userland
programs will similarly be difficult to grep for fields that are related.

I think it would be better if the fields in the signalfd_siginfo
structure were named as follows:

struct signalfd_siginfo {
    uint32_t  fdsi_signo;
    int32_t   fdsi_errno;
    int32_t   fdsi_code;
    uint32_t  fdsi_pid;
    uint32_t  fdsi_uid;
    int32_t   fdsi_fd;
    uint32_t  fdsi_tid;
    uint32_t  fdsi_band;
    uint32_t  fdsi_overrun;
    uint32_t  fdsi_trapno;
    int32_t   fdsi_status;
    int32_t   fdsi_int;
    uint64_t  fdsi_ptr;
    uint64_t  fdsi_utime;
    uint64_t  fdsi_stime;
    uint64_t  fdsi_addr;
    uint28_t  pad[];
};

Then one could grep for "si_errno" and find instances in both structures.

(I realize that one could paper over this issue by just making the change
in glibc, but of course it would be better to have the kernel and glibc
definitions be consistent.)

Making this change would of course not break anything in terms of
ABI compatibility.

What do you think about making this change?

Cheers,

Michael


-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

