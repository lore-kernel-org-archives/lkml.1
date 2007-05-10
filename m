Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbXEJS4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbXEJS4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXEJS4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:56:45 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:50139 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbXEJS4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:56:44 -0400
Subject: post 2.6.21 regression in F_GETLK
From: Doug Chapman <doug.chapman@hp.com>
To: linux-kernel@vger.kernel.org, bfields@citi.umich.edu, hch@infradead.org,
       doug.chapman@hp.com
Content-Type: multipart/mixed; boundary="=-+P6zmb0ffUDIK2nruQHd"
Date: Thu, 10 May 2007 14:56:15 -0400
Message-Id: <1178823375.7247.11.camel@dchapman.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-34.el4) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+P6zmb0ffUDIK2nruQHd
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

A recent regression (introduced after 2.6.21) was caught by the LTP test
fcntl11.  It appears that F_GETLK is not properly checking for existing
F_RDLCK and allows taking out a write lock.

This can be demonstrated by either running fcntl11 from the LTP suite or
I have hacked up a much shorter version which demonstrates the issue and
am attaching it.

Using git bisect I came up with this commit as the one that introduced
the issue.  I briefly tried to back this out from the current tree but
appears a lot has change since then so I will need to try that manually.


commit c2fa1b8a6c059dd08a802545fed3badc8df2adc1
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Tue Feb 20 16:10:11 2007 -0500

    locks: create posix-to-flock helper functions

    Factor out a bit of messy code by creating posix-to-flock counterparts
    to the existing flock-to-posix helper functions.

    Cc: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>




- Doug


--=-+P6zmb0ffUDIK2nruQHd
Content-Disposition: attachment; filename=simple_fcntl_test.c
Content-Type: text/x-csrc; name=simple_fcntl_test.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

#define PATH_MAX 80
#define STRING          "abcdefghijklmnopqrstuvwxyz\n"

int fd;

char *locktypes[] = { "F_RDLCK", "F_WRLCK", "F_UNLCK" };


int
do_lock (int cmd, short type, short whence, int start, int len)
{
	struct flock fl;

	fl.l_type = type;
	fl.l_whence = whence;
	fl.l_start = start;
	fl.l_len = len;
	return (fcntl (fd, cmd, &fl));
}

int
test_lock (int type, int start, int len, int expected)
{
	struct flock fl;

	fflush (stdout);
	if (fork () == 0) {
		fl.l_type = type;
		fl.l_whence = SEEK_SET;
		fl.l_start = start;
		fl.l_len = len;
		fl.l_pid = 0;
		if (fcntl (fd, F_GETLK, &fl) < 0) {
			perror ("fcntl");
			exit (1);
		}

		if (fl.l_type == expected) {
			printf ("PASS\n");
		} else {
			printf ("FAILED\n");
			printf ("\ttype = %s, expect %s\n",
				locktypes[fl.l_type], locktypes[expected]);
			printf ("\tstart = %d\n", fl.l_start);
			printf ("\tlen = %d\n", fl.l_len);
			printf ("\tpid = %d\n", fl.l_pid);
		}
		exit (0);
	} else {
		wait (NULL);
	}

	return 0;
}

main ()
{
	char *buf = STRING;
	char template[PATH_MAX];
	struct flock fl;

	snprintf (template, PATH_MAX, "tempfile.XXXXXX");

	if ((fd = mkstemp (template)) < 0) {
		perror ("mkstemp");
		fprintf (stderr, "Couldn't open temp file! errno = %d",
			 errno);
		exit (1);
	}

	if (write (fd, buf, strlen (STRING)) < 0) {
		perror ("write");
		fprintf (stderr, "Couldn't write to temp file! errno = %d",
			 errno);
		exit (1);
	}

	/*
	 * Add a write lock to the middle of the file and a read
	 * at the begining
	 */
	if (do_lock (F_SETLK, (short) F_WRLCK, (short) 0, 10, 5) < 0) {
		fprintf (stderr, "fcntl on file failed, errno =%d", errno);
		exit (1);
	}

	if (do_lock (F_SETLK, (short) F_RDLCK, (short) 0, 1, 5) < 0) {
		fprintf (stderr, "fcntl on file failed, errno =%d", errno);
		exit (1);
	}

	/* this first test fails */
	printf ("child will try to get a F_WRLCK on the same area that the F_RDLCK already exists\n");
	printf ("it should reject due to the F_RDLCK\n");
	test_lock (F_WRLCK, 1, 5, F_RDLCK);

}

--=-+P6zmb0ffUDIK2nruQHd--

