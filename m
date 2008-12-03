Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbYLCDmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbYLCDmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 22:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYLCDmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 22:42:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34150 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbYLCDmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 22:42:31 -0500
Subject: Re: [RFC PATCH 1/3] adding mmap support to the unified trace buffer
From: Steven Rostedt <srostedt@redhat.com>
To: Jiaying Zhang <jiayingz@google.com>
Cc: linux-kernel@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       Michael Rubin <mrubin@google.com>, Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <5df78e1d0812021655p6819d893v113848ae7bf4b4ee@mail.gmail.com>
References: <5df78e1d0812021625q8a0d362i5d7a650543157864@mail.gmail.com>
	 <5df78e1d0812021655p6819d893v113848ae7bf4b4ee@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 02 Dec 2008 22:42:13 -0500
Message-Id: <1228275733.4886.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-12-02 at 16:55 -0800, Jiaying Zhang wrote:
> Refer to the previous email
> "[RFC PATCH 0/3] A couple of feature requests to the unified trace buffer".
> 
> Add the mmap support to the unified trace buffer. The patch includes an
> API that maps a page offset to a physical page in a trace buffer, APIs
> that export the offset of the current produced/consumed data, and an
> API to advance the consumed data pointer.
> 
> Index: linux-2.6.26/include/linux/ring_buffer.h
> ===================================================================
> --- linux-2.6.26.orig/include/linux/ring_buffer.h       2008-12-01
> 14:46:11.000000000 -0800
> +++ linux-2.6.26/include/linux/ring_buffer.h    2008-12-01
> 14:46:30.000000000 -0800
> @@ -5,6 +5,7 @@
>  #include <linux/seq_file.h>
> 
>  struct ring_buffer;
> +struct ring_buffer_per_cpu;
>  struct ring_buffer_iter;
> 
>  /*
> @@ -108,6 +109,7 @@
> 
>  int ring_buffer_empty(struct ring_buffer *buffer);
>  int ring_buffer_empty_cpu(struct ring_buffer *buffer, int cpu);
> +int ring_buffer_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer);
> 
>  void ring_buffer_record_disable(struct ring_buffer *buffer);
>  void ring_buffer_record_enable(struct ring_buffer *buffer);
> @@ -124,4 +126,12 @@
>        RB_FL_OVERWRITE         = 1 << 0,
>  };
> 
> +struct ring_buffer_per_cpu *ring_buffer_cpu(struct ring_buffer *buffer,
> +               int cpu);
> +struct page * ring_buffer_get_page(struct ring_buffer_per_cpu *cpu_buffer,
> +               pgoff_t pgoff);
> +void ring_buffer_advance_reader(struct ring_buffer_per_cpu *cpu_buffer,
> +               int count_in);
> +u32 ring_buffer_get_produced(struct ring_buffer_per_cpu *cpu_buffer);
> +u32 ring_buffer_get_consumed(struct ring_buffer_per_cpu *cpu_buffer);
>  #endif /* _LINUX_RING_BUFFER_H */
> Index: linux-2.6.26/kernel/ktrace/ring_buffer.c
> ===================================================================
> --- linux-2.6.26.orig/kernel/ktrace/ring_buffer.c       2008-12-01
> 14:46:11.000000000 -0800
> +++ linux-2.6.26/kernel/ktrace/ring_buffer.c    2008-12-01
> 16:03:01.000000000 -0800
> @@ -131,7 +131,6 @@
>  {
>        if (bpage->page)
>                free_page((unsigned long)bpage->page);
> -       kfree(bpage);
>  }
> 
>  /*
> @@ -155,6 +154,7 @@
>        spinlock_t                      lock;
>        struct lock_class_key           lock_key;
>        struct list_head                pages;
> +       struct buffer_page              *page_array;
>        struct buffer_page              *head_page;     /* read from head */
>        struct buffer_page              *tail_page;     /* write to tail */
>        struct buffer_page              *commit_page;   /* commited pages */
> @@ -186,6 +186,11 @@
>        u64                             read_stamp;
>  };
> 
> +struct ring_buffer_per_cpu *ring_buffer_cpu(struct ring_buffer
> *buffer, int cpu)
> +{
> +       return buffer->buffers[cpu];
> +}
> +
>  #define RB_WARN_ON(buffer, cond)                               \
>        do {                                                    \
>                if (unlikely(cond)) {                           \
> @@ -238,25 +243,26 @@
>        return 0;
>  }
> 
> +#define BP_HEADER_SIZE  ALIGN(sizeof(struct buffer_page), cache_line_size())
> +
>  static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>                             unsigned nr_pages)
>  {
>        struct list_head *head = &cpu_buffer->pages;
> -       struct buffer_page *page, *tmp;
> +       struct buffer_page *page;
> +       void *array;
>        unsigned long addr;
>        LIST_HEAD(pages);
>        unsigned i;
> 
> +       array = cpu_buffer->page_array;
>        for (i = 0; i < nr_pages; i++) {
> -               page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
> -                                   GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
> -               if (!page)
> -                       goto free_pages;
> -               list_add(&page->list, &pages);
> +               page = (struct buffer_page *) (array + i * BP_HEADER_SIZE);
> +               list_add_tail(&page->list, &pages);
> 
>                addr = __get_free_page(GFP_KERNEL);
>                if (!addr)
> -                       goto free_pages;
> +                       return -ENOMEM;

Hmm, where do you free the page added by __get_free_page?

>                page->page = (void *)addr;
>        }
> 
> @@ -265,13 +271,6 @@
>        rb_check_pages(cpu_buffer);
> 
>        return 0;
> -
> - free_pages:
> -       list_for_each_entry_safe(page, tmp, &pages, list) {
> -               list_del_init(&page->list);
> -               free_buffer_page(page);

free_buffer_page() also frees the real page that was added.

> -       }
> -       return -ENOMEM;
>  }
> 
>  static struct ring_buffer_per_cpu *
> @@ -292,22 +291,23 @@
>        spin_lock_init(&cpu_buffer->lock);
>        INIT_LIST_HEAD(&cpu_buffer->pages);
> 
> -       page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
> -                           GFP_KERNEL, cpu_to_node(cpu));
> -       if (!page)
> +       cpu_buffer->page_array = kzalloc_node(BP_HEADER_SIZE * buffer->pages,
> +                       GFP_KERNEL, cpu_to_node(cpu));

There was talk about buffer->pages * BP_HEADER_SIZE growing larger than
what kalloc can handle. This is why I went with the link list.


> +       if (!cpu_buffer->page_array)
>                goto fail_free_buffer;
> 
> +       page = (struct buffer_page *) ((void *) cpu_buffer->page_array +
> +                       BP_HEADER_SIZE * (buffer->pages -1));

BTW, one of my patches moves some of the data into the front of the
page. That is, each page will now have meta data at the beginning. This
is to help with splice, that we do not need to bind the buffer_page with
the page itself for later use. What I moved into the page was the
timestamp and "commit" which is also the size of data on that page.

With that, do you still need to make an array here?

>        cpu_buffer->reader_page = page;
>        addr = __get_free_page(GFP_KERNEL);
>        if (!addr)
> -               goto fail_free_reader;
> +               goto fail_free_array;
>        page->page = (void *)addr;
> -
>        INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
> 
> -       ret = rb_allocate_pages(cpu_buffer, buffer->pages);
> +       ret = rb_allocate_pages(cpu_buffer, buffer->pages - 1);
>        if (ret < 0)
> -               goto fail_free_reader;
> +               goto fail_free_array;
> 
>        cpu_buffer->head_page
>                = list_entry(cpu_buffer->pages.next, struct buffer_page, list);
> @@ -315,8 +315,8 @@
> 
>        return cpu_buffer;
> 
> - fail_free_reader:
> -       free_buffer_page(cpu_buffer->reader_page);
> + fail_free_array:
> +       kfree(cpu_buffer->page_array);

Again, you have a huge memory leak here. Nothing freed the allocate
pages in the array.

> 
>  fail_free_buffer:
>        kfree(cpu_buffer);
> @@ -335,6 +335,7 @@
>                list_del_init(&page->list);
>                free_buffer_page(page);
>        }
> +       kfree(cpu_buffer->page_array);
>        kfree(cpu_buffer);
>  }
> 
> @@ -439,7 +440,7 @@
> 
>        for (i = 0; i < nr_pages; i++) {
>                BUG_ON(list_empty(&cpu_buffer->pages));
> -               p = cpu_buffer->pages.next;
> +               p = cpu_buffer->pages.prev;
>                page = list_entry(p, struct buffer_page, list);
>                list_del_init(&page->list);
>                free_buffer_page(page);
> @@ -497,7 +498,7 @@
>  {
>        struct ring_buffer_per_cpu *cpu_buffer;
>        unsigned nr_pages, rm_pages, new_pages;
> -       struct buffer_page *page, *tmp;
> +       struct buffer_page *page, *array;
>        unsigned long buffer_size;
>        unsigned long addr;
>        LIST_HEAD(pages);
> @@ -544,23 +545,23 @@

Can you run the diff output with '-p' so that we can see the function
each change is in.

>        new_pages = nr_pages - buffer->pages;
> 
>        for_each_buffer_cpu(buffer, cpu) {
> +               cpu_buffer = buffer->buffers[cpu];
> +               array = kzalloc_node(BP_HEADER_SIZE * nr_pages,
> +                       GFP_KERNEL, cpu_to_node(cpu));

There's no error check here.

> +               memcpy(array, cpu_buffer->page_array,
> +                               BP_HEADER_SIZE * buffer->pages);
>                for (i = 0; i < new_pages; i++) {
> -                       page = kzalloc_node(ALIGN(sizeof(*page),
> -                                                 cache_line_size()),
> -                                           GFP_KERNEL, cpu_to_node(cpu));
> -                       if (!page)
> -                               goto free_pages;
> -                       list_add(&page->list, &pages);
> +                       page = (struct buffer_page *) ((void *) array +
> +                                       (buffer->pages + i) * BP_HEADER_SIZE);

This looks totally busted.

>                        addr = __get_free_page(GFP_KERNEL);
>                        if (!addr)
> -                               goto free_pages;
> +                               return -ENOMEM;

Again, nothing freed the pages that were allocated.

>                        page->page = (void *)addr;
> +                       list_add_tail(&page->list, &pages);
>                }
> -       }
> -
> -       for_each_buffer_cpu(buffer, cpu) {
> -               cpu_buffer = buffer->buffers[cpu];
>                rb_insert_pages(cpu_buffer, &pages, new_pages);
> +               kfree(cpu_buffer->page_array);
> +               cpu_buffer->page_array = array;
>        }
> 
>        BUG_ON(!list_empty(&pages));
> @@ -570,13 +571,6 @@
>        mutex_unlock(&buffer->mutex);
> 
>        return size;
> -
> - free_pages:
> -       list_for_each_entry_safe(page, tmp, &pages, list) {
> -               list_del_init(&page->list);
> -               free_buffer_page(page);
> -       }
> -       return -ENOMEM;
>  }
> 
>  static inline int rb_null_event(struct ring_buffer_event *event)
> @@ -1299,6 +1293,11 @@
>                  head->read == rb_page_commit(commit)));
>  }
> 
> +int ring_buffer_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +       return rb_per_cpu_empty(cpu_buffer);
> +}
> +
>  /**
>  * ring_buffer_record_disable - stop all writes into the buffer
>  * @buffer: The ring buffer to stop writes to.
> @@ -1638,6 +1637,58 @@
>        cpu_buffer->reader_page->read += length;
>  }
> 
> +u32 ring_buffer_get_produced(struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +       struct buffer_page *reader;
> +       unsigned pgoff;
> +
> +       reader = rb_get_reader_page(cpu_buffer);
> +       if (!reader)
> +               return 0;
> +       pgoff = ((void *) reader - (void *) cpu_buffer->page_array) /
> +               BP_HEADER_SIZE;
> +       return pgoff * BUF_PAGE_SIZE + rb_page_commit(reader);
> +}
> +
> +u32 ring_buffer_get_consumed(struct ring_buffer_per_cpu *cpu_buffer)
> +{
> +       struct buffer_page *reader;
> +       unsigned pgoff;
> +
> +       reader = rb_get_reader_page(cpu_buffer);
> +       if (!reader)
> +               return 0;
> +       pgoff = ((void *) reader - (void *) cpu_buffer->page_array) /
> +               BP_HEADER_SIZE;
> +       return pgoff * BUF_PAGE_SIZE + reader->read;
> +}

Note, the reader page is special. It is not actually in the ring buffer.
It sits outside the buffer and the reader can do anything it wants to it
(like move it to another file with a splice).  When it is done with the
contents on that page, it swaps the reader page with the next page in
the ring buffer.

In over write mode, the writer (producer) may overwrite the buffer over
and over again but it will never touch what is currently on the reader
page.

This is a must because we are going to make the writer (in the future)
lockless) and the reader will still have locks. Only one reader at a
time, but we can have many writers. Well, each writer is on its own CPU
so it is ok, although the writers are reentrent.

-- Steve

> +
> +void ring_buffer_advance_reader(struct ring_buffer_per_cpu *cpu_buffer,
> +               int count)
> +{
> +       unsigned long flags;
> +       struct buffer_page *reader;
> +
> +       spin_lock_irqsave(&cpu_buffer->lock, flags);
> +       reader = cpu_buffer->reader_page;
> +       reader->read += count;
> +       spin_unlock_irqrestore(&cpu_buffer->lock, flags);
> +}
> +
> +struct page * ring_buffer_get_page(struct ring_buffer_per_cpu *cpu_buffer,
> +               pgoff_t pgoff)
> +{
> +       struct page *page;
> +       struct buffer_page *bpage;
> +
> +       bpage = (struct buffer_page *) ((void *) cpu_buffer->page_array +
> +                       pgoff * BP_HEADER_SIZE);
> +       page = virt_to_page(bpage->page);
> +       if (!page)
> +               printk("error: fail to vmalloc page\n");
> +       return page;
> +}
> +
>  static void rb_advance_iter(struct ring_buffer_iter *iter)
>  {
>        struct ring_buffer *buffer;

