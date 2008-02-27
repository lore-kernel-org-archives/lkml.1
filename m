Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYB0WEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYB0WEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYB0WEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:04:40 -0500
Received: from styx.suse.cz ([82.119.242.94]:36769 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752731AbYB0WEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:04:40 -0500
Date: Wed, 27 Feb 2008 23:04:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Roland McGrath <roland@redhat.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
In-Reply-To: <20080227210038.93AFC2700FD@magilla.localdomain>
Message-ID: <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz>
 <20080227210038.93AFC2700FD@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Roland McGrath wrote:

> Have you observed an actual problem?  I don't think the "race" you seem 
> to be concerned about is a problem at all.
> The comment refers to the necessary atomicity of posting the signal along
> with doing the wakeups.  Those are done together with the siglock held.
> It does not matter that the siglock was dropped and reacquired before
> there.  

What happens here is that the proces that was woken-up is spinning on the 
siglock even before the actual SIGCONT has been queued. When this lock is 
released, the process continues executing, and its SIGCONT handler doesn't 
run, even though it executes _just because_ it was woken up by SIGCONT. 

Let's take this as an example:

#include <signal.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

volatile int sigcont_received = 0;

static void sigcont_handler(int signo)
{
	sigcont_received = 1;
}

int main(int argc, char **argv)
{

	struct sigaction action;

	memset(&action, 0, sizeof(action));
	action.sa_handler = sigcont_handler;
	sigemptyset(&action.sa_mask);

	if (sigaction(SIGCONT, &action, NULL) != 0) {
		fprintf(stderr, "sigaction() failed\n");
		return 1;
	}

	while (1) {
		if (kill(getpid(), SIGSTOP) != 0) {
			printf("could not send SIGSTOP to self\n");
			return 1;
		}

			if (sigcont_received)
				printf("finished (SIGCONT received)\n");
			else
				printf("finished (without SIGCONT)\n");
		sigcont_received = 0;
	}
	return 0;
}

Do you agree that when you run this program, and once it gets stopped 
(sends SIGSTOP to itself), send SIGCONT to it. It should always print

	finished (SIGCONT received)

right? Without my patch, sometimes 

	finished (without SIGCONT)

can be observed (for some reason, it seems to trigger more often on ia64 
machines than on any x86 hardware).

Thanks,

-- 
Jiri Kosina
SUSE Labs
