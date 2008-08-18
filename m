Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYHRXVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYHRXVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 19:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYHRXUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 19:20:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260AbYHRXUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 19:20:50 -0400
Date: Mon, 18 Aug 2008 16:20:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: kirill@shutemov.name, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] binfmt_misc.c: avoid potential kernel stack overflow
Message-Id: <20080818162046.f6c41e84.akpm@linux-foundation.org>
In-Reply-To: <48A98293.5080109@openvz.org>
References: <20080818112849.GA4951@localhost.localdomain>
	<48A98293.5080109@openvz.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 18:09:23 +0400
Pavel Emelyanov <xemul@openvz.org> wrote:

> (Put lkml in Cc. The original message is beyond)
> 
> Oops! My fault. The problem is that in case of modularized binfmt,
> the appropriate binary handler gets registered _before_ the script
> one and sets the misc_bang flag even too early.
> 
> Thus when we launch a script the load_misc_binary sets this bang,
> then returns error, since the binary is actually a script, then the
> load_script_binary successfully loads the script, then it loads the
> misc binary again, which exits with the -ENOEXEC error due to bang 
> set.
> 
> This patch helped my box, what about yours?
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 7562053..8d7e88e 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -120,8 +120,6 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>  	if (bprm->misc_bang)
>  		goto _ret;
>  
> -	bprm->misc_bang = 1;
> -
>  	/* to keep locking time low, we copy the interpreter string */
>  	read_lock(&entries_lock);
>  	fmt = check_file(bprm);
> @@ -199,6 +197,8 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>  	if (retval < 0)
>  		goto _error;
>  
> +	bprm->misc_bang = 1;
> +
>  	retval = search_binary_handler (bprm, regs);
>  	if (retval < 0)
>  		goto _error;

<scrabble, hunt>

I put together the below description.  It has no signed-off-by: (yet).
Has this been sufficiently well tested and checked to be in a merge-ready
state?

Thanks.



From: Pavel Emelyanov <xemul@openvz.org>

Fix a regression introduced by 3a2e7f47d71e1df86acc1dda6826890b6546a4e1
("binfmt_misc.c: avoid potential kernel stack overflow").

In the case of modularized binfmt, the appropriate binary handler gets
registered _before_ the script one and sets the misc_bang flag even too
early.

Thus when we launch a script the load_misc_binary sets this bang, then
returns error, since the binary is actually a script, then the
load_script_binary successfully loads the script, then it loads the misc
binary again, which exits with the -ENOEXEC error due to bang set.

Reported-and-tested-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: <stable@kernel.org>		[2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_misc.c~binfmt_miscc-avoid-potential-kernel-stack-overflow fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_miscc-avoid-potential-kernel-stack-overflow
+++ a/fs/binfmt_misc.c
@@ -120,8 +120,6 @@ static int load_misc_binary(struct linux
 	if (bprm->misc_bang)
 		goto _ret;
 
-	bprm->misc_bang = 1;
-
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
@@ -199,6 +197,8 @@ static int load_misc_binary(struct linux
 	if (retval < 0)
 		goto _error;
 
+	bprm->misc_bang = 1;
+
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
 		goto _error;
_

