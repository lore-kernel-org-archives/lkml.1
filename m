Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0CHXCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:02:33 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40732 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0CHXCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:02:30 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	<20100308094647.GA14268@elte.hu>
	<20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	<20100308190857.400bde09@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003081115280.3989@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 08 Mar 2010 15:02:22 -0800
In-Reply-To: <alpine.LFD.2.00.1003081115280.3989@localhost.localdomain> (Linus Torvalds's message of "Mon\, 8 Mar 2010 11\:18\:33 -0800 \(PST\)")
Message-ID: <m1fx4apgch.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 8 Mar 2010, Alan Cox wrote:
>>
>> Quite untrue. I've actually *used* path based security systems (DEC10
>> ACLs) and for almost every case its brain-dead.
>> 
>> Imagine a world where this happened
>
> Alan, stop right there.
>
> You're making the same silly and incorrect mistake that Al did.
>
> Namely thinking that you have to have just one or the other.
>
> When you say "your /etc/passwd example is a special case", you are 
> admitting that there are two different cases, but then after that,  you 
> still don't see the whole point I'm trying to make.
>
> Let me try again:
>
>   THERE ARE DIFFERENT CASES
>
> That's the point. Just admit that, and then let the calm of "Ooh, there 
> are different kinds of circumstances that may want different kinds of 
> rules" permeate you.
>
> My whole (and only) argument is against the "only one way is correct" 
> mentality.


Reading through all of this it occurred to me there is a case where
path names are fundamentally important shows up for me all of the
time.  If pathnames were not fundamentally important we could apply
a patch like the one below and allow unprivileged users to unshare
the mount namespace and mount filesystems wherever.  There is nothing
fundamental about those operations that require root privileges except
that you are manipulating the pathnames of objects.

Unfortunately if we did that suid executables would become impossible
because they couldn't trust anything to start with.

Even little things like /lib64/ld-linux-x86-64.so are very special things
that you can't let just anyone change.

Eric


diff --git a/fs/namespace.c b/fs/namespace.c
index d69c06f..85ba785 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1650,10 +1650,6 @@ static int do_new_mount(struct path *path, char *type, int flags,
 	if (!type)
 		return -EINVAL;
 
-	/* we need capabilities... */
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	lock_kernel();
 	mnt = do_kern_mount(type, flags, name, data);
 	unlock_kernel();
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 1e8cda0..00fd7c5 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -180,9 +180,6 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 			       CLONE_NEWNET | CLONE_NEWPID)))
 		return 0;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	*new_nsp = create_new_namespaces(unshare_flags, current,
 				new_fs ? new_fs : current->fs);
 	if (IS_ERR(*new_nsp)) {

