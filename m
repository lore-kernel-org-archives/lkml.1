Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbXCZU6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbXCZU6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXCZU6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:58:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54156 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbXCZU6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:58:02 -0400
Subject: Re: [Patch 3/7] integrity: EVM as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
In-Reply-To: <20070326182315.GA31340@vino.hallyn.com>
References: <1174666176.11149.3.camel@localhost.localdomain>
	 <20070325001454.14ab63c2.akpm@linux-foundation.org>
	 <20070326182315.GA31340@vino.hallyn.com>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 16:56:44 -0400
Message-Id: <1174942604.12510.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 13:23 -0500, Serge E. Hallyn wrote: 
> Quoting Andrew Morton (akpm@linux-foundation.org):
> > On Fri, 23 Mar 2007 12:09:36 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > 
> > > This is a re-release of EVM as an integrity service provider.
> > 
> > What a huge set of patches.
> > 
> > Frankly, I don't know how we're going to get these reviewed and mergeable
> > and merged - there doesn't seem to be a lot of interest and personally
> > I only have a vague idea of what it all even does.
> 
> Mimi,
> 
> would it make sense to work with just the integrity subsystem first,
> then when they've been sitting for awhile without breaking anything
> and people are done giving comments, look at EVM, then after awhile at
> IMA?
> 
> You've sent out all the patches so you can point people back to this
> submission if they ask "why isn't there a user"  :)
> 
> Just a thought.  Cause it *is* a lot of patches...
> 
> -serge

I don't have a problem with Serge's suggestion of including just the 
integrity patches at this point, if that is preferable.  The integrity
patches would be: integrity-new-hooks.patch, 
integrity-new-hooks-fix.patch, integrity-fs-hook-placement.patch 
and, the one I just submitted, integrity_dummy_verify_metadata.patch.
Then as Serge recommended, release the remainder of the code in smaller 
pieces.

Mimi Zohar

> > This patch does worrisome-looking things with VFS internals (anything
> > which takes inode_lock is fishy).
> > 
> > 
> > Bunch of cleanups, pretty obvious:
> > 
> >  fs/sysfs/mount.c          |    3 ---
> >  include/linux/magic.h     |    1 +
> >  security/evm/evm.h        |    2 --
> >  security/evm/evm_config.c |   19 ++++++++++---------
> >  security/evm/evm_crypto.c |    8 +++-----
> >  security/evm/evm_main.c   |   10 ++++------
> >  6 files changed, 18 insertions(+), 25 deletions(-)
> > 
> > diff -puN fs/sysfs/mount.c~integrity-evm-as-an-integrity-service-provider-tidy fs/sysfs/mount.c
> > --- a/fs/sysfs/mount.c~integrity-evm-as-an-integrity-service-provider-tidy
> > +++ a/fs/sysfs/mount.c
> > @@ -12,9 +12,6 @@
> >  
> >  #include "sysfs.h"
> >  
> > -/* Random magic number */
> > -#define SYSFS_MAGIC 0x62656572
> > -
> >  struct vfsmount *sysfs_mount;
> >  struct super_block * sysfs_sb = NULL;
> >  struct kmem_cache *sysfs_dir_cachep;
> > diff -puN include/linux/magic.h~integrity-evm-as-an-integrity-service-provider-tidy include/linux/magic.h
> > --- a/include/linux/magic.h~integrity-evm-as-an-integrity-service-provider-tidy
> > +++ a/include/linux/magic.h
> > @@ -20,6 +20,7 @@
> >  #define MINIX2_SUPER_MAGIC	0x2468		/* minix V2 fs */
> >  #define MINIX2_SUPER_MAGIC2	0x2478		/* minix V2 fs, 30 char names */
> >  #define MINIX3_SUPER_MAGIC	0x4d5a		/* minix V3 fs */
> > +#define SYSFS_MAGIC		0x62656572
> >  
> >  #define MSDOS_SUPER_MAGIC	0x4d44		/* MD */
> >  #define NCP_SUPER_MAGIC		0x564c		/* Guess, what 0x564c is :-) */
> > diff -puN security/evm/evm.h~integrity-evm-as-an-integrity-service-provider-tidy security/evm/evm.h
> > --- a/security/evm/evm.h~integrity-evm-as-an-integrity-service-provider-tidy
> > +++ a/security/evm/evm.h
> > @@ -8,7 +8,6 @@
> >  #include <linux/spinlock_types.h>
> >  #include <linux/integrity.h>
> >  
> > -#define DEVFS_SUPER_MAGIC	0x1373
> >  #define MAX_DIGEST_SIZE 	20	/* 160-bits */
> >  
> >  extern char *evm_hmac, *evm_hash;
> > @@ -48,7 +47,6 @@ struct evm_iint_cache {
> >  	struct mutex mutex;
> >  };
> >  
> > -extern void display_config(const char *);
> >  extern struct evm_xattr_config *evm_parse_config(char *data,
> >  						 unsigned long datalen,
> >  						 int *datasize);
> > diff -puN security/evm/evm_config.c~integrity-evm-as-an-integrity-service-provider-tidy security/evm/evm_config.c
> > --- a/security/evm/evm_config.c~integrity-evm-as-an-integrity-service-provider-tidy
> > +++ a/security/evm/evm_config.c
> > @@ -18,17 +18,17 @@
> >   * Configuration data
> >   */
> >  struct evm_xattr_config *evm_config_xattrdata;
> > -int evm_config_xattrnum = 0;	/* number of extended attributes */
> > +int evm_config_xattrnum;	/* number of extended attributes */
> >  
> >  /*
> >   * inode->i_integrity information
> >   */
> > -void display_config(const char *name)
> > +static void display_config(const char *name)
> >  {
> >  	struct evm_xattr_config *config_p;
> >  
> >  	for_each_xattr(config_p, evm_config_xattrdata, evm_config_xattrnum)
> > -	    printk(KERN_INFO "%s: %s\n", name, config_p->xattr_name);
> > +		printk(KERN_INFO "%s: %s\n", name, config_p->xattr_name);
> >  }
> >  
> >  /*
> > @@ -42,7 +42,6 @@ int evm_init_config(struct evm_xattr_con
> >  		evm_config_xattrdata = evm_data;
> >  		evm_config_xattrnum = evm_datasize;
> >  		display_config(__FUNCTION__);
> > -
> >  	} else {
> >  		printk(KERN_INFO "%s: config file definition missing\n",
> >  		       __FUNCTION__);
> > @@ -60,9 +59,11 @@ static char *get_tag(char *buf_start, ch
> >  	/* Get start of tag */
> >  	while (bufp < buf_end) {
> >  		if (*bufp == ' ')	/* skip blanks */
> > -			while ((*bufp == ' ') && (bufp++ < buf_end)) ;
> > +			while ((*bufp == ' ') && (bufp++ < buf_end))
> > +				;
> >  		else if (*bufp == '#') {	/* skip comment */
> > -			while ((*bufp != '\n') && (bufp++ < buf_end)) ;
> > +			while ((*bufp != '\n') && (bufp++ < buf_end))
> > +				;
> >  			bufp++;
> >  		} else if (*bufp == '\n')	/* skip newline */
> >  			bufp++;
> > @@ -107,8 +108,8 @@ struct evm_xattr_config *evm_parse_confi
> >  	*xattrnum = num_xattr;
> >  
> >  	datap = data;
> > -	config_xattrdata =
> > -	    kmalloc(num_xattr * sizeof(struct evm_xattr_config), GFP_KERNEL);
> > +	config_xattrdata = kmalloc(num_xattr * sizeof(struct evm_xattr_config),
> > +				GFP_KERNEL);
> >  	if (!config_xattrdata)
> >  		return NULL;
> >  
> > @@ -123,7 +124,7 @@ struct evm_xattr_config *evm_parse_confi
> >  	return config_xattrdata;
> >  }
> >  
> > -inline void evm_cleanup_config(void)
> > +void evm_cleanup_config(void)
> >  {
> >  	kfree(evm_config_xattrdata);
> >  }
> > diff -puN security/evm/evm_crypto.c~integrity-evm-as-an-integrity-service-provider-tidy security/evm/evm_crypto.c
> > --- a/security/evm/evm_crypto.c~integrity-evm-as-an-integrity-service-provider-tidy
> > +++ a/security/evm/evm_crypto.c
> > @@ -33,7 +33,7 @@
> >  static unsigned char tpm_key[MAX_TPMKEY];
> >  static int tpm_keylen = MAX_TPMKEY;
> >  
> > -int update_file_hash(struct dentry *dentry, struct file *f,
> > +static int update_file_hash(struct dentry *dentry, struct file *f,
> >  		     struct hash_desc *desc)
> >  {
> >  	struct file *file = f;
> > @@ -217,11 +217,9 @@ int evm_calc_hmac(struct dentry *dentry,
> >  	struct scatterlist sg[1];
> >  	char *fname;
> >  	int error = 0;
> > -
> >  	struct evm_xattr_config *config_p;
> >  	int xattr_size = 0;
> >  	char *xattr_value = NULL;
> > -
> >  	struct h_misc {
> >  		unsigned long ino;
> >  		__u32 generation;
> > @@ -278,7 +276,7 @@ int evm_calc_hmac(struct dentry *dentry,
> >  					__FUNCTION__, fname,
> >  					config_p->xattr_name);
> >  		}
> > -	};
> > +	}
> >  	kfree(xattr_value);
> >  	memset(hmac_misc, 0, sizeof misc);
> >  	hmac_misc->ino = inode->i_ino;
> > @@ -331,7 +329,7 @@ int evm_init_tpmkernkey(void)
> >  
> >  	kmk = request_key(&key_type_user, TPMKEY, NULL);
> >  	if (IS_ERR(kmk)) {
> > -		return (-1);
> > +		return -1;
> >  	} else {
> >  		down_read(&kmk->sem);
> >  		ukp = kmk->payload.data;
> > diff -puN security/evm/evm_main.c~integrity-evm-as-an-integrity-service-provider-tidy security/evm/evm_main.c
> > --- a/security/evm/evm_main.c~integrity-evm-as-an-integrity-service-provider-tidy
> > +++ a/security/evm/evm_main.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/proc_fs.h>
> >  #include <linux/xattr.h>
> >  #include <linux/file.h>
> > +#include <linux/magic.h>
> >  #include <linux/writeback.h>
> >  #include "evm_integrity.h"
> >  #include "evm.h"
> > @@ -363,10 +364,7 @@ static int evm_verify_data(struct dentry
> >   */
> >  static int skip_measurement(struct inode *inode, int mask)
> >  {
> > -#define SYSFS_MAGIC 0x62656572
> > -
> > -	if ((inode->i_sb->s_magic == DEVFS_SUPER_MAGIC) ||
> > -	    (inode->i_sb->s_magic == PROC_SUPER_MAGIC) ||
> > +	if ((inode->i_sb->s_magic == PROC_SUPER_MAGIC) ||
> >  	    (inode->i_sb->s_magic == SYSFS_MAGIC)) {
> >  		return 1;	/*can't measure */
> >  	}
> > @@ -877,9 +875,9 @@ static void evm_enable_integrity(void)
> >  
> >  static void evm_cleanup_integrity(void)
> >  {
> > -	if (evm_install) {
> > +	if (evm_install)
> >  		unregister_integrity(&evm_install_ops);
> > -	} else
> > +	else
> >  		unregister_integrity(&evm_integrity_ops);
> >  }
> >  
> > _
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

