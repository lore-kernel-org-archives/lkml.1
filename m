Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbYEVSlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbYEVSlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYEVSke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:40:34 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48422 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbYEVSkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:40:33 -0400
Subject: Re: [RFC][Patch 4/4]integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
In-Reply-To: <Xine.LNX.4.64.0805221212110.32056@us.intercode.com.au>
References: <1211385314.20922.28.camel@localhost.localdomain>
	 <Xine.LNX.4.64.0805221212110.32056@us.intercode.com.au>
Content-Type: text/plain
Date: Thu, 22 May 2008 14:39:43 -0400
Message-Id: <1211481583.4867.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for reviewing the code.  Will fix these and add
locking around integrity_templates.

Mimi

On Thu, 2008-05-22 at 12:39 +1000, James Morris wrote:
> On Wed, 21 May 2008, Mimi Zohar wrote:
> 
> > +#define IMA_HASH_KEY(digest) (hash_long(\
> > +	(unsigned long)(*digest), IMA_HASH_BITS));
> 
> Please make this a static inline and use hash_ptr().
> 
> > +	i_size = i_size_read(file->f_dentry->d_inode);
> > +	while (offset < i_size) {
> > +		int error;
> > +
> > +		rbuf_len = kernel_read(file, offset, rbuf, PAGE_SIZE);
> > +		if (rbuf_len <= 0)
> > +			break;
> 
> Why is the return value of kernel_read() not being propagated to the 
> caller?
> 
> > +		error = crypto_hash_update(desc, sg, rbuf_len);
> > +		if (error) {
> > +			result = -EINVAL;
> > +			break;
> > +		}
> 
> Why are you replacing the error code from crypto_hash_update() with 
> -EINVAL ?
> 
> > +	tfm = crypto_alloc_hash(ima_hash, 0, CRYPTO_ALG_ASYNC);
> > +	if (IS_ERR(tfm)) {
> > +		printk(KERN_INFO "%s: failed to load %s transform: %ld\n",
> > +		       __func__, ima_hash, PTR_ERR(tfm));
> > +		return -ENOSYS;
> > +	}
> 
> Similarly, why not propagate the actual error ?
> 
> (This kind of thing happens quite a lot in the code).
> 
> 
> 
> > +static int __init init_ima(void)
> > +{
> > +	int error;
> > +	tfm_hash = crypto_alloc_hash(ima_hash, 0, CRYPTO_ALG_ASYNC);
> > +
> > +	error = ima_init();
> > +	if (error)
> > +		goto out;
> > +	ima_fixup_inodes();
> > +	if (ima_base_hooks)
> > +		error = register_integrity(&ima_base_ops);
> > +	else
> > +		error = register_integrity(&ima_integrity_ops);
> > +	register_template("ima", &ima_template_ops);
> > +out:
> > +	return error;
> > +}
> 
> What if crypto_alloc_hash() fails ?  Actually, where is it used?
> 
> 
> - James

