Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYHUIhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYHUIhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYHUIgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:36:38 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56125 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYHUIga (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:36:30 -0400
Message-ID: <48AD28DD.6090109@de.ibm.com>
Date: Thu, 21 Aug 2008 10:35:41 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?BM_Deutschland_Research_=26_Developm?=
 =?ISO-8859-1?Q?ent_GmbH_/_Vorsitzender_des_Aufsichtsrats=3A_?=
 =?ISO-8859-1?Q?Martin_Jetter=2CGesch=E4ftsf=FChrung=3A_Herbert_Kir?=
 =?ISO-8859-1?Q?cher=2CSitz_der_Gesellschaft=3A_B=F6blingen_/_R?=
 =?ISO-8859-1?Q?egistergericht=3A_Amtsgericht_Stuttgart=2C_HRB_24?=
 =?ISO-8859-1?Q?3294?=
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: jaredeh@gmail.com
CC: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
References: <48AD00F0.5030403@gmail.com>
In-Reply-To: <48AD00F0.5030403@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> +/***************** functions in other axfs files ******************************/
> +int axfs_get_sb(struct file_system_type *, int, const char *, void *,
> +		struct vfsmount *);
This is neither implemented nor used in axfs_inode.c - why define it here?

> +void axfs_kill_super(struct super_block *);
Same for this one.


> +void axfs_profiling_add(struct axfs_super *, unsigned long, unsigned int);
> +int axfs_copy_mtd(struct super_block *, void *, u64, u64);
> +int axfs_copy_block(struct super_block *, void *, u64, u64);
These are used, but not implemented here. Please consider putting them 
in a header file


> +static int axfs_copy_data(struct super_block *sb, void *dst,
> +			  struct axfs_region_desc *region, u64 offset, u64 len)
> +{
> +	u64 mmapped = 0;
> +	u64 end = region->fsoffset + offset + len;
> +	u64 begin = region->fsoffset + offset;
> +	u64 left;
> +	void *addr;
> +	void *newdst;
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +
> +	if (len == 0)
> +		return 0;
> +
> +	if (region->virt_addr) {
> +		if (sbi->mmap_size >= end) {
> +			mmapped = len;
> +		} else if (sbi->mmap_size > begin) {
> +			mmapped = sbi->mmap_size - begin;
> +		}
> +	}
You can save braces and make the code more readable here:
=> if (sbi->mmap_size >= end)
	mmapped = len;
    else if (sbi->mmap_size > begin)
	mmapped = si->mmap_size - begin;


> +struct inode *axfs_create_vfs_inode(struct super_block *sb, int ino)
> +{
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +	struct inode *inode;
> +	u64 size;
[SNIP]
> +	size = AXFS_GET_INODE_FILE_SIZE(sbi, ino);
> +	inode->i_size = size;
The variable size is not needed. Do
	inode->i_size = AXFS_GET_INODE_FILE_SIZE(sbi, ino);


> +static struct dentry *axfs_lookup(struct inode *dir, struct dentry *dentry,
> +				  struct nameidata *nd)
> +{
> +	struct super_block *sb = dir->i_sb;
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +	u64 ino_number = dir->i_ino;
> +	u64 dir_index = 0;
> +	u64 entry;
> +	char *name;
> +	int namelen, err;
> +
> +	while (dir_index < AXFS_GET_INODE_NUM_ENTRIES(sbi, ino_number)) {
> +		entry = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number);
> +		entry += dir_index;
> +
> +		name = AXFS_GET_INODE_NAME(sbi, entry);
> +		namelen = strlen(name);
> +
> +		/* fast test, the entries are sorted alphabetically and the
> +		 * first letter is smaller than the first letter in the search
> +		 * name then it isn't in this directory.  Keeps this loop from
> +		 * needing to scan through always.
> +		 */
> +		if (dentry->d_name.name[0] < name[0])
> +			break;
> +
> +		dir_index++;
> +
> +		/* Quick check that the name is roughly the right length */
> +		if (dentry->d_name.len != namelen)
> +			continue;
> +
> +		err = memcmp(dentry->d_name.name, name, namelen);
> +		if (err > 0)
> +			continue;
> +
> +		/* The file name isn't present in the directory. */
> +		if (err < 0)
> +			break;
Very ingenious way to compare strings. strncmp also stops after the 
first character if it does'nt fit. I doubt this has a measurable 
performance advantage over using strncmp, please consider to replace 
this logic to make the code smaller and more readable. See lib/string.c.

> +static int axfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
> +{
> +	struct inode *inode = filp->f_dentry->d_inode;
> +	struct super_block *sb = inode->i_sb;
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +	u64 ino_number = inode->i_ino;
> +	u64 entry;
> +	loff_t dir_index;
> +	char *name;
> +	int namelen, mode;
> +	int err = 0;
> +
> +	/* Get the current index into the directory and verify it is not beyond
> +	   the end of the list */
> +	dir_index = filp->f_pos;
> +	if (dir_index >= AXFS_GET_INODE_NUM_ENTRIES(sbi, ino_number))
> +		goto out;
> +
> +	/* Verify the inode is for a directory */
> +	if (!(S_ISDIR(inode->i_mode))) {
> +		err = -EINVAL;
> +		goto out;
> +	}
Well, -ENOTDIR would be the correct return code. You can remove that 
sanity check alltogether, vfs_readdir makes sure this is the right 
file type. If you really want to check, make it 
BUG_ON(!S_ISDIR(inode->i_mode));

> +static int axfs_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> +{
> +	struct file *file = vma->vm_file;
> +	struct inode *inode = file->f_dentry->d_inode;
> +	struct super_block *sb = inode->i_sb;
> +	struct axfs_super *sbi = AXFS_SB(sb);
> +	u64 ino_number = inode->i_ino;
> +	u64 array_index;
> +
> +	array_index = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number) + vmf->pgoff;
> +
> +	/* if that pages are marked for write they will probably end up in RAM
> +	   therefore we don't want their counts for being XIP'd */
> +	if (!(vma->vm_flags & VM_WRITE))
> +		axfs_profiling_add(sbi, array_index, ino_number);
Thats very inacurate profiling, it does never count MAP_PRIVATE 
mappings which is the regular case for executables and libraries. When 
booting an enterprise distro, my sniff test shows that only about 5% 
of the MAP_PRIVATE mappings get COW'ed. To get correct statistics, it 
might be a good idea to find a way to add here and substract during 
cow. Or to scan these mappings when the profiling information is being 
retrieved - the readonly bit in the pte gives the right indication for 
MIXEDMAP mappings.

