Return-Path: <linux-kernel-owner+w=401wt.eu-S934341AbZIOC5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341AbZIOC5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934211AbZIOC5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:57:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:18348 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933071AbZIOC5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:57:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,386,1249282800"; 
   d="c'?scan'208";a="187631092"
Date: Tue, 15 Sep 2009 10:57:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "mtosatti@redhat.com" <mtosatti@redhat.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
       "avi@qumranet.com" <avi@qumranet.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       WANG Cong <xiyou.wangcong@gmail.com>, Mike Smith <scgtrp@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] devmem: handle partial kmem write/read
Message-ID: <20090915025710.GA23881@localhost>
References: <20090914032901.GA16189@localhost> <20090914043444.GA18590@localhost> <20090915092448.d511df31.kamezawa.hiroyu@jp.fujitsu.com> <20090915020208.GA15159@localhost> <20090915113113.126f90f0.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20090915113113.126f90f0.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 15, 2009 at 10:31:13AM +0800, KAMEZAWA Hiroyuki wrote:
> On Tue, 15 Sep 2009 10:02:08 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Tue, Sep 15, 2009 at 08:24:48AM +0800, KAMEZAWA Hiroyuki wrote:
> > > On Mon, 14 Sep 2009 12:34:44 +0800
> > > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > > Hi Kame,
> > > > 
> > > > This patch needs more work. I first intent to fix a bug:
> > > > 
> > > >                         sz = vwrite(kbuf, (char *)p, sz);
> > > >                         p += sz;
> > > >                 }
> > > > 
> > > > So if the returned len is 0, the kbuf/p pointers will mismatch. 
> > > > 
> > > > Then I realize it changed the write behavior. The current vwrite()
> > > > behavior is strange, it returns 0 if _whole range_ is hole, otherwise
> > > > ignores the hole silently. So holes can be treated differently even in
> > > > the original code.
> > > > 
> > > Ah, ok...
> > > 
> > > > I'm not really sure about the right behavior. KAME-san, do you have
> > > > any suggestions?
> > > > 
> > > maybe following make sense.
> > > =
> > > written = vwrite(kbuf, (char *p), sz);
> > > if (!written) // whole vmem was a hole
> > > 	written = sz;
> > 
> > Since the 0 return value won't be used at all, it would be simpler to
> > tell vwrite() return the untouched buflen/sz, like this. It will ignore
> > _all_ the holes silently. Need to update comments too.
> > 
> 
> Hmm. IIUC the original kmem code returns immediately if vread/vwrite returns 0.

Agreed for vread. It seems vwrite don't do that for both kmem and
vmalloc part.

> But it seems this depends on wrong assumption that vmap area is continuous,
> at the first look.

You mean it is possible that not all pages are mapped in a vmlist addr,size range?
Is vmalloc areas guaranteed to be page aligned? Sorry for the dumb questions.

> In man(4) mem,kmem
> ==
>        Byte  addresses  in  mem  are interpreted as physical memory addresses.
>        References to nonexistent locations cause errors to be returned.
> 	.....
>        The file kmem is the same as mem, except that the kernel virtual memory
>        rather than physical memory is accessed.
> 
> ==
> 
> Then, we have to return error for accesses to "nonexistent locations".

That's one important factor to consider. On the other hand, the
original kmem read/write implementation don't return error code for
holes. Instead kmem read returns early, while kmem write ignores holes
but is buggy..

> memory-hole in vmap area is ....."nonexistent" ? 
> I think it's nonexistent if there are no overlaps between requested [pos, pos+len)
> and registerred vmalloc area.
> But, hmm, there are no way for users to know "existing vmalloc area".
> Then, my above idea may be wrong.
> 
> Then, I'd like to modify as following,
> 
>   - If is_vmalloc_or_module_addr(requested address) is false, return -EFAULT.
>   - If is_vmalloc_or_module_addr(requested address) is true, return no error.
>     Even if specified range doesn't include no exsiting vmalloc area.
> 
> How do you think ?

Looks reasonable to me. But it's good to hear more wide opinions..

> Thanks,
> -Kame
> p.s. I wonder current /dev/kmem cannot read text area of kernel if it's not
> directly mapped.

Attached is a small tool (from LKML) for reading 'modprobe_path' from kmem,
it's not text, but is close..

Thanks,
Fengguang

> 
> 
> > --- linux-mm.orig/mm/vmalloc.c  2009-09-15 09:40:08.000000000 +0800                                                                  
> > +++ linux-mm/mm/vmalloc.c       2009-09-15 09:43:33.000000000 +0800                                                                  
> > @@ -1834,7 +1834,6 @@ long vwrite(char *buf, char *addr, unsig                                                                       
> >         struct vm_struct *tmp;                                                                                                       
> >         char *vaddr;                                                                                                                 
> >         unsigned long n, buflen;                                                                                                     
> > -       int copied = 0;                                                                                                              
> >                                                                                                                                      
> >         /* Don't allow overflow */                                                                                                   
> >         if ((unsigned long) addr + count < count)                                                                                    
> > @@ -1858,7 +1857,6 @@ long vwrite(char *buf, char *addr, unsig                                                                       
> >                         n = count;                                                                                                   
> >                 if (!(tmp->flags & VM_IOREMAP)) {                                                                                    
> >                         aligned_vwrite(buf, addr, n);                                                                                
> > -                       copied++;                                                                                                    
> >                 }                                                                                                                    
> >                 buf += n;                                                                                                            
> >                 addr += n;                                                                                                           
> > @@ -1866,8 +1864,6 @@ long vwrite(char *buf, char *addr, unsig                                                                       
> >         }                                                                                                                            
> >  finished:                                                                                                                           
> >         read_unlock(&vmlist_lock);                                                                                                   
> > -       if (!copied)                                                                                                                 
> > -               return 0;                                                                                                            
> >         return buflen;                                                                                                               
> >  }                                                                                                                                   
> > 
> > > ==
> > > needs fix.
> > > 
> > > Anyway, I wonder kmem is broken. It's should be totally rewritten.
> > > 
> > > For example, this doesn't check anything.
> > > ==
> > >         if (p < (unsigned long) high_memory) {
> > > 
> > > ==
> > > 
> > > But....are there users ?
> > > If necessary, I'll write some...
> > 
> > I'm trying to stop possible mem/kmem users to access hwpoison pages.. 
> > I'm not the user, but rather a tester ;)
> > 
> > Thanks,
> > Fengguang
> > 
> > > Thanks,
> > > -Kame
> > > 
> > > 
> > > > Thanks,
> > > > Fengguang
> > > > 
> > > > On Mon, Sep 14, 2009 at 11:29:01AM +0800, Wu Fengguang wrote:
> > > > > Current vwrite silently ignores vwrite() to vmap holes.
> > > > > Better behavior should be stop the write and return
> > > > > on such holes.
> > > > > 
> > > > > Also return on partial read, which may happen in future
> > > > > (eg. hit hwpoison pages).
> > > > > 
> > > > > CC: Andi Kleen <andi@firstfloor.org>
> > > > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > > > ---
> > > > >  drivers/char/mem.c |   30 ++++++++++++++++++------------
> > > > >  1 file changed, 18 insertions(+), 12 deletions(-)
> > > > > 
> > > > > --- linux-mm.orig/drivers/char/mem.c	2009-09-14 10:59:50.000000000 +0800
> > > > > +++ linux-mm/drivers/char/mem.c	2009-09-14 11:06:25.000000000 +0800
> > > > > @@ -444,18 +444,22 @@ static ssize_t read_kmem(struct file *fi
> > > > >  		if (!kbuf)
> > > > >  			return -ENOMEM;
> > > > >  		while (count > 0) {
> > > > > +			unsigned long n;
> > > > > +
> > > > >  			sz = size_inside_page(p, count);
> > > > > -			sz = vread(kbuf, (char *)p, sz);
> > > > > -			if (!sz)
> > > > > +			n = vread(kbuf, (char *)p, sz);
> > > > > +			if (!n)
> > > > >  				break;
> > > > > -			if (copy_to_user(buf, kbuf, sz)) {
> > > > > +			if (copy_to_user(buf, kbuf, n)) {
> > > > >  				free_page((unsigned long)kbuf);
> > > > >  				return -EFAULT;
> > > > >  			}
> > > > > -			count -= sz;
> > > > > -			buf += sz;
> > > > > -			read += sz;
> > > > > -			p += sz;
> > > > > +			count -= n;
> > > > > +			buf += n;
> > > > > +			read += n;
> > > > > +			p += n;
> > > > > +			if (n < sz)
> > > > > +				break;
> > > > >  		}
> > > > >  		free_page((unsigned long)kbuf);
> > > > >  	}
> > > > > @@ -551,11 +555,13 @@ static ssize_t write_kmem(struct file * 
> > > > >  				free_page((unsigned long)kbuf);
> > > > >  				return -EFAULT;
> > > > >  			}
> > > > > -			sz = vwrite(kbuf, (char *)p, sz);
> > > > > -			count -= sz;
> > > > > -			buf += sz;
> > > > > -			virtr += sz;
> > > > > -			p += sz;
> > > > > +			n = vwrite(kbuf, (char *)p, sz);
> > > > > +			count -= n;
> > > > > +			buf += n;
> > > > > +			virtr += n;
> > > > > +			p += n;
> > > > > +			if (n < sz)
> > > > > +				break;
> > > > >  		}
> > > > >  		free_page((unsigned long)kbuf);
> > > > >  	}
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > Please read the FAQ at  http://www.tux.org/lkml/
> > > > 
> > 

--vkogqOf2sHV7VnPd
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="tmap.c"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/poll.h>
#include <sys/mman.h>

int page_size;
#define PAGE_SIZE page_size
#define PAGE_MASK (~(PAGE_SIZE-1))

void get_var (unsigned long addr) {
	off_t ptr = addr & ~(PAGE_MASK);
	off_t offset = addr & PAGE_MASK;
	int i = 0;
	char *map;
	static int kfd = -1;

	kfd = open("/dev/kmem",O_RDONLY);
	if (kfd < 0) {
		perror("open");
		exit(0);
	}

	map = mmap(NULL,PAGE_SIZE,PROT_READ,MAP_SHARED,kfd,offset);
	if (map == MAP_FAILED) {
		perror("mmap");
		exit(-1);
	}
	printf("%s\n",map+ptr);

	return;
}

int main(int argc, char **argv)
{
	FILE *fp;
	char addr_str[11]="0x";
	char var[51];
	unsigned long addr;
	char ch;
	int r;

	if (argc != 2) {
		fprintf(stderr,"usage: %s System.map\n",argv[0]);
		exit(-1);
	}

	if ((fp = fopen(argv[1],"r")) == NULL) {
		perror("fopen");
		exit(-1);
	}

	do {
		/* ffffffff81723880 D modprobe_path */
		r = fscanf(fp,"%16s %c %50s\n",&addr_str[2],&ch,var);
		if (strcmp(var,"modprobe_path")==0)
			break;
	} while(r > 0);
	if (r < 0) {
		printf("could not find modprobe_path\n");
		exit(-1);
	}
	page_size = getpagesize();
	addr = strtoul(addr_str,NULL,16);
	printf("found modprobe_path at (%s) %08lx\n",addr_str,addr);
	get_var(addr);

	return 0;
}


--vkogqOf2sHV7VnPd--
