Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab0BWB7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:59:11 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51577 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0BWB7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:59:08 -0500
Message-Id: <201002230159.o1N1x07J088559@www262.sakura.ne.jp>
Subject: Re: [AppArmor #4 0/12] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: john.johansen@canonical.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Feb 2010 10:59:00 +0900
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
In-Reply-To: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 23022010 #3405462, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting from apparmorfs.c and jumping randomly...





346 static bool unpack_trans_table(struct aa_ext *e, struct aa_profile *profile)(...snipped...)
369                         /*
370                          * verify: transition names string
371                          */
372                         for (c = j = 0; j < size - 1; j++) {
373                                 if (!str[j])
374                                         c++;
375                         }
376                         /* names beginning with : require an embedded \0 */
377                         if (*str == ':' && c != 1)
378                                 goto fail;
379                         /* fail - all other cases with embedded \0 */
380                         else if (c)
381                                 goto fail;
382                         profile->file.trans.table[i] = str;
You need to "profile->file.trans.table[i] = str;" before "goto fail;"
in order to let "aa_free_domain_entries()" to kzfree().





333 static struct aa_namespace *aa_prepare_namespace(const char *name)
334 {
335         struct aa_namespace *ns, *root;
336 
337         root = aa_current_profile()->ns;
aa_current_profile() returns NULL if current_cred()->security->profile == NULL.

338 
339         write_lock(&root->lock);
340         if (name)
341                 /* released by caller */
342                 ns = aa_get_namespace(__aa_find_namespace(&root->sub_ns, name));
343         else
344                 /* released by caller */
345                 ns = aa_get_namespace(root);
The "if (!ns) { ... } " block is for only name != NULL case because
aa_alloc_namespace(NULL) returns NULL. Thus, you might want to do like

	else {
		/* released by caller */
		ns = aa_get_namespace(root);
		goto out_unlock;
	}

369         }
 out_unlock:
370         write_unlock(&root->lock);
371 
372         /* return ref */
373         return ns;





889 ssize_t aa_interface_replace_profiles(void *udata, size_t size, bool add_only)
(...snipped...)
946                 /* must be cleared as it is shared with replaced-by */
947                 kzfree(new_profile->rename);
948                 new_profile->rename = NULL;
Is it OK to clear now because replacement may not be taken place due to
aa_audit_iface() returning -ENOMEM?





108 static const char *hname_tail(const char *hname)
109 {
110         char *split;
111         /* check for namespace which begins with a : and ends with : or \0 */
112         hname = strstrip((char *)hname);
Oops. strstrip() has gone in 2.6.33 .





 28 static void *kvmalloc(size_t size)
 29 {
I think you should return NULL for size == 0.
kmalloc(0, GFP_KERNEL) returns ZERO_SIZE_PTR, which results in
copy_from_user(ZERO_SIZE_PTR, userbuf, (size_t) -1)
at aa_simple_write_to_buffer() if aa_profile_remove() got ((size_t) -1)
for "size" parameter. This will cause problem if access_ok() check inside
copy_from_user() is "return 1;".
 30         void *buffer = kmalloc(size, GFP_KERNEL);
 31         if (!buffer)
 32                 buffer = vmalloc(size);
 33         return buffer;
 34 }





1003 ssize_t aa_interface_remove_profiles(char *fqname, size_t size)
(...snipped...)
1027         /* ref count held by cred */
1028         root = aa_current_profile()->ns;
aa_current_profile() may return NULL.





278 static void *p_start(struct seq_file *f, loff_t *pos)
279         __acquires(root->lock)
280 {
281         struct aa_profile *profile = NULL;
282         struct aa_namespace *root = aa_current_profile()->ns;
aa_current_profile() may return NULL.
