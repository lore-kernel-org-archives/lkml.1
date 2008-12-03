Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbYLCBEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbYLCBEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYLCBD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 20:03:59 -0500
Received: from ivent.com.au ([125.7.48.1]:54649 "EHLO picard.ivent.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYLCBD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 20:03:58 -0500
X-Greylist: delayed 2340 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2008 20:03:58 EST
Subject: Re: New Security Features, Please Comment
From: Geoffrey McRae <geoff@rabidhost.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1228260494.24232.21.camel@compy.ivent.com.au>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 11:24:54 +1100
Message-Id: <1228263894.7183.13.camel@lappy.spacevs.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - picard.ivent.com.au
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rabidhost.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry all, there is a bug in the patch that causes the compile to
fail... typo in the defines for ia32. I will upload a new patch as soon
as I test compile my new changes.

On Wed, 2008-12-03 at 10:28 +1100, Geoffrey McRae wrote:
> This is my first patch to the linux kernel, so please forgive me if I
> have broken any posting rules. Also, I am not on the mailing list, so
> please CC me on any replies to this.
> 
> A side note before I start, the links to the linux howtos on the mailing
> list info page are broken, someone might want to fix that.
> 
> I posted a message in linux-api yesterday regarding this, but had no
> responses. At this point I am looking for comments regarding these new
> syscalls and the likelyhood of having this patch applied.
> 
> As the engineer for a web hosting company I have seen the need for
> grater control over a processes uid/gid. Currently with shared virtual
> hosting solutions, if for security we wish to run a shared CGI language
> (such as PHP) as the user that owns the website we are forced to fork a
> new process per request, then call setuid/gid and then launch the script
> language. This ofcource is resource intensive, but at present there is
> no other solution.
> 
> My patch adds four new syscalls to the kernel that allows this issue to
> be overcome, and I am sure that it could find application in many other
> programs. The syscalls are:
> 
> * long enable_setpresuid(uid_t start, uid_t end);
> 
> This function enables the use of the setpresuid call for the calling
> process, the calling process has to have CAP_SETUID permission to call
> this function. The start and end parameters specify the uid range that
> the setpresuid must be called with.
> 
> * long enable_setpresgid(gid_t start, gid_t end);
> 
> This function is the same as above, except it enables the setpresgid
> call for the specified gid range.
> 
> * long setpresuid(pid_t pid, uid_t ruid, uid_t euid, uid_t suid);
> 
> This function changes the specified IMMEDIATE child pid's real, saved
> and effective uid to the specified uid. Returns -EPERM if the
> enable_setpresuid call has not been made first.
> 
> * long setpresgid(pid_t pid, gid_t rgid, gid_t egid, gid_t sgid);
> 
> This function does the same as above, except it applies to the group of
> the IMMEDIATE child.
> 
> The reason for the enable functions is so that the calling app can drop
> root privlages after enabling the setpresuid/setpresgid for a certian
> range of uid/gid numbers. This allows the parent process to change its
> child processes (forked) uid/gid at any time without needing root access
> while being secure so that it can not set its child processes to users
> such as root.
> 
> An example of its usage follows...
> 
> int main()
> {
> 	pid_t child;
> 
> 	/* enable the setpres* functions for ids 1000-9999 */
> 	enable_setpresuid(1000, 9999);
> 	enable_setpresgid(1000, 9999);
> 
> 	/* drop to an un-privlaged user */
> 	setresuid(65534, 65534, 65534);
> 
> 	/* fork a useless child for example sake */
> 	child = fork();
> 	if (child == 0) {
> 		sleep(10);
> 		return 0;
> 	}
> 
> 	/* change the childs uid/gid to 1000 */
> 	setpresuid(child, 1000, 1000, 1000);
> 	setpresgid(child, 1000, 1000, 1000);
> 
> 	/* wait for the child to terminate */
> 	wait(NULL);
> 	return 0;
> }
> 
> For the patch and a bit more information please goto:
> http://www.spacevs.com/rambles/setuid2.php
> 
> Even though not stated on the website, this code is released under
> whatever licence is needed to get it into the kernel.
> 
> -Geoffrey McRae
> 

