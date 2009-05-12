Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZELVSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZELVSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZELVSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:18:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56384 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZELVSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:18:32 -0400
Subject: Re: [PATCH] IMA: do not measure everything opened by root by
 default
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       Dave Safford <safford@watson.ibm.com>
In-Reply-To: <20090512191423.6903.37464.stgit@dhcp231-142.rdu.redhat.com>
References: <20090512191423.6903.37464.stgit@dhcp231-142.rdu.redhat.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 17:18:31 -0400
Message-Id: <1242163111.8494.23.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 15:14 -0400, Eric Paris wrote:
> The IMA default policy measures every single file opened by root.  This is
> terrible for most users.  Consider a system (like mine) with virtual machine
> images.  When those images are touched (which happens at boot for me) those
> images are measured.  This is just way too much for the default case.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

The question of what to measure is a major issue. If you measure too
much, performance is affected, but if you measure too little, then the
measurement list will not contain everything that could affect the
Trusted Computing Base(TCB), such as configuration files and scripts.

The solution is not to remove the rule that measures everything read
by root, but to replace the default IMA configuration file with an LSM
specific one, which should be done early in the etc init scripts or
initrd.  LTP contains a sample script to replace the default IMA policy
(testcases/kernel/security/integrity/ima/tests/ima_policy.sh).

The following SELinux integrity rule, prevents /var/log/messages from
being measured. (Dependent on "integrity: lsm audit rule matching fix"
patch in the security-testing tree.)

dont_measure func=PATH_CHECK mask=MAY_READ obj_type=var_log_t

By defining an equivalent SELinux integrity rule for each virtual
machine image type, the virtual machine images will not be measured.
This is far better than not measuring everything in the TCB.

Mimi Zohar

> ---
> 
>  security/integrity/ima/ima_policy.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index b168c1d..dec6dcb 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -61,8 +61,6 @@ static struct ima_measure_rule_entry default_rules[] = {
>  	 .flags = IMA_FUNC | IMA_MASK},
>  	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
>  	 .flags = IMA_FUNC | IMA_MASK},
> -	{.action = MEASURE,.func = PATH_CHECK,.mask = MAY_READ,.uid = 0,
> -	 .flags = IMA_FUNC | IMA_MASK | IMA_UID}
>  };
> 
>  static LIST_HEAD(measure_default_rules);
> 

