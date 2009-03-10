Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZCJH62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZCJH62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 03:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZCJH6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 03:58:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:56992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbZCJH6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 03:58:15 -0400
Message-ID: <49B61D68.9090908@kernel.org>
Date: Tue, 10 Mar 2009 16:57:28 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: test module to verify percpu allocator
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
In-Reply-To: <1236671631-9305-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------070408040508080101070206"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 07:57:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070408040508080101070206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello, again.

Attached is the test module to test percpu allocator.  Just build as
an external module and load/unload to perform the test.

Thanks.

-- 
tejun

--------------070408040508080101070206
Content-Type: text/x-csrc;
 name="test_module.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test_module.c"

#include <linux/module.h>
#include <linux/device.h>
#include <linux/sysfs.h>
#include <linux/percpu.h>

static inline void pcpu_dump_chunk_slots(void) {}

struct alloc_cmd {
	size_t size;
	int marker;
};

static const struct alloc_cmd cmds[] = {
	{  256, 0 }, {  256, 1 }, {  256, 0 }, {  256, 1 },
	{  256, 0 }, {  256, 1 }, {  256, 0 }, {  256, 1 },
	{  256, 0 }, {  256, 1 }, {  256, 0 }, {  256, 1 },
	{  256, 0 }, {  256, 1 }, {  256, 0 }, {  256, 1 },
	{  256, 0 }, {  256, 1 }, {  256, 0 }, {  256, 1 },
	{  256, 0 }, {  256, 1 }, {  256, 0 }, {  256, 1 },
	{  256, 0 }, {  256, 1 }, {  256, 0 }, {  256, 1 },
	{  256, 0 }, {  256, 1 }, {  256, 0 }, {  256, 1 },	/* 8k */

	{ 1024, 2 }, { 1024, 2 }, { 1024, 2 }, { 1024, 2 },
	{ 1024, 2 }, { 1024, 2 }, { 1024, 2 }, { 1024, 2 },
	{ 1024, 2 }, { 1024, 2 }, { 1024, 2 }, { 1024, 2 },
	{ 1024, 2 }, { 1024, 2 }, { 1024, 2 }, { 1024, 2 },
	{ 1024, 2 }, { 1024, 2 }, { 1024, 2 }, { 1024, 2 },
	{ 1024, 2 }, { 1024, 2 }, { 1024, 2 }, { 1024, 2 },
	{ 1024, 2 }, { 1024, 2 }, { 1024, 2 }, { 1024, 2 },
	{ 1024, 2 }, { 1024, 2 }, { 1024, 2 }, { 1024, 2 },	/* 32k */

	{ 8192, 3 }, { 8192, 3 }, { 8192, 3 }, { 8192, 3 },
	{ 8192, 3 }, { 8192, 3 }, { 8192, 3 }, { 8192, 3 },
	{ 8192, 3 }, { 8192, 3 }, { 8192, 3 }, { 8192, 3 },
	{ 8192, 3 }, { 8192, 3 }, { 8192, 3 }, { 8192, 3 },
	{ 8192, 3 }, { 8192, 3 }, { 8192, 3 }, { 8192, 3 },
	{ 8192, 3 }, { 8192, 3 }, { 8192, 3 }, { 8192, 3 },
	{ 8192, 3 }, { 8192, 3 }, { 8192, 3 }, { 8192, 3 },
	{ 8192, 3 }, { 8192, 3 }, { 8192, 3 }, { 8192, 3 },	/* 128k */

	{ 0, 0 },	/* free 0s */

	{  128, 4 }, {  128, 4 }, {  128, 4 }, {  128, 4 },
	{  128, 4 }, {  128, 4 }, {  128, 4 }, {  128, 4 },
	{  128, 4 }, {  128, 4 }, {  128, 4 }, {  128, 4 },
	{  128, 4 }, {  128, 4 }, {  128, 4 }, {  128, 4 },
	{  128, 4 }, {  128, 4 }, {  128, 4 }, {  128, 4 },
	{  128, 4 }, {  128, 4 }, {  128, 4 }, {  128, 4 },
	{  128, 4 }, {  128, 4 }, {  128, 4 }, {  128, 4 },
	{  128, 4 }, {  128, 4 }, {  128, 4 }, {  128, 4 },
	{  128, 4 }, {  128, 4 }, {  128, 4 }, {  128, 4 },	/* 4.5k */

	{ 0, 1 },	/* free 1s */

	{ 1024, 5 }, { 1024, 5 }, { 1024, 5 }, { 1024, 5 },	/* 4k */

	{ 0, 5 },	/* free 5s */
	{ 0, 4 },
	{ 0, 3 },
	{ 0, 2 },
};

#define NR_CMDS		ARRAY_SIZE(cmds)

static void *ptrs[NR_CMDS];

static unsigned long seed_val(unsigned int cmdno, unsigned int cpu)
{
	return 0xdeadbeefbeefdeadULL
		+ cmdno + (cmdno << 16) + (cpu << 8) + (cpu << 24);
}

static void fill_area(void *p, size_t size, unsigned int cmdno)
{
	unsigned int cpu;

	for_each_possible_cpu(cpu) {
		unsigned long v = seed_val(cmdno, cpu);
		unsigned long *up = per_cpu_ptr(p, cpu);
		size_t left = size;

		while (left >= sizeof(unsigned long)) {
			*up++ = v++;
			left -= sizeof(unsigned long);
		}
	}
}

static void verify_area(void *p, size_t size, unsigned int cmdno)
{
	unsigned int warns = 5;
	unsigned int cpu;

	for_each_possible_cpu(cpu) {
		unsigned long v = seed_val(cmdno, cpu);
		unsigned long *up = per_cpu_ptr(p, cpu);
		size_t left = size;

		while (left >= sizeof(unsigned long)) {
			if (*up != v && warns-- > 0) {
				printk("MISMATCH: cmdno=%u size=%zu cpu=%u off=%zu p=%p\n",
				       cmdno, size, cpu, size - left, p);
				printk("          [%p]=%lx should be %lx\n",
				       up, *up, v);
			}
			up++; v++;
			left -= sizeof(unsigned long);
		}
	}
}

static void free_cmd(unsigned int cmdno)
{
	if (!ptrs[cmdno])
		return;

	verify_area(ptrs[cmdno], cmds[cmdno].size, cmdno);
	free_percpu(ptrs[cmdno]);
	ptrs[cmdno] = NULL;
}

static void run_test(void)
{
	unsigned int i, j;

	for (i = 0; i < NR_CMDS; i++) {
		const struct alloc_cmd *cmd = &cmds[i];

		if (cmd->size) {
			printk("ALLOC: %zu bytes marker=%d\n",
			       cmd->size, cmd->marker);
			ptrs[i] = __alloc_percpu(cmd->size,
					__alignof__(unsigned long long));
			if (ptrs[i])
				fill_area(ptrs[i], cmd->size, i);
			else
				printk("failed to allocate %zu bytes\n",
				       cmd->size);
			continue;
		}

		printk("FREE: marker=%d\n", cmd->marker);
		pcpu_dump_chunk_slots();
		for (j = 0; j < i; j++)
			if (cmds[j].marker == cmd->marker)
				free_cmd(j);
		printk("FREE: done\n");
		pcpu_dump_chunk_slots();
	}
}

struct stupid_large_alignment_struct {
	int a;
	int b;
	int c;
} __aligned(2048);

struct stupid_large_struct {
	char a[1024];
};

static DEFINE_PER_CPU(struct stupid_large_alignment_struct, blah_blah);
DEFINE_PER_CPU(struct stupid_large_struct, blah_blah2);
DEFINE_PER_CPU(struct stupid_large_struct, blah_blah3);
DEFINE_PER_CPU(struct stupid_large_struct, blah_blah4);
DEFINE_PER_CPU(struct stupid_large_struct, blah_blah5);
DEFINE_PER_CPU(struct stupid_large_struct, blah_blah6);

static int __init test_init(void)
{
	unsigned int cpu;

	printk("XXX test_pcpu:");
	for_each_possible_cpu(cpu)
		printk(" %p", &per_cpu(blah_blah, cpu));
	printk("\n");
	pcpu_dump_chunk_slots();

	run_test();
	return 0;
}

static void __exit test_exit(void)
{
	unsigned int i;

	printk("XXX cleaning up\n");
	pcpu_dump_chunk_slots();

	for (i = 0; i < NR_CMDS; i++)
		free_cmd(i);

	printk("XXX done\n");
	pcpu_dump_chunk_slots();
}

module_init(test_init);
module_exit(test_exit);
MODULE_LICENSE("GPL");

--------------070408040508080101070206--
