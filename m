Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYKFVBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYKFVBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYKFVBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:01:38 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55865 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbYKFVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:01:37 -0500
Date: Thu, 6 Nov 2008 15:01:12 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <dustin.kirkland@gmail.com>,
       Eric Sandeen <sandeen@redhat.com>, Tyler Hicks <tchicks@us.ibm.com>,
       David Kleikamp <shaggy@us.ibm.com>
Subject: Re: [PATCH 3/5] eCryptfs: Filename Encryption: Encoding and
	encryption functions
Message-ID: <20081106210112.GD6688@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com> <20081104214120.GC6677@halcrowt61p.austin.ibm.com> <1225909056.12673.632.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225909056.12673.632.camel@nimitz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 10:17:36AM -0800, Dave Hansen wrote:
> If you truly need to track the actual allocated name size, I'd
> suggest just having a:
> 
> struct e...c_filename {
> 	char *name;
> 	char *len;
> };
> 
> Stack allocate that sucker just like you stack allocate
> 'copied_name_size', and then pass *it* around.
> 
> 	filename->name = foo;
> 	filename->bar = 1234;
> 
> is way more readable than:
> 
> +                       (*encoded_name) = NULL;
> +                       (*encoded_name_size) = 0;
> 
> and
> 
> +                       (*encoded_name)[(*encoded_name_size)] = '\0';
> +                       (*encoded_name_size)++;

Agreed; something akin to qstr would do well for this sort of thing
throughout eCryptfs. In addition to making it more readable, it would
also help a bit with stack usage in some places.

> I'm certainly guilty of overly-verbose names for things, but I
> think:
> 
> 	ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE
> 
> may be a few characters too long.  :)

I generally try to strike a balance between verbosity and readability
with my symbol names. I frequently find myself torn between something
like:

ECRYPTFS_FILENAME_ENCRYPTION_KEY_ENCRYPTED_FILENAME_PREFIX_SIZE

And something like:

FNEKEFNPFXSZ

> This construct:
> 
> +               decoded_name = kmalloc(decoded_name_size, GFP_KERNEL);
> +               if (!decoded_name) {
> +                       printk(KERN_ERR "%s: Out of memory whilst attempting "
> +                              "to kmalloc [%Zd] bytes\n", __func__,
> +                              decoded_name_size);
> +                       rc = -ENOMEM;
> +                       goto out;
> +               }
> 
> also appears all over.  Personally, I think this is way too verbose,
> but I can also see how it would be useful.  But, the crappy part is
> that there is nothing unique in each of this printk()s to help the
> dmesg reader to figure out what is going on.

There are so many colorful ways for eCryptfs to blow up that I have
found it very useful to have printk's all over the place along error
paths. On the other hand, I have yet to ever receive a bug report
indicating that a kmalloc failed, so all of these particular warnings
may be more trouble than they are worth.

> I think you'd save yourself a lot of code if you had an
> ecryptfs_kmalloc(), did the NULL check and printk() in there, and
> also added a stack dump.

I still need to set the rc value appropriate for the context and then
jump to the appropriate exit label for the location in the function at
which the kmalloc occurs. Wrapping kmalloc() can only really serve, in
general, to provide the printk and stack dump. In that case, why not
just implement a kernel-wide symbol for this (e.g.,
kmalloc_verbose())?

> >         rc = write_tag_66_packet(auth_tok->token.private_key.signature,
> > -                                ecryptfs_code_for_cipher_string(crypt_stat),
> > +                                ecryptfs_code_for_cipher_string(
> > +                                        crypt_stat->cipher,
> > +                                        crypt_stat->key_size),
> >                                  crypt_stat, &payload, &payload_len);
> >         if (rc) {
> 
> Why not just have ecryptfs_code_for_cipher_string() do the ->cipher
> and ->key_size lookup?

I changed this function in this patchset specifically to support
cipher strings and key sizes from either ecryptfs_crypt_stat or
ecryptfs_mount_crypt_stat structs.
