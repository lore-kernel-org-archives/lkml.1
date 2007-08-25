Return-Path: <linux-kernel-owner+w=401wt.eu-S1761514AbXHYAK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761514AbXHYAK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXHYAKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:10:19 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:34060 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbXHYAKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:10:17 -0400
Date: Fri, 24 Aug 2007 20:05:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH] Sort module list - use ppos instead of m->private
Message-ID: <20070825000513.GA9811@Krystal>
References: <20070812150844.305211039@polymtl.ca> <20070812151039.996081605@polymtl.ca> <20070815033945.GA13134@mail.ustc.edu.cn> <20070815041845.GJ21089@ftp.linux.org.uk> <20070815063741.GB5175@mail.ustc.edu.cn> <20070815065301.GK21089@ftp.linux.org.uk> <20070824153933.GA21226@Krystal> <20070824163448.a48dadc2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070824163448.a48dadc2.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:01:44 up 26 days, 20 min,  3 users,  load average: 0.12, 0.30, 0.23
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Fri, 24 Aug 2007 11:39:33 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Sort modules list - use ppos instead of m->private
> > 
> > When reading the data by small chunks (i.e. byte by byte), the index (ppos) is
> > incremented by seq_read() directly and no "next" callback is called when going
> > to the next module.
> > 
> > Therefore, use ppos instead of m->private to deal with the fact that this index
> > is incremented directly to pass to the next module in seq_read() after the
> > buffer has been emptied.
> 
> Confused.  What problem is this patch fixing?  I'm guessing that something
> is going wrong when /proc/modules is read one-byte-at-a-time?
> 
> <tests that>
> 
> <nope>
> 
> Better changelogs, please.
> 

Ok, will append this in the changelog (I sent this to Rusty earlier
today):

Small test program for this:

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define BUFSIZE 1024

int main()
{
        int fd = open("/proc/modules", O_RDONLY);
        char buf[BUFSIZE];
        ssize_t size;

        do {
                size = read(fd, buf, 1);
                printf("%c", buf[0]);
                usleep(100000);
        } while(size > 0);

        close(fd);
        return 0;
}

Before fix, it prints the first module indefinitely. The patch fixes
this.

I will also append more detail to "Sort module list by pointer address
to get coherent sleepable seq_file iterators" changelog before the
2.6.23-rc3-mm1 repost.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
