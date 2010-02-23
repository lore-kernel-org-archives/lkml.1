Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab0BWIiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:38:52 -0500
Received: from adelie.canonical.com ([91.189.90.139]:45478 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab0BWIiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:38:50 -0500
Message-ID: <4B839414.90201@canonical.com>
Date: Tue, 23 Feb 2010 00:38:44 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: john.johansen@canonical.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [AppArmor #4 0/12] AppArmor security module
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com> <201002230159.o1N1x07J088559@www262.sakura.ne.jp>
In-Reply-To: <201002230159.o1N1x07J088559@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Starting from apparmorfs.c and jumping randomly...
> 
>
> 
> 
> 
> 346 static bool unpack_trans_table(struct aa_ext *e, struct aa_profile *profile)(...snipped...)
> 369                         /*
> 370                          * verify: transition names string
> 371                          */
> 372                         for (c = j = 0; j < size - 1; j++) {
> 373                                 if (!str[j])
> 374                                         c++;
> 375                         }
> 376                         /* names beginning with : require an embedded \0 */
> 377                         if (*str == ':' && c != 1)
> 378                                 goto fail;
> 379                         /* fail - all other cases with embedded \0 */
> 380                         else if (c)
> 381                                 goto fail;
> 382                         profile->file.trans.table[i] = str;
> You need to "profile->file.trans.table[i] = str;" before "goto fail;"
> in order to let "aa_free_domain_entries()" to kzfree().
> 
> 
sigh, yep.  You know the depressing thing is I patched that once and seem
to have dropped the fix when I fiddled with the code, again.  :(

> 
> 
> 
> 333 static struct aa_namespace *aa_prepare_namespace(const char *name)
> 334 {
> 335         struct aa_namespace *ns, *root;
> 336 
> 337         root = aa_current_profile()->ns;
> aa_current_profile() returns NULL if current_cred()->security->profile == NULL.
> 
that should never happen anymore, see last comment

> 338 
> 339         write_lock(&root->lock);
> 340         if (name)
> 341                 /* released by caller */
> 342                 ns = aa_get_namespace(__aa_find_namespace(&root->sub_ns, name));
> 343         else
> 344                 /* released by caller */
> 345                 ns = aa_get_namespace(root);
> The "if (!ns) { ... } " block is for only name != NULL case because
> aa_alloc_namespace(NULL) returns NULL. Thus, you might want to do like
> 
err, no.  It is only for if the name is specified and the profile couldn't be
found in 
342          ns = aa_get_namespace(__aa_find_namespace(&root->sub_ns, name));

The other case of ns = aa_get_namespace(root); is guaranteed to succeed.
I should move the whole if (!ns) block under if (name)

> 	else {
> 		/* released by caller */
> 		ns = aa_get_namespace(root);
> 		goto out_unlock;
> 	}
> 
> 369         }
>  out_unlock:
> 370         write_unlock(&root->lock);
> 371 
> 372         /* return ref */
> 373         return ns;
> 
> 
> 
> 
> 
> 889 ssize_t aa_interface_replace_profiles(void *udata, size_t size, bool add_only)
> (...snipped...)
> 946                 /* must be cleared as it is shared with replaced-by */
> 947                 kzfree(new_profile->rename);
> 948                 new_profile->rename = NULL;
> Is it OK to clear now because replacement may not be taken place due to
> aa_audit_iface() returning -ENOMEM?
> 
yes.  The rename field is only used at this one point and the rename profile,
if found is used.  However if the rename fails the name of what was to be renamed isn't currently audited and it really should be.

So this should be moved and used as part of auditing.

> 
> 
> 
> 
> 108 static const char *hname_tail(const char *hname)
> 109 {
> 110         char *split;
> 111         /* check for namespace which begins with a : and ends with : or \0 */
> 112         hname = strstrip((char *)hname);
> Oops. strstrip() has gone in 2.6.33 .
> 
Hrmm, I had missed that.  It exists after a fashion as front for strim but
I missed that on my .33 build

> 
> 
> 
> 
>  28 static void *kvmalloc(size_t size)
>  29 {
> I think you should return NULL for size == 0.
> kmalloc(0, GFP_KERNEL) returns ZERO_SIZE_PTR, which results in
> copy_from_user(ZERO_SIZE_PTR, userbuf, (size_t) -1)
> at aa_simple_write_to_buffer() if aa_profile_remove() got ((size_t) -1)
> for "size" parameter. This will cause problem if access_ok() check inside
> copy_from_user() is "return 1;".
>  30         void *buffer = kmalloc(size, GFP_KERNEL);
>  31         if (!buffer)
>  32                 buffer = vmalloc(size);
>  33         return buffer;
>  34 }
> 
agreed, will do

> 
> 
> 
> 1003 ssize_t aa_interface_remove_profiles(char *fqname, size_t size)
> (...snipped...)
> 1027         /* ref count held by cred */
> 1028         root = aa_current_profile()->ns;
> aa_current_profile() may return NULL.
> 
see below

> 
> 278 static void *p_start(struct seq_file *f, loff_t *pos)
> 279         __acquires(root->lock)
> 280 {
> 281         struct aa_profile *profile = NULL;
> 282         struct aa_namespace *root = aa_current_profile()->ns;
> aa_current_profile() may return NULL.

No, it shouldn't anymore.  That is one of the cleanups this round,
I got rid of the use of NULL to represent the unconfined profile.
Previously you would get a mix of "unfilter profiles" where the
unconfined profile was used and post filtered where NULL was used
to represent unconfined.  This was because NULL used to be used
to represent unconfined everywhere but with profile namespaces
we need to carry which unconfined profile it is.  Getting rid of
the mixed use allowed for several cleanups and made the code
easier to read too.

However I do notice that I missed cleaning up the comment for
aa_current_profile.  I will make another pass at all the comments
and see if I missed anything else.

I will also up the policy/context comments to note that the
context should not ever have a NULL value for profile.  It should
either be pointing to a confining profile or to the unconfined
profile for the namespace.

As always, thanks for the review Tetsuo

john

