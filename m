Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbZF2Dsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbZF2Dsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 23:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZF2Dso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 23:48:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZF2Dsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 23:48:43 -0400
Date: Mon, 29 Jun 2009 05:48:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: performance counter ~0.4% error finding retired instruction
	count
Message-ID: <20090629034840.GB8059@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy> <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy> <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy> <20090627060432.GB16200@elte.hu> <19013.49344.860564.948905@cargo.ozlabs.ibm.com> <20090627172854.GE21595@elte.hu> <19016.8971.391008.394778@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19016.8971.391008.394778@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> I can think of three ways to eliminate the PLT resolver overhead on
> execvp:
> 
> (1) Do execvp on a non-executable file first to get execvp resolved:
> 
> 	char tmpnam[16];
> 	int fd;
> 	char *args[1];
> 
> 	strcpy(tmpname, "/tmp/perfXXXXXX");
> 	fd = mkstemp(tmpname);
> 	if (fd >= 0) {
> 		args[1] = NULL;
> 		execvp(tmpname, args);
> 		close(fd);
> 		unlink(tmpname);
> 	}
> 	enable_counters();
> 	execvp(prog, argv);
> 
> (2) Look up execvp in glibc and call it directly:
> 
> 	int (*execptr)(const char *, char *const []);
> 
> 	execptr = dlsym(RTLD_NEXT, "execvp");
> 	enable_counters();
> 	(*execptr)(prog, argv);
> 
> (3) Resolve the executable path ourselves and then invoke the execve
> system call directly:
> 
> 	char *execpath;
> 
> 	execpath = search_path(getenv("PATH"), prog);
> 	enable_counters();
> 	syscall(NR_execve, execpath, argv, envp);
> 
> (4) Same as (1), but rely on "" being an invalid program name for
> execvp:
> 
> 	execvp("", argv);
> 	enable_counters();
> 	execvp(prog, argv);
> 
> What do you guys think?  Does any of these appeal more than the
> others?  I'm leaning towards (4) myself.

(4) looks convincingly elegant.

We could also do (5): a one-shot counters-disabled ptrace run of the 
target, then enable-counters-in-target + ptrace-detach after the 
first stop.

	Ingo
