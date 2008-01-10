Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbYAJBSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbYAJBSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 20:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYAJBSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 20:18:30 -0500
Received: from ozlabs.org ([203.10.76.45]:40990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbYAJBS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 20:18:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
Date: Thu, 10 Jan 2008 12:18:01 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
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
References: <1196983219534-git-send-email-zach.brown@oracle.com> <200801100904.46842.rusty@rustcorp.com.au> <alpine.LFD.1.00.0801091423160.3148@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801091423160.3148@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101218.03291.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2008 09:58:10 Linus Torvalds wrote:
> On Thu, 10 Jan 2008, Rusty Russell wrote:
> > I'd have to read his original statement, but eventfd doesn't build up
> > state, so I think it qualifies.
>
> How about you guys battle it out by giving an example program usign the
> interface?

Nice idea.

> And *simplicity* of the end result really does matter. If it's not simple
> to use, people won't use it.

Completely agreed, but async is always more complex than sync.  

eg. your malloc()-and-overwrite trick here assumes it's serial, similarly 
stack vars.  Even before anything's happened we've massively increased the 
number of mallocs :(  Maybe someone else can see a neater way?

Below is an async-ready version (I've assumed you still want each dir grouped 
together).  It's already slower (best 0m3.842s vs best 0m3.659s):

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

static void find(const char *base, int baselen);

struct result
{
	struct result *next;
	struct stat st;
	unsigned int namelen;
	char name[];
};

static struct result *new_result(const char *base, int baselen,
				 const char *sub, int sublen)
{
	struct result *r;

	r = malloc(sizeof(*r) + baselen + sublen + 2);
	memcpy(r->name, base, baselen);
	r->name[baselen] = '/';
	memcpy(r->name + baselen + 1, sub, sublen+1);
	r->namelen = baselen + sublen + 1;
	
	return r;
}

static void process(struct result *r, struct result **dirs)
{
	printf("%8lu %s\n", r->st.st_size, r->name);
	if (S_ISDIR(r->st.st_mode)) {
		r->next = *dirs;
		*dirs = r;
	} else 
		free(r);
}

/* -1 = fail, 0 = success, 1 = in progress. */
static int handle_async(struct result *r)
{
	/* Ours is sync. */
	return lstat(r->name, &r->st);
}

static void process_pending(struct result *pending, struct result **dirs)
{
	/* Since we're sync, pending will be NULL.  Otherwise call
	pending as they complete. */
}

static void find(const char *base, int baselen)
{
	DIR *dir;
	struct result *r, *pending = NULL, *dirs = NULL;

	dir = opendir(base);
	if (dir) {
		struct dirent *de;
		while ((de = readdir(dir)) != NULL) {
			const char *p = de->d_name;
			int len = strlen(p);
			if (p[0] == '.') {
				if (len == 1)
					continue;
				if (len == 2 && p[1] == '.')
					continue;
			}
			r = new_result(base, baselen, p, len);
			switch (handle_async(r)) {
			case 0:
				process(r, &dirs);
				break;
			case -1:
				free(r);
				break;
			case 1:
				r->next = pending;
				pending = r;
			}
		}
		closedir(dir);
		process_pending(pending, &dirs);
		while (dirs) {
			find(dirs->name, dirs->namelen);
			r = dirs;
			dirs = dirs->next;
			free(r);
		}
	}
}

int main(int argc, char **argv)
{
	find(".",1);
	return 0;
}

