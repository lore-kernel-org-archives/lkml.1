Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYH2Wp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYH2Wp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbYH2Wps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:45:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755770AbYH2Wpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:45:47 -0400
Date: Fri, 29 Aug 2008 15:45:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dyn_array: using %pF instead of
 print_fn_descriptor_symbol
Message-Id: <20080829154523.b55becd4.akpm@linux-foundation.org>
In-Reply-To: <86802c440808291532r15dd581cj3f69755985578c2b@mail.gmail.com>
References: <1220047669-15029-1-git-send-email-yhlu.kernel@gmail.com>
	<20080829152053.92fa6fd4.akpm@linux-foundation.org>
	<86802c440808291532r15dd581cj3f69755985578c2b@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 15:32:58 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Fri, Aug 29, 2008 at 3:20 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Fri, 29 Aug 2008 15:07:49 -0700
> > Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> +             printk(KERN_DEBUG "per_cpu_dyn_array %pF ==> [%#lx - %#lx]\n",
> >> +                     da->name, phys, phys + size);
> >
> > This:
> >
> > struct dyn_array {
> >        void **name;
> >
> > is a bit confusing.  One normally expects a variable called "name" to
> > point at a character string.
> >
> > What _does_ this thing point at?  There are no code comments which I
> > can find, it's unobvious from the source code, the type is the
> > information-free void** and the identifier is misleading.
> >
> > I find that documenting the data structures is the best way of making
> > code understandable (and hence maintainable).
> 
> struct dyn_array {
>         void **name;
>         unsigned long size;
>         unsigned int *nr;
>         unsigned long align;
>         void (*init_work)(void *);
> };
> extern struct dyn_array *__dyn_array_start[], *__dyn_array_end[];
> extern struct dyn_array *__per_cpu_dyn_array_start[],
> *__per_cpu_dyn_array_end[];
> 
> #define DEFINE_DYN_ARRAY_ADDR(nameX, addrX, sizeX, nrX, alignX, init_workX) \
>                 static struct dyn_array __dyn_array_##nameX __initdata = \
>                 {       .name = (void **)&(nameX),\
>                         .size = sizeX,\
>                         .nr   = &(nrX),\
>                         .align = alignX,\
>                         .init_work = init_workX,\
>                 }; \
>                 static struct dyn_array *__dyn_array_ptr_##nameX __used \
>                 __attribute__((__section__(".dyn_array.init"))) = \
>                         &__dyn_array_##nameX
> 
> #define DEFINE_DYN_ARRAY(nameX, sizeX, nrX, alignX, init_workX) \
>         DEFINE_DYN_ARRAY_ADDR(nameX, nameX, sizeX, nrX, alignX, init_workX)
> 
> and use is
> 
> struct irq_desc *sparse_irqs;
> DEFINE_DYN_ARRAY(sparse_irqs, sizeof(struct irq_desc), nr_irq_desc,
> PAGE_SIZE, init_work);
> 
> 
> then sparse_irqs is pointer, and .name store the address of that pointer.
> 
> later use
> *da->name = phys_to_virt(phys);
> to take back the dyn address.
> 

Well yes, I have a copy of that too.

Why is it called "name"?

