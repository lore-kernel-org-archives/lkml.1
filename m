Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbYLCRUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbYLCRUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYLCRU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:20:26 -0500
Received: from kroah.org ([198.145.64.141]:45234 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752536AbYLCRUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:20:24 -0500
Date: Wed, 3 Dec 2008 09:18:54 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, mingo@elte.hu,
       viro@ZenIV.linux.org.uk, vegard.nossum@gmail.com, ebiederm@xmission.com,
       Yoshiya.Koyama@hp.com, rjw@sisk.pl, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data
	to userspace
Message-ID: <20081203171854.GC17014@kroah.com>
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com> <200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org> <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com> <19f34abd0811040139t8334502i7a5d8501c5fe95ac@mail.gmail.com> <20081104151234.GH28946@ZenIV.linux.org.uk> <20081106100410.GN4890@elte.hu> <20081107190544.GA1551@kroah.com> <20081107231205.GA2528@x200.localdomain> <20081111141412.b52469d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111141412.b52469d2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 02:14:12PM -0800, Andrew Morton wrote:
> On Sat, 8 Nov 2008 02:12:05 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Fri, Nov 07, 2008 at 11:05:44AM -0800, Greg KH wrote:
> > > On Thu, Nov 06, 2008 at 11:04:10AM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > > > 
> > > > > On Tue, Nov 04, 2008 at 10:39:19AM +0100, Vegard Nossum wrote:
> > > > > > On Sun, Oct 26, 2008 at 10:08 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > > > > > # uname -a
> > > > > > Linux localhost.localdomain 2.6.25.11-97.fc9.i686 #1 SMP Mon Jul 21
> > > > > > 01:31:09 EDT 2008 i686 i686 i386 GNU/Linux
> > > > > > # prelink -mRf /sbin/udevd
> > > > > > # ./a.out /proc/564/exe
> > > > > > warning: /proc/564/exe: got return value 38, expected 11
> > > > > > 2f7362696e2f7564657664005f47387942426e5952446e566f306868202864656c6574656429
> > > > > > /sbin/udevd _G8yBBnYRDnVo0hh (deleted)
> > > > > > 
> > > > > > Yoshiya Koyama reports that the problem exists on RHEL 2.6.9-42.ELsmp too.
> > > > > > 
> > > > > > I don't think it's exactly the same problem as originally reported,
> > > > > > because I definitely wasn't using prelinking (the prelink binary
> > > > > > wasn't even installed on the machine until today). But finding the
> > > > > > root cause of this may solve both problems.
> > > > > 
> > > > > switch_names() buggered in case of short names on both sides.  That should
> > > > > help:
> > > > > 
> > > > > >From 2acda856910b774717e0290bbf948c7dee0f2e1a Mon Sep 17 00:00:00 2001
> > > > > From: Al Viro <viro@zeniv.linux.org.uk>
> > > > > Date: Mon, 3 Nov 2008 15:03:50 -0500
> > > > > Subject: [PATCH] fix switch_names() breakage in short-to-short case
> > > > > 
> > > > > We want ->name.len to match the resulting name on *both*
> > > > > source and target
> > > > > 
> > > > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > > > 
> > > > please credit kmemcheck in the commit message and use an appropriate 
> > > > Reported-by line as well. Thanks,
> > > 
> > > Did this fix ever get merged into Linus's tree?
> > 
> > So far no.
> 
> I queued the below for 2.6.28 inclusion and tagged for -stable
> backporting.  


What ever happened to this patch?  Did it not make it into Linus's tree
somehow?

thanks,

greg k-h

(original patch below...)















> From: Al Viro <viro@ZenIV.linux.org.uk>
> 
> Vegard sayeth:
> 
> When I run readlink on the /proc/*/exe-file for udevd, the kernel
> returns some unitialized data to userspace:
> 
> # strace -e trace=readlink readlink /proc/4762/exe
> readlink("/proc/4762/exe", "/sbin/udevd", 1025) = 30
> 
> You can see it because the kernel thinks that the string is 30 bytes
> long, but in fact it is only 12 (including the '\0').
> 
> If we explicitly clear the buffer before calling readlink, we can also
> see that some garbage has been filled in there, after the string:
> 
> # ./readlink /proc/4762/exe
> readlink(/proc/4762/exe) = 30
> 2f7362696e2f7564657664000000ffffffad4effffffadffffffdeffffffffffffffff202864656c657465642900000000000000000000000000000
> 
> (Output is from following simple program:)
> 
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
> 
> int main(int argc, char *argv[])
> {
>         char buf[1024];
>         int i;
>         ssize_t n;
> 
>         memset(buf, 0, sizeof(buf));
>         n = readlink(argv[1], buf, sizeof(buf));
> 
>         printf("readlink(%s) = %d\n", argv[1], n);
> 
>         for (i = 0; i < sizeof(buf); ++i)
>                 printf("%02x", buf[i]);
>         printf("\n");
> 
>         return 0;
> }
> 
> It was discovered by kmemcheck:
> 
> WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6a109e4)
> 64000000ad4eaddeffffffffffffffff000000000200000000000000c0838ff8
>  i i u u u u u u u u u u u u u u u u u u u u u u u u u u u u u u
>          ^
> 
> Pid: 21511, comm: readlink Not tainted (2.6.28-rc1 #58) 945P-A
> EIP: 0060:[<c04f988d>] EFLAGS: 00000296 CPU: 0
> EIP is at __d_path+0x8d/0x1c0
> EAX: 0000000e EBX: d7ba0fe7 ECX: 00000001 EDX: f68b0b40
> ESI: f6a109e4 EDI: d7ba0fef EBP: e58c3f28 ESP: c2569c08
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> CR0: 8005003b CR2: f6c1d704 CR3: 31fc7000 CR4: 00000650
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff4ff0 DR7: 00000400
>  [<c04fa4b0>] d_path+0xb0/0xd0
>  [<c052c37c>] proc_pid_readlink+0x6c/0xc0
>  [<c04eda34>] sys_readlinkat+0x94/0xa0
>  [<c04eda67>] sys_readlink+0x27/0x30
>  [<c0422f83>] sysenter_do_call+0x12/0x3f
>  [<ffffffff>] 0xffffffff
> 
> 
> 
> 
> 
> We want ->name.len to match the resulting name on *both* source and target.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Cc: "Vegard Nossum" <vegard.nossum@gmail.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: <stable@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/dcache.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff -puN fs/dcache.c~vfs-fix-switch_names-breakage-in-short-to-short-case fs/dcache.c
> --- a/fs/dcache.c~vfs-fix-switch_names-breakage-in-short-to-short-case
> +++ a/fs/dcache.c
> @@ -1621,8 +1621,11 @@ static void switch_names(struct dentry *
>  			 */
>  			memcpy(dentry->d_iname, target->d_name.name,
>  					target->d_name.len + 1);
> +			dentry->d_name.len = target->d_name.len;
> +			return;
>  		}
>  	}
> +	do_switch(dentry->d_name.len, target->d_name.len);
>  }
>  
>  /*
> @@ -1682,7 +1685,6 @@ already_unhashed:
>  
>  	/* Switch the names.. */
>  	switch_names(dentry, target);
> -	do_switch(dentry->d_name.len, target->d_name.len);
>  	do_switch(dentry->d_name.hash, target->d_name.hash);
>  
>  	/* ... and switch the parents */
> @@ -1792,7 +1794,6 @@ static void __d_materialise_dentry(struc
>  	struct dentry *dparent, *aparent;
>  
>  	switch_names(dentry, anon);
> -	do_switch(dentry->d_name.len, anon->d_name.len);
>  	do_switch(dentry->d_name.hash, anon->d_name.hash);
>  
>  	dparent = dentry->d_parent;
> _
