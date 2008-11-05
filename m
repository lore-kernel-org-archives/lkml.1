Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYKESSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYKESSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYKESRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:17:44 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41117 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbYKESRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:17:43 -0500
Subject: Re: [PATCH 3/5] eCryptfs: Filename Encryption: Encoding and
	encryption functions
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <dustin.kirkland@gmail.com>,
       Eric Sandeen <sandeen@redhat.com>, Tyler Hicks <tchicks@us.ibm.com>,
       David Kleikamp <shaggy@us.ibm.com>
In-Reply-To: <20081104214120.GC6677@halcrowt61p.austin.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com>
	 <20081104214120.GC6677@halcrowt61p.austin.ibm.com>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:17:36 -0800
Message-Id: <1225909056.12673.632.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 15:41 -0600, Michael Halcrow wrote:
> +static int ecryptfs_copy_filename(char **copied_name, size_t *copied_name_size,
> +                                 const char *name, size_t name_size)
> +{
> +       int rc = 0;
> +
> +       (*copied_name) = kmalloc((name_size + 2), GFP_KERNEL);
> +       if (!(*copied_name)) {
> +               rc = -ENOMEM;
> +               goto out;
> +       }
> +       memcpy((void *)(*copied_name), (void *)name, name_size);
> +       (*copied_name)[(name_size)] = '\0';     /* Only for convenience
> +                                                * in printing out the
> +                                                * string in debug
> +                                                * messages */
> +       (*copied_name_size) = (name_size + 1);
> +out:
> +       return rc;
> +}

Might this be a good place to use ERR_PTR()?  The pointer arithmetic
here looks a bit goofy.  Is this all just to get 'copied_name_size'
returned?  Why does it even matter if it is only there for printk'ing?

But, as I look at it, you do this all over the patch(es) and I think it
really reduces the readability everywhere.

If you truly need to track the actual allocated name size, I'd suggest
just having a:

struct e...c_filename {
	char *name;
	char *len;
};

Stack allocate that sucker just like you stack allocate
'copied_name_size', and then pass *it* around.

	filename->name = foo;
	filename->bar = 1234;

is way more readable than:

+                       (*encoded_name) = NULL;
+                       (*encoded_name_size) = 0;

and

+                       (*encoded_name)[(*encoded_name_size)] = '\0';
+                       (*encoded_name_size)++;

I'm certainly guilty of overly-verbose names for things, but I think:

	ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE

may be a few characters too long.  :)

This construct:

+               decoded_name = kmalloc(decoded_name_size, GFP_KERNEL);
+               if (!decoded_name) {
+                       printk(KERN_ERR "%s: Out of memory whilst attempting "
+                              "to kmalloc [%Zd] bytes\n", __func__,
+                              decoded_name_size);
+                       rc = -ENOMEM;
+                       goto out;
+               }

also appears all over.  Personally, I think this is way too verbose, but
I can also see how it would be useful.  But, the crappy part is that
there is nothing unique in each of this printk()s to help the dmesg
reader to figure out what is going on.

I think you'd save yourself a lot of code if you had an
ecryptfs_kmalloc(), did the NULL check and printk() in there, and also
added a stack dump.

>         rc = write_tag_66_packet(auth_tok->token.private_key.signature,
> -                                ecryptfs_code_for_cipher_string(crypt_stat),
> +                                ecryptfs_code_for_cipher_string(
> +                                        crypt_stat->cipher,
> +                                        crypt_stat->key_size),
>                                  crypt_stat, &payload, &payload_len);
>         if (rc) {

Why not just have ecryptfs_code_for_cipher_string() do the ->cipher and
->key_size lookup?  

-- Dave

