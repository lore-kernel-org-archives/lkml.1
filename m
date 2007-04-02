Return-Path: <linux-kernel-owner+w=401wt.eu-S965933AbXDBVS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965933AbXDBVS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965937AbXDBVS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:18:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965933AbXDBVSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:18:41 -0400
Date: Mon, 2 Apr 2007 16:43:44 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/2] Use a single loader for i386 and x86_64
Message-ID: <20070402194344.GA7711@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch moves lguest.c one level bellow, and enhances it with the
ability to kick off 64 binaries. It would be much easier to just ifdef
functions, but I have x86_64 machines loading 32-bit kernels as a longer
goal, and that's why the patch features the load_elf_header() function.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lgcommon.patch"

--- i386/lguest.c	2007-04-02 16:19:27.000000000 -0300
+++ lguest.c	2007-04-02 16:19:28.000000000 -0300
@@ -29,11 +29,22 @@
 #include <sys/uio.h>
 #include <termios.h>
 #include <zlib.h>
+
+typedef uint64_t u64;
 typedef uint32_t u32;
 typedef uint16_t u16;
 typedef uint8_t u8;
 
-#include "../../../include/asm/lguest_user.h"
+#include "../../include/asm/lguest_user.h"
+#include <lguest_defs.h>
+
+unsigned long (*finish)(unsigned long mem, unsigned long *page_offset,
+			  const char *initrd, unsigned long *ird_size);
+
+typedef unsigned long (*load_function)(int, void *, unsigned long,
+			    unsigned long *, const char *, unsigned long *,
+			    unsigned long *);
+
 
 #define PAGE_PRESENT 0x7 	/* Present, RW, Execute */
 #define NET_PEERNUM 1
@@ -63,8 +74,8 @@ struct device
 
 	/* Watch DMA to this address if handle_input non-NULL. */
 	unsigned long watch_address;
-	u32 (*handle_output)(int fd, const struct iovec *iov,
-			     unsigned int num, struct device *me);
+	unsigned long (*handle_output)(int fd, const struct iovec *iov,
+				     unsigned int num, struct device *me);
 
 	/* Device-specific data. */
 	void *priv;
@@ -78,7 +89,7 @@ static int zero_fd;
    FIXME: vdso gets mapped just under it, and we need to protect that. */
 #define RESERVE_TOP LGUEST_GUEST_TOP - 1024*1024
 
-static u32 memparse(const char *ptr)
+static unsigned long memparse(const char *ptr)
 {
 	char *end;
 	unsigned long ret = strtoul(ptr, &end, 0);
@@ -142,8 +153,8 @@ static void map_memory(unsigned long mem
 		err(1, "Mmaping /dev/zero for %li bytes", mem);
 }
 
-static u32 finish(unsigned long mem, unsigned long *page_offset,
-		  const char *initrd, unsigned long *ird_size)
+static unsigned long finish32(unsigned long mem, unsigned long *page_offset,
+			  const char *initrd, unsigned long *ird_size)
 {
 	u32 *pgdir = NULL, *linear = NULL;
 	int i, pte_pages;
@@ -169,7 +180,7 @@ static u32 finish(unsigned long mem, uns
 	/* Now set up pgd so that this memory is at page_offset */
 	for (i = 0; i < mem / getpagesize(); i += getpagesize()/sizeof(u32)) {
 		pgdir[(i + *page_offset/getpagesize())/1024]
-			= (((u32)linear + i*sizeof(u32)) | PAGE_PRESENT);
+			= (((u32)(long)linear + i*sizeof(u32)) | PAGE_PRESENT);
 		verbose("Top level %lu = %#08x\n",
 			(i + *page_offset/getpagesize())/1024,
 			pgdir[(i + *page_offset/getpagesize())/1024]);
@@ -178,8 +189,14 @@ static u32 finish(unsigned long mem, uns
 	return (unsigned long)pgdir;
 }
 
+static unsigned long finish64(unsigned long mem, unsigned long *page_offset,
+		  const char *initrd, unsigned long *ird_size)
+{
+	return 0;
+}
+
 /* Returns the entry point */
-static u32 map_elf(int elf_fd, const Elf32_Ehdr *ehdr, unsigned long mem,
+static unsigned long map_elf32(int elf_fd, const Elf32_Ehdr *ehdr, unsigned long mem,
 		   unsigned long *pgdir_addr,
 		   const char *initrd, unsigned long *ird_size,
 		   unsigned long *page_offset)
@@ -210,7 +227,7 @@ static u32 map_elf(int elf_fd, const Elf
 			continue;
 
 		verbose("Section %i: size %i addr %p\n",
-			i, phdr[i].p_memsz, (void *)phdr[i].p_paddr);
+			i, phdr[i].p_memsz, (void *)(long)phdr[i].p_paddr);
 		/* We map everything private, writable. */
 		if (phdr[i].p_paddr + phdr[i].p_memsz > mem)
 			errx(1, "Segment %i overlaps end of memory", i);
@@ -227,6 +244,77 @@ static u32 map_elf(int elf_fd, const Elf
 			phdr[i].p_offset -= (phdr[i].p_paddr % getpagesize());
 			phdr[i].p_paddr -= (phdr[i].p_paddr % getpagesize());
 		}
+		addr = mmap((void *)(long)phdr[i].p_paddr,
+			    phdr[i].p_filesz,
+			    PROT_READ|PROT_WRITE|PROT_EXEC,
+			    MAP_FIXED|MAP_PRIVATE,
+			    elf_fd, phdr[i].p_offset);
+		if (addr != (void *)(long)phdr[i].p_paddr)
+			err(1, "Mmaping vmlinux segment %i returned %p not %p (%p)",
+			    i, addr, (void *)(long)phdr[i].p_paddr, &phdr[i].p_paddr);
+	}
+
+	*pgdir_addr = finish(mem, page_offset, initrd, ird_size);
+	/* Entry is physical address: convert to virtual */
+	return ehdr->e_entry + *page_offset;
+}
+
+/* Returns the entry point */
+static unsigned long map_elf64(int elf_fd, const Elf64_Ehdr *ehdr, unsigned long mem,
+		   unsigned long *pgdir_addr,
+		   const char *initrd, unsigned long *ird_size,
+		   unsigned long *page_offset)
+{
+#ifdef CONFIG_X86_64
+	void *addr;
+	Elf64_Phdr phdr[ehdr->e_phnum];
+	unsigned int i;
+	Elf64_Shdr sec[ehdr->e_shnum];
+	Elf64_Sym *syms;
+	char *strtab = NULL;
+	unsigned long nsyms = 0;
+
+	/* Sanity checks. */
+	if (ehdr->e_type != ET_EXEC
+	    || ehdr->e_machine != EM_X86_64
+	    || ehdr->e_phentsize != sizeof(Elf64_Phdr)
+	    || ehdr->e_phnum < 1 || ehdr->e_phnum > 65536U/sizeof(Elf64_Phdr))
+		errx(1, "Malformed elf64 header");
+
+	if (lseek(elf_fd, ehdr->e_phoff, SEEK_SET) < 0)
+		err(1, "Seeking to program headers");
+	if (read(elf_fd, phdr, sizeof(phdr)) != sizeof(phdr))
+		err(1, "Reading program headers");
+
+	map_memory(mem);
+
+	*page_offset = 0;
+	/* We map the loadable segments at virtual addresses corresponding
+	 * to their physical addresses (our virtual == guest physical). */
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		if (phdr[i].p_type != PT_LOAD)
+			continue;
+
+		verbose("Section %i: size %li addr %p\n",
+			i, phdr[i].p_memsz, (void *)phdr[i].p_paddr);
+		/* We map everything private, writable. */
+		if (phdr[i].p_paddr + phdr[i].p_memsz > mem)
+			errx(1, "Segment %i overlaps end of memory", i);
+
+		/* We expect linear address space. */
+		if (!*page_offset)
+			*page_offset = phdr[i].p_vaddr - phdr[i].p_paddr;
+		else if ((*page_offset != phdr[i].p_vaddr - phdr[i].p_paddr) &&
+			 phdr[i].p_vaddr != VSYSCALL_START)
+			errx(1, "Page offset of section %i different (got %lx, expected %lx)",
+			     i, (phdr[i].p_vaddr - phdr[i].p_paddr), *page_offset);
+
+		/* Recent ld versions don't page align any more. */
+		if (phdr[i].p_paddr % getpagesize()) {
+			phdr[i].p_filesz += (phdr[i].p_paddr % getpagesize());
+			phdr[i].p_offset -= (phdr[i].p_paddr % getpagesize());
+			phdr[i].p_paddr -= (phdr[i].p_paddr % getpagesize());
+		}
 		addr = mmap((void *)phdr[i].p_paddr,
 			    phdr[i].p_filesz,
 			    PROT_READ|PROT_WRITE|PROT_EXEC,
@@ -237,9 +325,67 @@ static u32 map_elf(int elf_fd, const Elf
 			    i, addr, (void *)phdr[i].p_paddr, &phdr[i].p_paddr);
 	}
 
-	*pgdir_addr = finish(mem, page_offset, initrd, ird_size);
+	/* Now process sections searching for boot page tables
+	 * Start by finding the symtab section */
+	if (lseek(elf_fd, ehdr->e_shoff, SEEK_SET) < 0)
+		err(1, "Seeking to section headers");
+	if (read(elf_fd, sec, sizeof(sec)) != sizeof(sec))
+		err(1, "Reading section headers");
+
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		if (sec[i].sh_type == SHT_SYMTAB) {
+			int ret = 0;
+			syms = malloc(sec[i].sh_size);
+			if (!syms)
+				err(1,"Not enough memory for symbol table");
+			ret = lseek(elf_fd, sec[i].sh_offset, SEEK_SET);
+			if (ret < 0)
+				err(1, "Seeking to symbol table");
+			ret = read(elf_fd, syms, sec[i].sh_size);
+			if (ret != sec[i].sh_size)
+				err(1, "Reading symbol table");
+			nsyms = sec[i].sh_size / sizeof(Elf64_Sym);
+
+
+			/* symtab links to strtab. We use it to find symbol
+			 * names */
+			strtab = malloc(sec[sec[i].sh_link].sh_size);
+			if (!strtab)
+				err(1,"Not enough memory for string table");
+			ret = lseek(elf_fd, sec[sec[i].sh_link].sh_offset , SEEK_SET);
+			if (ret < 0)
+				err(1, "Seeking to string table");
+			ret = read(elf_fd, strtab, sec[sec[i].sh_link].sh_size);
+			if (ret != sec[sec[i].sh_link].sh_size)
+				err(1, "Reading string table");
+			break;
+		}
+	}
+
+	/* We now have a pointer to the symtab, start searching for the symbol */
+	for (i = 0; i < nsyms; i++) {
+		if ((syms[i].st_shndx == SHN_UNDEF) || !syms[i].st_name)
+			continue;
+		if (!strcmp("boot_level4_pgt",
+				(char *)((u64)syms[i].st_name + strtab))) {
+			*pgdir_addr = syms[i].st_value - *page_offset;
+			break;
+		}
+	}
+
+	if (!*pgdir_addr)
+		err(1,"Unable to find boot pgdir");
+
+	*ird_size = load_initrd(initrd, mem);
+
 	/* Entry is physical address: convert to virtual */
+	printf("entry=%lx page_offset=%lx  entry+page_offset=%lx\n",
+	       ehdr->e_entry, *page_offset, ehdr->e_entry + *page_offset);
 	return ehdr->e_entry + *page_offset;
+#else
+	errno = EINVAL;
+	err(1, "Too many bits! i386 architecture cannot load 64 bit kernels");
+#endif
 }
 
 static unsigned long intuit_page_offset(unsigned char *img, unsigned long len)
@@ -254,9 +400,9 @@ static unsigned long intuit_page_offset(
 	errx(1, "could not determine page offset");
 }
 
-static u32 bzimage(int fd, unsigned long mem, unsigned long *pgdir_addr,
-		   const char *initrd, unsigned long *ird_size,
-		   unsigned long *page_offset)
+static unsigned long bzimage(int fd, unsigned long mem, unsigned long *pgdir_addr,
+			   const char *initrd, unsigned long *ird_size,
+			   unsigned long *page_offset)
 {
 	gzFile f;
 	int ret, len = 0;
@@ -277,13 +423,13 @@ static u32 bzimage(int fd, unsigned long
 	*pgdir_addr = finish(mem, page_offset, initrd, ird_size);
 
 	/* Entry is physical address: convert to virtual */
-	return (u32)img + *page_offset;
+	return (long)img + *page_offset;
 }
 
-static u32 load_bzimage(int bzimage_fd, const Elf32_Ehdr *ehdr,
-			unsigned long mem, unsigned long *pgdir_addr,
-			const char *initrd, unsigned long *ird_size,
-			unsigned long *page_offset)
+static unsigned long load_bzimage(int bzimage_fd, const Elf32_Ehdr *ehdr,
+				unsigned long mem, unsigned long *pgdir_addr,
+				const char *initrd, unsigned long *ird_size,
+				unsigned long *page_offset)
 {
 	unsigned char c;
 	int state = 0;
@@ -363,7 +509,7 @@ static struct device *new_device(struct 
 				 int fd,
 				 int (*handle_input)(int, struct device *),
 				 unsigned long watch_off,
-				 u32 (*handle_output)(int,
+				 unsigned long (*handle_output)(int,
 						      const struct iovec *,
 						      unsigned,
 						      struct device *))
@@ -384,16 +530,16 @@ static struct device *new_device(struct 
 	return dev;
 }
 
-static int tell_kernel(u32 pagelimit, u32 pgdir, u32 start, u32 page_offset)
+static int tell_kernel(long pagelimit, long pgdir, long start, long page_offset)
 {
-	u32 args[] = { LHREQ_INITIALIZE,
+	unsigned long args[] = { LHREQ_INITIALIZE,
 		       pagelimit, pgdir, start, page_offset };
 	int fd = open("/dev/lguest", O_RDWR);
 
 	if (fd < 0)
 		err(1, "Opening /dev/lguest");
 
-	verbose("Telling kernel limit %u, pgdir %i, e=%#08x page_off=0x%08x\n",
+	verbose("Telling kernel limit %lu, pgdir %li, e=%#08lx page_off=0x%08lx\n",
 		pagelimit, pgdir, start, page_offset);
 	if (write(fd, args, sizeof(args)) < 0)
 		err(1, "Writing to /dev/lguest");
@@ -423,7 +569,7 @@ static void *_check_pointer(unsigned lon
 #define check_pointer(addr,size) _check_pointer(addr, size, __LINE__)
 
 /* Returns pointer to dma->used_len */
-static u32 *dma2iov(unsigned long dma, struct iovec iov[], unsigned *num)
+static unsigned long *dma2iov(unsigned long dma, struct iovec iov[], unsigned *num)
 {
 	unsigned int i;
 	struct lguest_dma *udma;
@@ -446,12 +592,12 @@ static u32 *dma2iov(unsigned long dma, s
 	return &udma->used_len;
 }
 
-static u32 *get_dma_buffer(int fd, void *addr,
+static unsigned long *get_dma_buffer(int fd, void *addr,
 			   struct iovec iov[], unsigned *num, u32 *irq)
 {
-	u32 buf[] = { LHREQ_GETDMA, (u32)addr };
+	unsigned long buf[] = { LHREQ_GETDMA, (unsigned long)addr };
 	unsigned long udma;
-	u32 *res;
+	unsigned long *res;
 
 	udma = write(fd, buf, sizeof(buf));
 	if (udma == (unsigned long)-1)
@@ -466,7 +612,7 @@ static u32 *get_dma_buffer(int fd, void 
 
 static void trigger_irq(int fd, u32 irq)
 {
-	u32 buf[] = { LHREQ_IRQ, irq };
+	unsigned long buf[] = { LHREQ_IRQ, irq };
 	if (write(fd, buf, sizeof(buf)) != 0)
 		err(1, "Triggering irq %i", irq);
 }
@@ -486,7 +632,8 @@ struct console_abort
 /* We DMA input to buffer bound at start of console page. */
 static int handle_console_input(int fd, struct device *dev)
 {
-	u32 num, irq = 0, *lenp;
+	u32 num, irq = 0;
+	unsigned long *lenp;
 	int len;
 	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
 	struct console_abort *abort = dev->priv;
@@ -535,19 +682,20 @@ static unsigned long peer_offset(unsigne
 	return 4 * peernum;
 }
 
-static u32 handle_tun_output(int fd, const struct iovec *iov,
-			     unsigned num, struct device *dev)
+static unsigned long handle_tun_output(int fd, const struct iovec *iov,
+				     unsigned num, struct device *dev)
 {
 	/* Now we've seen output, we should warn if we can't get buffers. */
 	*(bool *)dev->priv = true;
 	return writev(dev->fd, iov, num);
 }
 
-static u32 handle_block_output(int fd, const struct iovec *iov,
-			       unsigned num, struct device *dev)
+static unsigned long handle_block_output(int fd, const struct iovec *iov,
+				       unsigned num, struct device *dev)
 {
 	struct lguest_block_page *p = dev->mem;
-	u32 irq, reply_num, *lenp;
+	u32 irq, reply_num;
+	unsigned long *lenp;
 	int len;
 	struct iovec reply[LGUEST_MAX_DMA_SECTIONS];
 	off64_t device_len, off = (off64_t)p->sector * 512;
@@ -555,11 +703,13 @@ static u32 handle_block_output(int fd, c
 	device_len = *(off64_t *)dev->priv;
 
 	if (off >= device_len)
-		err(1, "Bad offset %llu vs %llu", off, device_len);
+		err(1, "Bad offset %llu vs %llu", (unsigned long long)off, 
+						(unsigned long long)device_len);
 	if (lseek64(dev->fd, off, SEEK_SET) != off)
 		err(1, "Bad seek to sector %i", p->sector);
 
-	verbose("Block: %s at offset %llu\n", p->type ? "WRITE" : "READ", off);
+	verbose("Block: %s at offset %llu\n", p->type ? "WRITE" : "READ", 
+						(unsigned long long)off);
 
 	lenp = get_dma_buffer(fd, dev->mem, reply, &reply_num, &irq);
 	if (!lenp)
@@ -569,7 +719,8 @@ static u32 handle_block_output(int fd, c
 		len = writev(dev->fd, iov, num);
 		if (off + len > device_len) {
 			ftruncate(dev->fd, device_len);
-			errx(1, "Write past end %llu+%u", off, len);
+			errx(1, "Write past end  %llu+%u",
+						(unsigned long long)off, len);
 		}
 		*lenp = 0;
 	} else {
@@ -639,7 +790,8 @@ static void wakeup(int signo)
 
 static int handle_tun_input(int fd, struct device *dev)
 {
-	u32 irq = 0, num, *lenp;
+	u32 irq = 0, num;
+	unsigned long *lenp;
 	int len;
 	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
 
@@ -836,8 +988,8 @@ static void setup_block_file(const char 
 		(void *)(dev->desc->pfn * getpagesize()), p->num_sectors);
 }
 
-static u32 handle_console_output(int fd, const struct iovec *iov,
-				 unsigned num, struct device*dev)
+static unsigned long handle_console_output(int fd, const struct iovec *iov,
+					 unsigned num, struct device*dev)
 {
 	return writev(STDOUT_FILENO, iov, num);
 }
@@ -871,11 +1023,11 @@ static const char *get_arg(const char *a
 	return NULL;
 }
 
-static u32 handle_device(int fd, unsigned long dma, unsigned long addr,
+static long handle_device(int fd, unsigned long dma, unsigned long addr,
 			 struct devices *devices)
 {
 	struct device *i;
-	u32 *lenp;
+	unsigned long *lenp;
 	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
 	unsigned num = 0;
 
@@ -916,20 +1068,45 @@ static void handle_input(int fd, int chi
 	}
 }
 
+static unsigned long load_elf_header(unsigned char *elf_nident)
+{
+	errno = 0;	
+	switch (*(elf_nident+EI_CLASS)) {
+		case ELFCLASS32:
+			finish = finish32;
+			if (memcmp(elf_nident, ELFMAG, SELFMAG) == 0)
+				return (unsigned long)map_elf32;
+			else
+				return (unsigned long)load_bzimage;
+			break;
+		case ELFCLASS64:
+			finish = finish64;
+			if (memcmp(elf_nident, ELFMAG, SELFMAG) == 0)
+				return (unsigned long)map_elf64;
+			else
+				return (unsigned long)load_bzimage;
+			break;
+		default:
+			/* unrecognized class */
+			errno = EINVAL;
+			return 0;
+	}
+
+}
+
 int main(int argc, char *argv[])
 {
 	unsigned long mem, pgdir, entry, initrd_size, page_offset;
 	int arg, kern_fd, fd, child, pipefd[2];
-	Elf32_Ehdr hdr;
+	/* Worst case */
+	Elf64_Ehdr hdr;
 	struct sigaction act;
 	sigset_t sigset;
 	struct lguest_device_desc *devdescs;
 	struct devices devices;
 	struct lguest_boot_info *boot = (void *)0;
 	const char *initrd_name = NULL;
-	u32 (*load)(int, const Elf32_Ehdr *ehdr, unsigned long,
-		    unsigned long *, const char *, unsigned long *,
-		    unsigned long *);
+	load_function load;
 
 	if (argv[1] && strcmp(argv[1], "--verbose") == 0) {
 		verbose = true;
@@ -954,10 +1131,10 @@ int main(int argc, char *argv[])
 	if (read(kern_fd, &hdr, sizeof(hdr)) != sizeof(hdr))
 		err(1, "Reading %s elf header", argv[2]);
 
-	if (memcmp(hdr.e_ident, ELFMAG, SELFMAG) == 0)
-		load = map_elf;
-	else
-		load = load_bzimage;
+	load = (load_function)load_elf_header(hdr.e_ident);
+
+	if (!load)
+		err(1, "Could not identify file class");
 
 	devices.max_infd = -1;
 	devices.dev = NULL;

--2fHTh5uZTiUOsy+g--
