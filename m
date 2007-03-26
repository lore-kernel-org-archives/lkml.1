Return-Path: <linux-kernel-owner+w=401wt.eu-S933509AbXCZDk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbXCZDk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 23:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXCZDk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 23:40:28 -0400
Received: from [64.62.148.172] ([64.62.148.172]:4926 "EHLO arnor.apana.org.au"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933509AbXCZDk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 23:40:27 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: zohar@linux.vnet.ibm.com (Mimi Zohar)
Subject: Re: [RFC][Patch 3/6] integrity: EVM as an integrity service provider
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Organization: Core
In-Reply-To: <1173369828.5981.3.camel@localhost.localdomain>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HVg4A-0002vq-00@gondolin.me.apana.org.au>
Date: Mon, 26 Mar 2007 13:40:18 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> +int update_file_hash(struct dentry *dentry, struct file *f,
> +                    struct hash_desc *desc)
> +{

...

> +       while (offset < i_size) {
> +               rbuf_len = kernel_read(file, offset, rbuf, PAGE_SIZE);
> +               if (rbuf_len <= 0)
> +                       break;
> +               offset += rbuf_len;
> +               sg[0].page = virt_to_page(rbuf);
> +               sg[0].offset = ((long)rbuf & ~PAGE_MASK);
> +               sg[0].length = rbuf_len;
> +
> +               crypto_hash_update(desc, sg, rbuf_len);

You should check for errors here and on all calls to crypto_hash_*
that return errors.

> +int evm_calc_hash(struct dentry *dentry, struct file *file, char *digest,
> +                 int xattr_type)
> +{
> +       struct crypto_hash *tfm;
> +       struct hash_desc desc;
> +       int error = 0;
> +
> +       if (!dentry && !file)
> +               return -ENOENT;
> +
> +       tfm = crypto_alloc_hash(evm_hash, 0, CRYPTO_ALG_ASYNC);
> +       if (!tfm) {

That should be !IS_ERR(tfm).

> +static int __init init_evm(void)
> +{
> +       int error;
> +
> +       if (strncmp(evm_hash, "sha1", 4) == 0) {
> +               evm_hash_type = EVM_TYPE_SHA1;
> +               hash_digest_size = SHA1_DIGEST_SIZE;
> +               hash_str_size = SHA1_STR_SIZE;

This looks suspect.  Can you guarantee that only md5/sha1 are used?
If not you should be getting these from the tfm.  If yes then you
shouldn't allow arbitrary strings to be used.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
