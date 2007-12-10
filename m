Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbXLJWVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbXLJWVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 17:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXLJWUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 17:20:53 -0500
Received: from imap.vc.cvut.cz ([147.32.240.222]:45939 "EHLO imap.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbXLJWUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 17:20:52 -0500
X-Greylist: delayed 1781 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2007 17:20:51 EST
Message-ID: <1197322514.475db112ac621@imap.vc.cvut.cz>
Date: Mon, 10 Dec 2007 22:35:14 +0100
From: vandrove@vc.cvut.cz
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Denis V. Lunev" <den@sw.ru>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, rjw@sisk.pl,
       trond.myklebust@fys.uio.no, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org, den@openvz.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 2.6.24-rc4] proc: Remove/Fix proc generic d_revalidate
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com> <1197067918.10831.13.camel@heimdal.trondhjem.org> <20071207151444.af5d8e11.akpm@linux-foundation.org> <200712080043.29292.rjw@sisk.pl> <20071208000043.GC1951@martell.zuzino.mipt.ru> <20071207161508.afe8fdf1.akpm@linux-foundation.org> <m1lk85q0cw.fsf_-_@ebiederm.dsl.xmission.com> <475CA9EA.1090405@vc.cvut.cz> <475D3FE2.202@sw.ru> <20071210113519.00d4d361.akpm@linux-foundation.org>
In-Reply-To: <20071210113519.00d4d361.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.0
X-Originating-IP: 65.113.40.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton <akpm@linux-foundation.org>:

> On Mon, 10 Dec 2007 16:32:18 +0300 "Denis V. Lunev" <den@sw.ru> wrote:
> >
> 
> Plese don't top-post.  It makes replying to you rather awkward.
> 
> > could you, plz, check patch sent by Eric above in this thread.
> > 
> > I have tried it on my test node and it works for module you have
> > provided. The problem exists without it.
> > 
> 
> When Peter says "with your patch in place" I assume that he's referring to
> Eric's latest patch, namely.

Sorry, I was not clear.  No, I meant Eric's original patch.  Without
d_revalidate() problem does not occur.
                                                   Petr

> 
> --- a/fs/proc/generic.c~proc-remove-fix-proc-generic-d_revalidate
> +++ a/fs/proc/generic.c
> @@ -374,16 +374,9 @@ static int proc_delete_dentry(struct den
>  	return 1;
>  }
>  
> -static int proc_revalidate_dentry(struct dentry *dentry, struct nameidata
> *nd)
> -{
> -	d_drop(dentry);
> -	return 0;
> -}
> -
>  static struct dentry_operations proc_dentry_operations =
>  {
>  	.d_delete	= proc_delete_dentry,
> -	.d_revalidate	= proc_revalidate_dentry,
>  };
>  
>  /*
> 
> So we still have problems, it appears.
> 
> > 
> > Petr Vandrovec wrote:
> > > Eric W. Biederman wrote:
> > >> Ultimately to implement /proc perfectly we need an implementation
> > >> of d_revalidate because files and directories can be removed behind
> > >> the back of the VFS, and d_revalidate is the only way we can let
> > >> the VFS know that this has happened.
> > >>
> > >> So until we get a proper test for keeping dentries in the dcache
> > >> fix the current d_revalidate method by completely removing it.  This
> > >> returns us to the current status quo.
> > > 
> > > Hello,
> > >    I know that I'm late to the party, but mount points is not only
> > > problem with d_revalidate.  With your patch in place module below gets
> > > refcount incremented by two every time I do 'ls -la /proc/fs/vmblock'.
> > > 
> > >
> > > #include <linux/kernel.h>
> > > #include <linux/module.h>
> > > #include <linux/proc_fs.h>
> > > 
> > > static int vmblockinit(void) {
> > >    struct proc_dir_entry *controlProcDirEntry;
> > > 
> > >    /* Create /proc/fs/vmblock */
> > >    controlProcDirEntry = proc_mkdir("vmblock", proc_root_fs);
> > >    if (!controlProcDirEntry) {
> > >       printk(KERN_DEBUG "Bad...\n");
> > >       return -EINVAL;
> > >    }
> > >    controlProcDirEntry->owner = THIS_MODULE;
> > >    return 0;
> > > }
> > > 
> > > static void vmblockexit(void) {
> > >    remove_proc_entry("vmblock", proc_root_fs);
> > > }
> > > 
> > > module_init(vmblockinit);
> > > module_exit(vmblockexit);
> > > 
> > > 
> > > (code comes from VMware's vmblock module,
> > > http://sourceforge.net/project/showfiles.php?group_id=204462)
> > >                         Thanks,
> > >                             Petr
> > > 
> > > 
> 
> 
> 



