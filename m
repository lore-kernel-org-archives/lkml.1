Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYAXVYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYAXVYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbYAXVXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:23:49 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:23373 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545AbYAXVXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:23:43 -0500
Message-ID: <479901A8.3000706@oracle.com>
Date: Thu, 24 Jan 2008 16:22:48 -0500
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture team, Oracle USA
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Trond.Myklebust@netapp.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 24/27] NFS: Use local caching [try #2]
References: <20080123172038.11107.86025.stgit@warthog.procyon.org.uk> <20080123172246.11107.62216.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080123172246.11107.62216.stgit@warthog.procyon.org.uk>
Content-Type: multipart/mixed;
 boundary="------------010802080201070305010809"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010802080201070305010809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Some comments below.

This patch really ought to be broken into more manageable atomic changes 
to make it easier to review, and to provide more fine-grained 
explanation and rationalization for each specific change via individual 
patch descriptions.

David Howells wrote:
> The attached patch makes it possible for the NFS filesystem to make use of the
> network filesystem local caching service (FS-Cache).
> 
> To be able to use this, an updated mount program is required.  This can be
> obtained from:
> 
> 	http://people.redhat.com/steved/fscache/util-linux/

This should no longer be necessary.  The latest mount.nfs subcommand 
from nfs-utils supports text-based mounts when running on kernels 2.6.23 
and later.

> To mount an NFS filesystem to use caching, add an "fsc" option to the mount:
> 
> 	mount warthog:/ /a -o fsc

I hope you intend to provide updates to nfs(5) that describe the new 
mount options you introduce in this and later patches.  You don't 
mention it, but I assume that "nofsc" is the default behavior.

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/nfs/Makefile           |    1 
>  fs/nfs/client.c           |    5 +
>  fs/nfs/file.c             |   37 ++++
>  fs/nfs/fscache-def.c      |  289 +++++++++++++++++++++++++++++++++
>  fs/nfs/fscache.c          |  391 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/nfs/fscache.h          |  148 +++++++++++++++++
>  fs/nfs/inode.c            |   47 +++++
>  fs/nfs/read.c             |   28 +++
>  fs/nfs/super.c            |    3 
>  fs/nfs/sysctl.c           |    1 
>  include/linux/nfs_fs.h    |    9 +
>  include/linux/nfs_fs_sb.h |   18 ++
>  12 files changed, 968 insertions(+), 9 deletions(-)
>  create mode 100644 fs/nfs/fscache-def.c
>  create mode 100644 fs/nfs/fscache.c
>  create mode 100644 fs/nfs/fscache.h
> 
> 
> diff --git a/fs/nfs/Makefile b/fs/nfs/Makefile
> index df0f41e..073d04c 100644
> --- a/fs/nfs/Makefile
> +++ b/fs/nfs/Makefile
> @@ -16,3 +16,4 @@ nfs-$(CONFIG_NFS_V4)	+= nfs4proc.o nfs4xdr.o nfs4state.o nfs4renewd.o \
>  			   nfs4namespace.o
>  nfs-$(CONFIG_NFS_DIRECTIO) += direct.o
>  nfs-$(CONFIG_SYSCTL) += sysctl.o
> +nfs-$(CONFIG_NFS_FSCACHE) += fscache.o fscache-def.o
> diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> index a6f6254..bcdc5d0 100644
> --- a/fs/nfs/client.c
> +++ b/fs/nfs/client.c
> @@ -43,6 +43,7 @@
>  #include "delegation.h"
>  #include "iostat.h"
>  #include "internal.h"
> +#include "fscache.h"
>  
>  #define NFSDBG_FACILITY		NFSDBG_CLIENT
>  
> @@ -139,6 +140,8 @@ static struct nfs_client *nfs_alloc_client(const char *hostname,
>  	clp->cl_state = 1 << NFS4CLNT_LEASE_EXPIRED;
>  #endif
>  
> +	nfs_fscache_get_client_cookie(clp);
> +
>  	return clp;
>  
>  error_3:
> @@ -170,6 +173,8 @@ static void nfs_free_client(struct nfs_client *clp)
>  
>  	nfs4_shutdown_client(clp);
>  
> +	nfs_fscache_release_client_cookie(clp);
> +
>  	/* -EIO all pending I/O */
>  	if (!IS_ERR(clp->cl_rpcclient))
>  		rpc_shutdown_client(clp->cl_rpcclient);
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index b3bb89f..d492cd7 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -35,6 +35,7 @@
>  #include "delegation.h"
>  #include "internal.h"
>  #include "iostat.h"
> +#include "fscache.h"
>  
>  #define NFSDBG_FACILITY		NFSDBG_FILE
>  
> @@ -352,22 +353,48 @@ static int nfs_write_end(struct file *file, struct address_space *mapping,
>  	return status < 0 ? status : copied;
>  }
>  
> +/*
> + * Partially or wholly invalidate a page
> + * - Release the private state associated with a page if undergoing complete
> + *   page invalidation
> + * - Called if either PG_private or PG_fscache set on the page
> + * - Caller holds page lock
> + */

Add comments like this in a separate clean up patch.

>  static void nfs_invalidate_page(struct page *page, unsigned long offset)
>  {
>  	if (offset != 0)
>  		return;
>  	/* Cancel any unstarted writes on this page */
>  	nfs_wb_page_cancel(page->mapping->host, page);
> +
> +	nfs_fscache_invalidate_page(page, page->mapping->host);
>  }
>  
> +/*
> + * Release the private state associated with a page
> + * - Called if either PG_private or PG_fscache set on the page
> + * - Caller holds page lock
> + * - Return true (may release) or false (may not)
> + */
>  static int nfs_release_page(struct page *page, gfp_t gfp)
>  {
>  	/* If PagePrivate() is set, then the page is not freeable */
> -	return 0;
> +	if (PagePrivate(page))
> +		return 0;
> +	return nfs_fscache_release_page(page, gfp);
>  }
>  
> +/*
> + * Attempt to clear the private state associated with a page when an error
> + * occurs that requires the cached contents of an inode to be written back or
> + * destroyed
> + * - Called if either PG_private or PG_fscache set on the page
> + * - Caller holds page lock
> + * - Return 0 if successful, -error otherwise
> + */
>  static int nfs_launder_page(struct page *page)
>  {
> +	wait_on_page_fscache_write(page);
>  	return nfs_wb_page(page->mapping->host, page);
>  }
>  
> @@ -387,6 +414,11 @@ const struct address_space_operations nfs_file_aops = {
>  	.launder_page = nfs_launder_page,
>  };
>  
> +/*
> + * Notification that a PTE pointing to an NFS page is about to be made
> + * writable, implying that someone is about to modify the page through a
> + * shared-writable mapping
> + */
>  static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>  {
>  	struct file *filp = vma->vm_file;
> @@ -396,6 +428,9 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct page *page)
>  	struct address_space *mapping;
>  	loff_t offset;
>  
> +	/* make sure the cache has finished storing the page */
> +	wait_on_page_fscache_write(page);
> +
>  	lock_page(page);
>  	mapping = page->mapping;
>  	if (mapping != vma->vm_file->f_path.dentry->d_inode->i_mapping) {
> diff --git a/fs/nfs/fscache-def.c b/fs/nfs/fscache-def.c

A suggestion: fs/nfs/fsc-index.c might be a better name.

> new file mode 100644
> index 0000000..bc20b7d
> --- /dev/null
> +++ b/fs/nfs/fscache-def.c
> @@ -0,0 +1,289 @@
> +/* NFS FS-Cache index structure definition
> + *
> + * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/mm.h>
> +#include <linux/nfs_fs.h>
> +#include <linux/nfs_fs_sb.h>
> +#include <linux/in6.h>
> +
> +#include "internal.h"
> +#include "fscache.h"
> +
> +#define NFSDBG_FACILITY		NFSDBG_FSCACHE
> +
> +/*
> + * Definition of the auxiliary data attached to NFS inode storage objects.
> + * This is used for coherency management.
> + */
> +struct nfs_fh_auxdata {
> +	struct timespec	i_mtime;
> +	struct timespec	i_ctime;
> +	loff_t		i_size;
> +};

It might be useful to explain here why you need to supplement the mtime, 
ctime, and size fields that already exist in an NFS inode.

> +/*
> + * Definition of the key for an NFS server index object.  The server's IP
> + * address is stored as an IPv6 address, with IPv4 addresses being wrapped
> + * appropriately.
> + */
> +struct nfs_server_key {
> +	uint16_t nfsversion;
> +	uint16_t port;
> +	union {
> +		struct {
> +			uint8_t		ipv6wrapper[12];
> +			struct in_addr	addr;
> +		} ipv4_addr;
> +		struct in6_addr ipv6_addr;
> +	};
> +};
> +
> +static const struct fscache_netfs_operations nfs_cache_ops = {
> +};
> +
> +struct fscache_netfs nfs_cache_netfs = {
> +	.name		= "nfs",
> +	.version	= 0,
> +	.ops		= &nfs_cache_ops,
> +};
> +
> +static const uint8_t nfs_cache_ipv6_wrapper_for_ipv4[12] = {
> +	[0 ... 9]	= 0x00,
> +	[10 ... 11]	= 0xff
> +};
> +
> +/*
> + * Generate a key to describe a server in the main NFS index
> + */
> +static uint16_t nfs_server_get_key(const void *cookie_netfs_data,
> +				   void *buffer, uint16_t bufmax)
> +{
> +	const struct nfs_client *clp = cookie_netfs_data;
> +	struct nfs_server_key *key = buffer;
> +	uint16_t len = 0;
> +
> +	key->nfsversion = clp->cl_nfsversion;
> +
> +	switch (clp->cl_addr.sin_family) {
> +	case AF_INET:
> +		key->port = clp->cl_addr.sin_port;

Not sure why you are using the server's port here.  In almost every case 
the server side port number will be 2049, so it really doesn't add any 
uniquification.

If you're going for the client side port number, that changes after 
every connection, so it would be useless to identify a cache after a 
reboot (or even after the connection idles out!).

> +		memcpy(&key->ipv4_addr.ipv6wrapper,
> +		       &nfs_cache_ipv6_wrapper_for_ipv4,
> +		       sizeof(key->ipv4_addr.ipv6wrapper));
> +		memcpy(&key->ipv4_addr.addr,
> +		       &clp->cl_addr.sin_addr,
> +		       sizeof(key->ipv4_addr.addr));

I strongly recommend you use the existing IPv6 address conversion macros 
for this instead of open-coding yet another way of mapping an IPv4 
address to an IPv6 address.

However, since AF_INET6 support is being introduced in the NFS client in 
2.6.24, I recommend you take a look at these source files after Trond 
has pushed his NFS_ALL for 2.6.24.

> +		len = sizeof(struct nfs_server_key);
> +		break;
> +
> +	case AF_INET6:
> +		key->port = clp->cl_addr.sin_port;
> +
> +		memcpy(&key->ipv6_addr,
> +		       &clp->cl_addr.sin_addr,
> +		       sizeof(key->ipv6_addr));
> +		len = sizeof(struct nfs_server_key);
> +		break;
> +
> +	default:
> +		len = 0;
> +		printk(KERN_WARNING "NFS: Unknown network family '%d'\n",
> +			clp->cl_addr.sin_family);
> +		break;
> +	}
> +
> +	return len;
> +}
> +
> +/*
> + * The root index for the filesystem is defined by nfsd IP address and ports
> + */
> +const struct fscache_cookie_def nfs_cache_server_index_def = {
> +	.name		= "NFS.servers",
> +	.type 		= FSCACHE_COOKIE_TYPE_INDEX,
> +	.get_key	= nfs_server_get_key,
> +};

I'm going to have to study your latest fscache implementation in 
previous patches before commenting on most of the rest of this patch.

> +/*
> + * Generate a key to describe an NFS inode in an NFS server's index
> + */
> +static uint16_t nfs_fh_get_key(const void *cookie_netfs_data,
> +			       void *buffer, uint16_t bufmax)
> +{
> +	const struct nfs_inode *nfsi = cookie_netfs_data;
> +	uint16_t nsize;
> +
> +	/* use the inode's NFS filehandle as the key */
> +	nsize = nfsi->fh.size;
> +	memcpy(buffer, nfsi->fh.data, nsize);
> +	return nsize;
> +}
> +
> +/*
> + * Get an extra reference on a read context
> + * - This function can be absent if the completion function doesn't require a
> + *   context
> + */
> +static void nfs_fh_get_context(void *cookie_netfs_data, void *context)
> +{
> +	get_nfs_open_context(context);
> +}
> +
> +/*
> + * Release an extra reference on a read context
> + * - This function can be absent if the completion function doesn't require a
> + *   context
> + */
> +static void nfs_fh_put_context(void *cookie_netfs_data, void *context)
> +{
> +	if (context)
> +		put_nfs_open_context(context);
> +}
> +
> +/*
> + * Indication the cookie is no longer uncached
> + * - This function is called when the backing store currently caching a cookie
> + *   is removed
> + * - The netfs should use this to clean up any markers indicating cached pages
> + * - This is mandatory for any object that may have data
> + */
> +static void nfs_fh_now_uncached(void *cookie_netfs_data)
> +{
> +	struct nfs_inode *nfsi = cookie_netfs_data;
> +	struct pagevec pvec;
> +	pgoff_t first;
> +	int loop, nr_pages;
> +
> +	pagevec_init(&pvec, 0);
> +	first = 0;
> +
> +	dprintk("NFS: nfs_fh_now_uncached: nfs_inode 0x%p\n", nfsi);
> +
> +	for (;;) {
> +		/* grab a bunch of pages to clean */
> +		nr_pages = pagevec_lookup(&pvec,
> +					  nfsi->vfs_inode.i_mapping,
> +					  first,
> +					  PAGEVEC_SIZE - pagevec_count(&pvec));
> +		if (!nr_pages)
> +			break;
> +
> +		for (loop = 0; loop < nr_pages; loop++)
> +			ClearPageFsCache(pvec.pages[loop]);
> +
> +		first = pvec.pages[nr_pages - 1]->index + 1;
> +
> +		pvec.nr = nr_pages;
> +		pagevec_release(&pvec);
> +		cond_resched();
> +	}
> +}
> +
> +/*
> + * Tet certain file attributes from the netfs data

  "Get"

> + * - This function can be absent for an index
> + * - Not permitted to return an error
> + * - The netfs data from the cookie being used as the source is
> + *   presented
> + */
> +static void nfs_fh_get_attr(const void *cookie_netfs_data, uint64_t *size)
> +{
> +	const struct nfs_inode *nfsi = cookie_netfs_data;
> +
> +	*size = nfsi->vfs_inode.i_size;
> +}
> +
> +/*
> + * Get the auxiliary data from netfs data
> + * - This function can be absent if the index carries no state data
> + * - Should store the auxiliary data in the buffer
> + * - Should return the amount of amount stored
> + * - Not permitted to return an error
> + * - The netfs data from the cookie being used as the source is presented
> + */
> +static uint16_t nfs_fh_get_aux(const void *cookie_netfs_data,
> +			       void *buffer, uint16_t bufmax)
> +{
> +	struct nfs_fh_auxdata auxdata;
> +	const struct nfs_inode *nfsi = cookie_netfs_data;
> +
> +	auxdata.i_size = nfsi->vfs_inode.i_size;
> +	auxdata.i_mtime = nfsi->vfs_inode.i_mtime;
> +	auxdata.i_ctime = nfsi->vfs_inode.i_ctime;
> +
> +	if (bufmax > sizeof(auxdata))
> +		bufmax = sizeof(auxdata);
> +
> +	memcpy(buffer, &auxdata, bufmax);
> +	return bufmax;
> +}
> +
> +/*
> + * Consult the netfs about the state of an object
> + * - This function can be absent if the index carries no state data
> + * - The netfs data from the cookie being used as the target is
> + *   presented, as is the auxiliary data
> + */
> +static enum fscache_checkaux nfs_fh_check_aux(void *cookie_netfs_data,
> +					      const void *data,
> +					      uint16_t datalen)
> +{
> +	struct nfs_fh_auxdata auxdata;
> +	struct nfs_inode *nfsi = cookie_netfs_data;
> +
> +	if (datalen > sizeof(auxdata))
> +		return FSCACHE_CHECKAUX_OBSOLETE;
> +
> +	auxdata.i_size = nfsi->vfs_inode.i_size;
> +	auxdata.i_mtime = nfsi->vfs_inode.i_mtime;
> +	auxdata.i_ctime = nfsi->vfs_inode.i_ctime;
> +
> +	if (memcmp(data, &auxdata, datalen) != 0)
> +		return FSCACHE_CHECKAUX_OBSOLETE;
> +
> +	return FSCACHE_CHECKAUX_OKAY;
> +}
> +
> +/*
> + * The primary index for each server is simply made up of a series of NFS file
> + * handles
> + */
> +const struct fscache_cookie_def nfs_cache_fh_index_def = {
> +	.name		= "NFS.fh",
> +	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
> +	.get_key	= nfs_fh_get_key,
> +	.get_attr	= nfs_fh_get_attr,
> +	.get_aux	= nfs_fh_get_aux,
> +	.check_aux	= nfs_fh_check_aux,
> +	.get_context	= nfs_fh_get_context,
> +	.put_context	= nfs_fh_put_context,
> +	.now_uncached	= nfs_fh_now_uncached,
> +};
> +
> +/*
> + * Register NFS for caching
> + */
> +int nfs_fscache_register(void)
> +{
> +	return fscache_register_netfs(&nfs_cache_netfs);
> +}
> +
> +/*
> + * Unregister NFS for caching
> + */
> +void nfs_fscache_unregister(void)
> +{
> +	fscache_unregister_netfs(&nfs_cache_netfs);
> +}

   [ Snipped... ]

> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index 7f5e747..6dd628f 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -57,6 +57,7 @@
>  #include "delegation.h"
>  #include "iostat.h"
>  #include "internal.h"
> +#include "fscache.h"
>  
>  #define NFSDBG_FACILITY		NFSDBG_VFS
>  
> @@ -549,6 +550,8 @@ static int nfs_show_stats(struct seq_file *m, struct vfsmount *mnt)
>  
>  	rpc_print_iostats(m, nfss->client);
>  
> +	nfs_fscache_show_stats(m, nfss);
> +

See below: the NFS cache-related stats should be added to nfs_iostats.

>  	return 0;
>  }
>  
> diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
> index b62481d..b3b3280 100644
> --- a/fs/nfs/sysctl.c
> +++ b/fs/nfs/sysctl.c
> @@ -14,6 +14,7 @@
>  #include <linux/nfs_fs.h>
>  
>  #include "callback.h"
> +#include "internal.h"
>  
>  static const int nfs_set_port_min = 0;
>  static const int nfs_set_port_max = 65535;
> diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
> index 2d15d4a..8a5685f 100644
> --- a/include/linux/nfs_fs.h
> +++ b/include/linux/nfs_fs.h
> @@ -174,6 +174,9 @@ struct nfs_inode {
>  	int			 delegation_state;
>  	struct rw_semaphore	rwsem;
>  #endif /* CONFIG_NFS_V4*/
> +#ifdef CONFIG_NFS_FSCACHE
> +	struct fscache_cookie	*fscache;
> +#endif
>  	struct inode		vfs_inode;
>  };
>  
> @@ -187,6 +190,7 @@ struct nfs_inode {
>  #define NFS_INO_INVALID_ACL	0x0010		/* cached acls are invalid */
>  #define NFS_INO_REVAL_PAGECACHE	0x0020		/* must revalidate pagecache */
>  #define NFS_INO_REVAL_FORCED	0x0040		/* force revalidation ignoring a delegation */
> +#define NFS_INO_INVALID_FSCACHE_ATTR	0x0080	/* local cache attributes are invalid */
>  
>  /*
>   * Bit offsets in flags field
> @@ -195,6 +199,7 @@ struct nfs_inode {
>  #define NFS_INO_ADVISE_RDPLUS	(1)		/* advise readdirplus */
>  #define NFS_INO_STALE		(2)		/* possible stale inode */
>  #define NFS_INO_ACL_LRU_SET	(3)		/* Inode is on the LRU list */
> +#define NFS_INO_FSCACHE		(4)		/* inode can be cached by FS-Cache */
>  
>  static inline struct nfs_inode *NFS_I(struct inode *inode)
>  {
> @@ -216,6 +221,7 @@ static inline struct nfs_inode *NFS_I(struct inode *inode)
>  
>  #define NFS_FLAGS(inode)		(NFS_I(inode)->flags)
>  #define NFS_STALE(inode)		(test_bit(NFS_INO_STALE, &NFS_FLAGS(inode)))
> +#define NFS_FSCACHE(inode)	(test_bit(NFS_INO_FSCACHE, &NFS_FLAGS(inode)))
>  
>  #define NFS_FILEID(inode)		(NFS_I(inode)->fileid)
>  
> @@ -455,6 +461,8 @@ extern int  nfs_readpages(struct file *, struct address_space *,
>  		struct list_head *, unsigned);
>  extern int  nfs_readpage_result(struct rpc_task *, struct nfs_read_data *);
>  extern void nfs_readdata_release(void *data);
> +extern int  nfs_readpage_async(struct nfs_open_context *, struct inode *,
> +			       struct page *);
>  
>  /*
>   * Allocate nfs_read_data structures
> @@ -545,6 +553,7 @@ extern void * nfs_root_data(void);
>  #define NFSDBG_CALLBACK		0x0100
>  #define NFSDBG_CLIENT		0x0200
>  #define NFSDBG_MOUNT		0x0400
> +#define NFSDBG_FSCACHE		0x0800
>  #define NFSDBG_ALL		0xFFFF
>  
>  #ifdef __KERNEL__
> diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
> index 0cac49b..3c8e15d 100644
> --- a/include/linux/nfs_fs_sb.h
> +++ b/include/linux/nfs_fs_sb.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/list.h>
>  #include <linux/backing-dev.h>
> +#include <linux/fscache.h>
>  
>  struct nfs_iostats;
>  
> @@ -65,6 +66,10 @@ struct nfs_client {
>  	char			cl_ipaddr[16];
>  	unsigned char		cl_id_uniquifier;
>  #endif
> +
> +#ifdef CONFIG_NFS_FSCACHE
> +	struct fscache_cookie	*fscache;	/* client index cache cookie */
> +#endif
>  };
>  
>  /*
> @@ -95,12 +100,25 @@ struct nfs_server {
>  	unsigned int		acdirmin;
>  	unsigned int		acdirmax;
>  	unsigned int		namelen;
> +	unsigned int		options;	/* extra options enabled by mount */
> +#define NFS_OPTION_FSCACHE	0x00000001	/* - local caching enabled */

Why did you choose to create a new field for this rather than setting up 
a new NFS_MNT flag?  The new in-kernel NFS mount option parser uses the 
NFS_MNT flags too.

>  	struct nfs_fsid		fsid;
>  	__u64			maxfilesize;	/* maximum file size */
>  	unsigned long		mount_time;	/* when this fs was mounted */
>  	dev_t			s_dev;		/* superblock dev numbers */
>  
> +#ifdef CONFIG_NFS_FSCACHE
> +	/* statistical counters for local caching */
> +	atomic_t		fscache_cnt_read_ok;
> +	atomic_t		fscache_cnt_read_fail;
> +	atomic_t		fscache_cnt_write_ok;
> +	atomic_t		fscache_cnt_write_fail;
> +	atomic_t		fscache_cnt_uncache;
> +	int			fscache_last_read_error;
> +	int			fscache_last_write_error;
> +#endif
> +

These all belong in the nfs_iostats structure.  We don't handle 
performance metrics using atomic_t, as that results in undue overhead on 
SMP systems.  nfs_iostats is already set up with nice per-CPU vectors to 
prevent contention.

>  #ifdef CONFIG_NFS_V4
>  	u32			attr_bitmask[2];/* V4 bitmask representing the set
>  						   of attributes supported on this

--------------010802080201070305010809
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck_lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck_lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
email;internet:chuck dot lever at nospam oracle dot com
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------010802080201070305010809--
