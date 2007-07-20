Return-Path: <linux-kernel-owner+w=401wt.eu-S1761936AbXGTMD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936AbXGTMD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbXGTMDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:03:19 -0400
Received: from ozlabs.org ([203.10.76.45]:54702 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbXGTMDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:03:18 -0400
Subject: Re: [PATCH] Remove -static from Documentation/lguest/Makefile
From: Rusty Russell <rusty@rustcorp.com.au>
To: caglar@pardus.org.tr
Cc: LKML <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <200707192313.44106.caglar@pardus.org.tr>
References: <200707192313.44106.caglar@pardus.org.tr>
Content-Type: text/plain; charset=iso-8859-9
Date: Fri, 20 Jul 2007 22:02:53 +1000
Message-Id: <1184932973.10380.293.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 23:13 +0300, S.Çaðlar Onur wrote:
> Hi;
> 
> Remove -static from Documentation/lguest/Makefile, most distros only provides shared library form of zlib in their default installation. 
> And shared linking also provides litte tiny security for hypotetical security problems will be introduced by zlib :).

Unfortunately, this introduces a security hole.  See, the guest can
access all memory up to LGUEST_GUEST_TOP, or 0xB8000000 on my machine.
Without -static, we look like this:

>  cat /proc/4137/maps 
b7e0b000-b7e0d000 rw-p b7e0b000 00:00 0 
b7e0d000-b7f35000 r-xp 00000000 03:03 17069      /lib/tls/libc-2.3.6.so
b7f35000-b7f3a000 r--p 00127000 03:03 17069      /lib/tls/libc-2.3.6.so
b7f3a000-b7f3c000 rw-p 0012c000 03:03 17069      /lib/tls/libc-2.3.6.so
b7f3c000-b7f3f000 rw-p b7f3c000 00:00 0 
b7f3f000-b7f52000 r-xp 00000000 03:03 389723     /usr/lib/libz.so.1.2.3
b7f52000-b7f53000 rw-p 00012000 03:03 389723     /usr/lib/libz.so.1.2.3
b7f5b000-b7f5d000 rw-p b7f5b000 00:00 0 
b7f5d000-b7f5e000 r-xp b7f5d000 00:00 0          [vdso]
b7f5e000-b7f73000 r-xp 00000000 03:03 16351      /lib/ld-2.3.6.so
b7f73000-b7f75000 rw-p 00014000 03:03 16351      /lib/ld-2.3.6.so
b8000000-b8004000 r-xp 00000000 03:04
2485028    /home/rusty/linux-2.6.22-git13/Documentation/lguest/lguest
b8004000-b8005000 rw-p 00004000 03:04
2485028    /home/rusty/linux-2.6.22-git13/Documentation/lguest/lguest
bfecd000-bfee3000 rw-p bfecd000 00:00 0          [stack]

Whee!  Guest can overwrite our libc, libz, ld.so.  Also, we allocate
pages for virtual devices from B8000000 down, so we might not run very
far if we've blatted those libraries.

The correct solution is to allocate upwards, and then hand the top
address we got to the kernel as the highest accessible guest address.

How's this?
===
Link lguest example launcher non-static

S.Caglar Onur points out that many distributions don't ship a static
zlib.  Unfortunately the launcher currently maps virtual device memory
where shared libraries want to go.

The solution is to pre-scan the args to figure out how much memory we
have, then allocate devices above that, rather than down from the top.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r d9973bf15010 Documentation/lguest/Makefile
--- a/Documentation/lguest/Makefile	Fri Jul 20 21:40:49 2007 +1000
+++ b/Documentation/lguest/Makefile	Fri Jul 20 21:41:44 2007 +1000
@@ -11,8 +11,7 @@ include $(KBUILD_OUTPUT)/.config
 include $(KBUILD_OUTPUT)/.config
 LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)
 
-CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 \
-	-static -DLGUEST_GUEST_TOP="$(LGUEST_GUEST_TOP)" -Wl,-T,lguest.lds
+CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 -Wl,-T,lguest.lds
 LDLIBS:=-lz
 
 all: lguest.lds lguest
diff -r d9973bf15010 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c	Fri Jul 20 21:40:49 2007 +1000
+++ b/Documentation/lguest/lguest.c	Fri Jul 20 21:55:07 2007 +1000
@@ -47,12 +47,14 @@ static bool verbose;
 #define verbose(args...) \
 	do { if (verbose) printf(args); } while(0)
 static int waker_fd;
+static u32 top;
 
 struct device_list
 {
 	fd_set infds;
 	int max_infd;
 
+	struct lguest_device_desc *descs;
 	struct device *dev;
 	struct device **lastdev;
 };
@@ -324,8 +326,7 @@ static int tell_kernel(u32 pgdir, u32 st
 static int tell_kernel(u32 pgdir, u32 start, u32 page_offset)
 {
 	u32 args[] = { LHREQ_INITIALIZE,
-		       LGUEST_GUEST_TOP/getpagesize(), /* Just below us */
-		       pgdir, start, page_offset };
+		       top/getpagesize(), pgdir, start, page_offset };
 	int fd;
 
 	fd = open_or_die("/dev/lguest", O_RDWR);
@@ -382,7 +383,7 @@ static void *_check_pointer(unsigned lon
 static void *_check_pointer(unsigned long addr, unsigned int size,
 			    unsigned int line)
 {
-	if (addr >= LGUEST_GUEST_TOP || addr + size >= LGUEST_GUEST_TOP)
+	if (addr >= top || addr + size >= top)
 		errx(1, "%s:%i: Invalid address %li", __FILE__, line, addr);
 	return (void *)addr;
 }
@@ -629,24 +630,26 @@ static void handle_input(int fd, struct 
 	}
 }
 
-static struct lguest_device_desc *new_dev_desc(u16 type, u16 features,
-					       u16 num_pages)
-{
-	static unsigned long top = LGUEST_GUEST_TOP;
-	struct lguest_device_desc *desc;
-
-	desc = malloc(sizeof(*desc));
-	desc->type = type;
-	desc->num_pages = num_pages;
-	desc->features = features;
-	desc->status = 0;
-	if (num_pages) {
-		top -= num_pages*getpagesize();
-		map_zeroed_pages(top, num_pages);
-		desc->pfn = top / getpagesize();
-	} else
-		desc->pfn = 0;
-	return desc;
+static struct lguest_device_desc *
+new_dev_desc(struct lguest_device_desc *descs,
+	     u16 type, u16 features, u16 num_pages)
+{
+	unsigned int i;
+
+	for (i = 0; i < LGUEST_MAX_DEVICES; i++) {
+		if (!descs[i].type) {
+			descs[i].type = type;
+			descs[i].features = features;
+			descs[i].num_pages = num_pages;
+			if (num_pages) {
+				map_zeroed_pages(top, num_pages);
+				descs[i].pfn = top/getpagesize();
+				top += num_pages*getpagesize();
+			}
+			return &descs[i];
+		}
+	}
+	errx(1, "too many devices");
 }
 
 static struct device *new_device(struct device_list *devices,
@@ -669,7 +672,7 @@ static struct device *new_device(struct 
 	dev->fd = fd;
 	if (handle_input)
 		set_fd(dev->fd, devices);
-	dev->desc = new_dev_desc(type, features, num_pages);
+	dev->desc = new_dev_desc(devices->descs, type, features, num_pages);
 	dev->mem = (void *)(dev->desc->pfn * getpagesize());
 	dev->handle_input = handle_input;
 	dev->watch_key = (unsigned long)dev->mem + watch_off;
@@ -866,30 +869,6 @@ static void setup_tun_net(const char *ar
 		verbose("attached to bridge: %s\n", br_name);
 }
 
-/* Now we know how much memory we have, we copy in device descriptors */
-static void map_device_descriptors(struct device_list *devs, unsigned long mem)
-{
-	struct device *i;
-	unsigned int num;
-	struct lguest_device_desc *descs;
-
-	/* Device descriptor array sits just above top of normal memory */
-	descs = map_zeroed_pages(mem, 1);
-
-	for (i = devs->dev, num = 0; i; i = i->next, num++) {
-		if (num == LGUEST_MAX_DEVICES)
-			errx(1, "too many devices");
-		verbose("Device %i: %s\n", num,
-			i->desc->type == LGUEST_DEVICE_T_NET ? "net"
-			: i->desc->type == LGUEST_DEVICE_T_CONSOLE ? "console"
-			: i->desc->type == LGUEST_DEVICE_T_BLOCK ? "block"
-			: "unknown");
-		descs[num] = *i->desc;
-		free(i->desc);
-		i->desc = &descs[num];
-	}
-}
-
 static void __attribute__((noreturn))
 run_guest(int lguest_fd, struct device_list *device_list)
 {
@@ -934,8 +913,8 @@ static void usage(void)
 
 int main(int argc, char *argv[])
 {
-	unsigned long mem, pgdir, start, page_offset, initrd_size = 0;
-	int c, lguest_fd;
+	unsigned long mem = 0, pgdir, start, page_offset, initrd_size = 0;
+	int i, c, lguest_fd;
 	struct device_list device_list;
 	void *boot = (void *)0;
 	const char *initrd_name = NULL;
@@ -945,6 +924,15 @@ int main(int argc, char *argv[])
 	device_list.lastdev = &device_list.dev;
 	FD_ZERO(&device_list.infds);
 
+	/* We need to know how much memory so we can allocate devices. */ 
+	for (i = 1; i < argc; i++) {
+		if (argv[i][0] != '-') {
+			mem = top = atoi(argv[i]) * 1024 * 1024;
+			device_list.descs = map_zeroed_pages(top, 1);
+			top += getpagesize();
+			break;
+		}
+	}
 	while ((c = getopt_long(argc, argv, "v", opts, NULL)) != EOF) {
 		switch (c) {
 		case 'v':
@@ -974,15 +962,11 @@ int main(int argc, char *argv[])
 	setup_console(&device_list);
 
 	/* First we map /dev/zero over all of guest-physical memory. */
-	mem = atoi(argv[optind]) * 1024 * 1024;
 	map_zeroed_pages(0, mem / getpagesize());
 
 	/* Now we load the kernel */
 	start = load_kernel(open_or_die(argv[optind+1], O_RDONLY),
 			    &page_offset);
-
-	/* Write the device descriptors into memory. */
-	map_device_descriptors(&device_list, mem);
 
 	/* Map the initrd image if requested */
 	if (initrd_name) {


