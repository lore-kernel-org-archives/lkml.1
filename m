Return-Path: <linux-kernel-owner+w=401wt.eu-S1762381AbZDJIth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762381AbZDJIth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 04:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbZDJIt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 04:49:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58153 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbZDJItZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 04:49:25 -0400
Date: Fri, 10 Apr 2009 10:47:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/30] headers: fixup cred.h, ipc_namespace.h
Message-ID: <20090410084747.GB17962@elte.hu>
References: <20090410023248.GB27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023248.GB27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> cred.h uses __init
> ipc_namespace.h uses kern_ipc_perm.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  include/linux/cred.h          |    1 +
>  include/linux/ipc_namespace.h |    2 ++
>  2 files changed, 3 insertions(+)
> 
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -13,6 +13,7 @@
>  #define _LINUX_CRED_H
>  
>  #include <linux/capability.h>
> +#include <linux/init.h>
>  #include <linux/key.h>
>  #include <asm/atomic.h>
>  
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -6,6 +6,8 @@
>  #include <linux/rwsem.h>
>  #include <linux/notifier.h>
>  
> +struct kern_ipc_perm;
> +

Please, not yet another forward declaration...

I believe this should be cleaned up properly, instead of sprinkling 
the kernel with random placed forward declarations.

In a cleanly structured piace of code there's rarely any need for 
forward declarations like this. There's two basic header types 
needed:

   foo_types.h       declares all the data types and constants
                     [no complex inline functions]

   foo.h             externs, complex inlines

foo.h includes all foo_types.h and bar_types.h headers it needs.

The foo_types.h file includes all other bar_types.h headers it 
depends on for its data type definitions.

foo_types.h never includes a bar.h file.

The end result will be a clean hieararchy of data types, separated 
from methods. Complex inlines dont create the incestous 
cross-dependency hell anymore and dont contaminate the foo_types.h 
files.

Yes, this is quite a bit of work, but this has been done before for 
several complex headers so it's possible to do it. Also, you 
namespace guys compounded this particular IPC headers sub-problem to 
begin with:

 | commit ae5e1b22f17983da929a0d0178896269e19da186
 | Author: Pavel Emelyanov <xemul@openvz.org>
 | Date:   Fri Feb 8 04:18:22 2008 -0800
 |
 |     namespaces: move the IPC namespace under IPC_NS option

So when touching the IPC header code please clean it up all 
properly. We need separate ipc_types.h and ipc.h headers with clean 
rules and a clean, consistent looking total presentation.

To borrow a recent phrase of hch, right now when i look at all the 
ipc related headers it looks like as if a cat barfed all over the 
place ;-)

Thanks,

	Ingo
