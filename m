Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYBROR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYBROR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYBRORR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:17:17 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33493 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751791AbYBRORO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:17:14 -0500
Date: Mon, 18 Feb 2008 09:16:41 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
Message-ID: <20080218141640.GC12568@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	LKML <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <p7363wmxsxr.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 18, 2008 at 03:03:44PM +0100, Andi Kleen wrote:
> Tomasz Chmielewski <mangoo@wpkg.org> writes:
> >
> > Is it normal to expect the write speed go down to only few dozens of
> > kilobytes/s? Is it because of that many seeks? Can it be somehow
> > optimized? 
> 
> I have similar problems on my linux source partition which also
> has a lot of hard linked files (although probably not quite
> as many as you do). It seems like hard linking prevents
> some of the heuristics ext* uses to generate non fragmented
> disk layouts and the resulting seeking makes things slow.

ext3 tries to keep inodes in the same block group as their containing
directory.  If you have lots of hard links, obviously it can't really
do that, especially since we don't have a good way at mkdir time to
tell the filesystem, "Psst!  This is going to be a hard link clone of
that directory over there, put it in the same block group".

> What has helped a bit was to recreate the file system with -O^dir_index
> dir_index seems to cause more seeks.

Part of it may have simply been recreating the filesystem, not
necessarily removing the dir_index feature.  Dir_index speeds up
individual lookups, but it slows down workloads that do a readdir
followed by a stat of all of the files in the workload.  You can work
around this by calling readdir(), sorting all of the entries by inode
number, and then calling open or stat or whatever.  So this can help
out for workloads that are doing find or rm -r on a dir_index
workload.  Basically, it helps for some things, hurts for others.
Once things are in the cache it doesn't matter of course.

The following ld_preload can help in some cases.  Mutt has this hack
encoded in for maildir directories, which helps.

> Also keeping enough free space is also a good idea because that
> allows the file system code better choices on where to place data.

Yep, that too.

					- Ted


--zYM0uCDKw75PZbzx
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="spd_readdir.c"

/*
 * readdir accelerator
 *
 * (C) Copyright 2003, 2004 by Theodore Ts'o.
 *
 * Compile using the command:
 *
 * gcc -o spd_readdir.so -shared spd_readdir.c -ldl
 *
 * Use it by setting the LD_PRELOAD environment variable:
 * 
 * export LD_PRELOAD=/usr/local/sbin/spd_readdir.so
 *
 * %Begin-Header%
 * This file may be redistributed under the terms of the GNU Public
 * License.
 * %End-Header%
 * 
 */

#define ALLOC_STEPSIZE	100
#define MAX_DIRSIZE	0

#define DEBUG

#ifdef DEBUG
#define DEBUG_DIR(x)	{if (do_debug) { x; }}
#else
#define DEBUG_DIR(x)
#endif

#define _GNU_SOURCE
#define __USE_LARGEFILE64

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>
#include <dlfcn.h>

struct dirent_s {
	unsigned long long d_ino;
	long long d_off;
	unsigned short int d_reclen;
	unsigned char d_type;
	char *d_name;
};

struct dir_s {
	DIR	*dir;
	int	num;
	int	max;
	struct dirent_s *dp;
	int	pos;
	int	fd;
	struct dirent ret_dir;
	struct dirent64 ret_dir64;
};

static int (*real_closedir)(DIR *dir) = 0;
static DIR *(*real_opendir)(const char *name) = 0;
static struct dirent *(*real_readdir)(DIR *dir) = 0;
static struct dirent64 *(*real_readdir64)(DIR *dir) = 0;
static off_t (*real_telldir)(DIR *dir) = 0;
static void (*real_seekdir)(DIR *dir, off_t offset) = 0;
static int (*real_dirfd)(DIR *dir) = 0;
static unsigned long max_dirsize = MAX_DIRSIZE;
static num_open = 0;
#ifdef DEBUG
static int do_debug = 0;
#endif

static void setup_ptr()
{
	char *cp;

	real_opendir = dlsym(RTLD_NEXT, "opendir");
	real_closedir = dlsym(RTLD_NEXT, "closedir");
	real_readdir = dlsym(RTLD_NEXT, "readdir");
	real_readdir64 = dlsym(RTLD_NEXT, "readdir64");
	real_telldir = dlsym(RTLD_NEXT, "telldir");
	real_seekdir = dlsym(RTLD_NEXT, "seekdir");
	real_dirfd = dlsym(RTLD_NEXT, "dirfd");
	if ((cp = getenv("SPD_READDIR_MAX_SIZE")) != NULL) {
		max_dirsize = atol(cp);
	}
#ifdef DEBUG
	if (getenv("SPD_READDIR_DEBUG"))
		do_debug++;
#endif
}

static void free_cached_dir(struct dir_s *dirstruct)
{
	int i;

	if (!dirstruct->dp)
		return;

	for (i=0; i < dirstruct->num; i++) {
		free(dirstruct->dp[i].d_name);
	}
	free(dirstruct->dp);
	dirstruct->dp = 0;
}	

static int ino_cmp(const void *a, const void *b)
{
	const struct dirent_s *ds_a = (const struct dirent_s *) a;
	const struct dirent_s *ds_b = (const struct dirent_s *) b;
	ino_t i_a, i_b;
	
	i_a = ds_a->d_ino;
	i_b = ds_b->d_ino;

	if (ds_a->d_name[0] == '.') {
		if (ds_a->d_name[1] == 0)
			i_a = 0;
		else if ((ds_a->d_name[1] == '.') && (ds_a->d_name[2] == 0))
			i_a = 1;
	}
	if (ds_b->d_name[0] == '.') {
		if (ds_b->d_name[1] == 0)
			i_b = 0;
		else if ((ds_b->d_name[1] == '.') && (ds_b->d_name[2] == 0))
			i_b = 1;
	}

	return (i_a - i_b);
}


DIR *opendir(const char *name)
{
	DIR *dir;
	struct dir_s	*dirstruct;
	struct dirent_s *ds, *dnew;
	struct dirent64 *d;
	struct stat st;

	if (!real_opendir)
		setup_ptr();

	DEBUG_DIR(printf("Opendir(%s) (%d open)\n", name, num_open++));
	dir = (*real_opendir)(name);
	if (!dir)
		return NULL;

	dirstruct = malloc(sizeof(struct dir_s));
	if (!dirstruct) {
		(*real_closedir)(dir);
		errno = -ENOMEM;
		return NULL;
	}
	dirstruct->num = 0;
	dirstruct->max = 0;
	dirstruct->dp = 0;
	dirstruct->pos = 0;
	dirstruct->dir = 0;

	if (max_dirsize && (stat(name, &st) == 0) && 
	    (st.st_size > max_dirsize)) {
		DEBUG_DIR(printf("Directory size %ld, using direct readdir\n",
				 st.st_size));
		dirstruct->dir = dir;
		return (DIR *) dirstruct;
	}

	while ((d = (*real_readdir64)(dir)) != NULL) {
		if (dirstruct->num >= dirstruct->max) {
			dirstruct->max += ALLOC_STEPSIZE;
			DEBUG_DIR(printf("Reallocating to size %d\n", 
					 dirstruct->max));
			dnew = realloc(dirstruct->dp, 
				       dirstruct->max * sizeof(struct dir_s));
			if (!dnew)
				goto nomem;
			dirstruct->dp = dnew;
		}
		ds = &dirstruct->dp[dirstruct->num++];
		ds->d_ino = d->d_ino;
		ds->d_off = d->d_off;
		ds->d_reclen = d->d_reclen;
		ds->d_type = d->d_type;
		if ((ds->d_name = malloc(strlen(d->d_name)+1)) == NULL) {
			dirstruct->num--;
			goto nomem;
		}
		strcpy(ds->d_name, d->d_name);
		DEBUG_DIR(printf("readdir: %lu %s\n", 
				 (unsigned long) d->d_ino, d->d_name));
	}
	dirstruct->fd = dup((*real_dirfd)(dir));
	(*real_closedir)(dir);
	qsort(dirstruct->dp, dirstruct->num, sizeof(struct dirent_s), ino_cmp);
	return ((DIR *) dirstruct);
nomem:
	DEBUG_DIR(printf("No memory, backing off to direct readdir\n"));
	free_cached_dir(dirstruct);
	dirstruct->dir = dir;
	return ((DIR *) dirstruct);
}

int closedir(DIR *dir)
{
	struct dir_s	*dirstruct = (struct dir_s *) dir;

	DEBUG_DIR(printf("Closedir (%d open)\n", --num_open));
	if (dirstruct->dir)
		(*real_closedir)(dirstruct->dir);

	if (dirstruct->fd >= 0)
		close(dirstruct->fd);
	free_cached_dir(dirstruct);
	free(dirstruct);
	return 0;
}

struct dirent *readdir(DIR *dir)
{
	struct dir_s	*dirstruct = (struct dir_s *) dir;
	struct dirent_s *ds;

	if (dirstruct->dir)
		return (*real_readdir)(dirstruct->dir);

	if (dirstruct->pos >= dirstruct->num)
		return NULL;

	ds = &dirstruct->dp[dirstruct->pos++];
	dirstruct->ret_dir.d_ino = ds->d_ino;
	dirstruct->ret_dir.d_off = ds->d_off;
	dirstruct->ret_dir.d_reclen = ds->d_reclen;
	dirstruct->ret_dir.d_type = ds->d_type;
	strncpy(dirstruct->ret_dir.d_name, ds->d_name,
		sizeof(dirstruct->ret_dir.d_name));

	return (&dirstruct->ret_dir);
}

struct dirent64 *readdir64(DIR *dir)
{
	struct dir_s	*dirstruct = (struct dir_s *) dir;
	struct dirent_s *ds;

	if (dirstruct->dir)
		return (*real_readdir64)(dirstruct->dir);

	if (dirstruct->pos >= dirstruct->num)
		return NULL;

	ds = &dirstruct->dp[dirstruct->pos++];
	dirstruct->ret_dir64.d_ino = ds->d_ino;
	dirstruct->ret_dir64.d_off = ds->d_off;
	dirstruct->ret_dir64.d_reclen = ds->d_reclen;
	dirstruct->ret_dir64.d_type = ds->d_type;
	strncpy(dirstruct->ret_dir64.d_name, ds->d_name,
		sizeof(dirstruct->ret_dir64.d_name));

	return (&dirstruct->ret_dir64);
}

off_t telldir(DIR *dir)
{
	struct dir_s	*dirstruct = (struct dir_s *) dir;

	if (dirstruct->dir)
		return (*real_telldir)(dirstruct->dir);

	return ((off_t) dirstruct->pos);
}

void seekdir(DIR *dir, off_t offset)
{
	struct dir_s	*dirstruct = (struct dir_s *) dir;

	if (dirstruct->dir) {
		(*real_seekdir)(dirstruct->dir, offset);
		return;
	}

	dirstruct->pos = offset;
}

int dirfd(DIR *dir)
{
	struct dir_s	*dirstruct = (struct dir_s *) dir;

	if (dirstruct->dir)
		return (*real_dirfd)(dirstruct->dir);

	return (dirstruct->fd);
}

--zYM0uCDKw75PZbzx--
