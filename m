Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbZBYVuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbZBYVuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZBYVup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:50:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbZBYVup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:50:45 -0500
Date: Wed, 25 Feb 2009 15:53:56 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] exit_notify: kill the wrong capable(CAP_KILL) check
Message-ID: <20090225215356.GA1442@hallyn.com>
References: <20090225190218.GA7453@redhat.com> <20090225194140.D6F6EFC3DA@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225194140.D6F6EFC3DA@magilla.sf.frob.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Roland McGrath (roland@redhat.com):
> > I can't understand why exit_notify() checks capable(CAP_KILL), but this
> > looks just wrong.
> 
> I don't know either why it's there.  My guess is that it was not actually
> thought out specifically, just a "unless capable" exception added when the
> security-motivated exclusions (exec_id stuff) were added.
> 
> I can't think of any reason not to drop this check.

Because of the following test?

#include <stdio.h>
#include <sched.h>
#include <signal.h>
#include <stdlib.h>

int childfn(void *data)
{
	printf("hi there, i'm the child\n");
	sleep(10);
	exit(0);
}

int main()
{
	int stacksize = 4*getpagesize();
	void *stack, *stacktop;

	stack = malloc(stacksize);
	stacktop = stack + stacksize;

	int p = clone(childfn, stacktop, CLONE_PARENT|SIGSTOP, NULL);
	exit(0);
}
