Return-Path: <linux-kernel-owner+w=401wt.eu-S1751582AbZC0ENe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbZC0ENe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 00:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZC0ENY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 00:13:24 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56879 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZC0ENX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 00:13:23 -0400
Message-Id: <200903270412.n2R4CG7o054009@www262.sakura.ne.jp>
Subject: Re: TOMOYO in linux-next
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: pavel@ucw.cz, jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 27 Mar 2009 13:12:16 +0900
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 27032009 #1783695, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

James Morris wrote:
> As for the rest of the feedback, please work with the developers to fix 
> any bugs or lack of documentation.
Thanks.

Pavel Machek wrote:
> Are those interfaces documented somewhere?
They are documented at http://tomoyo.sourceforge.jp/en/2.2.x/policy-reference.html .

> This is quite nasty. I don't think turning off enforcement in
> interrupt is good idea. ("fails open").
This is not "fails open". TOMOYO deals only operations which are allowed to
sleep (e.g. opening files, making directories). This in_interrupt() check is
for safety in case somebody who are not allowed to sleep called TOMOYO's
function by error.

> I'm not sure basing security on pids is good idea...
PID is used for reaching a domain which that PID is in, not for access control
decisions.

> Hmm, barrier is spelled otherwise, and I'm not sure I'd trust this:
> 
> +struct tomoyo_path_info_with_data {
> +       /* Keep "head" first, for this pointer is passed to tomoyo_free(). */
> +       struct tomoyo_path_info head;
> +       char bariier1[16]; /* Safeguard for overrun. */
> 
> I guess constants should be used here:
Oh, typo, thanks.
I think there is no need to use #define here, for nobody accesses
barrier1/barrier2.

> +#ifdef TOMOYO_DEBUG_DOMAIN_UNDELETE
> +                       if (domain2->is_deleted != 255)
> +                               printk(KERN_DEBUG
> +                                      "Marked %p as non undeletable\n",
> +                                      domain2);
> +#endif
> +                       domain2->is_deleted = 255;
> 
> (I don't know why we want undelete in tomoyo.)
This "undelete domain" feature was introduced to allow administrators switch
domain policy periodically.

> If it contains copyright, it should contain copyright. It probably
> should not contain version numbers.
TOMOYO's management tools want /sys/kernel/security/tomoyo/version .

> Can we get an interface that does not need as many strings/ as much
> string parsing?
A plain text interface splitted by ' ' and '\n' is cleaner than introducing
binary interface. (TOMOYO uses \040 for ' ' and \012 for '\n'. No worry for
' ' and '\n' in pathnames.)

> That's my main complaint: Documentation.*tomoyo nor
> Documentation.*TOMOYO does not exist, still this adds a *lot* of new
> user<->kernel interfaces.
> 
> New user<->kernel interaces should be documented and very carefuly
> reviewed; I don't think that happened here.
These user<->kernel interface are for TOMOYO's policy management tools,
not for general userland applications like /bin/bash /usr/sbin/sshd etc.

Regards.

----------------------------------------
TOMOYO: Fix a typo.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
---
 security/tomoyo/common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.29-git1.orig/security/tomoyo/common.h
+++ linux-2.6.29-git1/security/tomoyo/common.h
@@ -55,7 +55,7 @@ struct tomoyo_path_info {
 struct tomoyo_path_info_with_data {
 	/* Keep "head" first, for this pointer is passed to tomoyo_free(). */
 	struct tomoyo_path_info head;
-	char bariier1[16]; /* Safeguard for overrun. */
+	char barrier1[16]; /* Safeguard for overrun. */
 	char body[TOMOYO_MAX_PATHNAME_LEN];
 	char barrier2[16]; /* Safeguard for overrun. */
 };
