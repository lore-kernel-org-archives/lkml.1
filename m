Return-Path: <linux-kernel-owner+w=401wt.eu-S1762381AbYD2VGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762381AbYD2VGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYD2VGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:06:15 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:34924 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755266AbYD2VGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:06:14 -0400
Message-ID: <48178DEB.90200@henry.ne.arcor.de>
Date: Tue, 29 Apr 2008 23:06:51 +0200
From: Henry Nestler <Henry.Ne@Arcor.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux
 2.6
References: <480E6BB4.5080902@henry.nestler.gmail.com>	 <480E8069.20502@henry.ne.arcor.de> <20080428164634.GC18210@elte.hu>	 <48164E29.4080409@henry.ne.arcor.de> <20080429143314.GG26461@elte.hu> <84144f020804290814o18f4868tf6536cc7f16cb8d7@mail.gmail.com>
In-Reply-To: <84144f020804290814o18f4868tf6536cc7f16cb8d7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Tue, Apr 29, 2008 at 5:33 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>  btw., i have a kmemcheck-reported bug fixed in this same area with the
>>  patch below. I dont remember the details anymore, but the root mount
>>  code did something really, really weird here.
>>
>>  Subject: init: root mount fix
>>  From: Ingo Molnar <mingo@elte.hu>
>>  Date: Tue Apr 29 16:31:50 CEST 2008
>>
>>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>  ---
>>   init/do_mounts.c |    8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>>  Index: linux/init/do_mounts.c
>>  ===================================================================
>>  --- linux.orig/init/do_mounts.c
>>  +++ linux/init/do_mounts.c
>>  @@ -201,9 +201,13 @@ static int __init do_mount_root(char *na
>>         return 0;
>>   }
>>
>>  +#if PAGE_SIZE < PATH_MAX
>>  +# error increase the fs_names allocation size here
>>  +#endif
>>
>> +
>>   void __init mount_block_root(char *name, int flags)
>>   {
>>  -       char *fs_names = __getname();
>>  +       char *fs_names = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
>>
>>         char *p;
>>   #ifdef CONFIG_BLOCK
>>         char b[BDEVNAME_SIZE];
>>  @@ -251,7 +255,7 @@ retry:
>>
>>  #endif
>>         panic("VFS: Unable to mount root fs on %s", b);
>>   out:
>>  -       putname(fs_names);
>>  +       free_pages((unsigned long)fs_names, 1);
>>   }
>>
>>   #ifdef CONFIG_ROOT_NFS
> 
> It could have been a bug in early kmemcheck too. We don't check memory
> allocated with the page allocator, only slab, so this shouldn't
> trigger anything.
> 

Using "__get_free_pages" don't help. The real problem is the page after
the allocated page. Not the page where fs_names starts.

Have just printk some adresses from fs_names. They are c1152000,
c1150000, c2736000, c0450000, and so. All this adresses are not in
vmalloc. See boot messages. Was booting with mem=40:
  virtual kernel memory layout:
    fixmap  : 0xffffc000 - 0xfffff000   (  12 kB)
    vmalloc : 0xc3000000 - 0xffffa000   ( 975 MB)
    lowmem  : 0xc0000000 - 0xc2800000   (  40 MB)

In mount_block_root the loop
   for (p = fs_names; *p; p += strlen(p)+1) {
can point behind the allocated page. What is, if the function
exact_copy_from_user access to "p+PAGE_SIZE" where p=fs_names+9 and this
page is not mapped?

The problem I see, is, that sys_mount is designed for userland calls.
But mount_block_root give kernel space as parameter (address >=
c000000). In mount_block_root (fs/namespace.c) the size will roll over,
and is limited to PAGE_SIZE. For example TASK_SIZE=c0000000,
data=c1152000...c2736000:
   size = TASK_SIZE - (unsigned long)data;
   if (size > PAGE_SIZE)
           size = PAGE_SIZE;
   i = size - exact_copy_from_user((void *)page, data, size);

There, "exact_copy_from_user" is all times called with 4096 as size, if
comes from mount_block_root. That's why I would give only page aligned
parameters from mount_block_root to sys_mount.

Sorry, that I operate with hexnumbers. Memory mapping is not my favorite
source code, and with the numbers it is more clear to see here.

-- 
Henry N.
