Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbYHRBSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbYHRBSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYHRBS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:18:28 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:39640 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYHRBS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LFJgrFYSQSBZUtRZ2zHAWJcGPBNDNbmqEjNP8A2kglXTK4jsa5a53SQZVdJJag1any
         fWZTwy2Ea2enRD+H/kqtWg9F84hSDAy4KKuvvfy6QrFINP5h/RHIl7uK/KhLKy6PZs/j
         Ka4ghrBfm0u9zEh+EilOmxipzOm8LVWYl4Zec=
Message-ID: <524f69650808171818r781115c5w170cc58b91866b4c@mail.gmail.com>
Date: Sun, 17 Aug 2008 20:18:25 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Rutger Nijlunsing" <rutger.nijlunsing@gmail.com>
Subject: Re: OOPS in request_key.c bisected (and then refound)
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080817194532.GB15440@nospam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080817194532.GB15440@nospam.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copying lkml on this additional feedback on the patch to fix the oops
introduced in April by the keyctl subsystem

On Sun, Aug 17, 2008 at 2:45 PM, Rutger Nijlunsing
<rutger.nijlunsing@gmail.com> wrote:
> When trying to mount an CIFS share with SPGENO on Debian, I got
> nothing. Digging deeping revealing on OOPS at function
> call_sbin_request_key+0x166/0x255in 2.6.27 which was not there in
> 2.6.25. Bisecting this with the simplest command generating the OOPS,
> which was taken from 'man keyctl':
>
>    keyctl request2 user debug:yyyy spoon
>
> took about 4 hours on the evolutionary dead-end Pentium 4 and returned
> commit:
>
> commit 69664cf16af4f31cd54d77948a4baf9c7e0ca7b9
> Author: David Howells <dhowells@redhat.com>
> Date:   Tue Apr 29 01:01:31 2008 -0700
>
>    keys: don't generate user and user session keyrings unless they're accessed
>
> ...as the culprit.
>
> Googling for this revealed that this OOPS had been reported before in
> May, that a patch was written, tested and considered OK:
> http://lists.samba.org/archive/linux-cifs-client/2008-May/003001.html
>
> Applying this patch is still the right thing to do since it made the
> OOPS disappear. Hopefully this will solve my SPNEGO problems, but
> that's a second concern. Here is the patch again, together with
> additional Tested-bys:
>
> ---
> KEYS: Make request key instantiate the per-user keyrings
>
> Make request_key() instantiate the per-user keyrings so that it doesn't oops
> if it needs to get hold of the user session keyring because there isn't a
> session keyring in place.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Tested-by: Steve French <smfrench@gmail.com>
> Tested-by: Rutger Nijlunsing <rutger.nijlunsing@gmail.com>
> ---
>
>  security/keys/internal.h     |    1 +
>  security/keys/process_keys.c |    2 +-
>  security/keys/request_key.c  |    4 ++++
>  3 files changed, 6 insertions(+), 1 deletions(-)
>
>
> diff --git a/security/keys/internal.h b/security/keys/internal.h
> index 8c05587..2bdfacc 100644
> --- a/security/keys/internal.h
> +++ b/security/keys/internal.h
> @@ -108,6 +108,7 @@ extern key_ref_t search_process_keyrings(struct key_type *type,
>
>  extern struct key *find_keyring_by_name(const char *name, bool skip_perm_check);
>
> +extern int install_user_keyrings(struct task_struct *tsk);
>  extern int install_thread_keyring(struct task_struct *tsk);
>  extern int install_process_keyring(struct task_struct *tsk);
>
> diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> index 5be6d01..45b240a 100644
> --- a/security/keys/process_keys.c
> +++ b/security/keys/process_keys.c
> @@ -40,7 +40,7 @@ struct key_user root_key_user = {
>  /*
>  * install user and user session keyrings for a particular UID
>  */
> -static int install_user_keyrings(struct task_struct *tsk)
> +int install_user_keyrings(struct task_struct *tsk)
>  {
>        struct user_struct *user = tsk->user;
>        struct key *uid_keyring, *session_keyring;
> diff --git a/security/keys/request_key.c b/security/keys/request_key.c
> index ba32ca6..abea08f 100644
> --- a/security/keys/request_key.c
> +++ b/security/keys/request_key.c
> @@ -74,6 +74,10 @@ static int call_sbin_request_key(struct key_construction *cons,
>
>        kenter("{%d},{%d},%s", key->serial, authkey->serial, op);
>
> +       ret = install_user_keyrings(tsk);
> +       if (ret < 0)
> +               goto error_alloc;
> +
>        /* allocate a new session keyring */
>        sprintf(desc, "_req.%u", key->serial);
>
>
>
> --
> Rutger Nijlunsing ---------------------------------- eludias ed dse.nl
> never attribute to a conspiracy which can be explained by incompetence
> ----------------------------------------------------------------------
>



-- 
Thanks,

Steve
