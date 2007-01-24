Return-Path: <linux-kernel-owner+w=401wt.eu-S1750912AbXAXPWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbXAXPWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbXAXPWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:22:09 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:56360 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXAXPWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:22:08 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 0/3] i_ino uniqueness: alternate approach -- hash the inodes
Date: Wed, 24 Jan 2007 16:21:44 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200701161857.l0GIvcaA016196@dantu.rdu.redhat.com> <20070123204648.204b1834.akpm@osdl.org> <45B76BAC.4040408@redhat.com>
In-Reply-To: <45B76BAC.4040408@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200701241621.44923.dada1@cosmosbay.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 January 2007 15:22, Jeff Layton wrote:
> Andrew Morton wrote:
> > What is the additional overhead, expressed in relative terms?  ie: as a
> > percentage?
>
> Short answer: ~3-4% in a not very scientific test.
>
> Long answer: I timed 3 different runs of a program that created and then
> closed a pipe 10 million times on a patched and unpatched kernel. I then
> added up the "system" times for each and divided them:

Do you mean this program ?

int count, pfd[2];
for (count = 0 ; count < 10000000 ; count++) {
	pipe(pfd);
	close(pfd[0]);
	close(pfd[1]);
}

The problem is you wont see the overhead of insert/delete the inode in a 
global tree, since you keep hot caches.

To have a better estimate of the overhead, I suggest you try to use more 
active pipes like :

#include <unistd.h>
#define SIZE 16384
int fds[SIZE];

int main(int argc, char *argv[])
{
        unsigned int i , count ;

        for (i = 0 ; i < SIZE ; i += 2)
                pipe(fds + i);
        i = 0;
        for (count = 0 ; count < 10000000 ; count++) {
                close(fds[i]);
                close(fds[i + 1]);
                pipe(fds + i);
                i = (i + 2) % SIZE;
        }
        return 0;
}


# ulimit -n 20000
# time ./pipebench

Eric
