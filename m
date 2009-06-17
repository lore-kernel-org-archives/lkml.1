Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbZFQKjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbZFQKjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZFQKjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:39:37 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:65084 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616AbZFQKjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CIcwkSkbzy5QkcFjDnEt8PY0OTGQGpxW3iRfX3TPgv8KBNbGvNo2MBbwubi00byXBd
         xjhlYeobsL5QBKXUW8q+Mi1iNEVNGkzuXf3z51VHX4G1KLWf5MO1CM+HSZhGrHmkG4el
         Goa5kLU+h8gfA63e+LDKfzsTN7VcnsXtzCLUQ=
Date: Wed, 17 Jun 2009 18:41:48 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: poornima nayak <mpnayak@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] timer_migration interface accepts any number as input in
	2.6.30-git9
Message-ID: <20090617104148.GC6167@cr0.nay.redhat.com>
References: <1245229936.3345.67.camel@localhost.localdomain> <20090617102126.GA28647@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617102126.GA28647@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 03:51:26PM +0530, Arun R Bharadwaj wrote:
>* poornima nayak <mpnayak@linux.vnet.ibm.com> [2009-06-17 14:42:16]:
>
>> Hi
>> 
>> Timer migration interface /proc/sys/kernel/timer_migration in
>> 2.6.30-git9 accepts any numerical value as input.
>> Steps to reproduce 
>> 1. echo -6666666 > /proc/sys/kernel/timer_migration
>> 2. cat /proc/sys/kernel/timer_migration
>> -6666666
>> 
>> 1. echo 44444444444444444444444444444444444444444444444444444444444 > /proc/sys/kernel/timer_migration
>> 2. cat /proc/sys/kernel/timer_migration
>> -1357789412
>> 
>> Expected behavior: Should 'echo: write error: Invalid argument' while
>> setting any value other then 0 & 1
>> 
>> Regards
>> Poornima
>> 
>
>Hi Poornima,
>
>Thanks for reporting the bug.
>Hope this patch removes the bug.
>The patch is based against the latest -tip/master.
>
>--arun
>
>
>Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


My fix goes further, the further part of it is shown below. :)
Mind to have a look?

Not tested yet.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

-----
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ab462b9..bc27e00 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2331,7 +2331,8 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 			if (*p < '0' || *p > '9')
 				break;
 
-			lval = simple_strtoul(p, &p, 0);
+			if (strict_strtoul(p, 0, &lval))
+				return -EINVAL;
 
 			len = p-buf;
 			if ((len < left) && *p && !isspace(*p))
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 756ccaf..ff2ca5c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -163,11 +163,14 @@ int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)
 	char *tail;
 	unsigned long val;
 	size_t len;
+	char tmp[32];
 
 	*res = 0;
 	len = strlen(cp);
 	if (len == 0)
 		return -EINVAL;
+	if (len > snprintf(tmp, "%ld", ULONG_MAX))
+		return -EINVAL;
 
 	val = simple_strtoul(cp, &tail, base);
 	if (tail == cp)
