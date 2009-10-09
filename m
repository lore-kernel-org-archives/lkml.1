Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbZJICAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbZJICAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 22:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbZJICAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 22:00:46 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55073 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683AbZJICAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 22:00:45 -0400
Date: Thu, 8 Oct 2009 22:00:11 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] extend get/setrlimit to support setting rlimits
	external to a process (v4)
Message-ID: <20091009020011.GA18784@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091005002617.GA5736@localhost.localdomain> <20091005005321.GA7180@localhost.localdomain> <4ACE5A53.3010502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACE5A53.3010502@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 11:32:03PM +0200, Marcin Slusarz wrote:
> I found some new issues in this patch, sorry ;).
> 
> Neil Horman wrote:
> > (...)
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 6f742f6..631f01b 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -49,6 +49,8 @@
> >  
> >  #include <asm/uaccess.h>
> >  
> > +#include <linux/string.h>
> > +#include <linux/ctype.h>
> >  #include <linux/errno.h>
> >  #include <linux/time.h>
> >  #include <linux/proc_fs.h>
> > @@ -455,72 +457,193 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
> >  struct limit_names {
> >  	char *name;
> >  	char *unit;
> > +	char *match;
> >  };
> >  
> >  static const struct limit_names lnames[RLIM_NLIMITS] = {
> > -	[RLIMIT_CPU] = {"Max cpu time", "ms"},
> > -	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
> > -	[RLIMIT_DATA] = {"Max data size", "bytes"},
> > -	[RLIMIT_STACK] = {"Max stack size", "bytes"},
> > -	[RLIMIT_CORE] = {"Max core file size", "bytes"},
> > -	[RLIMIT_RSS] = {"Max resident set", "bytes"},
> > -	[RLIMIT_NPROC] = {"Max processes", "processes"},
> > -	[RLIMIT_NOFILE] = {"Max open files", "files"},
> > -	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes"},
> > -	[RLIMIT_AS] = {"Max address space", "bytes"},
> > -	[RLIMIT_LOCKS] = {"Max file locks", "locks"},
> > -	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals"},
> > -	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
> > -	[RLIMIT_NICE] = {"Max nice priority", NULL},
> > -	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
> > -	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
> > +	[RLIMIT_CPU] = {"Max cpu time", "ms", "cpu"},
> > +	[RLIMIT_FSIZE] = {"Max file size", "bytes", "fsize"},
> > +	[RLIMIT_DATA] = {"Max data size", "bytes", "data"},
> > +	[RLIMIT_STACK] = {"Max stack size", "bytes", "stack"},
> > +	[RLIMIT_CORE] = {"Max core file size", "bytes", "core"},
> > +	[RLIMIT_RSS] = {"Max resident set", "bytes", "rss"},
> > +	[RLIMIT_NPROC] = {"Max processes", "processes", "nproc"},
> > +	[RLIMIT_NOFILE] = {"Max open files", "files", "nofile"},
> > +	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes", "memlock"},
> > +	[RLIMIT_AS] = {"Max address space", "bytes", "as"},
> > +	[RLIMIT_LOCKS] = {"Max file locks", "locks", "locks"},
> > +	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals", "sigpending"},
> > +	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes", "msgqueue"},
> > +	[RLIMIT_NICE] = {"Max nice priority", NULL, "nice"},
> > +	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL, "rtprio"},
> > +	[RLIMIT_RTTIME] = {"Max realtime timeout", "us", "rttime"},
> >  };
> 
> There's no way user can figure out what's the "match" for every limit.
> Maybe you could print it after "limit name"?
> 
I was figuring we could just document the names, but sure, thats fine.  I'll
likely do a format in which I do "Limit Name(id)" to display the name and id.

> > +	bufptr = kzalloc(PAGE_SIZE, GFP_KERNEL);
> 
> I think you could derive size of allocation from RLIM_NLIMITS.
> If I'm reading correctly it will be something like (RLIM_NLIMITS + 1) * 80.
> 
meh, ok.  It should be more like *90 if I add the id, but we can do that.

> > +
> > +	for (i = 0; i < strlen(element); i++)
> > +		element[i] = tolower(element[i]);
> 
> I don't think we should fix user mistakes like this...
> 
I guess not, if we display the id's

> > +
> > +	if (!strncmp(vmc, "unlimited", 9))
> > +		new_rlim.rlim_cur = RLIM_INFINITY;
> > +	else
> > +		new_rlim.rlim_cur = simple_strtoull(vmc, NULL, 10);
> 
> rlim_cur and rlim_max are unsigned long so you should use simple_strtoul
> 
Ok

> > +
> > +	if (!strncmp(vmm, "unlimited", 9))
> > +		new_rlim.rlim_max = RLIM_INFINITY;
> > +	else
> > +		new_rlim.rlim_max = simple_strtoull(vmm, NULL, 10);
> > +
> > +
> > +	for (i = 0; i < RLIM_NLIMITS; i++) {
> > +		if ((lnames[i].match) &&
> 
> match is always not null, you can drop this check
> 
Ok.

fine, one more version.  It'll take me a few days to test, the system I
developed this on is otherwise occupied at the moment.

Neil

