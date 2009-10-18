Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZJRMwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZJRMwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 08:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZJRMwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 08:52:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:53837 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZJRMwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 08:52:05 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUGFIX] dnotify: handle_event shouldn't match on FS_EVENT_ON_CHILD
Date: Sun, 18 Oct 2009 14:49:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>
References: <200910181446.44625.agruen@suse.de>
In-Reply-To: <200910181446.44625.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910181449.23267.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test case demonstrating the bug:


#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

static void create_event(int s, siginfo_t* si, void* p)
{
	printf("create\n");
}

static void delete_event(int s, siginfo_t* si, void* p)
{
	printf("delete\n");
}

int main (void) {
	struct sigaction action;
	char *tmpdir, *file;
	int fd1, fd2;

	sigemptyset (&action.sa_mask);
	action.sa_flags = SA_SIGINFO;

	action.sa_sigaction = create_event;
	sigaction (SIGRTMIN + 0, &action, NULL);

	action.sa_sigaction = delete_event;
	sigaction (SIGRTMIN + 1, &action, NULL);

#	define TMPDIR "/tmp/test.XXXXXX"
	tmpdir = malloc(strlen(TMPDIR) + 1);
	strcpy(tmpdir, TMPDIR);
	mkdtemp(tmpdir);

#	define TMPFILE "file"
	file = malloc(strlen(tmpdir) + strlen(TMPFILE) + 2);
	sprintf(file, "%s/%s", tmpdir, TMPFILE);

	fd1 = open (tmpdir, O_RDONLY);
	fcntl(fd1, F_SETSIG, SIGRTMIN);
	fcntl(fd1, F_NOTIFY, DN_MULTISHOT | DN_CREATE);

	fd2 = open (tmpdir, O_RDONLY);
	fcntl(fd2, F_SETSIG, SIGRTMIN + 1);
	fcntl(fd2, F_NOTIFY, DN_MULTISHOT | DN_DELETE);

	if (fork()) {
		creat(file, 0600);

		/* Spurious event triggered below! */

		unlink(file);
	} else {
		sleep(1);
		rmdir(tmpdir);
	}

	return 0;
}
