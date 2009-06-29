Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZF2CMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZF2CMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 22:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZF2CMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 22:12:31 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50161 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZF2CMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 22:12:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19016.8971.391008.394778@cargo.ozlabs.ibm.com>
Date: Mon, 29 Jun 2009 12:12:27 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: performance counter ~0.4% error finding retired instruction
	count
In-Reply-To: <20090627172854.GE21595@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
	<20090624151010.GA12799@elte.hu>
	<Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
	<Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy>
	<20090627060432.GB16200@elte.hu>
	<19013.49344.860564.948905@cargo.ozlabs.ibm.com>
	<20090627172854.GE21595@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can think of three ways to eliminate the PLT resolver overhead on
execvp:

(1) Do execvp on a non-executable file first to get execvp resolved:

	char tmpnam[16];
	int fd;
	char *args[1];

	strcpy(tmpname, "/tmp/perfXXXXXX");
	fd = mkstemp(tmpname);
	if (fd >= 0) {
		args[1] = NULL;
		execvp(tmpname, args);
		close(fd);
		unlink(tmpname);
	}
	enable_counters();
	execvp(prog, argv);

(2) Look up execvp in glibc and call it directly:

	int (*execptr)(const char *, char *const []);

	execptr = dlsym(RTLD_NEXT, "execvp");
	enable_counters();
	(*execptr)(prog, argv);

(3) Resolve the executable path ourselves and then invoke the execve
system call directly:

	char *execpath;

	execpath = search_path(getenv("PATH"), prog);
	enable_counters();
	syscall(NR_execve, execpath, argv, envp);

(4) Same as (1), but rely on "" being an invalid program name for
execvp:

	execvp("", argv);
	enable_counters();
	execvp(prog, argv);

What do you guys think?  Does any of these appeal more than the
others?  I'm leaning towards (4) myself.

Paul.
