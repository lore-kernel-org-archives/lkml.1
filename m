Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZESTz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZESTz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 15:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZESTzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 15:55:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15579 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZESTzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 15:55:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=uz36ku5xQtcMlBV6bLIFDhnsAeLBOI/06v1zELFkArGyVr4rjFM3JLjs12xFw392b
	nJbBWfpg/X/P2KdhJlvrg==
MIME-Version: 1.0
In-Reply-To: <20090519073942.GA10864@sli10-desk.sh.intel.com>
References: <20090519073942.GA10864@sli10-desk.sh.intel.com>
Date: Tue, 19 May 2009 12:55:18 -0700
Message-ID: <6599ad830905191255r13b6166fs105213faf30f229f@mail.gmail.com>
Subject: Re: [PATCH]cpuset: add new API to change cpuset top group's cpus
From: Paul Menage <menage@google.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 12:39 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>
> This patch adds one API to change cpuset top group's cpus. If we want to
> make one cpu idle, simply remove the cpu from cpuset top group's cpu list,
> then all tasks will be migrate to other cpus, and other tasks will not be
> migrated to this cpu again. No functional changes.

>
> +int cpuset_change_top_cpumask(const char *buf)
> +{
> +       int retval = 0;
> +       struct cpuset *cs = &top_cpuset;
> +       struct cpuset *trialcs;
> +
> +       if (!cgroup_lock_live_group(cs->css.cgroup))
> +               return -ENODEV;

top_cpuset can't possibly be dead, so a plain cgroup_lock() would be fine here.

> +
> +       trialcs = alloc_trial_cpuset(cs);
> +       if (!trialcs)
> +               return -ENOMEM;

You returned without doing a cgroup_unlock()

> +
> +       retval = update_cpumask(cs, trialcs, buf, true);

This will fail if any child cpuset is using any cpu not in the new
cpumask, since a child's cpumask must be a subset of its parent's.

So this can't work without co-ordination with userspace regarding
child cpusets. Given that, it seems simpler to do the whole thing in
userspace, or just use the existing hotplug infrastructure.

Paul
