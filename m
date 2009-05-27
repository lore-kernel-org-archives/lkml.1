Return-Path: <linux-kernel-owner+w=401wt.eu-S933129AbZE0W0C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbZE0W0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:26:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932879AbZE0WZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:25:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:5047 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024AbZE0WZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fK/9QMJ38MlAI+JyTxL/86cEIuhzrQAv1lyCeHig16aB8TIOKXgZSQnJNk1urULS/z
         HSNxq/rPKAeu4Vc2UjWMo9H5kXgXiQHcxSM01N/q1Q2kv8x+x1v0AF4lDn+yrBF0OOSZ
         AlcMFM/j+ySRUb/vvAtnjSRbKkHLTu5SaFFIM=
Date: Thu, 28 May 2009 02:25:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090527222547.GC8321@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com> <20090526131644.GA20920@hallyn.com> <20090526193503.GB11909@x200.localdomain> <4A1DA8FB.3000306@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1DA8FB.3000306@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 04:56:27PM -0400, Oren Laadan wrote:
> > Now here goes second version, with prefixes fixed (kstate_") like Ingo
> > suggested and so Linus could look at the code and with C/R code moved
> > close to usual code and with more checks added (which you should have
> > already!) to not restore null selector in %cs for example.
> 
> It is far from perfect. In fact, it's even clearly commented as such,
> and exactly there.  It would have been helpful if you pointed that
> out in a review, or even - god forbid - sent a patch to improve it.

This is ridiculous.

First, you declare that restart(2) should be allowed for anyone(!).
and then send patchset for inclusion in -mm which doesn't even check
if selectors are right!

> But it works, and it lets people play with a more-than-a-toy
> implementation and provide us with important feedback. Oh, and by
> the way, it doesn't require that people use containers to try it out.

Setting up container for playing is not hard:

	CLONE_NEWUTS=y
	CLONE_NEWIPC=y
	CLONE_NEWPID=y
	CLONE_NEWUSER=y
	CLONE_NEWNET=y

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sched.h>
#include <sys/mount.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>

#define CLONE_NEWNS	0x00020000
#define CLONE_NEWUTS	0x04000000
#define CLONE_NEWIPC	0x08000000
#define CLONE_NEWUSER	0x10000000
#define CLONE_NEWPID	0x20000000
#define CLONE_NEWNET	0x40000000

static int fn(void *_argv)
{
	char **argv = (char **)_argv;

	setsid();
	setpgid(getpid(), getpid());

	execve(argv[0], argv, __environ);
	return 1;
}

int main(int argc, char *argv[])
{
	unsigned long flags = 0;
	int status;
	pid_t pid;
	void *p;

	flags |= CLONE_NEWNS;
	flags |= CLONE_NEWUTS;
	flags |= CLONE_NEWIPC;
	flags |= CLONE_NEWUSER;
	flags |= CLONE_NEWPID;
	flags |= CLONE_NEWNET;

	p = malloc(4 * 4096);
	if (!p)
		return 1;
	argv++;
	pid = clone(fn, p + 4 * 4096, flags, (void *)argv);
	fprintf(stderr, "pid = %d\n", pid);
	if (pid == -1)
		return 1;
	waitpid(pid, &status, __WALL);
	return 0;
}
