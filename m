Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbZCCBJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbZCCBJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZCCBJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:09:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38250 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZCCBJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:09:49 -0500
Date: Tue, 3 Mar 2009 10:08:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] cgroups: show correct file mode
Message-Id: <20090303100827.43d82c3a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49AC8307.7090008@cn.fujitsu.com>
References: <49AB40BF.4030706@cn.fujitsu.com>
	<6599ad830903021019p3b29c173oc7772af6679d90e0@mail.gmail.com>
	<49AC8307.7090008@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Mar 2009 09:08:23 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Paul Menage wrote:
> > On Sun, Mar 1, 2009 at 6:13 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >> Now a cgroup subsystem can set default file mode of its control files,
> >> so here is a patchset to correct file mode of each subsystem's files.
> > 
> > I really think that we should be defaulting this based on whether the
> > control file has read or write handlers.
> > 
> > Sure, there are special cases like "tasks" that we'd need to set a
> > manual value for, but most of these patches would be unnecessary.
> > 
> 
> Those patches are small and trivial, but it's ok for me to do this
> automatically. How about below patch.
> 
> Note cpuset.memory_pressure is read-only though it has read handler.
> Since if the read handler is removed, it'll return EINVAL instead of
> the current EACCESS, I think it's better to leave as it is.
> 
> =====================
> 
> cgroups: show correct file mode
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  include/linux/cgroup.h |    5 +++++
>  kernel/cgroup.c        |   30 ++++++++++++++++++++++++++++++
>  kernel/cpuset.c        |    1 +
>  3 files changed, 36 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 6ad1989..af3c10f 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -258,6 +258,11 @@ struct cftype {
>  	 */
>  	char name[MAX_CFTYPE_NAME];
>  	int private;
> +	/*
> +	 * If not 0, file mode is set to this value, otherwise it will
> +	 * be figured out automatically
> +	 */
> +	int mode;
>  
>  	/*
>  	 * If non-zero, defines the maximum length of string that can
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 379baa3..0b19204 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1750,6 +1750,33 @@ static int cgroup_create_dir(struct cgroup *cgrp, struct dentry *dentry,
>  	return error;
>  }
>  
> +/**
> + * cgroup_file_mode - deduce file mode of a control file
> + * @cft: the control file in question
> + *
> + * returns cftype->mode if ->mode is not 0
> + * returns 0644 if it has both a read and a write handler
> + * returns 0444 if it has only a read handler
> + * returns 0200 if it has only a write hander
> + */
> +static int cgroup_file_mode(const struct cftype *cft)
> +{
> +	int mode = 0;
> +
> +	if (cft->mode)
> +		return cft->mode;
> +
> +	if (cft->read || cft->read_u64 || cft->read_s64 ||
> +	    cft->read_map || cft->read_seq_string)
> +		mode += 0444;
> +
> +	if (cft->write || cft->write_u64 || cft->write_s64 ||
> +	    cft->write_string || cft->trigger)
> +		mode += 0200;
> +

+= is not |=...

Thanks,
-Kame

