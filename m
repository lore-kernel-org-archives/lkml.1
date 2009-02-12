Return-Path: <linux-kernel-owner+w=401wt.eu-S1759680AbZBLRyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680AbZBLRyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZBLRym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:54:42 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:61854 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZBLRyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:54:41 -0500
Date: Thu, 12 Feb 2009 09:54:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mimi Zohar <zohar@us.ibm.com>, akpm <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, James Morris <jmorris@namei.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH -next] security/audit/ima: fix build error
Message-Id: <20090212095414.733dd248.randy.dunlap@oracle.com>
In-Reply-To: <OFF3345B15.9471295A-ON8525755A.00024CFE-8525755A.0002C8E8@us.ibm.com>
References: <20090210194121.80256b72.sfr@canb.auug.org.au>
	<4991DBA0.1000008@oracle.com>
	<20090211094050.47c4828d.sfr@canb.auug.org.au>
	<OFF3345B15.9471295A-ON8525755A.00024CFE-8525755A.0002C8E8@us.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4994622C.02D1:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 19:30:24 -0500 Mimi Zohar wrote:

> Stephen Rothwell <sfr@canb.auug.org.au> wrote on 02/10/2009 05:40:50 PM:
> 
> > Hi Randy,
> > 
> > On Tue, 10 Feb 2009 11:55:12 -0800 Randy Dunlap 
> <randy.dunlap@oracle.com> wrote:
> > >
> > > Stephen Rothwell wrote:
> > > > 
> > > > Dropped trees (temporarily):
> > > >    audit (difficult conflicts)
> > > 
> > > Maybe this is fixed by the dropped audit tree?
> > 
> > The audit tree is Al Viro's (cc'd).  But I *think* everything in it has
> > been applied upstream.
> > 
> > > linux-next-20090210/security/integrity/ima/ima_policy.c:111: error: 
> implicit
> > declaration of function 'security_audit_rule_match'
> > > linux-next-20090210/security/integrity/ima/ima_policy.c:230: error: 
> implicit
> > declaration of function 'security_audit_rule_init'
> > > 
> > > when
> > > CONFIG_SECURITY=y
> > > CONFIG_AUDIT=n
> > > CONFIG_IMA=y
> > > CONFIG_IMA_AUDIT=y
> > 
> > This looks more like a security subsystem than audit to me?
> 
> These are the IMA Kconfig rules:
> CONFIG_IMA=y
> CONFIG_IMA_MEASURE_PCR_IDX=10
> CONFIG_IMA_AUDIT=y
> CONFIG_IMA_LSM_RULES=y
> 
> CONFIG_IMA_LSM_RULES requires the audit subsystem.  The default
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> measurement policy is not defined terms of the LSM extended
> attributes, and thus is not required.


This config still fails to build in linux-next-20090212.  And the ^^^
statement above may be correct, but it's not enforced in Kconfig, so let's
do that, OK?



From: Randy Dunlap <randy.dunlap@oracle.com>

IMA_LSM_RULES requires AUDIT.  This is automatic if SECURITY_SELINUX=y
but not when SECURITY_SMACK=y (and SECURITY_SELINUX=n), so make the
dependency explicit.  This fixes the following build error:

security/integrity/ima/ima_policy.c:111:error: implicit declaration of function 'security_audit_rule_match'
security/integrity/ima/ima_policy.c:230:error: implicit declaration of function 'security_audit_rule_init'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 security/integrity/ima/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20090212.orig/security/integrity/ima/Kconfig
+++ linux-next-20090212/security/integrity/ima/Kconfig
@@ -49,7 +49,7 @@ config IMA_AUDIT
 
 config IMA_LSM_RULES
 	bool
-	depends on IMA && (SECURITY_SELINUX || SECURITY_SMACK)
+	depends on IMA && AUDIT && (SECURITY_SELINUX || SECURITY_SMACK)
 	default y
 	help
-	  Disabling this option will disregard LSM based policy rules
+	  Disabling this option will disregard LSM based policy rules.
