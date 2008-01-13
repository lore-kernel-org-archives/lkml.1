Return-Path: <linux-kernel-owner+w=401wt.eu-S1751513AbYAMGoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbYAMGoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 01:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbYAMGos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 01:44:48 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:59129 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750768AbYAMGor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 01:44:47 -0500
Message-ID: <400206690.16519@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 13 Jan 2008 14:44:34 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Joerg Platte <jplatte@naasa.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801101103.06688.lists@naasa.net> <400029009.12072@ustc.edu.cn> <200801130032.32495.jplatte@naasa.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <200801130032.32495.jplatte@naasa.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JDwaA-00017Q-W6@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 13, 2008 at 12:32:30AM +0100, Joerg Platte wrote:
> Am Freitag, 11. Januar 2008 schrieb Fengguang Wu:
> > On Thu, Jan 10, 2008 at 11:03:05AM +0100, Joerg Platte wrote:
> > > Am Donnerstag, 10. Januar 2008 schrieb Fengguang Wu:
> > > > > problem, because the iowait problem disappeared today after the
> > > > > regular Debian update. I'll try to install the old package versions
> > > > > to make it show up again. Maybe that helps to debug it.
> > > >
> > > > Thank you. I'm running sid, ext2 as rootfs now ;-)
> > >
> > > The error is back and I'm getting thousands of messages like this with
> > > the patched kernel:
> > >
> > > mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3936 0 0 wc
> > > _M > tw 1024 sk 0 requeue_io 301: inode 81441 size 0 at 08:07(sda7)
> > > mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc
> > > _M > tw 1024 sk 2 requeue_io 301: inode 81441 size 0 at 08:07(sda7)
> > > mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc
> > > _M > tw 1024 sk 2 requeue_io 301: inode 81441 size 0 at 08:07(sda7)
> >
> > Joerg, what's the output of `dumpe2fs /dev/sda7` and `lsof|grep /tmp`?
> 
> After another reboot I tried to get more information about the konqueror 
> process possibly causing the iowait load by using strace -p. Here is the 
> output:
> 
> gettimeofday({1200180588, 878508}, NULL) = 0
> setitimer(ITIMER_VIRTUAL, {it_interval={0, 0}, it_value={0, 0}}, NULL) = 0
> rt_sigaction(SIGVTALRM, {SIG_DFL}, {0xb5cffed0, [VTALRM], SA_RESTART}, 8) = 0
> gettimeofday({1200180588, 879942}, NULL) = 0
> time(NULL)                              = 1200180588
> gettimeofday({1200180588, 880838}, NULL) = 0
> gettimeofday({1200180588, 881284}, NULL) = 0

No idea yet :-/ I'm afraid I have to trouble you again - the bug just
refused to appear in my system. I prepared a kernel module for you to
gather more information:

make && insmod ext2-writeback-debug.ko && sleep 1s && rmmod ext2-writeback-debug
dmesg > ext2-writeback-debug.dmesg

Please do it when 100% iowait appears, and send the dmesg file.

Thank you,
Fengguang

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=Makefile

obj-m := ext2-writeback-debug.o
KDIR  := /lib/modules/$(shell uname -r)/build
PWD   := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
clean:  
	rm -f *.mod.c *.ko *.o


--PEIAKu/WMn1b1Hv9
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="ext2-writeback-debug.c"

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/mm.h>
#include <linux/fs.h>
#include <linux/writeback.h>
#include <linux/kprobes.h>
#include <linux/pagevec.h>

void print_page(struct page *page)
{
	printk(KERN_DEBUG "%lu\t%u\t%u\t%c%c%c%c%c\n",
			page->index,
			page_count(page),
			page_mapcount(page),
			PageUptodate(page)      ? 'U' : '_',
			PageDirty(page)         ? 'D' : '_',
			PageWriteback(page)     ? 'W' : '_',
			PagePrivate(page)       ? 'P' : '_',
			PageLocked(page)        ? 'L' : '_');
}

void print_writeback_control(struct writeback_control *wbc)
{
	printk(KERN_DEBUG
			"global dirty %lu writeback %lu nfs %lu\n"
			"wbc flags %c%c towrite %ld skipped %ld\n",
			global_page_state(NR_FILE_DIRTY),
			global_page_state(NR_WRITEBACK),
			global_page_state(NR_UNSTABLE_NFS),
			wbc->encountered_congestion ? 'C':'_',
			wbc->more_io ? 'M':'_',
			wbc->nr_to_write,
			wbc->pages_skipped);
}

void print_inode_pages(struct inode *inode)
{
	struct address_space *mapping = inode->i_mapping;
	struct pagevec pvec;
	int nr_pages;
	int i;
	pgoff_t index = 0;
	struct dentry *dentry;
	int dcount;
	char *dname;

	nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
			PAGECACHE_TAG_DIRTY,
			(pgoff_t)PAGEVEC_SIZE);

	if (list_empty(&inode->i_dentry)) {
		dname = "";
		dcount = 0;
	} else {
		dentry = list_entry(inode->i_dentry.next,
					struct dentry, d_alias);
		dname = dentry->d_iname;
		dcount = atomic_read(&dentry->d_count);
	}

	printk(KERN_DEBUG "inode %lu(%s/%s) count %d,%d size %llu pages %lu\n",
			inode->i_ino,
			inode->i_sb->s_id,
			dname,
			atomic_read(&inode->i_count),
			dcount,
			i_size_read(inode),
			mapping->nrpages
	      );

	for (i = 0; i < nr_pages; i++)
		print_page(pvec.pages[i]);
}

int handler_pre(struct kprobe *p, struct pt_regs *regs)
{
	static int count = 0;

	if (count++ < 10)
		dump_stack();

	return 0;
}

void handler_post(struct kprobe *p, struct pt_regs *regs, unsigned long flags)
{
}

static struct kprobe my_kprobe = {
	.pre_handler = handler_pre,
	.post_handler = handler_post,
	.symbol_name = "submit_bio"
};


static int jdo_ext2_writepage(struct page *page, struct writeback_control *wbc)
{
	struct inode * const inode = page->mapping->host;

	if (!i_size_read(inode)) {
		printk(KERN_DEBUG "ext2_writepage:\n");
		print_page(page);
		print_writeback_control(wbc);
	}

	jprobe_return();
	return 0;
}
static struct jprobe jprobe_ext2_writepage = {
	.entry = jdo_ext2_writepage,
	.kp.symbol_name = "ext2_writepage"
};


static void jdo_requeue_io(struct inode *inode)
{
	if (!i_size_read(inode)) {
		printk(KERN_DEBUG "requeue_io:\n");
		print_inode_pages(inode);
	}

	jprobe_return();
}
static struct jprobe jprobe_requeue_io = {
	.entry = jdo_requeue_io,
	.kp.symbol_name = "requeue_io"
};

static int setup_kprobe(struct kprobe *kprobe)
{
	int ret = register_kprobe(kprobe);
	printk("register_kprobe(%s) = %d\n", kprobe->symbol_name, ret);
	return ret;
}

static int setup_jprobe(struct jprobe *jprobe)
{
	int ret = register_jprobe(jprobe);
	printk("register_jprobe(%s) = %d\n", jprobe->kp.symbol_name, ret);
	return ret;
}

static int __init jprobe_init(void)
{
	int ret;

	ret = setup_jprobe(&jprobe_ext2_writepage);
	if (ret)
		return -1;

	ret = setup_jprobe(&jprobe_requeue_io);
	if (ret)
		return -1;

	ret = setup_kprobe(&my_kprobe);
	if (ret)
		return -1;

	return 0;
}

static void __exit jprobe_exit(void)
{
	unregister_kprobe(&my_kprobe);
	unregister_jprobe(&jprobe_requeue_io);
	unregister_jprobe(&jprobe_ext2_writepage);
}

module_init(jprobe_init)
module_exit(jprobe_exit)
MODULE_LICENSE("GPL");

--PEIAKu/WMn1b1Hv9--

