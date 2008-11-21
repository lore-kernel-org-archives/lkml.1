Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYKUCiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYKUCiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 21:38:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKUCiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 21:38:12 -0500
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:36483 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYKUCiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 21:38:11 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] loop file resizable 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tomas@slax.org, linux-kernel@vger.kernel.org, akinobu.mita@gmail.com,
       util-linux-ng@vger.kernel.org
In-Reply-To: <20081120132654.4c649eb0.akpm@linux-foundation.org>
References: <492120DC.1070407@slax.org> <20081118164207.137e92be.akpm@linux-foundation.org> <16149.1227066661@jrobl> <20081120132654.4c649eb0.akpm@linux-foundation.org>
Date: Fri, 21 Nov 2008 11:37:58 +0900
Message-ID: <7027.1227235078@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton:
> Well if we're going to do this then I guess we'll need to tell the
> util-linux people about it, as users will be needing some tool with
> which to access the new fucntionality.
> 
> Presumably that would be some enhancement to losetup, or perhaps a new
> tool.  Could the util-linux people please have a think about this and
> comment?
> 
> Also, I'm not sure that the user interface is terribly good.  The user
> must extend the file size and then we tell the loop driver to use all
> of the new file size.  it would be better (more flexible) to allow
> userspace to explicitly pass in the new size for the loop device.
> 
> But I'm not sure that this is worth bothering about.

Here is the utility named logrow.

J. R. Okajima

----------------------------------------------------------------------
/*
 * Copyright (C) 2005-2008 Junjiro Okajima
 *
 * This program, aufs is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

/*
 * $Id: logrow.c,v 1.1 2008/11/17 01:59:40 sfjro Exp $
 */

#include <linux/fs.h>
#include <linux/loop.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define _GNU_SOURCE
#include <getopt.h>

char *me;

void usage(FILE *f)
{
	fprintf(f, "%s [options] loop_dev [backend_file]\n"
		"-s, --set new_size_in_bytes\n"
		"\twhen backend_file is given, "
		"it will be expanded too while keeping the original contents\n",
		me);
}

struct option opts[] = {
	{
		.name		= "set",
		.has_arg	= 1,
		.flag		= NULL,
		.val		= 's'
	},
	{
		.name		= "help",
		.has_arg	= 0,
		.flag		= NULL,
		.val		= 'h'
	}
};

void err_size(char *name, __u64 old)
{
	fprintf(stderr, "size must be larger than current %s (%llu)\n",
		name, old);
}

int main(int argc, char *argv[])
{
	int fd, err, c, i, bfd;
	ssize_t ssz;
	size_t sz;
	__u64 old, new, append;
	char a[BUFSIZ];
	struct stat st;
	FILE *out;
	char *backend, *dev;

	err = EINVAL;
	out = stderr;
	me = argv[0];
	new = 0;
	while ((c = getopt_long(argc, argv, "s:h", opts, &i)) != -1) {
		switch (c) {
		case 's':
			errno = 0;
			new = strtoull(optarg, NULL, 0);
			if (errno) {
				err = errno;
				perror(argv[i]);
				goto out;
			}
			break;

		case 'h':
			err = 0;
			out = stdout;
			goto err;

		default:
			perror(argv[i]);
			goto err;
		}
	}

	if (optind < argc)
		dev = argv[optind++];
	else
		goto err;

	fd = open(dev, O_RDONLY);
	if (fd < 0) {
		err = errno;
		perror(dev);
		goto out;
	}

	err = ioctl(fd, BLKGETSIZE64, &old);
	if (err) {
		err = errno;
		perror("ioctl BLKGETSIZE64");
		goto out;
	}

	if (!new) {
		printf("%llu\n", old);
		goto out;
	}

	if (new < old) {
		err = EINVAL;
		err_size(dev, old);
		goto out;
	}

	if (optind < argc) {
		backend = argv[optind++];
		bfd = open(backend, O_WRONLY|O_APPEND);
		if (bfd < 0) {
			err = errno;
			perror(backend);
			goto out;
		}
		err = fstat(bfd, &st);
		if (err) {
			err = errno;
			perror(backend);
			goto out;
		}
		if (new < st.st_size) {
			err = EINVAL;
			err_size(backend, st.st_size);
			goto out;
		}
		append = new - st.st_size;
		sz = sizeof(a);
		while (append > 0) {
			if (append < sz)
				sz = append;
			ssz = write(bfd, a, sz);
			if (ssz != sz) {
				err = errno;
				perror(backend);
				goto out;
			}
			append -= sz;
		}
		err = fsync(bfd);
		if (err) {
			err = errno;
			perror(backend);
			goto out;
		}
	}

	err = ioctl(fd, LOOP_SET_CAPACITY, new);
	if (err) {
		err = errno;
		perror("ioctl LOOP_SET_CAPACITY");
	}
	goto out;

 err:
	usage(out);
 out:
	return err;
}
