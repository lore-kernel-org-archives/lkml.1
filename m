Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbXKHHiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbXKHHiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 02:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXKHHih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 02:38:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:51454 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbXKHHig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 02:38:36 -0500
In-Reply-To: <Pine.LNX.4.64.0711020927530.25341@blarg.am.freescale.net>
References: <CBDE987B-0713-4D62-8122-054183E75410@kernel.crashing.org>  <1193188894.27073.20.camel@heimdal.trondhjem.org>  <1954B8FA-6E29-4FB7-86B0-EA43AF8F2AAF@kernel.crashing.org>  <2B2C1270-60FB-4830-A62C-D0357D2E1FB3@kernel.crashing.org> <1193335168.7705.39.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0711020927530.25341@blarg.am.freescale.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <39F21091-B0FC-46D2-AA5B-19491053A8B8@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nfs@lists.sourceforge.net, neilb@suse.de, bfields@fieldses.org,
       Linus Torvalds <torvalds@linux-foundation.org>, chuck.lever@oracle.com,
       Andrew Morton <akpm@osdl.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: LTP ustat01 test fails on NFSROOT
Date: Thu, 8 Nov 2007 01:36:45 -0600
To: Trond Myklebust <Trond.Myklebust@netapp.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 2, 2007, at 9:28 AM, Kumar Gala wrote:

> On Thu, 25 Oct 2007, Trond Myklebust wrote:
>
>> Could you please try the following patch?
>>
>> Cheers
>>   Trond
>
> Its a new month so I'll ping again about sending this fix upstream to
> linus for 2.6.24 :) ?
>
> - k

Trond,

any update on sending this to Linus for 2.6.24?

- k

>> --------------------------------- CUT HERE  
>> -----------------------------
>> From: Trond Myklebust <Trond.Myklebust@netapp.com>
>> Date: Thu, 25 Oct 2007 13:56:10 -0400
>> NFS: Fix the ustat() regression
>>
>> Since 2.6.18, the superblock sb->s_root has been a dummy dentry  
>> with a
>> dummy inode. This breaks ustat(), which actually uses sb->s_root in a
>> vfstat() call.
>>
>> Fix this by making the s_root a dummy alias to the directory inode  
>> that was
>> used when creating the superblock.
>>
>> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
>> ---
>>
>>  fs/nfs/getroot.c |   81 +++++++++++++++++ 
>> +------------------------------------
>>  1 files changed, 27 insertions(+), 54 deletions(-)
>>
>> diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
>> index 522e5ad..0ee4384 100644
>> --- a/fs/nfs/getroot.c
>> +++ b/fs/nfs/getroot.c
>> @@ -43,6 +43,25 @@
>>  #define NFSDBG_FACILITY		NFSDBG_CLIENT
>>
>>  /*
>> + * Set the superblock root dentry.
>> + * Note that this function frees the inode in case of error.
>> + */
>> +static int nfs_superblock_set_dummy_root(struct super_block *sb,  
>> struct inode *inode)
>> +{
>> +	/* The mntroot acts as the dummy root dentry for this superblock */
>> +	if (sb->s_root == NULL) {
>> +		sb->s_root = d_alloc_root(inode);
>> +		if (sb->s_root == NULL) {
>> +			iput(inode);
>> +			return -ENOMEM;
>> +		}
>> +		/* Circumvent igrab(): we know the inode is not being freed */
>> +		atomic_inc(&inode->i_count);
>> +	}
>> +	return 0;
>> +}
>> +
>> +/*
>>   * get an NFS2/NFS3 root dentry from the root filehandle
>>   */
>>  struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh  
>> *mntfh)
>> @@ -54,33 +73,6 @@ struct dentry *nfs_get_root(struct super_block  
>> *sb, struct nfs_fh *mntfh)
>>  	struct inode *inode;
>>  	int error;
>>
>> -	/* create a dummy root dentry with dummy inode for this  
>> superblock */
>> -	if (!sb->s_root) {
>> -		struct nfs_fh dummyfh;
>> -		struct dentry *root;
>> -		struct inode *iroot;
>> -
>> -		memset(&dummyfh, 0, sizeof(dummyfh));
>> -		memset(&fattr, 0, sizeof(fattr));
>> -		nfs_fattr_init(&fattr);
>> -		fattr.valid = NFS_ATTR_FATTR;
>> -		fattr.type = NFDIR;
>> -		fattr.mode = S_IFDIR | S_IRUSR | S_IWUSR;
>> -		fattr.nlink = 2;
>> -
>> -		iroot = nfs_fhget(sb, &dummyfh, &fattr);
>> -		if (IS_ERR(iroot))
>> -			return ERR_PTR(PTR_ERR(iroot));
>> -
>> -		root = d_alloc_root(iroot);
>> -		if (!root) {
>> -			iput(iroot);
>> -			return ERR_PTR(-ENOMEM);
>> -		}
>> -
>> -		sb->s_root = root;
>> -	}
>> -
>>  	/* get the actual root for this mount */
>>  	fsinfo.fattr = &fattr;
>>
>> @@ -96,6 +88,10 @@ struct dentry *nfs_get_root(struct super_block  
>> *sb, struct nfs_fh *mntfh)
>>  		return ERR_PTR(PTR_ERR(inode));
>>  	}
>>
>> +	error = nfs_superblock_set_dummy_root(sb, inode);
>> +	if (error != 0)
>> +		return ERR_PTR(error);
>> +
>>  	/* root dentries normally start off anonymous and get spliced in  
>> later
>>  	 * if the dentry tree reaches them; however if the dentry already
>>  	 * exists, we'll pick it up at this point and use it as the root
>> @@ -241,33 +237,6 @@ struct dentry *nfs4_get_root(struct  
>> super_block *sb, struct nfs_fh *mntfh)
>>
>>  	dprintk("--> nfs4_get_root()\n");
>>
>> -	/* create a dummy root dentry with dummy inode for this  
>> superblock */
>> -	if (!sb->s_root) {
>> -		struct nfs_fh dummyfh;
>> -		struct dentry *root;
>> -		struct inode *iroot;
>> -
>> -		memset(&dummyfh, 0, sizeof(dummyfh));
>> -		memset(&fattr, 0, sizeof(fattr));
>> -		nfs_fattr_init(&fattr);
>> -		fattr.valid = NFS_ATTR_FATTR;
>> -		fattr.type = NFDIR;
>> -		fattr.mode = S_IFDIR | S_IRUSR | S_IWUSR;
>> -		fattr.nlink = 2;
>> -
>> -		iroot = nfs_fhget(sb, &dummyfh, &fattr);
>> -		if (IS_ERR(iroot))
>> -			return ERR_PTR(PTR_ERR(iroot));
>> -
>> -		root = d_alloc_root(iroot);
>> -		if (!root) {
>> -			iput(iroot);
>> -			return ERR_PTR(-ENOMEM);
>> -		}
>> -
>> -		sb->s_root = root;
>> -	}
>> -
>>  	/* get the info about the server and filesystem */
>>  	error = nfs4_server_capabilities(server, mntfh);
>>  	if (error < 0) {
>> @@ -289,6 +258,10 @@ struct dentry *nfs4_get_root(struct  
>> super_block *sb, struct nfs_fh *mntfh)
>>  		return ERR_PTR(PTR_ERR(inode));
>>  	}
>>
>> +	error = nfs_superblock_set_dummy_root(sb, inode);
>> +	if (error != 0)
>> +		return ERR_PTR(error);
>> +
>>  	/* root dentries normally start off anonymous and get spliced in  
>> later
>>  	 * if the dentry tree reaches them; however if the dentry already
>>  	 * exists, we'll pick it up at this point and use it as the root
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

