Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbYE0OAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbYE0OAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbYE0OAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:00:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:56889 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756240AbYE0OAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:00:37 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18pNZczScUpnVuaM5BXtmXYaR/kQ8t5s7u3QKA/o/
	lDZUMueWHGEp6P
Date: Tue, 27 May 2008 16:00:31 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: vegardno@ifi.uio.no, penberg@cs.helsinki.fi
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Message-ID: <20080527140031.GA3380@alice>
References: <20080526143422.GA3203@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080526143422.GA3203@alice>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26-rc3 (x86_64)
X-Uptime: 15:54:28 up  3:11,  1 user,  load average: 0.04, 0.43, 0.68
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i tested a kmemcheck kernel as an attempt to debug
this further... seems CONFIG_SECURITY is unrelated to
this, but slub debugging only catches the
overwrite it if i enable CONFIG_SECURITY.

with slub_debug=FZPU i get the warning at
init_object+0x63:

(gdb) l *(init_object+0x63)
0xc0187243 is in init_object (mm/slub.c:544).
539	{
540		u8 *p = object;
541	
542		if (s->flags & __OBJECT_POISON) {
543			memset(p, POISON_FREE, s->objsize - 1);
544			p[s->objsize - 1] = POISON_END;
545		}
546	
547		if (s->flags & SLAB_RED_ZONE)
548			memset(p + s->objsize,

if i set slub_debug=- i get the kmemcheck warning at

(gdb) l *(__slab_alloc+0x238)
0xc0187bc8 is in __slab_alloc (mm/slub.c:303).
298		return *(void **)(object + s->offset);
299	}
300	
301	static inline void set_freepointer(struct kmem_cache *s, void
*object, void *fp)
302	{
303		*(void **)(object + s->offset) = fp;
304	}
305	
306	/* Loop over all objects in a slab */
307	#define for_each_object(__p, __s, __addr, __objects) \

I used the kmemcheck git tree from
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-kmemcheck-4.git

In case you need some of the other kmemcheck output please
let me know.

Greetings, Eric

* Eric Sesterhenn (snakebyte@gmx.de) wrote:
> hi,
> 
> i enabled CONFIG_SECURITY on current git and get tons of
> Redzone overwritten errors during early boot, even
> with CONFIG_SECURITY_CAPABILITIES and CONFIG_SECURITY_NETWORK
> disabled. After a while it ends with a kernel panic
> saying: not syncing: Out of memory and no killable process...
> Root partition is ext3 format.
> 
> At the moment i dont have a camera at hand, so i'll try
> to write down everything which looks interesting, please tell
> me if i missed something.
> 
> The first 24 Bytes of the overwritten section contain
> zeros. Then we have a constant 0x18, and three changing
> values. the next three bites contain exactly the same
> values, first the 0x18, then the two changing ones.
> 
> The only value i found so far matching the 0x18 and
> which might be related to CONFIG_SECURITY is CAP_SYS_RESOURCE
> defined in /include/linux/capability.h
> 
> BUG hugetlbfs_inode_cache: Redzone overwritten
> 
> INFO: 0xccd8e250-0xccd8e253. First byte 0x0 instead of 0xbb
> Info: Slab 0xc119d1c0 objects=12 used=0 fs=0xccd8e000 flags=0x400020c3
> Info: Object 0xccd8e00 offset=0 fp=0xccd8e280
> 
> Object 0xccd8e00: 00 00 00 ...
> Object 0xccd8e10: 00 00 00 00 00 00 00 00 00 18 e0 d8 cc 18 e0 d8 cc
> Object 0xccd8e20  00 00 00 ...
> ...
> 
> Pid: 1, comm:swapper Not tainted 2.6.26-rc3-00436-gb373303 #42
> print_trailer
> check_bytes_and_report
> check_object
> __slab_alloc
> kmem_cache_alloc
> ? hugetlbfs_alloc_inode
> ? hugetlbfs_alloc_inode
> hugetlbfs_alloc_inode
> alloc_inote
> new_inode
> hugetlbs_get_inote
> hugetlbfs_fill_super
> ? sget
> ? set_anon_super
> get_sb_node
> hugetlbfs_get_sb
> ? hugetlbfs_fill_super
> vfs_kern_mount
> kern_mount_data
> init_hugetlbfs_fs
> ? init_once
> ? kernel_init
> kernel_init
