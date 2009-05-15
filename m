Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbZEOHeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbZEOHeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 03:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbZEOHds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 03:33:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148AbZEOHdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 03:33:47 -0400
Date: Fri, 15 May 2009 09:33:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] perf_counter: Allow specifying a pid to record
Message-ID: <20090515073327.GA13879@elte.hu>
References: <20090515014527.GD16671@ghostprotocols.net> <20090515015046.GA13664@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515015046.GA13664@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Thu, May 14, 2009 at 10:45:27PM -0300, Arnaldo Carvalho de Melo escreveu:
> > commit ee8ffeaf1ba6aee56cf822cba291fbacb5dd450b
> > Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Date:   Thu May 14 22:41:18 2009 -0300
> > 
> >     perf_count: Allow connecting to an existing thread
> >     
> >     Impact: new command line option
> >     
> >     Allow specifying a pid instead of always fork+exec'ing a command.
> >     
> >     Because the PERF_EVENT_COMM and PERF_EVENT_MMAP events happened before
> >     we connected, we must synthesize them so that 'perf record' can get what
> >     it needs.
> 
> Grr, it should read "so that 'perf report' can get", new patch below.
> 
> commit 37216038fe2807ee0725e221675914cd41233541
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Thu May 14 22:41:18 2009 -0300
> 
>     perf_count: Allow connecting to an existing thread
>     
>     Impact: new command line option
>     
>     Allow specifying a pid instead of always fork+exec'ing a command.
>     
>     Because the PERF_EVENT_COMM and PERF_EVENT_MMAP events happened before
>     we connected, we must synthesize them so that 'perf report' can get what
>     it needs.
>     
>     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>


Very nice, applied it - thanks Arnaldo!

> +static void pid_synthesize_mmap_events(pid_t pid, pid_t pgid)
> +{
> +	char filename[PATH_MAX];
> +	FILE *fp;
> +
> +	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
> +
> +	fp = fopen(filename, "r");
> +	if (fp == NULL) {
> +		fprintf(stderr, "couldn't open %s\n", filename);
> +		exit(EXIT_FAILURE);
> +	}
> +	while (1) {
> +		char bf[BUFSIZ];
> +		unsigned char vm_read, vm_write, vm_exec, vm_mayshare;
> +		struct mmap_event mmap_ev = {
> +			.header.type = PERF_EVENT_MMAP,
> +		};
> +		unsigned long ino;
> +		int major, minor;
> +		size_t size;
> +		if (fgets(bf, sizeof(bf), fp) == NULL)
> +			break;
> +
> +		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
> +		sscanf(bf, "%llx-%llx %c%c%c%c %llx %x:%x %lu",
> +			&mmap_ev.start, &mmap_ev.len,
> +                        &vm_read, &vm_write, &vm_exec, &vm_mayshare,
> +                        &mmap_ev.pgoff, &major, &minor, &ino);
> +		if (vm_exec == 'x') {
> +			char *execname = strrchr(bf, ' ');
> +
> +			if (execname == NULL || execname[1] != '/')
> +				continue;
> +
> +			execname += 1;
> +			size = strlen(execname);
> +			execname[size - 1] = '\0'; /* Remove \n */
> +			memcpy(mmap_ev.filename, execname, size);
> +			size = ALIGN(size, sizeof(uint64_t));
> +			mmap_ev.len -= mmap_ev.start;
> +			mmap_ev.header.size = (sizeof(mmap_ev) -
> +					       (sizeof(mmap_ev.filename) - size));
> +			mmap_ev.pid = pgid;
> +			mmap_ev.tid = pid;
> +	
> +			if (write(output, &mmap_ev, mmap_ev.header.size) < 0) {
> +				perror("failed to write");
> +				exit(-1);
> +			}
> +		}
> +	}
> +
> +	fclose(fp);
> +}

Neat - this was one of the holes in the concept :)

	Ingo
