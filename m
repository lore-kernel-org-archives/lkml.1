Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0CDQbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:31:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43883 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab0CDQbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:31:35 -0500
Date: Thu, 4 Mar 2010 16:30:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       mdharm-kernel@one-eyed-alien.net, oliver@neukum.org, greg@kroah.com,
       x0082077@ti.com, sshtylyov@ru.mvista.com, benh@kernel.crashing.org,
       bigeasy@linutronix.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       santosh.shilimkar@ti.com, Pavel Machek <pavel@ucw.cz>,
       tom.leiming@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100304163023.GC13417@n2100.arm.linux.org.uk>
References: <1267316072.23523.1842.camel@pasglop> <1267333263.2762.11.camel@mulgrave.site> <20100302211049V.fujita.tomonori@lab.ntt.co.jp> <1267549527.15401.78.camel@e102109-lin.cambridge.arm.com> <20100303215437.GF2579@ucw.cz> <1267709756.6526.380.camel@e102109-lin.cambridge.arm.com> <20100304135128.GA12191@atrey.karlin.mff.cuni.cz> <1267712512.31654.176.camel@mulgrave.site> <1267716578.6526.483.camel@e102109-lin.cambridge.arm.com> <20100304154103.GA9384@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304154103.GA9384@linux-sh.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 12:41:03AM +0900, Paul Mundt wrote:
> On Thu, Mar 04, 2010 at 03:29:38PM +0000, Catalin Marinas wrote:
> > On Thu, 2010-03-04 at 14:21 +0000, James Bottomley wrote:
> > > The thing which was discovered in this thread is basically that ARM is
> > > handling deferred flushing (for D/I coherency) in a slightly different
> > > way from everyone else ... 
> > 
> > Doing a grep for PG_dcache_dirty defined in terms of PG_arch_1 reveals
> > that MIPS, Parisc, Score, SH and SPARC do similar things to ARM. PowerPC
> > and IA-64 use PG_arch_1 as a clean rather than dirty bit.
> > 
> SH used to use it as a PG_mapped which was roughly similar to the
> PG_dcache_clean approach, at which point things like flushing for the PIO
> case in the HCD wasn't necessary. It did result in rather aggressive over
> flushing though, which is one of the reasons we elected to switch to
> PG_dcache_dirty.
> 
> Note that the PG_dcache_dirty semantics are also outlined in
> Documentation/cachetlb.txt for PG_arch_1 usage, so it's hardly esoteric.

Indeed; the ARM approach was basically taken from Sparc64.

The problem being talked about (with data from PIO drivers not being
visible to userspace) is one of those corner cases.  It's been around
for something like 6 years or more, being reported by folk on the ARM
list on and off - so it's nothing new.

However, it seems very obscure - I've never been able to reproduce it
on any platform I have here, even with people's test programs which
instantly show it on their hardware.  It seems to require a very
specific set of hardware and software conditions to trigger it.

The general critera (from memory) seems to be:
- a virtual indexed aliasing cache (whether it be VIVT or VIPT aliasing)
- write allocate caches show the problem better than read allocate only
- using a block device for the filesystem
- mmap'ing a page and immediately accessing the last few cache lines in
  that page

The problem is that if enough of your data cache gets cycled through
in between the data being written to the page, and userspace trying to
read it, then you're going to see correct data.  So, the larger the L1
cache, the greater the chance that you'll see a problem.

Here is a program which Lothar sent me some time ago (the timestamp on
the .c is June 2004 - I can't find the original email though.)  I've
just checked with Lothar, who has given me permission to reproduce it.

I can't guarantee that this program still shows a problem - since I
believe I've never been able to reproduce it myself.  It might be worth
checking how other architectures behave.

Note that loop did get fixed with flush_dcache_page(), so trying it
against a loopback mounted filesystem won't show the problem.

/*
 * creates a testfile, 'mmap's it, and checks its content reading
 * page back to front. If a data error is found, the same page is read
 * over and over again, until data is eventually correct after some time.
 *
 * This points out a cache problem in the ARM linux kernel
 * Using the cache in Write-Through mode (kernel command line option: cachepolicy=writethrough)
 * or CONFIG_XSCALE_CACHE_ERRATA=y in older kernels prevents this problem
 *
 * (C) Lothar Wassmann, <LW@KARO-electronics.de>
 *
 */
#include <unistd.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/ioctl.h>

#define PAGE_SIZE	4096
#define PAGE_SIZE_INT	((PAGE_SIZE)/sizeof(unsigned long))
#define PAGE_MASK	((PAGE_SIZE)-1)

#undef USE_BLKFLSBUF
#define BLKFRASET  _IO(0x12,100)/* set filesystem (mm/filemap.c) read-ahead */


size_t file_size = 256 * PAGE_SIZE;

unsigned long *buf=NULL;

const char* fn="testfile";

void usage(const char* name)
{
	printf("%s <mount point> [filename]\n", name);
	printf("\trequires <mount point> to be defined in /etc/fstab\n");
	printf("\t<mount point> will be unmounted and remounted during the test\n");
}

int create_file(const char* name, size_t size)
{
	int ret=0;
	int i;
	int fd;

	fd = open(name, O_CREAT|O_RDWR|O_SYNC|O_TRUNC, S_IWUSR|S_IRUSR|S_IRGRP|S_IROTH);
	if (fd < 0) {
		fprintf(stderr, "Failed to open '%s' for writing, errno=%d\n", name, errno);
		return errno;
	}

	for (i = size / sizeof(*buf); i > 0; i--) {
		buf[i-1] = i;
	}
	write(fd, buf, size);
	memset(buf, 0x55, size);

	close(fd);
	return ret;
}

int do_check(int fd, void *mapptr, size_t size)
{
	const int num_pages=size/PAGE_SIZE;
	volatile unsigned char *ptr=mapptr;
	int errors = 0;
	int soft = 0;
	int page;

	printf("Checking data from %08lx to %08lx\n", (unsigned long)(ptr + size),
	       (unsigned long)ptr);

	for (page = num_pages - 1; page >= 0; page--) {
		volatile unsigned long *pp=(volatile unsigned long *)&ptr[page*PAGE_SIZE];
		int offs;
		int page_errs=0;
		int err_offs=-1;

		for (offs = 0; offs < PAGE_SIZE; offs += sizeof(unsigned long)) {
			volatile unsigned long *lp=&pp[offs/sizeof(unsigned long)];
			unsigned long data=*lp;
			unsigned long ref=(((page*PAGE_SIZE)+offs)/sizeof(data)) + 1;

			if (data != ref) {
				const int max_tries=100000;
				int retries=max_tries;
				unsigned long new_data=*lp;

				errors++;
				page_errs++;
				while ((new_data != ref) && (--retries > 0)) {
					if (data != new_data) {
						fprintf(stderr, "Data @ page %03x:%03x (%08lx) changed to %08lx(%08lx)\n",
							page, offs, (unsigned long)lp, new_data, ref);
					}
					data = new_data;
					new_data = *lp;
				}
				if (new_data == ref) {
					fprintf(stderr, "Data @ page %03x:%03x (%08lx) OK after %d retries: %08lx\n",
						page, offs, (unsigned long)lp, max_tries - retries, new_data);
					soft++;
				} else {
					if (err_offs != offs) {
						fprintf(stderr, "Data error @ page %03x:%03x (%08lx): %08lx -> %08lx\n",
							page, offs, (unsigned long)lp, ref, data);
						err_offs = offs;
					}
					// retry the same page again, until data is correct
					offs = 0;
				}
			}
		}
		if (page_errs) {
			page = num_pages;
		}
	}

	fprintf(stderr, "Errors reverse check: %d; soft: %d; total bytes %d in %d pages\n",
		errors, soft, size, num_pages);

	return errors;
}

int check_file(const char* name, size_t size)
{
	int ret=0;
	int fd;
	void *ptr=NULL;
	int errors=0;
	int last_errors=0;

	fd = open(name, O_RDONLY|O_SYNC);
	if (fd < 0) {
		fprintf(stderr, "Failed to open '%s' for reading\n", name);
		return errno;
	}

	ptr = mmap(NULL, size, PROT_READ, MAP_SHARED/*PRIVATE*/, fd, 0);
	if (ptr == MAP_FAILED) {
		close(fd);
		return -ENOMEM;
	}

	printf("Checking file '%s'\n", name);
	do {
		last_errors = errors;
		errors = do_check(fd, ptr, size);
		if (errors != 0) {
			ret = errors;
		}
	} while (errors > 0 && errors != last_errors);

	if (munmap(ptr, size) != 0) {
		fprintf(stderr, "Failed to unmap %08lx\n", (unsigned long)ptr);
		if (ret == 0) {
			ret = -ENOMEM;
		}
	}
	close(fd);
	if (buf != NULL) {
		memset(buf, 0x55, size);
	}

	if (ret == 0) {
		printf("check successful\n");
	} else {
		printf("check failed\n");
	}

	return ret;
}

int main(int argc, char *argv[])
{
	int rc=0;
	char fname[100];
	char mount[44];
	char umount[44];

	if (argc < 2) {
		// first argument is required
		usage(argv[0]);
		return 1;
	}
	if (argc > 2) {
		// take optional second argument as filename
		fn = argv[2];
	}

	sprintf(fname, "%s/%s", argv[1], fn);
	sprintf(mount, "mount %s", argv[1]);
	sprintf(umount, "umount %s", argv[1]);

	file_size &= ~PAGE_MASK; // round size to page boundary
	buf = malloc(file_size);

	if (buf == NULL) {
		fprintf(stderr, "Failed to allocate buffer\n");
		rc = -ENOMEM;
	}

#ifdef USE_BLKFLSBUF	
	printf("Mounting '%s'\n", argv[1]);
	system(mount);
#endif

	while (rc == 0) {
		printf("Opening '%s'\n", fname);
		rc = create_file(fname, file_size);
		if (rc != 0) {
			fprintf(stderr, "Failed to create file '%s', rc=%d\n", fname, rc);
			break;
		}

#ifndef USE_BLKFLSBUF
		printf("Unmounting '%s'\n", argv[1]);
		system(umount);

		printf("Remounting '%s'\n", argv[1]);
		system(mount);
#else
		{
			int fd = open("/dev/loop0", O_RDONLY);
			ioctl(fd, BLKFLSBUF, 0);
			ioctl(fd, BLKRASET, 0);
			ioctl(fd, BLKFRASET, 0);
			close(fd);
		}
#endif

		rc = check_file(fname, file_size);
	}

	if (buf != NULL) {
		free(buf);
	}

	return rc;
}
