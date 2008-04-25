Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbYD0RNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbYD0RNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbYD0RNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:13:12 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37941 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755056AbYD0RNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:13:10 -0400
Date: Fri, 25 Apr 2008 15:48:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stat benchmark
Message-ID: <20080425194845.GE21193@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Soeren Sandmann <sandmann@daimi.au.dk>,
	linux-kernel@vger.kernel.org
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 24, 2008 at 10:59:10PM +0200, Soeren Sandmann wrote:
> 
> Under the theory that disk seeks are killing us, one idea is to add a
> 'multistat' system call that would allow statting of many files at a
> time, which would give the disk scheduler more to work with. 

Why don't you try this version of your stat-benchmark first?  If you
give it the -s option, it will sort the files by inode number first.
I think you will find this should make a significant difference.

If it works, something that would be really great if someone were to
make a generic library which could be used instead of readdir().  I
have something which works as an LD_PRELOAD, but apparently it's been
blowing up on 64-bit systems, and I haven't had time to debug it.
It's probably better to do it as a library which userspace
applications linked against, anyway.  Would you or someone you know be
interesed in maybe taking this idea and running with it?

Regards,

						- Ted


--AqsLC8rIMeq19msA
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="stat-benchmark.c"

#include <sys/time.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <getopt.h>

struct dirent_s {
	unsigned long long d_ino;
	long long d_off;
	unsigned short int d_reclen;
	unsigned char d_type;
	char *d_name;
};


static void
disaster (const char *what)
{
    fprintf (stderr, "%s failed: %s\n", what, strerror (errno));
    exit (1);
}

static void
dump_caches (void)
{
    int fd = open ("/proc/sys/vm/drop_caches", O_RDWR);

    if (fd < 0)
	disaster ("opening drop_caches");
    
    if (write (fd, "3", strlen ("3")) < 0)
	disaster ("writing drop_caches");

    if (close (fd) < 0)
	disaster ("closing drop_caches");
}

static int ino_cmp(const void *a, const void *b)
{
	const struct dirent_s *ds_a = (const struct dirent_s *) a;
	const struct dirent_s *ds_b = (const struct dirent_s *) b;
	unsigned int i_a, i_b;
	
	i_a = ds_a->d_ino;
	i_b = ds_b->d_ino;

	return (i_a - i_b);
}

static double
tv_to_sec (const struct timeval *tv)
{
    return tv->tv_sec + tv->tv_usec / 1000000.0;
}

static double
time_diff (const struct timeval *before,
	   const struct timeval *after)
{
    return tv_to_sec (after) - tv_to_sec (before);
}

static int
pot (int n)
{
    int p = 1;
    while (p <= n)
	p *= 2;
    return p;
}

int
main (int argc, char **argv)
{
    DIR *dir = opendir (".");
    struct dirent *ent;
    struct timeval before;
    struct timeval after;
    struct dirent_s *ds = NULL;
    int n_files;
    int do_sort = 0;
    int drop_caches = 1;
    int i, c;

    while ((c = getopt (argc, argv, "sc")) != EOF) {
	    switch (c) {
	    case 's':
		    do_sort++;
		    break;
	    case 'c':
		    drop_caches = 0;
		    break;
	    default:
		    printf("Usage: %s [-s]\n", argv[0]);
	    }
    }

    /* Dump caches */
    
    if (drop_caches)
	    dump_caches();

    sleep (1);

    /* Read directory */
    errno = 0;
    
    gettimeofday (&before, NULL);

    n_files = 0;
    while ((ent = readdir (dir)))
    {
	ds = realloc (ds, sizeof (struct dirent_s) * pot (n_files));

	if (!ds)
	    disaster ("realloc");

	ds[n_files].d_name = strdup (ent->d_name);
	ds[n_files].d_ino = ent->d_ino;
	n_files++;
    }
    
    if (errno != 0)
	disaster ("readdir");
	
    gettimeofday (&after, NULL);

    printf ("Time to readdir(): %f s\n", time_diff (&before, &after));

    if (do_sort)
	    qsort(ds, n_files, sizeof(struct dirent_s), ino_cmp);

    /* Stat all the files */

    gettimeofday (&before, NULL);

    for (i = 0; i < n_files; ++i)
    { 
	struct stat statbuf;

	stat (ds[i].d_name, &statbuf);
    }
    
    gettimeofday (&after, NULL);

    printf ("Time to stat %d files: %f s\n",
	    n_files, time_diff (&before, &after));

    return 0;
}

--AqsLC8rIMeq19msA
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

--AqsLC8rIMeq19msA--
