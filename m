Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYADR2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYADR2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 12:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYADR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 12:28:21 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:43831 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYADR2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 12:28:18 -0500
Date: Fri, 4 Jan 2008 11:26:09 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, wd@denx.de
Subject: [PATCH 1/3 v2] Merge mkubootimg tool for building U-Boot images
Message-ID: <20080104112609.6b678ccc@zod.rchland.ibm.com>
In-Reply-To: <20080104161336.GB31026@uranus.ravnborg.org>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com>
	<20080103160244.6a28519b@zod.rchland.ibm.com>
	<20080104161336.GB31026@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several platforms require the mkimage tool to generate a uImage file that is
used with U-Boot.  This brings the mkimage tool in-kernel to enable building
those platforms without having mkimage externally provided.  The tool is named
mkubootimg for better clarity.

This is currently based off of the version found in U-Boot 1.3.1.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

---
 scripts/Makefile             |    1 
 scripts/mkubootimg/Makefile  |    6 
 scripts/mkubootimg/crc32.c   |  196 +++++++++++
 scripts/mkubootimg/mkimage.c |  727 +++++++++++++++++++++++++++++++++++++++++++
 scripts/mkubootimg/uimage.h  |  161 +++++++++
 5 files changed, 1091 insertions(+)

--- linux-2.6.orig/scripts/Makefile
+++ linux-2.6/scripts/Makefile
@@ -20,6 +20,7 @@ hostprogs-y += unifdef
 
 subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
+subdir-y                     += mkubootimg
 
 # Let clean descend into subdirs
 subdir-	+= basic kconfig package
--- /dev/null
+++ linux-2.6/scripts/mkubootimg/Makefile
@@ -0,0 +1,6 @@
+hostprogs-y	:= mkubootimg
+always		:= $(hostprogs-y)
+
+mkubootimg-objs	:= mkimage.o crc32.o
+
+HOSTCFLAGS_crc32.o := -DUSE_HOSTCC
--- /dev/null
+++ linux-2.6/scripts/mkubootimg/crc32.c
@@ -0,0 +1,196 @@
+/*
+ * This file is derived from crc32.c from the zlib-1.1.3 distribution
+ * by Jean-loup Gailly and Mark Adler.
+ */
+
+/* crc32.c -- compute the CRC-32 of a data stream
+ * Copyright (C) 1995-1998 Mark Adler
+ * For conditions of distribution and use, see copyright notice in zlib.h
+ */
+
+#ifndef USE_HOSTCC	/* Shut down "ANSI does not permit..." warnings */
+#include <common.h>
+#endif
+
+#include "zlib.h"
+
+#define local static
+#define ZEXPORT	/* empty */
+unsigned long crc32 (unsigned long, const unsigned char *, unsigned int);
+
+#ifdef DYNAMIC_CRC_TABLE
+
+local int crc_table_empty = 1;
+local uLongf crc_table[256];
+local void make_crc_table OF((void));
+
+/*
+  Generate a table for a byte-wise 32-bit CRC calculation on the polynomial:
+  x^32+x^26+x^23+x^22+x^16+x^12+x^11+x^10+x^8+x^7+x^5+x^4+x^2+x+1.
+
+  Polynomials over GF(2) are represented in binary, one bit per coefficient,
+  with the lowest powers in the most significant bit.  Then adding polynomials
+  is just exclusive-or, and multiplying a polynomial by x is a right shift by
+  one.  If we call the above polynomial p, and represent a byte as the
+  polynomial q, also with the lowest power in the most significant bit (so the
+  byte 0xb1 is the polynomial x^7+x^3+x+1), then the CRC is (q*x^32) mod p,
+  where a mod b means the remainder after dividing a by b.
+
+  This calculation is done using the shift-register method of multiplying and
+  taking the remainder.  The register is initialized to zero, and for each
+  incoming bit, x^32 is added mod p to the register if the bit is a one (where
+  x^32 mod p is p+x^32 = x^26+...+1), and the register is multiplied mod p by
+  x (which is shifting right by one and adding x^32 mod p if the bit shifted
+  out is a one).  We start with the highest power (least significant bit) of
+  q and repeat for all eight bits of q.
+
+  The table is simply the CRC of all possible eight bit values.  This is all
+  the information needed to generate CRC's on data a byte at a time for all
+  combinations of CRC register values and incoming bytes.
+*/
+local void make_crc_table()
+{
+  uLong c;
+  int n, k;
+  uLong poly;            /* polynomial exclusive-or pattern */
+  /* terms of polynomial defining this crc (except x^32): */
+  static const Byte p[] = {0,1,2,4,5,7,8,10,11,12,16,22,23,26};
+
+  /* make exclusive-or pattern from polynomial (0xedb88320L) */
+  poly = 0L;
+  for (n = 0; n < sizeof(p)/sizeof(Byte); n++)
+    poly |= 1L << (31 - p[n]);
+
+  for (n = 0; n < 256; n++)
+  {
+    c = (uLong)n;
+    for (k = 0; k < 8; k++)
+      c = c & 1 ? poly ^ (c >> 1) : c >> 1;
+    crc_table[n] = c;
+  }
+  crc_table_empty = 0;
+}
+#else
+/* ========================================================================
+ * Table of CRC-32's of all single-byte values (made by make_crc_table)
+ */
+local const uLongf crc_table[256] = {
+  0x00000000L, 0x77073096L, 0xee0e612cL, 0x990951baL, 0x076dc419L,
+  0x706af48fL, 0xe963a535L, 0x9e6495a3L, 0x0edb8832L, 0x79dcb8a4L,
+  0xe0d5e91eL, 0x97d2d988L, 0x09b64c2bL, 0x7eb17cbdL, 0xe7b82d07L,
+  0x90bf1d91L, 0x1db71064L, 0x6ab020f2L, 0xf3b97148L, 0x84be41deL,
+  0x1adad47dL, 0x6ddde4ebL, 0xf4d4b551L, 0x83d385c7L, 0x136c9856L,
+  0x646ba8c0L, 0xfd62f97aL, 0x8a65c9ecL, 0x14015c4fL, 0x63066cd9L,
+  0xfa0f3d63L, 0x8d080df5L, 0x3b6e20c8L, 0x4c69105eL, 0xd56041e4L,
+  0xa2677172L, 0x3c03e4d1L, 0x4b04d447L, 0xd20d85fdL, 0xa50ab56bL,
+  0x35b5a8faL, 0x42b2986cL, 0xdbbbc9d6L, 0xacbcf940L, 0x32d86ce3L,
+  0x45df5c75L, 0xdcd60dcfL, 0xabd13d59L, 0x26d930acL, 0x51de003aL,
+  0xc8d75180L, 0xbfd06116L, 0x21b4f4b5L, 0x56b3c423L, 0xcfba9599L,
+  0xb8bda50fL, 0x2802b89eL, 0x5f058808L, 0xc60cd9b2L, 0xb10be924L,
+  0x2f6f7c87L, 0x58684c11L, 0xc1611dabL, 0xb6662d3dL, 0x76dc4190L,
+  0x01db7106L, 0x98d220bcL, 0xefd5102aL, 0x71b18589L, 0x06b6b51fL,
+  0x9fbfe4a5L, 0xe8b8d433L, 0x7807c9a2L, 0x0f00f934L, 0x9609a88eL,
+  0xe10e9818L, 0x7f6a0dbbL, 0x086d3d2dL, 0x91646c97L, 0xe6635c01L,
+  0x6b6b51f4L, 0x1c6c6162L, 0x856530d8L, 0xf262004eL, 0x6c0695edL,
+  0x1b01a57bL, 0x8208f4c1L, 0xf50fc457L, 0x65b0d9c6L, 0x12b7e950L,
+  0x8bbeb8eaL, 0xfcb9887cL, 0x62dd1ddfL, 0x15da2d49L, 0x8cd37cf3L,
+  0xfbd44c65L, 0x4db26158L, 0x3ab551ceL, 0xa3bc0074L, 0xd4bb30e2L,
+  0x4adfa541L, 0x3dd895d7L, 0xa4d1c46dL, 0xd3d6f4fbL, 0x4369e96aL,
+  0x346ed9fcL, 0xad678846L, 0xda60b8d0L, 0x44042d73L, 0x33031de5L,
+  0xaa0a4c5fL, 0xdd0d7cc9L, 0x5005713cL, 0x270241aaL, 0xbe0b1010L,
+  0xc90c2086L, 0x5768b525L, 0x206f85b3L, 0xb966d409L, 0xce61e49fL,
+  0x5edef90eL, 0x29d9c998L, 0xb0d09822L, 0xc7d7a8b4L, 0x59b33d17L,
+  0x2eb40d81L, 0xb7bd5c3bL, 0xc0ba6cadL, 0xedb88320L, 0x9abfb3b6L,
+  0x03b6e20cL, 0x74b1d29aL, 0xead54739L, 0x9dd277afL, 0x04db2615L,
+  0x73dc1683L, 0xe3630b12L, 0x94643b84L, 0x0d6d6a3eL, 0x7a6a5aa8L,
+  0xe40ecf0bL, 0x9309ff9dL, 0x0a00ae27L, 0x7d079eb1L, 0xf00f9344L,
+  0x8708a3d2L, 0x1e01f268L, 0x6906c2feL, 0xf762575dL, 0x806567cbL,
+  0x196c3671L, 0x6e6b06e7L, 0xfed41b76L, 0x89d32be0L, 0x10da7a5aL,
+  0x67dd4accL, 0xf9b9df6fL, 0x8ebeeff9L, 0x17b7be43L, 0x60b08ed5L,
+  0xd6d6a3e8L, 0xa1d1937eL, 0x38d8c2c4L, 0x4fdff252L, 0xd1bb67f1L,
+  0xa6bc5767L, 0x3fb506ddL, 0x48b2364bL, 0xd80d2bdaL, 0xaf0a1b4cL,
+  0x36034af6L, 0x41047a60L, 0xdf60efc3L, 0xa867df55L, 0x316e8eefL,
+  0x4669be79L, 0xcb61b38cL, 0xbc66831aL, 0x256fd2a0L, 0x5268e236L,
+  0xcc0c7795L, 0xbb0b4703L, 0x220216b9L, 0x5505262fL, 0xc5ba3bbeL,
+  0xb2bd0b28L, 0x2bb45a92L, 0x5cb36a04L, 0xc2d7ffa7L, 0xb5d0cf31L,
+  0x2cd99e8bL, 0x5bdeae1dL, 0x9b64c2b0L, 0xec63f226L, 0x756aa39cL,
+  0x026d930aL, 0x9c0906a9L, 0xeb0e363fL, 0x72076785L, 0x05005713L,
+  0x95bf4a82L, 0xe2b87a14L, 0x7bb12baeL, 0x0cb61b38L, 0x92d28e9bL,
+  0xe5d5be0dL, 0x7cdcefb7L, 0x0bdbdf21L, 0x86d3d2d4L, 0xf1d4e242L,
+  0x68ddb3f8L, 0x1fda836eL, 0x81be16cdL, 0xf6b9265bL, 0x6fb077e1L,
+  0x18b74777L, 0x88085ae6L, 0xff0f6a70L, 0x66063bcaL, 0x11010b5cL,
+  0x8f659effL, 0xf862ae69L, 0x616bffd3L, 0x166ccf45L, 0xa00ae278L,
+  0xd70dd2eeL, 0x4e048354L, 0x3903b3c2L, 0xa7672661L, 0xd06016f7L,
+  0x4969474dL, 0x3e6e77dbL, 0xaed16a4aL, 0xd9d65adcL, 0x40df0b66L,
+  0x37d83bf0L, 0xa9bcae53L, 0xdebb9ec5L, 0x47b2cf7fL, 0x30b5ffe9L,
+  0xbdbdf21cL, 0xcabac28aL, 0x53b39330L, 0x24b4a3a6L, 0xbad03605L,
+  0xcdd70693L, 0x54de5729L, 0x23d967bfL, 0xb3667a2eL, 0xc4614ab8L,
+  0x5d681b02L, 0x2a6f2b94L, 0xb40bbe37L, 0xc30c8ea1L, 0x5a05df1bL,
+  0x2d02ef8dL
+};
+#endif
+
+#if 0
+/* =========================================================================
+ * This function can be used by asm versions of crc32()
+ */
+const uLongf * ZEXPORT get_crc_table()
+{
+#ifdef DYNAMIC_CRC_TABLE
+  if (crc_table_empty) make_crc_table();
+#endif
+  return (const uLongf *)crc_table;
+}
+#endif
+
+/* ========================================================================= */
+#define DO1(buf) crc = crc_table[((int)crc ^ (*buf++)) & 0xff] ^ (crc >> 8);
+#define DO2(buf)  DO1(buf); DO1(buf);
+#define DO4(buf)  DO2(buf); DO2(buf);
+#define DO8(buf)  DO4(buf); DO4(buf);
+
+/* ========================================================================= */
+uLong ZEXPORT crc32(uLong crc, const Bytef *buf, uInt len)
+{
+#ifdef DYNAMIC_CRC_TABLE
+    if (crc_table_empty)
+      make_crc_table();
+#endif
+    crc = crc ^ 0xffffffffL;
+    while (len >= 8)
+    {
+      DO8(buf);
+      len -= 8;
+    }
+    if (len) do {
+      DO1(buf);
+    } while (--len);
+    return crc ^ 0xffffffffL;
+}
+
+#if defined(CONFIG_CMD_JFFS2) || \
+	(defined(CONFIG_CMD_NAND) \
+	&& !defined(CFG_NAND_LEGACY))
+
+/* No ones complement version. JFFS2 (and other things ?)
+ * don't use ones compliment in their CRC calculations.
+ */
+uLong ZEXPORT crc32_no_comp(uLong crc, const Bytef *buf, uInt len)
+{
+#ifdef DYNAMIC_CRC_TABLE
+    if (crc_table_empty)
+      make_crc_table();
+#endif
+    while (len >= 8)
+    {
+      DO8(buf);
+      len -= 8;
+    }
+    if (len) do {
+      DO1(buf);
+    } while (--len);
+
+    return crc;
+}
+
+#endif
--- /dev/null
+++ linux-2.6/scripts/mkubootimg/mkimage.c
@@ -0,0 +1,727 @@
+/*
+ * (C) Copyright 2000-2004
+ * DENX Software Engineering
+ * Wolfgang Denk, wd@denx.de
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/in.h>		/* for host / network byte order conversions	*/
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <time.h>
+#include <unistd.h>
+
+#ifndef	O_BINARY		/* should be define'd on __WIN32__ */
+#define O_BINARY	0
+#endif
+
+#include "uimage.h"
+
+#ifndef MAP_FAILED
+#define MAP_FAILED (-1)
+#endif
+
+static char *cmdname;
+
+extern unsigned long crc32 (unsigned long crc, const char *buf, unsigned int len);
+
+typedef struct table_entry {
+	int	val;		/* as defined in image.h	*/
+	char	*sname;		/* short (input) name		*/
+	char	*lname;		/* long (output) name		*/
+} table_entry_t;
+
+static table_entry_t arch_name[] = {
+    {	IH_CPU_INVALID,		NULL,		"Invalid CPU",	},
+    {	IH_CPU_ALPHA,		"alpha",	"Alpha",	},
+    {	IH_CPU_ARM,		"arm",		"ARM",		},
+    {	IH_CPU_I386,		"x86",		"Intel x86",	},
+    {	IH_CPU_IA64,		"ia64",		"IA64",		},
+    {	IH_CPU_M68K,		"m68k",		"MC68000",	},
+    {	IH_CPU_MICROBLAZE,	"microblaze",	"MicroBlaze",	},
+    {	IH_CPU_MIPS,		"mips",		"MIPS",		},
+    {	IH_CPU_MIPS64,		"mips64",	"MIPS 64 Bit",	},
+    {	IH_CPU_NIOS,		"nios",		"NIOS",		},
+    {	IH_CPU_NIOS2,		"nios2",	"NIOS II",	},
+    {	IH_CPU_PPC,		"ppc",		"PowerPC",	},
+    {	IH_CPU_S390,		"s390",		"IBM S390",	},
+    {	IH_CPU_SH,		"sh",		"SuperH",	},
+    {	IH_CPU_SPARC,		"sparc",	"SPARC",	},
+    {	IH_CPU_SPARC64,		"sparc64",	"SPARC 64 Bit",	},
+    {	IH_CPU_BLACKFIN,	"blackfin",	"Blackfin",	},
+    {	IH_CPU_AVR32,		"avr32",	"AVR32",	},
+    {	-1,			"",		"",		},
+};
+
+static table_entry_t os_name[] = {
+    {	IH_OS_INVALID,	NULL,		"Invalid OS",		},
+    {	IH_OS_4_4BSD,	"4_4bsd",	"4_4BSD",		},
+    {	IH_OS_ARTOS,	"artos",	"ARTOS",		},
+    {	IH_OS_DELL,	"dell",		"Dell",			},
+    {	IH_OS_ESIX,	"esix",		"Esix",			},
+    {	IH_OS_FREEBSD,	"freebsd",	"FreeBSD",		},
+    {	IH_OS_IRIX,	"irix",		"Irix",			},
+    {	IH_OS_LINUX,	"linux",	"Linux",		},
+    {	IH_OS_LYNXOS,	"lynxos",	"LynxOS",		},
+    {	IH_OS_NCR,	"ncr",		"NCR",			},
+    {	IH_OS_NETBSD,	"netbsd",	"NetBSD",		},
+    {	IH_OS_OPENBSD,	"openbsd",	"OpenBSD",		},
+    {	IH_OS_PSOS,	"psos",		"pSOS",			},
+    {	IH_OS_QNX,	"qnx",		"QNX",			},
+    {	IH_OS_RTEMS,	"rtems",	"RTEMS",		},
+    {	IH_OS_SCO,	"sco",		"SCO",			},
+    {	IH_OS_SOLARIS,	"solaris",	"Solaris",		},
+    {	IH_OS_SVR4,	"svr4",		"SVR4",			},
+    {	IH_OS_U_BOOT,	"u-boot",	"U-Boot",		},
+    {	IH_OS_VXWORKS,	"vxworks",	"VxWorks",		},
+    {	-1,		"",		"",			},
+};
+
+static table_entry_t type_name[] = {
+    {	IH_TYPE_INVALID,    NULL,	  "Invalid Image",	},
+    {	IH_TYPE_FILESYSTEM, "filesystem", "Filesystem Image",	},
+    {	IH_TYPE_FIRMWARE,   "firmware",	  "Firmware",		},
+    {	IH_TYPE_KERNEL,	    "kernel",	  "Kernel Image",	},
+    {	IH_TYPE_MULTI,	    "multi",	  "Multi-File Image",	},
+    {	IH_TYPE_RAMDISK,    "ramdisk",	  "RAMDisk Image",	},
+    {	IH_TYPE_SCRIPT,     "script",	  "Script",		},
+    {	IH_TYPE_STANDALONE, "standalone", "Standalone Program", },
+    {	IH_TYPE_FLATDT,     "flat_dt",    "Flat Device Tree",	},
+    {	-1,		    "",		  "",			},
+};
+
+static table_entry_t comp_name[] = {
+    {	IH_COMP_NONE,	"none",		"uncompressed",		},
+    {	IH_COMP_BZIP2,	"bzip2",	"bzip2 compressed",	},
+    {	IH_COMP_GZIP,	"gzip",		"gzip compressed",	},
+    {	-1,		"",		"",			},
+};
+
+static	void	copy_file (int, const char *, int);
+static	void	usage	(void);
+static	void	print_header (image_header_t *);
+static	void	print_type (image_header_t *);
+static	char	*put_table_entry (table_entry_t *, char *, int);
+static	char	*put_arch (int);
+static	char	*put_type (int);
+static	char	*put_os   (int);
+static	char	*put_comp (int);
+static	int	get_table_entry (table_entry_t *, char *, char *);
+static	int	get_arch(char *);
+static	int	get_comp(char *);
+static	int	get_os  (char *);
+static	int	get_type(char *);
+
+
+static char	*datafile;
+static char	*imagefile;
+
+static int dflag    = 0;
+static int eflag    = 0;
+static int lflag    = 0;
+static int vflag    = 0;
+static int xflag    = 0;
+static int opt_os   = IH_OS_LINUX;
+static int opt_arch = IH_CPU_PPC;
+static int opt_type = IH_TYPE_KERNEL;
+static int opt_comp = IH_COMP_GZIP;
+
+static image_header_t header;
+static image_header_t *hdr = &header;
+
+int
+main (int argc, char **argv)
+{
+	int ifd;
+	uint32_t checksum;
+	uint32_t addr;
+	uint32_t ep;
+	struct stat sbuf;
+	unsigned char *ptr;
+	char *endptr;
+	char *name = "";
+
+	cmdname = *argv;
+
+	addr = ep = 0;
+
+	while (--argc > 0 && **++argv == '-') {
+		while (*++*argv) {
+			switch (**argv) {
+			case 'l':
+				lflag = 1;
+				break;
+			case 'A':
+				if ((--argc <= 0) ||
+				    (opt_arch = get_arch(*++argv)) < 0)
+					usage ();
+				goto NXTARG;
+			case 'C':
+				if ((--argc <= 0) ||
+				    (opt_comp = get_comp(*++argv)) < 0)
+					usage ();
+				goto NXTARG;
+			case 'O':
+				if ((--argc <= 0) ||
+				    (opt_os = get_os(*++argv)) < 0)
+					usage ();
+				goto NXTARG;
+			case 'T':
+				if ((--argc <= 0) ||
+				    (opt_type = get_type(*++argv)) < 0)
+					usage ();
+				goto NXTARG;
+
+			case 'a':
+				if (--argc <= 0)
+					usage ();
+				addr = strtoul ((char *) *++argv, &endptr, 16);
+				if (*endptr) {
+					fprintf (stderr,
+						"%s: invalid load address %s\n",
+						cmdname, *argv);
+					exit (EXIT_FAILURE);
+				}
+				goto NXTARG;
+			case 'd':
+				if (--argc <= 0)
+					usage ();
+				datafile = *++argv;
+				dflag = 1;
+				goto NXTARG;
+			case 'e':
+				if (--argc <= 0)
+					usage ();
+				ep = strtoul (*++argv, &endptr, 16);
+				if (*endptr) {
+					fprintf (stderr,
+						"%s: invalid entry point %s\n",
+						cmdname, *argv);
+					exit (EXIT_FAILURE);
+				}
+				eflag = 1;
+				goto NXTARG;
+			case 'n':
+				if (--argc <= 0)
+					usage ();
+				name = *++argv;
+				goto NXTARG;
+			case 'v':
+				vflag++;
+				break;
+			case 'x':
+				xflag++;
+				break;
+			default:
+				usage ();
+			}
+		}
+NXTARG:		;
+	}
+
+	if ((argc != 1) || ((lflag ^ dflag) == 0))
+		usage();
+
+	if (!eflag) {
+		ep = addr;
+		/* If XIP, entry point must be after the U-Boot header */
+		if (xflag)
+			ep += sizeof(image_header_t);
+	}
+
+	/*
+	 * If XIP, ensure the entry point is equal to the load address plus
+	 * the size of the U-Boot header.
+	 */
+	if (xflag) {
+		if (ep != addr + sizeof(image_header_t)) {
+			fprintf (stderr,
+				"%s: For XIP, the entry point must be the load addr + %lu\n",
+				cmdname,
+				(unsigned long)sizeof(image_header_t));
+			exit (EXIT_FAILURE);
+		}
+	}
+
+	imagefile = *argv;
+
+	if (lflag) {
+		ifd = open(imagefile, O_RDONLY|O_BINARY);
+	} else {
+		ifd = open(imagefile, O_RDWR|O_CREAT|O_TRUNC|O_BINARY, 0666);
+	}
+
+	if (ifd < 0) {
+		fprintf (stderr, "%s: Can't open %s: %s\n",
+			cmdname, imagefile, strerror(errno));
+		exit (EXIT_FAILURE);
+	}
+
+	if (lflag) {
+		int len;
+		char *data;
+		/*
+		 * list header information of existing image
+		 */
+		if (fstat(ifd, &sbuf) < 0) {
+			fprintf (stderr, "%s: Can't stat %s: %s\n",
+				cmdname, imagefile, strerror(errno));
+			exit (EXIT_FAILURE);
+		}
+
+		if ((unsigned)sbuf.st_size < sizeof(image_header_t)) {
+			fprintf (stderr,
+				"%s: Bad size: \"%s\" is no valid image\n",
+				cmdname, imagefile);
+			exit (EXIT_FAILURE);
+		}
+
+		ptr = (unsigned char *)mmap(NULL, sbuf.st_size,
+					    PROT_READ, MAP_SHARED, ifd, 0);
+		if ((caddr_t)ptr == (caddr_t)-1) {
+			fprintf (stderr, "%s: Can't read %s: %s\n",
+				cmdname, imagefile, strerror(errno));
+			exit (EXIT_FAILURE);
+		}
+
+		/*
+		 * create copy of header so that we can blank out the
+		 * checksum field for checking - this can't be done
+		 * on the PROT_READ mapped data.
+		 */
+		memcpy (hdr, ptr, sizeof(image_header_t));
+
+		if (ntohl(hdr->ih_magic) != IH_MAGIC) {
+			fprintf (stderr,
+				"%s: Bad Magic Number: \"%s\" is no valid image\n",
+				cmdname, imagefile);
+			exit (EXIT_FAILURE);
+		}
+
+		data = (char *)hdr;
+		len  = sizeof(image_header_t);
+
+		checksum = ntohl(hdr->ih_hcrc);
+		hdr->ih_hcrc = htonl(0);	/* clear for re-calculation */
+
+		if (crc32 (0, data, len) != checksum) {
+			fprintf (stderr,
+				"%s: ERROR: \"%s\" has bad header checksum!\n",
+				cmdname, imagefile);
+			exit (EXIT_FAILURE);
+		}
+
+		data = (char *)(ptr + sizeof(image_header_t));
+		len  = sbuf.st_size - sizeof(image_header_t) ;
+
+		if (crc32 (0, data, len) != ntohl(hdr->ih_dcrc)) {
+			fprintf (stderr,
+				"%s: ERROR: \"%s\" has corrupted data!\n",
+				cmdname, imagefile);
+			exit (EXIT_FAILURE);
+		}
+
+		/* for multi-file images we need the data part, too */
+		print_header ((image_header_t *)ptr);
+
+		(void) munmap((void *)ptr, sbuf.st_size);
+		(void) close (ifd);
+
+		exit (EXIT_SUCCESS);
+	}
+
+	/*
+	 * Must be -w then:
+	 *
+	 * write dummy header, to be fixed later
+	 */
+	memset (hdr, 0, sizeof(image_header_t));
+
+	if (write(ifd, hdr, sizeof(image_header_t)) != sizeof(image_header_t)) {
+		fprintf (stderr, "%s: Write error on %s: %s\n",
+			cmdname, imagefile, strerror(errno));
+		exit (EXIT_FAILURE);
+	}
+
+	if (opt_type == IH_TYPE_MULTI || opt_type == IH_TYPE_SCRIPT) {
+		char *file = datafile;
+		uint32_t size;
+
+		for (;;) {
+			char *sep = NULL;
+
+			if (file) {
+				if ((sep = strchr(file, ':')) != NULL) {
+					*sep = '\0';
+				}
+
+				if (stat (file, &sbuf) < 0) {
+					fprintf (stderr, "%s: Can't stat %s: %s\n",
+						cmdname, file, strerror(errno));
+					exit (EXIT_FAILURE);
+				}
+				size = htonl(sbuf.st_size);
+			} else {
+				size = 0;
+			}
+
+			if (write(ifd, (char *)&size, sizeof(size)) != sizeof(size)) {
+				fprintf (stderr, "%s: Write error on %s: %s\n",
+					cmdname, imagefile, strerror(errno));
+				exit (EXIT_FAILURE);
+			}
+
+			if (!file) {
+				break;
+			}
+
+			if (sep) {
+				*sep = ':';
+				file = sep + 1;
+			} else {
+				file = NULL;
+			}
+		}
+
+		file = datafile;
+
+		for (;;) {
+			char *sep = strchr(file, ':');
+			if (sep) {
+				*sep = '\0';
+				copy_file (ifd, file, 1);
+				*sep++ = ':';
+				file = sep;
+			} else {
+				copy_file (ifd, file, 0);
+				break;
+			}
+		}
+	} else {
+		copy_file (ifd, datafile, 0);
+	}
+
+	/* We're a bit of paranoid */
+#if defined(_POSIX_SYNCHRONIZED_IO) && !defined(__sun__) && !defined(__FreeBSD__) && !defined(__APPLE__)
+	(void) fdatasync (ifd);
+#else
+	(void) fsync (ifd);
+#endif
+
+	if (fstat(ifd, &sbuf) < 0) {
+		fprintf (stderr, "%s: Can't stat %s: %s\n",
+			cmdname, imagefile, strerror(errno));
+		exit (EXIT_FAILURE);
+	}
+
+	ptr = (unsigned char *)mmap(NULL, sbuf.st_size,
+				    PROT_READ|PROT_WRITE, MAP_SHARED, ifd, 0);
+	if (ptr == (unsigned char *)MAP_FAILED) {
+		fprintf (stderr, "%s: Can't map %s: %s\n",
+			cmdname, imagefile, strerror(errno));
+		exit (EXIT_FAILURE);
+	}
+
+	hdr = (image_header_t *)ptr;
+
+	checksum = crc32 (0,
+			  (const char *)(ptr + sizeof(image_header_t)),
+			  sbuf.st_size - sizeof(image_header_t)
+			 );
+
+	/* Build new header */
+	hdr->ih_magic = htonl(IH_MAGIC);
+	hdr->ih_time  = htonl(sbuf.st_mtime);
+	hdr->ih_size  = htonl(sbuf.st_size - sizeof(image_header_t));
+	hdr->ih_load  = htonl(addr);
+	hdr->ih_ep    = htonl(ep);
+	hdr->ih_dcrc  = htonl(checksum);
+	hdr->ih_os    = opt_os;
+	hdr->ih_arch  = opt_arch;
+	hdr->ih_type  = opt_type;
+	hdr->ih_comp  = opt_comp;
+
+	strncpy((char *)hdr->ih_name, name, IH_NMLEN);
+
+	checksum = crc32(0,(const char *)hdr,sizeof(image_header_t));
+
+	hdr->ih_hcrc = htonl(checksum);
+
+	print_header (hdr);
+
+	(void) munmap((void *)ptr, sbuf.st_size);
+
+	/* We're a bit of paranoid */
+#if defined(_POSIX_SYNCHRONIZED_IO) && !defined(__sun__) && !defined(__FreeBSD__) && !defined(__APPLE__)
+	(void) fdatasync (ifd);
+#else
+	(void) fsync (ifd);
+#endif
+
+	if (close(ifd)) {
+		fprintf (stderr, "%s: Write error on %s: %s\n",
+			cmdname, imagefile, strerror(errno));
+		exit (EXIT_FAILURE);
+	}
+
+	exit (EXIT_SUCCESS);
+}
+
+static void
+copy_file (int ifd, const char *datafile, int pad)
+{
+	int dfd;
+	struct stat sbuf;
+	unsigned char *ptr;
+	int tail;
+	int zero = 0;
+	int offset = 0;
+	int size;
+
+	if (vflag) {
+		fprintf (stderr, "Adding Image %s\n", datafile);
+	}
+
+	if ((dfd = open(datafile, O_RDONLY|O_BINARY)) < 0) {
+		fprintf (stderr, "%s: Can't open %s: %s\n",
+			cmdname, datafile, strerror(errno));
+		exit (EXIT_FAILURE);
+	}
+
+	if (fstat(dfd, &sbuf) < 0) {
+		fprintf (stderr, "%s: Can't stat %s: %s\n",
+			cmdname, datafile, strerror(errno));
+		exit (EXIT_FAILURE);
+	}
+
+	ptr = (unsigned char *)mmap(NULL, sbuf.st_size,
+				    PROT_READ, MAP_SHARED, dfd, 0);
+	if (ptr == (unsigned char *)MAP_FAILED) {
+		fprintf (stderr, "%s: Can't read %s: %s\n",
+			cmdname, datafile, strerror(errno));
+		exit (EXIT_FAILURE);
+	}
+
+	if (xflag) {
+		unsigned char *p = NULL;
+		/*
+		 * XIP: do not append the image_header_t at the
+		 * beginning of the file, but consume the space
+		 * reserved for it.
+		 */
+
+		if ((unsigned)sbuf.st_size < sizeof(image_header_t)) {
+			fprintf (stderr,
+				"%s: Bad size: \"%s\" is too small for XIP\n",
+				cmdname, datafile);
+			exit (EXIT_FAILURE);
+		}
+
+		for (p=ptr; p < ptr+sizeof(image_header_t); p++) {
+			if ( *p != 0xff ) {
+				fprintf (stderr,
+					"%s: Bad file: \"%s\" has invalid buffer for XIP\n",
+					cmdname, datafile);
+				exit (EXIT_FAILURE);
+			}
+		}
+
+		offset = sizeof(image_header_t);
+	}
+
+	size = sbuf.st_size - offset;
+	if (write(ifd, ptr + offset, size) != size) {
+		fprintf (stderr, "%s: Write error on %s: %s\n",
+			cmdname, imagefile, strerror(errno));
+		exit (EXIT_FAILURE);
+	}
+
+	if (pad && ((tail = size % 4) != 0)) {
+
+		if (write(ifd, (char *)&zero, 4-tail) != 4-tail) {
+			fprintf (stderr, "%s: Write error on %s: %s\n",
+				cmdname, imagefile, strerror(errno));
+			exit (EXIT_FAILURE);
+		}
+	}
+
+	(void) munmap((void *)ptr, sbuf.st_size);
+	(void) close (dfd);
+}
+
+static void
+usage (void)
+{
+	fprintf (stderr, "Usage: %s -l image\n"
+			 "          -l ==> list image header information\n"
+			 "       %s [-x] -A arch -O os -T type -C comp "
+			 "-a addr -e ep -n name -d data_file[:data_file...] image\n",
+		cmdname, cmdname);
+	fprintf (stderr, "          -A ==> set architecture to 'arch'\n"
+			 "          -O ==> set operating system to 'os'\n"
+			 "          -T ==> set image type to 'type'\n"
+			 "          -C ==> set compression type 'comp'\n"
+			 "          -a ==> set load address to 'addr' (hex)\n"
+			 "          -e ==> set entry point to 'ep' (hex)\n"
+			 "          -n ==> set image name to 'name'\n"
+			 "          -d ==> use image data from 'datafile'\n"
+			 "          -x ==> set XIP (execute in place)\n"
+		);
+	exit (EXIT_FAILURE);
+}
+
+static void
+print_header (image_header_t *hdr)
+{
+	time_t timestamp;
+	uint32_t size;
+
+	timestamp = (time_t)ntohl(hdr->ih_time);
+	size = ntohl(hdr->ih_size);
+
+	printf ("Image Name:   %.*s\n", IH_NMLEN, hdr->ih_name);
+	printf ("Created:      %s", ctime(&timestamp));
+	printf ("Image Type:   "); print_type(hdr);
+	printf ("Data Size:    %d Bytes = %.2f kB = %.2f MB\n",
+		size, (double)size / 1.024e3, (double)size / 1.048576e6 );
+	printf ("Load Address: 0x%08X\n", ntohl(hdr->ih_load));
+	printf ("Entry Point:  0x%08X\n", ntohl(hdr->ih_ep));
+
+	if (hdr->ih_type == IH_TYPE_MULTI || hdr->ih_type == IH_TYPE_SCRIPT) {
+		int i, ptrs;
+		uint32_t pos;
+		uint32_t *len_ptr = (uint32_t *) (
+					(unsigned long)hdr + sizeof(image_header_t)
+				);
+
+		/* determine number of images first (to calculate image offsets) */
+		for (i=0; len_ptr[i]; ++i)	/* null pointer terminates list */
+			;
+		ptrs = i;		/* null pointer terminates list */
+
+		pos = sizeof(image_header_t) + ptrs * sizeof(long);
+		printf ("Contents:\n");
+		for (i=0; len_ptr[i]; ++i) {
+			size = ntohl(len_ptr[i]);
+
+			printf ("   Image %d: %8d Bytes = %4d kB = %d MB\n",
+				i, size, size>>10, size>>20);
+			if (hdr->ih_type == IH_TYPE_SCRIPT && i > 0) {
+				/*
+				 * the user may need to know offsets
+				 * if planning to do something with
+				 * multiple files
+				 */
+				printf ("    Offset = %08X\n", pos);
+			}
+			/* copy_file() will pad the first files to even word align */
+			size += 3;
+			size &= ~3;
+			pos += size;
+		}
+	}
+}
+
+
+static void
+print_type (image_header_t *hdr)
+{
+	printf ("%s %s %s (%s)\n",
+		put_arch (hdr->ih_arch),
+		put_os   (hdr->ih_os  ),
+		put_type (hdr->ih_type),
+		put_comp (hdr->ih_comp)
+	);
+}
+
+static char *put_arch (int arch)
+{
+	return (put_table_entry(arch_name, "Unknown Architecture", arch));
+}
+
+static char *put_os (int os)
+{
+	return (put_table_entry(os_name, "Unknown OS", os));
+}
+
+static char *put_type (int type)
+{
+	return (put_table_entry(type_name, "Unknown Image", type));
+}
+
+static char *put_comp (int comp)
+{
+	return (put_table_entry(comp_name, "Unknown Compression", comp));
+}
+
+static char *put_table_entry (table_entry_t *table, char *msg, int type)
+{
+	for (; table->val>=0; ++table) {
+		if (table->val == type)
+			return (table->lname);
+	}
+	return (msg);
+}
+
+static int get_arch(char *name)
+{
+	return (get_table_entry(arch_name, "CPU", name));
+}
+
+
+static int get_comp(char *name)
+{
+	return (get_table_entry(comp_name, "Compression", name));
+}
+
+
+static int get_os (char *name)
+{
+	return (get_table_entry(os_name, "OS", name));
+}
+
+
+static int get_type(char *name)
+{
+	return (get_table_entry(type_name, "Image", name));
+}
+
+static int get_table_entry (table_entry_t *table, char *msg, char *name)
+{
+	table_entry_t *t;
+	int first = 1;
+
+	for (t=table; t->val>=0; ++t) {
+		if (t->sname && strcasecmp(t->sname, name)==0)
+			return (t->val);
+	}
+	fprintf (stderr, "\nInvalid %s Type - valid names are", msg);
+	for (t=table; t->val>=0; ++t) {
+		if (t->sname == NULL)
+			continue;
+		fprintf (stderr, "%c %s", (first) ? ':' : ',', t->sname);
+		first = 0;
+	}
+	fprintf (stderr, "\n");
+	return (-1);
+}
--- /dev/null
+++ linux-2.6/scripts/mkubootimg/uimage.h
@@ -0,0 +1,161 @@
+/*
+ * (C) Copyright 2000-2005
+ * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
+ *
+ * See file CREDITS for list of people who contributed to this
+ * project.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ ********************************************************************
+ * NOTE: This header file defines an interface to U-Boot. Including
+ * this (unmodified) header file in another file is considered normal
+ * use of U-Boot, and does *not* fall under the heading of "derived
+ * work".
+ ********************************************************************
+ */
+
+#ifndef __IMAGE_H__
+#define __IMAGE_H__
+
+/*
+ * Operating System Codes
+ */
+#define IH_OS_INVALID		0	/* Invalid OS	*/
+#define IH_OS_OPENBSD		1	/* OpenBSD	*/
+#define IH_OS_NETBSD		2	/* NetBSD	*/
+#define IH_OS_FREEBSD		3	/* FreeBSD	*/
+#define IH_OS_4_4BSD		4	/* 4.4BSD	*/
+#define IH_OS_LINUX		5	/* Linux	*/
+#define IH_OS_SVR4		6	/* SVR4		*/
+#define IH_OS_ESIX		7	/* Esix		*/
+#define IH_OS_SOLARIS		8	/* Solaris	*/
+#define IH_OS_IRIX		9	/* Irix		*/
+#define IH_OS_SCO		10	/* SCO		*/
+#define IH_OS_DELL		11	/* Dell		*/
+#define IH_OS_NCR		12	/* NCR		*/
+#define IH_OS_LYNXOS		13	/* LynxOS	*/
+#define IH_OS_VXWORKS		14	/* VxWorks	*/
+#define IH_OS_PSOS		15	/* pSOS		*/
+#define IH_OS_QNX		16	/* QNX		*/
+#define IH_OS_U_BOOT		17	/* Firmware	*/
+#define IH_OS_RTEMS		18	/* RTEMS	*/
+#define IH_OS_ARTOS		19	/* ARTOS	*/
+#define IH_OS_UNITY		20	/* Unity OS	*/
+
+/*
+ * CPU Architecture Codes (supported by Linux)
+ */
+#define IH_CPU_INVALID		0	/* Invalid CPU	*/
+#define IH_CPU_ALPHA		1	/* Alpha	*/
+#define IH_CPU_ARM		2	/* ARM		*/
+#define IH_CPU_I386		3	/* Intel x86	*/
+#define IH_CPU_IA64		4	/* IA64		*/
+#define IH_CPU_MIPS		5	/* MIPS		*/
+#define IH_CPU_MIPS64		6	/* MIPS	 64 Bit */
+#define IH_CPU_PPC		7	/* PowerPC	*/
+#define IH_CPU_S390		8	/* IBM S390	*/
+#define IH_CPU_SH		9	/* SuperH	*/
+#define IH_CPU_SPARC		10	/* Sparc	*/
+#define IH_CPU_SPARC64		11	/* Sparc 64 Bit */
+#define IH_CPU_M68K		12	/* M68K		*/
+#define IH_CPU_NIOS		13	/* Nios-32	*/
+#define IH_CPU_MICROBLAZE	14	/* MicroBlaze   */
+#define IH_CPU_NIOS2		15	/* Nios-II	*/
+#define IH_CPU_BLACKFIN		16	/* Blackfin	*/
+#define IH_CPU_AVR32		17	/* AVR32	*/
+#define IH_CPU_ST200	        18	/* STMicroelectronics ST200  */
+
+/*
+ * Image Types
+ *
+ * "Standalone Programs" are directly runnable in the environment
+ *	provided by U-Boot; it is expected that (if they behave
+ *	well) you can continue to work in U-Boot after return from
+ *	the Standalone Program.
+ * "OS Kernel Images" are usually images of some Embedded OS which
+ *	will take over control completely. Usually these programs
+ *	will install their own set of exception handlers, device
+ *	drivers, set up the MMU, etc. - this means, that you cannot
+ *	expect to re-enter U-Boot except by resetting the CPU.
+ * "RAMDisk Images" are more or less just data blocks, and their
+ *	parameters (address, size) are passed to an OS kernel that is
+ *	being started.
+ * "Multi-File Images" contain several images, typically an OS
+ *	(Linux) kernel image and one or more data images like
+ *	RAMDisks. This construct is useful for instance when you want
+ *	to boot over the network using BOOTP etc., where the boot
+ *	server provides just a single image file, but you want to get
+ *	for instance an OS kernel and a RAMDisk image.
+ *
+ *	"Multi-File Images" start with a list of image sizes, each
+ *	image size (in bytes) specified by an "uint32_t" in network
+ *	byte order. This list is terminated by an "(uint32_t)0".
+ *	Immediately after the terminating 0 follow the images, one by
+ *	one, all aligned on "uint32_t" boundaries (size rounded up to
+ *	a multiple of 4 bytes - except for the last file).
+ *
+ * "Firmware Images" are binary images containing firmware (like
+ *	U-Boot or FPGA images) which usually will be programmed to
+ *	flash memory.
+ *
+ * "Script files" are command sequences that will be executed by
+ *	U-Boot's command interpreter; this feature is especially
+ *	useful when you configure U-Boot to use a real shell (hush)
+ *	as command interpreter (=> Shell Scripts).
+ */
+
+#define IH_TYPE_INVALID		0	/* Invalid Image		*/
+#define IH_TYPE_STANDALONE	1	/* Standalone Program		*/
+#define IH_TYPE_KERNEL		2	/* OS Kernel Image		*/
+#define IH_TYPE_RAMDISK		3	/* RAMDisk Image		*/
+#define IH_TYPE_MULTI		4	/* Multi-File Image		*/
+#define IH_TYPE_FIRMWARE	5	/* Firmware Image		*/
+#define IH_TYPE_SCRIPT		6	/* Script file			*/
+#define IH_TYPE_FILESYSTEM	7	/* Filesystem Image (any type)	*/
+#define IH_TYPE_FLATDT		8	/* Binary Flat Device Tree Blob	*/
+
+/*
+ * Compression Types
+ */
+#define IH_COMP_NONE		0	/*  No	 Compression Used	*/
+#define IH_COMP_GZIP		1	/* gzip	 Compression Used	*/
+#define IH_COMP_BZIP2		2	/* bzip2 Compression Used	*/
+
+#define IH_MAGIC	0x27051956	/* Image Magic Number		*/
+#define IH_NMLEN		32	/* Image Name Length		*/
+
+/*
+ * all data in network byte order (aka natural aka bigendian)
+ */
+
+typedef struct image_header {
+	uint32_t	ih_magic;	/* Image Header Magic Number	*/
+	uint32_t	ih_hcrc;	/* Image Header CRC Checksum	*/
+	uint32_t	ih_time;	/* Image Creation Timestamp	*/
+	uint32_t	ih_size;	/* Image Data Size		*/
+	uint32_t	ih_load;	/* Data	 Load  Address		*/
+	uint32_t	ih_ep;		/* Entry Point Address		*/
+	uint32_t	ih_dcrc;	/* Image Data CRC Checksum	*/
+	uint8_t		ih_os;		/* Operating System		*/
+	uint8_t		ih_arch;	/* CPU architecture		*/
+	uint8_t		ih_type;	/* Image Type			*/
+	uint8_t		ih_comp;	/* Compression Type		*/
+	uint8_t		ih_name[IH_NMLEN];	/* Image Name		*/
+} image_header_t;
+
+
+#endif	/* __IMAGE_H__ */
