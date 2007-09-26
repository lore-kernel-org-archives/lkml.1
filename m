Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbXIZNLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbXIZNLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbXIZNLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:11:35 -0400
Received: from h90-m1.hosting90.cz ([81.0.225.70]:60106 "EHLO
	h90-m1.hosting90.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXIZNLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:11:34 -0400
Message-ID: <46FA5A85.20407@prepere.com>
Date: Wed, 26 Sep 2007 15:11:33 +0200
From: Miloslav Semler <majkls@prepere.com>
User-Agent: IceDove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: David Newall <david@davidnewall.com>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com> <46FA341A.80706@davidnewall.com> <6BA6E9EE-B67B-4334-AC83-9B8E30527832@mac.com>
In-Reply-To: <6BA6E9EE-B67B-4334-AC83-9B8E30527832@mac.com>
Content-Type: multipart/mixed;
 boundary="------------040704080203060907030703"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040704080203060907030703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Kyle Moffett napsal(a):
> On Sep 26, 2007, at 06:27:38, David Newall wrote:
>> Kyle Moffett wrote:
>>> David, please do tell myself and Adrian how "locking down" chroot() 
>>> the way you want will avoid letting root break out through any of 
>>> the above ways?
>>
>> As has been said, there are thousands of ways to break out of a 
>> chroot.  It's just that one of them should not be that chroot lets 
>> you walk out.  I can't explain it clearer than that.  If you don't 
>> see it now you probably never will.
>
> Let me put it this way:  You *CANNOT* enforce chroot() the way you 
> want to without a completely unacceptable performance penalty.  Let's 
> start with the simplest example of:
>
> fd = open("/", O_DIRECTORY);
> chroot("/foo");
> fchdir(fd);
> chroot(".");
>
> If you had ever actually looked at the Linux VFS, it is completely 
> *impossible* to tell whether "fd" at the time of the chroot is inside 
> or outside of "/foo" without tracking an enormous amount of extra state.
so there *is* solution. It is possible. I solved it. I have patch and it 
is working. So if you find some way how to break it I woud glad if you 
tell me it.
> Even then, any such determination may not be valid since an FD may be 
> opened to an inode which is hardlinked at multiple locations in the 
> directory tree.  It could also be bind-mounted at multiple locations, 
> or it may not even be mounted at all in this namespace (CDROM that was 
> lazy-unmounted).  That FD may be later passed over an open UNIX-domain 
> socket from another process.  Moreover, arbitrarily closing FDs would 
> break a huge number of programs.  Furthermore, since you can't fix the 
> "trivial" case of 'fchdir()', then there's no point in even 
> *attempting* to fix the "cwd is outside of chroot" problem, although 
> that is basically equivalent in difficulty to fixing the "dir-fd is 
> outside of chroot" problem.
>
> As for the nested-chroot() bit, the root user inside of a chroot is 
> always allowed to chroot().  This is necessary for test-suites for 
> various distro installers, chroot once to enter the installer playpen, 
> installer chroots again to configure the test-installed-system.  Once 
> you allow a second chroot, you're back at the "can't reliably and 
> efficiently track directory sub-tree members" problem.
>
> So if you think it can and should be fixed, then PROVIDE THE CODE.
Miloslav Semler

--------------040704080203060907030703
Content-Type: text/x-diff;
 name="sys_chroot+sys_fchdir.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sys_chroot+sys_fchdir.patch"

diff -Nrp linux-2.6.16.53/fs/namei.c linux-2.6.16.53-new/fs/namei.c
*** linux-2.6.16.53/fs/namei.c	2007-07-25 23:05:45.000000000 +0200
--- linux-2.6.16.53-new/fs/namei.c	2007-09-15 16:13:50.000000000 +0200
*************** static __always_inline void follow_dotdo
*** 728,733 ****
--- 728,772 ----
  	}
  	follow_mount(&nd->mnt, &nd->dentry);
  }
+ long directory_is_out(struct vfsmount *wdmnt, struct dentry *wdentry,
+ 		struct vfsmount *rootmnt, struct dentry *root)
+ {
+ 	struct nameidata oldentry, newentry;
+ 	long ret = 1;
+ 	
+         read_lock(&current->fs->lock);
+ 	oldentry.dentry = dget(wdentry);
+ 	oldentry.mnt = mntget(wdmnt);
+         read_unlock(&current->fs->lock);
+ 	newentry.dentry = oldentry.dentry;
+ 	newentry.mnt = oldentry.mnt;
+ 	
+ 	follow_dotdot(&newentry);
+ 	/* check it */
+ 	if(newentry.dentry == root && 
+ 		newentry.mnt == rootmnt){
+ 		ret = 0;
+ 		goto out;
+ 	}
+ 	
+ 	while(oldentry.mnt != newentry.mnt ||
+ 		oldentry.dentry != newentry.dentry){
+ 		
+ 		memcpy(&oldentry, &newentry, sizeof(struct nameidata));
+ 		follow_dotdot(&newentry);
+ 		
+ 		/* check it */
+ 		if(newentry.dentry == root && 
+ 			newentry.mnt == rootmnt){
+ 			ret = 0;
+ 			goto out;
+ 		}
+ 	}
+ out:
+ 	dput(newentry.dentry);
+ 	mntput(newentry.mnt);
+ 	return ret;
+ }
  
  /*
   *  It's more convoluted than I'd like it to be, but... it's still fairly
diff -Nrp linux-2.6.16.53/fs/open.c linux-2.6.16.53-new/fs/open.c
*** linux-2.6.16.53/fs/open.c	2007-07-25 23:05:45.000000000 +0200
--- linux-2.6.16.53-new/fs/open.c	2007-09-15 16:14:52.000000000 +0200
*************** dput_and_out:
*** 560,565 ****
--- 560,567 ----
  out:
  	return error;
  }
+ long directory_is_out(struct vfsmount *, struct dentry*, 
+ 		struct vfsmount *, struct dentry *);
  
  asmlinkage long sys_fchdir(unsigned int fd)
  {
*************** asmlinkage long sys_fchdir(unsigned int 
*** 581,586 ****
--- 583,591 ----
  	error = -ENOTDIR;
  	if (!S_ISDIR(inode->i_mode))
  		goto out_putf;
+ 	if (directory_is_out(mnt, dentry, current->fs->rootmnt, 
+ 				current->fs->root))
+ 		goto out_putf;
  
  	error = file_permission(file, MAY_EXEC);
  	if (!error)
*************** out:
*** 594,600 ****
  asmlinkage long sys_chroot(const char __user * filename)
  {
  	struct nameidata nd;
! 	int error;
  
  	error = __user_walk(filename, LOOKUP_FOLLOW | LOOKUP_DIRECTORY | LOOKUP_NOALT, &nd);
  	if (error)
--- 599,605 ----
  asmlinkage long sys_chroot(const char __user * filename)
  {
  	struct nameidata nd;
! 	int error, set_wd = 0;
  
  	error = __user_walk(filename, LOOKUP_FOLLOW | LOOKUP_DIRECTORY | LOOKUP_NOALT, &nd);
  	if (error)
*************** asmlinkage long sys_chroot(const char __
*** 607,615 ****
--- 612,631 ----
  	error = -EPERM;
  	if (!capable(CAP_SYS_CHROOT))
  		goto dput_and_out;
+ 	error = -ENOTDIR;
+ 	/*
+ 	if (directory_is_out(nd.mnt, nd.dentry, current->fs->rootmnt,
+ 				current->fs->root))
+ 		goto dput_and_out;
+ 		*/
+ 	set_wd = directory_is_out(current->fs->pwdmnt, current->fs->pwd, 
+ 				nd.mnt, nd.dentry);
  
  	set_fs_root(current->fs, nd.mnt, nd.dentry);
  	set_fs_altroot();
+ 	/* if wd is out, reset it to . */
+ 	if(set_wd)
+ 		set_fs_pwd(current->fs, nd.mnt, nd.dentry);
  	error = 0;
  dput_and_out:
  	path_release(&nd);

--------------040704080203060907030703--
