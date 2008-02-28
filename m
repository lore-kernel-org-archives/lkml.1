Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbYB1P3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbYB1P3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYB1P3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:29:04 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:58320 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480AbYB1P3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:29:03 -0500
Date: Thu, 28 Feb 2008 18:32:45 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] fix missed SIGCONT cases
Message-ID: <20080228153245.GB11484@tv-sign.ru>
References: <Pine.LNX.4.64.0802271610330.3391@jikos.suse.cz> <20080227210038.93AFC2700FD@magilla.localdomain> <Pine.LNX.4.64.0802272258150.3391@jikos.suse.cz> <20080228102649.071572700FD@magilla.localdomain> <Pine.LNX.4.64.0802281238550.3391@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802281238550.3391@jikos.suse.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Jiri Kosina wrote:
>
> On Thu, 28 Feb 2008, Roland McGrath wrote:
> 
> > [PATCH] clean up and fix SIGCONT
> > This reorganizes some of the signals code, replacing handle_stop_signal()
> > with prepare_signal() and finish_signal(), called as a pair before and
> > after generating any signal.  The CLD_CONTINUED notification to parent is
> > moved into finish_signal(), taking place after the signal is made pending
> > and siglock dropped.  This fixes a race where a process waking from SIGCONT
> > could resume application code without running its SIGCONT handler first.
> 
> Hi Roland,
> 
> I haven't tested what is the behavior with my patch, or without any 
> patches at all (will do), but with your patch applied, when I run the test 
> program under strace, it resumes immediately ... doesn't look particularly 
> OK to me:
> 
> $ strace -o /dev/null ./a.out | head -10
> finished (without SIGCONT)
> finished (without SIGCONT)
> finished (without SIGCONT)
> finished (without SIGCONT)
> finished (without SIGCONT)
> finished (without SIGCONT)
> finished (without SIGCONT)
> finished (without SIGCONT)
> finished (without SIGCONT)
> finished (without SIGCONT)

This is different, you can try this trivial program,

	int main(int argc, char **argv)
	{
		kill(getpid(), SIGSTOP);
		printf("I'm running, SIGSTOP doesn't really work with strace.\n");
		return 0;
	}

Oleg.

