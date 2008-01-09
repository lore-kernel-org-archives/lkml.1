Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYAIXA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYAIXA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbYAIXAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:00:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296AbYAIXAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:00:35 -0500
Date: Wed, 9 Jan 2008 14:58:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
In-Reply-To: <200801100904.46842.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.00.0801091423160.3148@woody.linux-foundation.org>
References: <1196983219534-git-send-email-zach.brown@oracle.com> <200801091448.46241.rusty@rustcorp.com.au> <47850F99.5020001@oracle.com> <200801100904.46842.rusty@rustcorp.com.au>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jan 2008, Rusty Russell wrote:
> 
> I'd have to read his original statement, but eventfd doesn't build up state, 
> so I think it qualifies.

How about you guys battle it out by giving an example program usign the 
interface?

Here's a favourite really simple load of mine:

 - do the equivalent of "ls -lR" or "find /usr" as quickly as possible, 
   without playing "sort by the inode numbers" games (that don't work in 
   general, but are great for some filesystems)

   Do this on a directory that isn't newly created, but has had files 
   added and removed over time (so that the return order of "readdir()" 
   isn't dense and sorted in the inode tables already). The classic 
   example is "ls -l /usr/bin" or similar.

This is actually a fairly hard load, because there's two easily tested 
cases that are both equally important: hot-cache (no IO at all, just CPU), 
and cold-cache (all about trying to get concurrent IO on inode lookups 
going, to get the disk elevator working in the *absense* of any sorting).

And almost all of the operations are operations that right now have no 
asynchronous model except for full threads (ie neither filename nor inode 
lookup have any aio_xyz() things).

How can we do something like *that*? It's about as simple an IO test 
program you can imagine, while I'd argue that it is still a reasonably 
"realistic" thing to do, and interesting for asynchronous operations.

How would do you something like this, striving to allow overlap of IO, and 
getting (hopefully) the block layer to create bigger request sizes?

To make it simple, let's make the *only* operation we care about being 
asynchronous be that "lstat()". And instead of printing out each file, 
just add up the sizes or something (ie make this approximate "du -sh"). 

But the important thing is that if things are cached, it should be the 
same speed as this trivial program, ie the async interfaces shouldn't slow 
things down. But if things require IO, hopefully we can get at least some 
reasonable number of concurrent IO's going, and making the program not 
seek back and forth quite so much).

Try this with and without a "echo 3 > /proc/sys/vm/drop_caches" in 
between. Both are real and relevant usage cases, I think.

And *simplicity* of the end result really does matter. If it's not simple 
to use, people won't use it.

		Linus

---
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

static void find(const char *base, int baselen);

static void handle(const char *name, int namelen)
{
	struct stat st;

	if (lstat(name, &st) < 0)
		return;
	printf("%8lu %s\n", st.st_size, name);
	if (S_ISDIR(st.st_mode))
		find(name, namelen);
}

static void find(const char *base, int baselen)
{
	DIR *dir;
	char *name = malloc(baselen + 255 + 2);

	if (!name)
		return;
	memcpy(name, base, baselen);
	name[baselen] = '/';
	dir = opendir(base);
	if (dir) {
		struct dirent *de;
		while ((de = readdir(dir)) != NULL) {
			const char *p = de->d_name;
			int len = strlen(p);
			if (len > 255)
				continue;
			if (p[0] == '.') {
				if (len == 1)
					continue;
				if (len == 2 && p[1] == '.')
					continue;
			}
			memcpy(name + baselen + 1, de->d_name, len+1);
			handle(name, baselen + 1 + len);
		}
		closedir(dir);
	}
	free(name);
}

int main(int argc, char **argv)
{
	find(".",1);
	return 0;
}
