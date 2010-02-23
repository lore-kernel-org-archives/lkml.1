Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0BWD5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 22:57:07 -0500
Received: from ozlabs.org ([203.10.76.45]:43579 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab0BWD5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 22:57:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dongdong Deng <dongdong.deng@windriver.com>
Subject: Re: [RESEND PATCH] module param_call: fix potential NULL pointer dereference
Date: Tue, 23 Feb 2010 14:26:45 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-15?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1266835251-15457-1-git-send-email-dongdong.deng@windriver.com>
In-Reply-To: <1266835251-15457-1-git-send-email-dongdong.deng@windriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002231426.45886.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010 09:10:51 pm Dongdong Deng wrote:
> The param_set_fn() function will get a parameter which is a NULL
> pointer when insmod module via bare params as following method:
> 
> $insmod foo.ko foo
> 
> If the param_set_fn() function didn't check that parameter and used
> it directly, it could caused an OOPS due to NULL pointer dereference.
> 
> The solution is simple:
> Using "" to replace NULL parameter, thereby the param_set_fn()
> function will never get a NULL pointer.

This changes the value of booleans, and loses checking for int params, etc.

I liked Americo's approach; I've combined the two approaches below.

Since I'm going away, can Andrew take this?

Subject: params: don't hand NULL values to param.set callbacks.

An audit by Dongdong Deng revealed that most driver-author-written param
calls don't handle val == NULL (which happens when parameters are specified
with no =, eg "foo" instead of "foo=1").

The only real case to use this is boolean, so handle it specially for that
case and remove a source of bugs for everyone else as suggested by Americo.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dongdong Deng <dongdong.deng@windriver.com>
Cc: Américo Wang <xiyou.wangcong@gmail.com>

diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -59,6 +59,9 @@ static int parse_one(char *param,
 	/* Find parameter */
 	for (i = 0; i < num_params; i++) {
 		if (parameq(param, params[i].name)) {
+			/* Noone handled NULL, so do it here. */
+			if (!val && params[i].set != param_set_bool)
+				return -EINVAL;
 			DEBUGP("They are equal!  Calling %p\n",
 			       params[i].set);
 			return params[i].set(val, &params[i]);
@@ -182,7 +185,6 @@ int parse_args(const char *name,
 		tmptype l;						\
 		int ret;						\
 									\
-		if (!val) return -EINVAL;				\
 		ret = strtolfn(val, 0, &l);				\
 		if (ret == -EINVAL || ((type)l != l))			\
 			return -EINVAL;					\
@@ -204,12 +206,6 @@ STANDARD_PARAM_DEF(ulong, unsigned long,
 
 int param_set_charp(const char *val, struct kernel_param *kp)
 {
-	if (!val) {
-		printk(KERN_ERR "%s: string parameter expected\n",
-		       kp->name);
-		return -EINVAL;
-	}
-
 	if (strlen(val) > 1024) {
 		printk(KERN_ERR "%s: string parameter too long\n",
 		       kp->name);
@@ -310,12 +306,6 @@ static int param_array(const char *name,
 	kp.arg = elem;
 	kp.flags = flags;
 
-	/* No equals sign? */
-	if (!val) {
-		printk(KERN_ERR "%s: expects arguments\n", name);
-		return -EINVAL;
-	}
-
 	*num = 0;
 	/* We expect a comma-separated list of values. */
 	do {
@@ -382,10 +372,6 @@ int param_set_copystring(const char *val
 {
 	const struct kparam_string *kps = kp->str;
 
-	if (!val) {
-		printk(KERN_ERR "%s: missing param set value\n", kp->name);
-		return -EINVAL;
-	}
 	if (strlen(val)+1 > kps->maxlen) {
 		printk(KERN_ERR "%s: string doesn't fit in %u chars.\n",
 		       kp->name, kps->maxlen-1);

-- 
Away travelling 25Feb-26Mar (6 .de + 1 .pl + 17 .lt + 2 .sg)
