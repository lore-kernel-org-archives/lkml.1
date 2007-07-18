Return-Path: <linux-kernel-owner+w=401wt.eu-S932474AbXGRCjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbXGRCjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 22:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbXGRCjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 22:39:35 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:51038 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbXGRCje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 22:39:34 -0400
Message-ID: <469D7D1B.4050909@gmail.com>
Date: Wed, 18 Jul 2007 04:38:19 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Bodo Eggert <7eggert@gmx.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org>
In-Reply-To: <20070716232755.GD11115@waste.org>
Content-Type: multipart/mixed;
 boundary="------------070700010304060503000008"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070700010304060503000008
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 07/17/2007 01:27 AM, Matt Mackall wrote:

> Larger soft pages waste tremendous amounts of memory (mostly in page
> cache) for minimal benefit on, say, the typical desktop. While there
> are workloads where it's a win, it's probably on a small percentage of
> machines.
> 
> So it's absolutely no help in fixing our order-1 allocation problem
> because we don't want to force large pages on people.

I was just now looking at how much space is in fact wasted in pagecache for 
various pagesizes by running the attached dumb little program from a few 
selected directories (heavy stack recursion, never mind).

Well, hmmm. This is on a (compiled) git tree:

rene@7ixe4:~/src/linux/local$ pageslack
total	: 447350347
  4k	: 67738037 (15%)
  8k	: 147814837 (33%)
16k	: 324614581 (72%)
32k	: 724629941 (161%)
64k	: 1592785333 (356%)

Nicely constant factor 2.2 instead of the 2 one would expect but oh well. On 
a collection of larger files the percentages obviously drop. This is on a 
directory of ogg vorbis files:

root@7ixe4:/mnt/ogg/.../... # pageslack
total	: 70817974
  4k	: 26442 (0%)
  8k	: 67402 (0%)
16k	: 124746 (0%)
32k	: 288586 (0%)
64k	: 419658 (0%)

The "typical desktop" is presented by neither I guess but does involve audio 
and (much larger still) video and bloody huge browser apps.

Not too sure then that 8K wouldn't be something I'd want, given fewer 
pagefaults and all that...

Rene.


--------------070700010304060503000008
Content-Type: text/plain;
 name="pageslack.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pageslack.c"

/* gcc -W -Wall -o pageslack pageslack.c */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>

#define PAGE_SIZE (1UL << PAGE_SHIFT)
#define PAGE_MASK (~(PAGE_SIZE - 1))

unsigned long long total;
unsigned long long slack[5];

void do_dir(const char *name)
{
	DIR *dir; 
	struct dirent *ent;

	dir = opendir(name);
	if (!dir) {
		perror("opendir");
		exit(EXIT_FAILURE);
	}
	while ((ent = readdir(dir))) {
		struct stat buf;
		char path[PATH_MAX];

		if (!strcmp(ent->d_name, "."))
			continue;
		if (!strcmp(ent->d_name, ".."))
			continue;

		sprintf(path, "%s/%s", name, ent->d_name);
		if (stat(path, &buf)) {
			perror("stat");
			exit(EXIT_FAILURE);
		}
		if (S_ISDIR(buf.st_mode)) {
			do_dir(path);
			continue;
		}
		if (S_ISREG(buf.st_mode)) {
			int i;

			for (i = 0; i < 5; i++) {
				unsigned long PAGE_SHIFT = 12 + i;
				slack[i] += (PAGE_SIZE - (buf.st_size % PAGE_SIZE)) % PAGE_SIZE;
			}
			total += buf.st_size;
		}
	}
	if (closedir(dir)) {
		perror("closedir");
		exit(EXIT_FAILURE);
	}
}

int main(void)
{
	do_dir(".");
	printf("total\t: %llu\n", total);
	printf(" 4k\t: %llu (%llu%%)\n", slack[0], (100 * slack[0]) / total);
	printf(" 8k\t: %llu (%llu%%)\n", slack[1], (100 * slack[1]) / total);
	printf("16k\t: %llu (%llu%%)\n", slack[2], (100 * slack[2]) / total);
	printf("32k\t: %llu (%llu%%)\n", slack[3], (100 * slack[3]) / total);
	printf("64k\t: %llu (%llu%%)\n", slack[4], (100 * slack[4]) / total);
	return EXIT_SUCCESS;
}

--------------070700010304060503000008--
