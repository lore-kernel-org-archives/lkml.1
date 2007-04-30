Return-Path: <linux-kernel-owner+w=401wt.eu-S1946563AbXD3RZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946563AbXD3RZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946558AbXD3RZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:25:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56834 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946531AbXD3RYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:24:50 -0400
Date: Mon, 30 Apr 2007 18:23:52 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>, menage@google.com, akpm@linux-foundation.org,
       dev@sw.ru, xemul@sw.ru, serue@us.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
Subject: Re: [PATCH 0/9] Containers (V9): Generic Process Containers
Message-ID: <20070430172352.GA8567@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Srivatsa Vaddagiri <vatsa@in.ibm.com>, Paul Jackson <pj@sgi.com>,
	menage@google.com, akpm@linux-foundation.org, dev@sw.ru,
	xemul@sw.ru, serue@us.ibm.com, ebiederm@xmission.com,
	haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
	ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
	devel@openvz.org
References: <20070427104607.252541000@menage.corp.google.com> <20070429023721.53f249b9.pj@sgi.com> <20070430171225.GH24350@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430171225.GH24350@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:42:25PM +0530, Srivatsa Vaddagiri wrote:
> On Sun, Apr 29, 2007 at 02:37:21AM -0700, Paul Jackson wrote:
> > It builds and boots and mounts the cpuset file system ok.
> > But trying to write the 'mems' file hangs the system hard.
> 
> Basically we are attempting a read_lock(&tasklist_lock) in
> container_task_count() after taking write_lock_irq(&tasklist_lock) in
> update_nodemask()!
> 
> This patch seems to fix the prb for me:
> 
> 
> Fix write_lock() followed by read_lock() bug by introducing a 2nd
> argument to be passed into container_task_count. Other choice is to
> introduce a lock and unlocked versions of container_task_count() ..
> 
> Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>

> -int container_task_count(const struct container *cont) {
> +int container_task_count(const struct container *cont, int take_lock) {
>  	int count = 0;
>  	struct task_struct *g, *p;
>  	struct container_subsys_state *css;
>  	int subsys_id;
>  	get_first_subsys(cont, &css, &subsys_id);
>  
> -	read_lock(&tasklist_lock);
> +	if (take_lock)
> +		read_lock(&tasklist_lock);
>  	do_each_thread(g, p) {
>  		if (task_subsys_state(p, subsys_id) == css)
>  			count ++;
>  	} while_each_thread(g, p);
> -	read_unlock(&tasklist_lock);
> +	if (take_lock)
> +		read_unlock(&tasklist_lock);
>  	return count;

Umm, no - please naje two versions with and without the lock.  Also
Please fix up the codingstyle, the { belongs onto a line of it's own.

