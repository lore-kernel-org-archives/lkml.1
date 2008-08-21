Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbYHUTTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbYHUTTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbYHUTTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:19:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbYHUTTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:19:10 -0400
Date: Thu, 21 Aug 2008 12:18:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ken Chen" <kenchen@google.com>
Cc: linux-kernel@vger.kernel.org, morgan@kernel.org
Subject: Re: [patch] fix NPTL thread iterator construct in cap_set_pg()
Message-Id: <20080821121827.45e44e4f.akpm@linux-foundation.org>
In-Reply-To: <b040c32a0808150924h2b93529aj803e0b923e1f96f3@mail.gmail.com>
References: <b040c32a0808150924h2b93529aj803e0b923e1f96f3@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 09:24:15 -0700
"Ken Chen" <kenchen@google.com> wrote:

> The usage of while_each_pid_task() construct in cap_set_pg() looks incorrect.
> The macro is meant to form 'do ... while' loop instead of a simple while loop.
> I think currently it will skip thread leader of a NPTL process.
> 
> Fix by convert to 'do ... while' style.
> 
> Signed-off-by: Ken Chen <kenchen@google.com>
> 
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 0101e84..26d8eda 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -167,7 +167,7 @@ static inline int cap_set_pg
>  	pgrp = find_vpid(pgrp_nr);
>  	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
>  		target = g;
> -		while_each_thread(g, target) {
> +		do {
>  			if (!security_capset_check(target, effective,
>  						   inheritable, permitted)) {
>  				security_capset_set(target, effective,
> @@ -175,7 +175,7 @@ static inline int cap_set_pg
>  				ret = 0;
>  			}
>  			found = 1;
> -		}
> +		} while_each_thread(g, target);
>  	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);
> 
>  	read_unlock(&tasklist_lock);

cap_set_pg() gets deleted by the credentials patches in linux-next and
afaict nothing replaced it.

Does this patch actually fix anything?  If not, ignoring it would be a
nice labour-saving device...

