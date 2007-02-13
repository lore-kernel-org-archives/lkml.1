Return-Path: <linux-kernel-owner+w=401wt.eu-S1751206AbXBMIzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbXBMIzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbXBMIzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:55:09 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:21012 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbXBMIzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:55:07 -0500
Message-ID: <45D17C48.9030105@sw.ru>
Date: Tue, 13 Feb 2007 11:52:24 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: menage@google.com
CC: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 6/7] containers (V7): BeanCounters over generic process
 containers
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.998727000@menage.corp.google.com>
In-Reply-To: <20070212085104.998727000@menage.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

menage@google.com wrote:
> This patch implements the BeanCounter resource control abstraction
> over generic process containers. It contains the beancounter core
> code, plus the numfiles resource counter. It doesn't currently contain
> any of the memory tracking code or the code for switching beancounter
> context in interrupts.

Numfiles is not the most interesting place in beancounters.
Kmemsize accounting is much more important actually.

> Currently all the beancounters resource counters are lumped into a
> single hierarchy; ideally it would be possible for each resource
> counter to be a separate container subsystem, allowing them to be
> connected to different hierarchies.
> 
> ---
>  fs/file_table.c          |   11 +
>  include/bc/beancounter.h |  192 ++++++++++++++++++++++++
>  include/bc/misc.h        |   27 +++
>  include/linux/fs.h       |    3 
>  init/Kconfig             |    4 
>  init/main.c              |    3 
>  kernel/Makefile          |    1 
>  kernel/bc/Kconfig        |   17 ++
>  kernel/bc/Makefile       |    7 
>  kernel/bc/beancounter.c  |  371 +++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/bc/misc.c         |   56 +++++++
>  11 files changed, 691 insertions(+), 1 deletion(-)
> 

[snip]

> Index: container-2.6.20/kernel/bc/misc.c
> ===================================================================
> --- /dev/null
> +++ container-2.6.20/kernel/bc/misc.c
> @@ -0,0 +1,56 @@
> +
> +#include <linux/fs.h>
> +#include <bc/beancounter.h>
> +
> +int bc_file_charge(struct file *file)
> +{
> +	int sev;
> +	struct beancounter *bc;
> +
> +	task_lock(current);
> +	bc = task_bc(current);
> +	css_get_current(&bc->css);
> +	task_unlock(current);
> +
> +	sev = (capable(CAP_SYS_ADMIN) ? BC_LIMIT : BC_BARRIER);
> +
> +	if (bc_charge(bc, BC_NUMFILES, 1, sev)) {
> +		css_put(&bc->css);
> +		return -EMFILE;
> +	}
> +
> +	file->f_bc = bc;
> +	return 0;
> +}
> +

I have already pointed out the fact that this place
will hurt performance too much. If we have some context
on task this context must
  1. be get-ed without any locking
  2. be settable to some temporary one without
     locking as well

Unfortunately current containers implementation doesn't
allow all of the above which blocks the rest implementation
of beancounters over them.
