Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab0BSLlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 06:41:00 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:43669 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab0BSLk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:40:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JXWJJjk8C5gwO0kaKRLL7UuPbE7nH8kDo/zGQuRqftyfcqlLAhUwi5aIPVrOHFPaIQ
         ycCN8tbAmlqD4x7vAxJQIYyr8a0PUQwMZe+9koMEB0d9edF+V01GBxSYCjr/pXQ8Zm1P
         1jy2fWj2lwhCEvoIh9TdYU57jDfv76AfXkdnc=
MIME-Version: 1.0
In-Reply-To: <1266332237.5252.48.camel@moss-pluto.epoch.ncsc.mil>
References: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
	 <1266332237.5252.48.camel@moss-pluto.epoch.ncsc.mil>
Date: Fri, 19 Feb 2010 19:40:55 +0800
Message-ID: <628d1651002190340o59305986h738aec31ec5e6a84@mail.gmail.com>
Subject: Re: [PATCH] LSM: add static to security_ops variable
From: wzt wzt <wzt.wzt@gmail.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, eparis@parisplace.org,
       lsm <linux-security-module@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I rewrite the patch, thx.

---
 include/linux/security.h |    2 ++
 security/security.c      |    7 ++++++-
 security/selinux/hooks.c |   14 ++------------
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 2c627d3..3a15b57 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -95,6 +95,8 @@ struct seq_file;
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 extern int cap_netlink_recv(struct sk_buff *skb, int cap);

+extern void reset_security_ops(void);
+
 #ifdef CONFIG_MMU
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
diff --git a/security/security.c b/security/security.c
index 122b748..3e4c4bc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -26,7 +26,7 @@ static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 extern struct security_operations default_security_ops;
 extern void security_fixup_ops(struct security_operations *ops);

-struct security_operations *security_ops;      /* Initialized to NULL */
+static struct security_operations *security_ops;       /* Initialized
to NULL */

 static inline int verify(struct security_operations *ops)
 {
@@ -63,6 +63,11 @@ int __init security_init(void)
        return 0;
 }

+void reset_security_ops(void)
+{
+       security_ops = &default_security_ops;
+}
+
 /* Save user chosen LSM */
 static int __init choose_lsm(char *str)
 {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a2ee84..e9599fd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -93,6 +93,7 @@

 extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
 extern struct security_operations *security_ops;
+extern struct security_operations default_security_ops;

 /* SECMARK reference count */
 atomic_t selinux_secmark_refcount = ATOMIC_INIT(0);
@@ -125,13 +126,6 @@ __setup("selinux=", selinux_enabled_setup);
 int selinux_enabled = 1;
 #endif

-
-/*
- * Minimal support for a secondary security module,
- * just to allow the use of the capability module.
- */
-static struct security_operations *secondary_ops;
-
 /* Lists of inode and superblock security structures initialized
    before the policy was loaded. */
 static LIST_HEAD(superblock_security_head);
@@ -5672,9 +5666,6 @@ static __init int selinux_init(void)
                                            0, SLAB_PANIC, NULL);
        avc_init();

-       secondary_ops = security_ops;
-       if (!secondary_ops)
-               panic("SELinux: No initial security operations\n");
        if (register_security(&selinux_ops))
                panic("SELinux: Unable to register with kernel.\n");

@@ -5835,8 +5826,7 @@ int selinux_disable(void)
        selinux_disabled = 1;
        selinux_enabled = 0;

-       /* Reset security_ops to the secondary module, dummy or capability. */
-       security_ops = secondary_ops;
+       reset_security_ops();

        /* Try to destroy the avc node cache */
        avc_disable();
-- 
1.6.5.3


On Tue, Feb 16, 2010 at 10:57 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> On Sun, 2010-02-07 at 19:24 +0800, wzt wzt wrote:
>> security_ops was declared as a global variable, so other drivers or
>> kernel code can easily change its value, like:
>>
>> extern struct security_operations *security_ops;
>> security_ops = NULL;
>>
>> then insmod this driver immediately, it will get an oops.  Other evil
>> drivers can aslo fake this variable as extern.
>
> I'd support a patch along these lines (but with the changes below) for a
> different reason:  at present, SELinux directly manipulates security_ops
> for the purpose of runtime disable support, whereas that ought to be
> handled by the security framework.
>
>>
>> Signed-off-by: wzt <zhitong.wangzt@alibaba-inc.com>
>> ---
>>  security/security.c      |   25 ++++++++++++++++++++++++-
>>  security/selinux/hooks.c |   18 ++++++------------
>>  2 files changed, 30 insertions(+), 13 deletions(-)
>>
>> diff --git a/security/security.c b/security/security.c
>> index 24e060b..781117d 100644
>> --- a/security/security.c
>> +++ b/security/security.c
>> @@ -26,7 +26,12 @@ static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
>>  extern struct security_operations default_security_ops;
>>  extern void security_fixup_ops(struct security_operations *ops);
>>
>> -struct security_operations *security_ops;      /* Initialized to NULL */
>> +static struct security_operations *security_ops;       /* Initialized
>> to NULL */
>> +/*
>> + * Minimal support for a secondary security module,
>> + * just to allow the use of the capability module.
>> + */
>
> The comment is no longer accurate - secondary_ops was originally used by
> SELinux to call the "secondary" security module (capability or dummy),
> but that was replaced by direct calls to capability and the only
> remaining use is to save and restore the original security ops pointer
> value if SELinux is disabled by early userspace based
> on /etc/selinux/config.  Further, if we support this directly in the
> security framework, then we can just use &default_security_ops for this
> purpose since that is now available.  So I don't believe we need
> secondary_ops at all.
>
>> +static struct security_operations *secondary_ops;
>
> We don't need the above variable at all.
>
>>  static inline int verify(struct security_operations *ops)
>>  {
>> @@ -63,6 +68,24 @@ int __init security_init(void)
>>         return 0;
>>  }
>>
>> +void reset_secondary_ops(void)
>> +{
>> +       secondary_ops = security_ops;
>> +       if (!secondary_ops)
>> +               panic("SELinux: No initial security operations\n");
>> +}
>
> We don't need the above function at all.
>
>> +
>> +void reset_security_ops(void)
>> +{
>> +       /* Reset security_ops to the secondary module, dummy or capability. */
>
> The dummy module was removed so this can only be capability.
>
>> +       security_ops = secondary_ops;
>
> This can just be:
>        security_ops = &default_security_ops;
>
>> +}
>>
>>  /* Save user chosen LSM */
>>  static int __init choose_lsm(char *str)
>>  {
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index 9a2ee84..9e8607e 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -92,7 +92,9 @@
>>  #define NUM_SEL_MNT_OPTS 5
>>
>>  extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
>> -extern struct security_operations *security_ops;
>> +extern void reset_secondary_ops(void);
>> +extern void reset_security_ops(void);
>
> The extern declaration for reset_security_ops() would properly go in
> include/linux/security.h for general use by security modules.
>
>>  /* SECMARK reference count */
>>  atomic_t selinux_secmark_refcount = ATOMIC_INIT(0);
>> @@ -126,12 +128,6 @@ int selinux_enabled = 1;
>>  #endif
>>
>>
>> -/*
>> - * Minimal support for a secondary security module,
>> - * just to allow the use of the capability module.
>> - */
>> -static struct security_operations *secondary_ops;
>> -
>>  /* Lists of inode and superblock security structures initialized
>>     before the policy was loaded. */
>>  static LIST_HEAD(superblock_security_head);
>> @@ -5672,9 +5668,8 @@ static __init int selinux_init(void)
>>                                             0, SLAB_PANIC, NULL);
>>         avc_init();
>>
>> -       secondary_ops = security_ops;
>> -       if (!secondary_ops)
>> -               panic("SELinux: No initial security operations\n");
>> +       reset_secondary_ops();
>> +
>
> We don't need to save this value as it is available via
> &default_security_ops and there is now only one possible value (dummy
> module killed).
>
>>         if (register_security(&selinux_ops))
>>                 panic("SELinux: Unable to register with kernel.\n");
>>
>> @@ -5835,8 +5830,7 @@ int selinux_disable(void)
>>         selinux_disabled = 1;
>>         selinux_enabled = 0;
>>
>> -       /* Reset security_ops to the secondary module, dummy or capability. */
>> -       security_ops = secondary_ops;
>> +       reset_security_ops();
>
> So this is the only change needed here.
>
>>
>>         /* Try to destroy the avc node cache */
>>         avc_disable();
> --
> Stephen Smalley
> National Security Agency
>
>
