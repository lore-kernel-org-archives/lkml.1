Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZFNB3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZFNB3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 21:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZFNB3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 21:29:47 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:44616 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZFNB3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 21:29:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=E8V/+mdTg11P0t3UvztB2epAoBng4mEPckKukjGwvsu2hZ8uHiXb3oVMorK5+sTQka
         UEMMCMk2Ct4PG2mJgqeiV0bEmKOWZvzSc8tafCll5S5O/A3fSF0txA0O6M91SbaB6rzU
         a1u8J9k9F0a/NlxcHE2E4Z4rFzLf2N9NcVQVg=
MIME-Version: 1.0
Date: Sun, 14 Jun 2009 09:29:48 +0800
Message-ID: <412e6f7f0906131829y6e0abb00j85e221f92ab439d2@mail.gmail.com>
Subject: memconsole: a virtual console to record the Oops message for 
	debugging purpose.
From: Changli Gao <xiaosuo@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus:

In the production environment, it is hard to find the causion of an
Oops message if a bug causes the kernel panics. Though the Oops
message is printed on the screen, we can't read the whole message in
most cases due to the size of the screen, and it is hard to save the
Oops message for debugging. I know kdump is a choice, but it needs
more memory, and in most cases, Oops messages are enough to find out
the bugs. The other choices are netconsole and serial line, but they
both need extra computers.

memconsole as a virtual console, will save the messages into a block
of boot memory reserved. Because the memory won't be cleaned(if the
self-check on memory is disabled) between two starts, the oops
messages as the other console messages will be saved between them, and
you have a chance to see what happened in the last start.

In order to avoid the corruption of the memory used by memconsole, I
find the memory from the end to the start.

Here is the code, and the code is mess currently. Am I in the right
direction? Are my assumptions right?

the following code is appended to the file mm/bootmem.c

void *memconsole_mem_start = NULL;
EXPORT_SYMBOL_GPL(memconsole_mem_start);
unsigned int memconsole_mem_size = 0;
EXPORT_SYMBOL_GPL(memconsole_mem_size);

static int __init memconsole_setup(char *str)
{
        unsigned long start;

        memconsole_mem_size = simple_strtoul(str, NULL, 10);
        memconsole_mem_size = PAGE_ALIGN(memconsole_mem_size);
        for (start = max_low_pfn - (memconsole_mem_size >> PAGE_SHIFT);
             start >= min_low_pfn;
             start -= (memconsole_mem_size >> PAGE_SHIFT)) {
                if (reserve_bootmem_generic(start << PAGE_SHIFT,
                                            memconsole_mem_size,
                                            BOOTMEM_EXCLUSIVE) >= 0)
                        break;
        }
        if (start < min_low_pfn)
                panic("Can't reserve bootmem for memconsole\n");
        memconsole_mem_start = phys_to_virt(start << PAGE_SHIFT);
        printk("reserve bootmem for memconsole %u@%p\n",
               memconsole_mem_size, memconsole_mem_start);

        return 1;
}
__setup("memconsole=", memconsole_setup);

An individual kernel module is used to implement the whole function.

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/reboot.h>
#include <linux/console.h>
#include <linux/proc_fs.h>
#include <linux/io.h>

static int reboot = 1;
module_param(reboot, bool, 0644);

static int panic_restart(struct notifier_block *block, unsigned long l, void *p)
{
        if (reboot)
                emergency_restart();
        return NOTIFY_DONE;
}

static struct notifier_block paniced = {
        .notifier_call  = panic_restart,
        .priority       = INT_MIN,
};

static char *buf;
static unsigned int *buf_len;
static char **buf_ptr;
static unsigned int buf_size;
struct buf_header {
        char *buf_ptr;
        unsigned int buf_len;
};
static DEFINE_SPINLOCK(buf_lock);

static int buf_init(void)
{
        extern void* memconsole_mem_start;
        extern unsigned int memconsole_mem_size;
        struct buf_header *hdr;

        if (memconsole_mem_size == 0 || memconsole_mem_start == NULL) {
                printk(KERN_WARNING "no memory for memconsole\n");
                return -ENOMEM;
        }
        hdr = memconsole_mem_start;
        if (memconsole_mem_size <= sizeof(*hdr)) {
                printk(KERN_WARNING "no enough memory for memconsole\n");
                return -EINVAL;
        }
        buf = (char*)(hdr + 1);
        buf_size = min(memconsole_mem_size - sizeof(*hdr), PAGE_SIZE);
        if (hdr->buf_ptr < buf || hdr->buf_ptr >= buf + buf_size ||
            hdr->buf_len > buf_size ||
            (hdr->buf_len < buf_size &&
             (unsigned int)(hdr->buf_ptr - buf) != hdr->buf_len)) {
                printk(KERN_WARNING "memory for memconsole isn't
initailized\n");
                hdr->buf_ptr = buf;
                hdr->buf_len = 0;
        }
        buf_ptr = &hdr->buf_ptr;
        buf_len = &hdr->buf_len;

        return 0;
}

static void record_msg(struct console *con, const char *msg, unsigned int len)
{
        unsigned int n;
        unsigned long flags;

        spin_lock_irqsave(&buf_lock, flags);
        while (len != 0) {
                n = min((unsigned int)(buf + buf_size - *buf_ptr), len);
                memcpy(*buf_ptr, msg, n);
                msg += n;
                len -= n;
                *buf_ptr += n;
                if (*buf_ptr == buf + buf_size)
                        *buf_ptr = buf;
                if (*buf_len < buf_size)
                        *buf_len = min((unsigned int)buf_size, *buf_len + n);
        }
        spin_unlock_irqrestore(&buf_lock, flags);
}

static struct console memconsole =
{
        .name   = "memconsole",
        .flags  = CON_ENABLED | CON_PRINTBUFFER,
        .write  = record_msg,
};

static int proc_read(char *page, char **start, off_t off, int count, int *eof,
                void *data)
{
        unsigned int n;
        unsigned int retval;
        unsigned long flags;

        spin_lock_irqsave(&buf_lock, flags);
        if ((retval = *buf_len) < buf_size) {
                memcpy(page, buf, *buf_len);
        } else {
                n = buf + buf_size - *buf_ptr;
                memcpy(page, *buf_ptr, n);
                if (buf != *buf_ptr)
                        memcpy(page + n, buf, *buf_ptr - buf);
                retval = buf_size;
        }
        spin_unlock_irqrestore(&buf_lock, flags);

        return retval;
}

static int __init init(void)
{
        int retval;

        if ((retval = buf_init()) != 0)
                return retval;
        if (create_proc_read_entry("memconsole", 0444, NULL, proc_read,
                                   NULL) == NULL) {
                printk("Can't register proc entry\n");
                return -EFAULT;
        }
        atomic_notifier_chain_register(&panic_notifier_list, &paniced);
        register_console(&memconsole);

        return 0;
}
module_init(init);

static void __exit fini(void)
{
        unregister_console(&memconsole);
        atomic_notifier_chain_unregister(&panic_notifier_list, &paniced);
        remove_proc_entry("memconsole", NULL);
}
module_exit(fini);

MODULE_AUTHOR("xiaosuo <xiaosuo@gmail.com>");
MODULE_LICENSE("GPL");

Certainly, I tested it on my virtual machine, and I did work.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
