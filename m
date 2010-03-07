Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0CGMcn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 07:32:43 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35888 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0CGMck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 07:32:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=m3FFCmFmSe6toieccmnlSaQoPK4jADLcvPTAm+rBgqeHWy+k3ycTGZYVTbnmtD9WzX
         G5hA7uYRLeN5rNTNKLqso2ehTlVAx3bq+cXLt/13xg+rT7IQpIfYC2TxGycp2A9vHjLw
         VmNVX9CwBbLh3s/6OS9y1Es2P++REVh4Nwvd0=
Message-ID: <4B939CE1.5050908@gmail.com>
Date: Sun, 07 Mar 2010 23:32:33 +1100
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.33 resets when enabling paging on AMD SC520 based board
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am (still) trying to port Linux to my AMD SC520 based board. I have seen
devices out there that use this part and run 2.4.x and 2.6.x series
kernels, so I assume its possible (the fact that there is a CPU Frequency
Scaling option and driver for the SC520 is also a dead-set give-away)

Now my board is an embedded, non PC architecture, custom board. It has
128MB RAM, 32MB flash (plus 512KB boot-flash) and some other odds-and-sods
that I don't really need to get working yet. It has no VGA. It has Serial
and Ethernet ports. The board currently runs a proprietary OS and firmware,
so I know that it is physically fine (memory is good etc)

I have updated U-Boot which had a seriously broken x86 port and have the
Ethernet and Serial ports working.

Being a custom, non PC based board, I have gone down the road of the 32-bit
Boot Protocol.

I have replaced __putstr() to output to the serial port, and using int3 to
track the boot progress through the low-level kernel code to monitor
register contents with the following patch:

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 51e2407..f17680a 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -170,6 +170,30 @@ static void scroll(void)
                vidmem[i] = ' ';
 }

+#define UART_LSR_THRE  0x20            /* Xmit holding register empty */
+
+static void NS16550_putc (char c)
+{
+       while ((inb(0x3f8 + 5) & UART_LSR_THRE) == 0);
+       outb(c, 0x3f8);
+}
+
+static void _serial_putc(const char c)
+{
+       if (c == '\n')
+               NS16550_putc('\r');
+
+       NS16550_putc(c);
+}
:
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 51e2407..f17680a 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -170,6 +170,30 @@ static void scroll(void)
                vidmem[i] = ' ';
 }

+#define UART_LSR_THRE  0x20            /* Xmit holding register empty */
+
+static void NS16550_putc (char c)
+{
+       while ((inb(0x3f8 + 5) & UART_LSR_THRE) == 0);
+       outb(c, 0x3f8);
+}
+
+static void _serial_putc(const char c)
+{
+       if (c == '\n')
+               NS16550_putc('\r');
+
+       NS16550_putc(c);
+}
+
+static void __putstr (int error, const char *s)
+{
+       while (*s) {
+               _serial_putc (*s++);
+       }
+}
+
+#if 0
 static void __putstr(int error, const char *s)
 {
        int x, y, pos;
@@ -215,7 +239,7 @@ static void __putstr(int error, const char *s)
        outb(15, vidport);
        outb(0xff & (pos >> 1), vidport+1);
 }
-
+#endif
 void *memset(void *s, int c, size_t n)
 {
        int i;
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 37c3d4b..b76c51d 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -25,6 +25,13 @@
 /* Physical address */
 #define pa(X) ((X) - __PAGE_OFFSET)

+.macro CHECKPOINT num
+       pushl   %eax
+       movl    $(\num), %eax
+       int3
+       popl    %eax
+.endm
+
 /*
  * References to members of the new_cpu_data structure.
  */
@@ -83,10 +90,12 @@ RESERVE_BRK(pagetables, INIT_MAP_SIZE)
  */
 __HEAD
 ENTRY(startup_32)
+       CHECKPOINT 0x01
        /* test KEEP_SEGMENTS flag to see if the bootloader is asking
                us to not reload segments */
        testb $(1<<6), BP_loadflags(%esi)
        jnz 2f
+       CHECKPOINT 0x02

 /*
  * Set segments to known values.
@@ -108,6 +117,7 @@ ENTRY(startup_32)
        movl $pa(__bss_stop),%ecx
        subl %edi,%ecx
        shrl $2,%ecx
+       CHECKPOINT 0xff01
        rep ; stosl
 /*
  * Copy bootup parameters out of the way.
@@ -120,13 +130,16 @@ ENTRY(startup_32)
        movl $pa(boot_params),%edi
        movl $(PARAM_SIZE/4),%ecx
        cld
+       CHECKPOINT 0xff02
        rep
        movsl
        movl pa(boot_params) + NEW_CL_POINTER,%esi
+       CHECKPOINT 0xff03
        andl %esi,%esi
        jz 1f                   # No comand line
        movl $pa(boot_command_line),%edi
        movl $(COMMAND_LINE_SIZE/4),%ecx
+       CHECKPOINT 0xff04
        rep
        movsl
 1:
@@ -229,6 +242,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
        movl $pa(__brk_base), %edi
        movl $pa(swapper_pg_dir), %edx
        movl $PTE_IDENT_ATTR, %eax
+       CHECKPOINT 0xff05
 10:
        leal PDE_IDENT_ATTR(%edi),%ecx          /* Create PDE entry */
        movl %ecx,(%edx)                        /* Store identity PDE entry */
@@ -291,10 +305,12 @@ ENTRY(startup_32_smp)
  *     NOTE! We have to correct for the fact that we're
  *     not yet offset PAGE_OFFSET..
  */
+       CHECKPOINT 0x03
 #define cr4_bits pa(mmu_cr4_features)
        movl cr4_bits,%edx
        andl %edx,%edx
        jz 6f
+       CHECKPOINT 0x04
        movl %cr4,%eax          # Turn on paging options (PSE,PAE,..)
        orl %edx,%eax
        movl %eax,%cr4
@@ -324,17 +340,24 @@ ENTRY(startup_32_smp)
        wrmsr

 6:
+       CHECKPOINT 0x05

 /*
  * Enable paging
  */
        movl $pa(swapper_pg_dir),%eax
+       CHECKPOINT 0x06
        movl %eax,%cr3          /* set the page table pointer.. */
+       CHECKPOINT 0x07
        movl %cr0,%eax
+       CHECKPOINT 0x08
        orl  $X86_CR0_PG,%eax
+       CHECKPOINT 0x09
        movl %eax,%cr0          /* ..and set paging (PG) bit */
+       CHECKPOINT 0x0a
        ljmp $__BOOT_CS,$1f     /* Clear prefetch and normalize %eip */
 1:
+       CHECKPOINT 0x0b
        /* Set up the stack pointer */
        lss stack_start,%esp

At the moment, I am tftp'ing the bzImage to 0xfca00 (0x100000 - 0x3600) so
the 32-bit entry-point is at 0x100000. It puts the 16-bit code and
setup_header at an odd place, but I don't think that matters since I am
already in protected mode.

I've checked the U-Boot GDT and it has 0x10 and 0x18 setup as per the
32-bit Boot Protocol.

I have an initial implementation of the U-Boot side of the 32-bit boot
protocol as follows:

	struct setup_header *hdr;
	struct boot_params boot_params __attribute__((aligned(16)));

	addr = 0x100000;

	load_addr = addr - 0x3600;
	hdr = (struct setup_header *)(load_addr + 0x1f1);

	memset(&boot_params, 0x00, sizeof boot_params);
	memcpy(&boot_params.hdr, hdr, sizeof (*hdr));

	printf("&boot_params  = 0x%8.8lx\n", (ulong)&boot_params);
	printf("sizeof (*hdr) = 0x%8.8lx\n", (ulong)(sizeof (*hdr)));
	printf("Boot Address  = 0x%8.8lx\n",
               (ulong)boot_params.hdr.code32_start);

	boot_params.alt_mem_k = 128 * 1024;
	boot_params.e820_entries = 1;
	boot_params.e820_map[0].addr = 0x00000000;
	boot_params.e820_map[0].size = 128 * 1024;
	boot_params.e820_map[0].type = 1;

	printf("Entering Linux\n");

       asm volatile(
	       "cli\n" \
	       "movl   %2, %%ds\n" \
	       "movl   %2, %%es\n" \
	       "movl   %2, %%fs\n" \
	       "movl   %2, %%gs\n" \
	       "movl   %2, %%ss\n" \
	       "xorl   %%ebp, %%ebp\n" \
	       "xorl   %%ebx, %%ebx\n" \
	       "int3\n" \
	       "jmp  *%3"
		: : "S" (&boot_params), "D" (0), "r" (0x18), "a" (addr));

The resulting output is:
&boot_params  = 0x03ffeb88
sizeof (*hdr) = 0x00000067
Boot Address  = 0x00100000
Entering Linux
Breakpoint
EIP: 0010:[<03fcc164>] EFLAGS: 00000246
EAX: 00100000 EBX: 00000000 ECX: 000003f8 EDX: 00000018
ESI: 03ffeb88 EDI: 00000000 EBP: 00000000 ESP: 03feba30
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
Breakpoint
EIP: 0010:[<00100007>] EFLAGS: 00000046
EAX: 00000001 EBX: 00000000 ECX: 000003fd EDX: 00000300
ESI: 03ffeb88 EDI: 003b8268 EBP: 00100000 ESP: 0000000a
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: eb88
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<00100018>] EFLAGS: 00000046
EAX: 00000002 EBX: 00000000 ECX: 000003fd EDX: 00000300
ESI: 03ffeb88 EDI: 003b8268 EBP: 00100000 ESP: 0000000a
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: eb88
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<00100046>] EFLAGS: 00000016
EAX: 0000ff01 EBX: 00000000 ECX: 0001ad30 EDX: 00000300
ESI: 03ffeb88 EDI: 003a8000 EBP: 00100000 ESP: 00000000
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: eb88
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<0010005b>] EFLAGS: 00000016
EAX: 0000ff02 EBX: 00000000 ECX: 00000400 EDX: 00000300
ESI: 03ffeb88 EDI: 0038ff20 EBP: 00100000 ESP: 00000000
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<0010006b>] EFLAGS: 00000016
EAX: 0000ff03 EBX: 00000000 ECX: 00000000 EDX: 00000300
ESI: 00000000 EDI: 00390f20 EBP: 00100000 ESP: 00000000
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<0010009a>] EFLAGS: 00000046
EAX: 0000ff05 EBX: 00000000 ECX: 00000000 EDX: 003a8000
ESI: 00000000 EDI: 00414000 EBP: 00100000 ESP: 00000003
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<0038ad57>] EFLAGS: 00000016
EAX: 00000003 EBX: 00000000 ECX: 00000000 EDX: 003a8008
ESI: 00000000 EDI: c0416000 EBP: 005b4003 ESP: 003a9067
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<0038adaa>] EFLAGS: 00000046
EAX: 00000005 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: c0416000 EBP: 005b4003 ESP: 003a9067
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<0038adb7>] EFLAGS: 00000046
EAX: 00000006 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: c0416000 EBP: 005b4003 ESP: 003a8000
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 00000000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<0038adc2>] EFLAGS: 00000046
EAX: 00000007 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: c0416000 EBP: 005b4003 ESP: 003a8000
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 003a8000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<0038adcd>] EFLAGS: 00000046
EAX: 00000008 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: c0416000 EBP: 005b4003 ESP: 00000033
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 003a8000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Breakpoint
EIP: 0010:[<0038adda>] EFLAGS: 00000086
EAX: 00000009 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: 00000000 EDI: c0416000 EBP: 005b4003 ESP: 80000033
 DS: 0018 ES: 0018 FS: 0018 GS: 0018 SS: 0000
CR0: 00000033 CR2: 00000000 CR3: 003a8000 CR4: 00080010
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400

At which point, the board resets. So the code which seems to be causing the
problem is:

	movl %eax,%cr0		/* ..and set paging (PG) bit */

Look at the memory where the Page Directory should be (0x003a8000) gives:

003a8000: 00414067 00415067 00000000 00000000    g@A.gPA.........
003a8010: 00000000 00000000 00000000 00000000    ................
003a8020: 00000000 00000000 00000000 00000000    ................
003a8030: 00000000 00000000 00000000 00000000    ................
003a8040: 00000000 00000000 00000000 00000000    ................
003a8050: 00000000 00000000 00000000 00000000    ................
003a8060: 00000000 00000000 00000000 00000000    ................
003a8070: 00000000 00000000 00000000 00000000    ................
003a8080: 00000000 00000000 00000000 00000000    ................
003a8090: 00000000 00000000 00000000 00000000    ................
003a80a0: 00000000 00000000 00000000 00000000    ................
003a80b0: 00000000 00000000 00000000 00000000    ................
003a80c0: 00000000 00000000 00000000 00000000    ................
003a80d0: 00000000 00000000 00000000 00000000    ................
003a80e0: 00000000 00000000 00000000 00000000    ................
003a80f0: 00000000 00000000 00000000 00000000    ................

Note: The endian-ness of the memory dump is messed up. Read each long in
reverse byte order (i.e. 0x003a8000 is 0x67, 0x003a8001 is 0x40 etc.)

Does this look right? Interestingly I also have:

003a8c00: 00414067 00415067 00000000 00000000    g@A.gPA.........
003a8c10: 00000000 00000000 00000000 00000000    ................
003a8c20: 00000000 00000000 00000000 00000000    ................
003a8c30: 00000000 00000000 00000000 00000000    ................
003a8c40: 00000000 00000000 00000000 00000000    ................
003a8c50: 00000000 00000000 00000000 00000000    ................
003a8c60: 00000000 00000000 00000000 00000000    ................
003a8c70: 00000000 00000000 00000000 00000000    ................
003a8c80: 00000000 00000000 00000000 00000000    ................
003a8c90: 00000000 00000000 00000000 00000000    ................
003a8ca0: 00000000 00000000 00000000 00000000    ................
003a8cb0: 00000000 00000000 00000000 00000000    ................
003a8cc0: 00000000 00000000 00000000 00000000    ................
003a8cd0: 00000000 00000000 00000000 00000000    ................
003a8ce0: 00000000 00000000 00000000 00000000    ................
003a8cf0: 00000000 00000000 00000000 00000000    ................

I checked for some kind of bizarre cross-addressing by modifying 0x3a8c00
and proved it is not shadowing 0x3a8000

Any ideas on how to track down the problem?

TIA

Graeme
