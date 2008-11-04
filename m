Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYKDSox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYKDSox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbYKDSol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:44:41 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:37829 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbYKDSok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:44:40 -0500
Date: Tue, 4 Nov 2008 12:44:36 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v8][PATCH 0/12] Kernel based checkpoint/restart
Message-ID: <20081104184436.GA16328@us.ibm.com>
References: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225374675-22850-1-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> Basic checkpoint-restart [C/R]: v8 adds support for "external" checkpoint
> and improves documentation. Older announcements below.

The following test-program seems to reliably trigger a bug.  Run it in a
new set of namespaces, i.e.
	ns_exec -cmpiuU ./runme > /tmp/o
then control-c it.  The second time I do that, I get the dcache.c:666
BUG().

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/syscall.h>

#define __NR_checkpoint 333
int main (int argc, char *argv[])
{
	pid_t pid = getpid();
	int ret;

	close(0); close(2);
	ret = syscall (__NR_checkpoint, pid, STDOUT_FILENO, 0);

	if (ret < 0)
		perror ("checkpoint");
	else
		printf ("checkpoint id %d\n", ret);

	sleep(200);
	return (ret > 0 ? 0 : 1);
}

-serge
