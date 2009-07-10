Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZGJStJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZGJStJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbZGJSsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:48:54 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:40515 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402AbZGJSsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=YrNdwu0Ai++D3CUT8IK1k2JstxYnLWzDJvNG+ckynJ52PLnD26ubkHh0xx5GecUnpi
         AByHDk0UlQlM6SFdVkedDRusD9rrswev5MWCCIgYAGc8RfpM7RhaCU2WZdSusTAXQXZ6
         vQDIV7uZVmF1yQtpv2lXwpl0fttxtNPH0luLI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 10 (cpufreq oops)
Date: Fri, 10 Jul 2009 20:54:37 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc2-next-20090708-03666-gb620e95-dirty; KDE/4.2.4; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
References: <20090710151846.c7ebec37.sfr@canb.auug.org.au>
In-Reply-To: <20090710151846.c7ebec37.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907102054.37956.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009 07:18:46 Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090709:
 
[ this particular problem goes back to next-20090709 ]

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cpufreq: fix OOPS in __cpufreq_governor()

commit 0d923c15b774bed3491400bae6db50481ac8b9e4 ("[CPUFREQ] Factor out
policy setting from cpufreq_add_dev") accidentally reordered new_policy
setup and policy->governor reset.

Fix it, also update comment to match the function name while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/cpufreq/cpufreq.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/drivers/cpufreq/cpufreq.c
===================================================================
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -896,10 +896,11 @@ int cpufreq_add_dev_interface(unsigned i
 	if (ret)
 		goto err_out_kobj_put;
 
-	policy->governor = NULL; /* to assure that the starting sequence is
-				  * run in cpufreq_set_policy */
+	memcpy(&new_policy, policy, sizeof(new_policy));
+
+	/* assure that the starting sequence is run in __cpufreq_set_policy */
+	policy->governor = NULL;
 
-	memcpy(&new_policy, policy, sizeof(struct cpufreq_policy));
 	/* set default policy */
 	ret = __cpufreq_set_policy(policy, &new_policy);
 	policy->user_policy.policy = policy->policy;
