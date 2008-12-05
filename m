Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbYLEI0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbYLEI0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYLEIZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:25:21 -0500
Received: from ozlabs.org ([203.10.76.45]:57211 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYLEIZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:25:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/3] param: Adapt MN10300 to the new parameter handling regime
Date: Fri, 5 Dec 2008 18:55:06 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20081203163207.13965.56517.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081203163207.13965.56517.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812051855.07203.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008 03:02:07 David Howells wrote:
> Make MN10300 use the new core parameter code.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Hi David,

   Maybe we should add a new param type to the general code so this can be
done with core_param.  See below. Not sure if it's a win tho (many archs want
mem=num@pos, x86 wants mem=nopentium, etc).

I've applied this and 3/3 meanwhile.

Thanks!
Rusty.

param: add "mem" type for module_param/core_param

core_param is now called early enough to be useful for arch's mem=
parameter.  Some archs want fancier parsing, but this allows:

	static unsigned long mem_override;
	core_param(mem, mem_override, mem, 0444);

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -94,7 +94,7 @@ struct kparam_array
 	__module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)
 
 /* Helper functions: type is byte, short, ushort, int, uint, long,
-   ulong, charp, bool or invbool, or XXX if you define param_get_XXX,
+   ulong, charp, bool or invbool, mem or XXX if you define param_get_XXX,
    param_set_XXX and param_check_XXX. */
 #define module_param_named(name, value, type, perm)			   \
 	param_check_##type(name, &(value));				   \
@@ -184,6 +184,10 @@ extern int param_get_invbool(char *buffe
 extern int param_get_invbool(char *buffer, struct kernel_param *kp);
 #define param_check_invbool(name, p) __param_check(name, p, int)
 
+extern int param_set_mem(const char *val, struct kernel_param *kp);
+extern int param_get_mem(char *buffer, struct kernel_param *kp);
+#define param_check_mem(name, p) __param_check(name, p, unsigned long)
+
 /* Comma-separated array: *nump is set to number they actually specified. */
 #define module_param_array_named(name, array, type, nump, perm)		\
 	static const struct kparam_array __param_arr_##name		\
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -264,6 +264,44 @@ int param_get_invbool(char *buffer, stru
 int param_get_invbool(char *buffer, struct kernel_param *kp)
 {
 	return sprintf(buffer, "%c", (*(int *)kp->arg) ? 'N' : 'Y');
+}
+
+int param_set_mem(const char *val, struct kernel_param *kp)
+{
+	unsigned long long mem;
+	char *endp;
+
+	if (!val || !*val)
+		return -EINVAL;
+
+	mem = memparse(val, &endp);
+	if (*endp)
+		return -EINVAL;
+
+	if ((unsigned long)mem != mem)
+		return -E2BIG;
+	*(unsigned long *)kp->arg = mem;
+	return 0;
+}
+
+int param_get_mem(char *buffer, struct kernel_param *kp)
+{
+	unsigned long mem = *(unsigned long *)kp->arg;
+	const char *suffix = "";
+
+	if (mem > 0) {
+		if (mem % (1024*1024*1024) == 0) {
+			suffix = "G";
+			mem /= 1024*1024*1024;
+		} else if (mem % (1024*1024) == 0) {
+			suffix = "M";
+			mem /= 1024*1024;
+		} else if (mem % 1024 == 0) {
+			suffix = "K";
+			mem /= 1024;
+		}
+	}		
+	return sprintf(buffer, "%lu%s", mem, suffix);
 }
 
 /* We break the rule and mangle the string. */
