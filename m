Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbYHEHHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbYHEHHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbYHEGrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:47:47 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:46581 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYHEGrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:47:24 -0400
Date: Tue, 5 Aug 2008 00:26:36 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808050626.m756QaPW003773@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc1-git5 16/26] mdb: cleanup CONFIG_SMP and includes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centralized external definitions into include files and corrected 
the file to conform to Linux coding practices.  fixed word wrap
problems with patches.

cleanup CONFIG_SMP and includes and overall organization

Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/debug/mdb-os.c	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb-os.c	2008-08-04 15:49:51.000000000 -0600
@@ -0,0 +1,1097 @@
+
+/***************************************************************************
+*
+*   Copyright (c) 2008 Jeff V. Merkey  All Rights Reserved.
+*   1058 East 50 South
+*   Lindon, Utah 84042
+*   jmerkey@wolfmountaingroup.com
+*
+*   This program is free software; you can redistribute it and/or modify it
+*   under the terms of the GNU General Public License as published by the
+*   Free Software Foundation, version 2.
+*
+*   This program is distributed in the hope that it will be useful, but
+*   WITHOUT ANY WARRANTY; without even the implied warranty of
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+*   General Public License for more details.
+*
+*   You are free to modify and re-distribute this program in accordance
+*   with the terms specified in the GNU Public License.  The copyright
+*   contained in this code is required to be present in any derivative
+*   works and you are required to provide the source code for this
+*   program as part of any commercial or non-commercial distribution.
+*   You are required to respect the rights of the Copyright holders
+*   named within this code.
+*
+*   jmerkey@wolfmountaingroup.com is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software.  
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   DESCRIP  :  Merkey's NetWare Debugger
+*
+***************************************************************************/
+
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/stat.h>
+#include <linux/errno.h>
+#include <linux/fcntl.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/genhd.h>
+#include <linux/hdreg.h>
+#include <linux/fs.h>
+#include <linux/major.h>
+#include <linux/mm.h>
+#include <linux/cdrom.h>
+#include <linux/pagemap.h>
+#include <linux/swap.h>
+#include <linux/smp.h>
+#include <linux/smp_lock.h>
+#include <linux/ctype.h>
+#include <linux/keyboard.h>
+#include <linux/console.h>
+#include <linux/serial_reg.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/segment.h>
+#include <asm/atomic.h>
+#include <asm/msr.h>
+#include <asm/io.h>
+
+#ifdef CONFIG_SMP
+#include <mach_apic.h>
+#include <mach_ipi.h>
+#endif
+
+#define __KERNEL_SYSCALLS__
+#include <linux/unistd.h>
+#include <linux/kallsyms.h>
+
+#include "mdb.h"
+#include "mdb-ia32.h"
+#include "mdb-list.h"
+#include "mdb-ia32-proc.h"
+#include "mdb-base.h"
+#include "mdb-proc.h"
+#include "mdb-os.h"
+#include "mdb-keyboard.h"
+
+#ifdef CONFIG_MDB
+
+// module symbol workspace
+unsigned char symbuf[MAX_PROCESSORS][MAX_SYMBOL_LEN];
+unsigned char modbuf[MAX_PROCESSORS][MAX_SYMBOL_LEN];
+unsigned char workbuf[MAX_PROCESSORS][MAX_SYMBOL_LEN];
+unsigned char traceBuf[MAX_SYMBOL_LEN];
+
+extern void touch_nmi_watchdog(void);
+
+int valid_stack_ptr(struct thread_info *tinfo, void *p)
+{
+    return ((p > (void *)tinfo) && (p < (void *)(tinfo + THREAD_SIZE - 3)));
+}
+
+unsigned long print_context_stack(struct thread_info *tinfo,
+			  unsigned long *stack, unsigned long ebp,
+                          unsigned long *rebp)
+{
+    register unsigned char *symbol;
+    unsigned long addr, offset;
+    unsigned char *modname;
+
+#ifdef	CONFIG_FRAME_POINTER
+    while (valid_stack_ptr(tinfo, (void *)ebp)) 
+    {
+         // addr = *(unsigned long *)(ebp + 4);
+	addr = mdb_getword((ebp + 4), 4);
+
+        if (DBGPrint("[<%08lx>] ", addr))
+           return 1;
+
+        symbol = GetSymbolFromValueOffsetModule(addr, &offset, &modname, 
+                                                traceBuf, MAX_SYMBOL_LEN);
+        if (symbol)
+        {
+           if (modname)
+           {   
+              if (offset)
+              {
+                 if (DBGPrint("%s|%s+0x%X", modname, symbol, offset))
+                    return 1;
+              }
+              else
+              {
+                 if (DBGPrint("%s|%s", modname, symbol))
+                    return 1;
+              }
+           }
+           else
+           {
+              if (offset)
+              {
+                 if (DBGPrint("%s+0x%X", symbol, offset))
+                    return 1;
+              }
+              else
+              {
+                 if (DBGPrint("%s", symbol))
+                    return 1;
+              }
+           }
+        }
+        if (DBGPrint("\n"))
+           return 1;
+
+        // if (ebp == *(unsigned long *)ebp)
+	if (ebp == mdb_getword(ebp, 4))
+	   break;
+
+        // ebp = *(unsigned long *)ebp;
+	ebp = mdb_getword(ebp, 4);
+    }
+#else
+    while (valid_stack_ptr(tinfo, stack)) 
+    {
+       addr = mdb_getword((unsigned long)stack, 4);
+       stack++;
+
+       if (__kernel_text_address(addr))
+       {
+          if (DBGPrint("[<%08lx>] ", addr))
+             return 1;
+
+          symbol = GetSymbolFromValueOffsetModule(addr, &offset, &modname, 
+                                                traceBuf, MAX_SYMBOL_LEN);
+          if (symbol)
+          {
+             if (modname)
+             {    
+                if (offset)
+                {
+                   if (DBGPrint("%s|%s+0x%X", modname, symbol, offset))
+                      return 1;
+                }
+                else
+                {
+                   if (DBGPrint("%s|%s", modname, symbol))
+                      return 1;
+                }
+             }
+             else
+             {
+                if (offset)  
+                {
+                   if (DBGPrint("%s+0x%X", symbol, offset))
+                      return 1;
+                }
+                else
+                {
+                   if (DBGPrint("%s", symbol))
+                      return 1;
+                }
+             }
+          }
+          if (DBGPrint("\n"))
+             return 1;
+       }
+    }
+#endif
+    if (rebp)
+       *rebp = ebp;
+
+    return 0;
+}
+
+int bt_stack(struct task_struct *task, struct pt_regs *regs,
+             unsigned long *stack)
+{
+    unsigned long ebp = 0;
+
+    if (!task)
+       task = current;
+
+    if (!stack) 
+    {
+       unsigned long dummy;
+
+       stack = &dummy;
+       if (task && task != current)
+       {  
+          if (mdb_verify_rw((void *)&task->thread.sp, 4))
+             return 0;
+
+          // stack = (unsigned long *)task->thread.esp;
+          stack = (unsigned long *)
+                  mdb_getword((unsigned long)&task->thread.sp, 4);
+       }
+    }
+
+#ifdef CONFIG_FRAME_POINTER
+    if (!ebp) 
+    {
+       if (task == current) 
+          asm ("movl %%ebp, %0" : "=r" (ebp) : );
+       else 
+       {
+          if (mdb_verify_rw((void *)task->thread.sp, 4))
+             return 0;
+
+          // ebp = *(unsigned long *)task->thread.esp;
+          ebp = (unsigned long)mdb_getword(task->thread.sp, 4);
+       } 
+    }
+#endif
+
+    while (1) 
+    {
+       struct thread_info *context;
+
+       context = (struct thread_info *)
+                 ((unsigned long)stack & (~(THREAD_SIZE - 1)));
+
+       if (mdb_verify_rw(context, 4))
+          return 0;
+
+       if (print_context_stack(context, stack, ebp, &ebp))
+          return 1;
+
+       if (mdb_verify_rw(&context->previous_esp, 4))
+          return 0;
+
+       // stack = (unsigned long *)context->previous_esp;
+       stack = (unsigned long *)
+               mdb_getword((unsigned long)&context->previous_esp, 4);
+       if (!stack)
+          break;
+
+       touch_nmi_watchdog();
+    }
+    return 0;
+}
+
+unsigned char *mdbprompt = "--- More (Q to Quit) ---";
+int nextline = 0;
+
+int mdb_printf(char *fmt, ...)
+{
+	char buffer[256];
+	char keystroke[16];
+	va_list	ap;
+	int linecount;
+	struct console *con;
+//	struct console *c = console_drivers;
+
+        preempt_disable();
+
+        linecount = 23;
+
+	va_start(ap, fmt);
+	vsprintf(buffer, fmt, ap);
+	va_end(ap);
+
+	for (con = console_drivers; con; con = con->next) 
+        {
+	   if ((con->flags & CON_ENABLED) && con->write &&
+	        (cpu_online(smp_processor_id()) ||
+		(con->flags & CON_ANYTIME)))
+  	      con->write(con, buffer, strlen(buffer));
+	}
+
+//	while (c) 
+//        {
+//	   c->write(c, buffer, strlen(buffer));
+//	   c = c->next;
+//	}
+
+	if (strchr(buffer, '\n') != NULL) 
+	   nextline++;
+
+	if (nextline == linecount) 
+        {
+	   nextline = 0;	
+
+	   for (con = console_drivers; con; con = con->next) 
+           {
+	      if ((con->flags & CON_ENABLED) && con->write &&
+ 	           (cpu_online(smp_processor_id()) ||
+	           (con->flags & CON_ANYTIME)))
+	         con->write(con, mdbprompt, strlen(mdbprompt));
+	   }  
+
+//	   c = console_drivers;
+//	   while (c) 
+//           {
+//	      c->write(c, mdbprompt, strlen(mdbprompt));
+//	      c = c->next;
+//	   }
+
+	   keystroke[0] = (char)mdb_getkey();
+	   nextline = 1;	
+
+	   if ((keystroke[0] == 'q') || (keystroke[0] == 'Q'))
+           {
+	      for (con = console_drivers; con; con = con->next) 
+              {
+		 if ((con->flags & CON_ENABLED) && con->write &&
+ 		     (cpu_online(smp_processor_id()) ||
+ 		     (con->flags & CON_ANYTIME)))
+		    con->write(con, "\n", 1);
+	      }  
+
+//	      c = console_drivers;
+//  	      while (c) 
+//              { 
+//	         c->write(c, "\n", 1);
+//	         c = c->next;
+//	      }
+
+              preempt_enable();
+              return 1;
+           }
+	}
+        preempt_enable();
+        return 0;
+}
+
+
+int mdb_serial_port = 0;
+
+int get_modem_char(void)
+{
+    unsigned char ch;
+    int status;
+
+    if (mdb_serial_port == 0)
+       return -1;
+
+    if ((status = inb(mdb_serial_port + UART_LSR)) & UART_LSR_DR) 
+    {
+       ch = inb(mdb_serial_port + UART_RX);
+       switch (ch)
+       {
+	   case 0x7f:
+  	      ch = 8;
+              break;
+
+           case '\t':
+	      ch = ' ';
+              break;
+
+           case 8:  // backspace
+              break;
+
+	   case 13: // enter
+	      mdb_printf("\n");
+              break;
+
+           default:
+	      if (!isprint(ch))
+	         return(-1);
+	      mdb_printf("%c", ch);
+              break;
+	}
+ 	return ch;
+    }
+    return -1;
+}
+
+int mdb_suppress_crlf = 0;
+static int get_kbd_char(void)
+{
+	int	scancode, scanstatus;
+	static int shift_lock;	/* CAPS LOCK state (0-off, 1-on) */
+	static int shift_key;	/* Shift next keypress */
+	static int ctrl_key;
+	u_short keychar;
+	extern u_short plain_map[], shift_map[], ctrl_map[];
+
+	if ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
+		return -1;
+
+	/*
+	 * Fetch the scancode
+	 */
+	scancode = inb(KBD_DATA_REG);
+	scanstatus = inb(KBD_STATUS_REG);
+
+	/*
+	 * Ignore mouse events.
+	 */
+	if (scanstatus & KBD_STAT_MOUSE_OBF)
+		return -1;
+
+	/*
+	 * Ignore release, trigger on make
+	 * (except for shift keys, where we want to
+	 *  keep the shift state so long as the key is
+	 *  held down).
+	 */
+
+	if (((scancode & 0x7f) == 0x2a) || 
+            ((scancode & 0x7f) == 0x36)) 
+        {
+		/*
+		 * Next key may use shift table
+		 */
+		if ((scancode & 0x80) == 0) {
+			shift_key=1;
+		} else {
+			shift_key=0;
+		}
+		return -1;
+	}
+
+	if ((scancode & 0x7f) == 0x1d) {
+		/*
+		 * Left ctrl key
+		 */
+		if ((scancode & 0x80) == 0) {
+			ctrl_key = 1;
+		} else {
+			ctrl_key = 0;
+		}
+		return -1;
+	}
+
+	if ((scancode & 0x80) != 0)
+		return -1;
+
+	scancode &= 0x7f;
+
+	/*
+	 * Translate scancode
+	 */
+
+	if (scancode == 0x3a) {
+		/*
+		 * Toggle caps lock
+		 */
+		shift_lock ^= 1;
+		return -1;
+	}
+
+	if (scancode == 0x0e) {
+		/*
+		 * Backspace
+		 */
+		return 8;
+	}
+
+	if (scancode == 0xe0) {
+		return -1;
+	}
+
+	/*
+	 * For Japanese 86/106 keyboards
+	 * 	See comment in drivers/char/pc_keyb.c.
+	 * 	- Masahiro Adegawa
+	 */
+	if (scancode == 0x73) {
+		scancode = 0x59;
+	} else if (scancode == 0x7d) {
+		scancode = 0x7c;
+	}
+
+	if (!shift_lock && !shift_key && !ctrl_key) {
+		keychar = plain_map[scancode];
+	} else if (shift_lock || shift_key) {
+		keychar = shift_map[scancode];
+	} else if (ctrl_key) {
+		keychar = ctrl_map[scancode];
+	} else {
+		keychar = 0x0020;
+		mdb_printf("Unknown state/scancode (%d)\n", scancode);
+	}
+
+	keychar &= 0x0fff;
+	if (keychar == '\t')
+		keychar = ' ';
+	
+        switch (keychar)
+        {
+           case K_F1:
+           case K_F2:
+           case K_F3:
+           case K_F4:
+           case K_F5:
+           case K_F6:
+           case K_F7:
+           case K_F8:
+           case K_F9:
+           case K_F10:
+           case K_F11:
+           case K_F12:
+	      return keychar;
+           default:
+              break;
+        }
+
+	switch (KTYP(keychar)) 
+        {
+	   case KT_LETTER:
+	   case KT_LATIN:
+		if (isprint(keychar))
+			break;		/* printable characters */
+		/* drop through */
+	   case KT_SPEC:
+		if (keychar == K_ENTER)
+			break;
+		/* drop through */
+           case KT_PAD:
+                switch (keychar)
+                { 
+                   case K_P0:
+                   case K_P1:
+                   case K_P2:
+                   case K_P4:
+                   case K_P6:
+                   case K_P7:
+                   case K_P8:
+                   case K_PDOT:
+                      return keychar;
+                }
+                return -1;
+
+           case KT_CUR:
+                switch (keychar)
+                { 
+                   case K_DOWN:
+                   case K_LEFT:
+                   case K_RIGHT:
+                   case K_UP:
+                      return keychar;
+                }
+                return -1;
+
+	   default:
+		return(-1);	/* ignore unprintables */
+	}
+
+	if ((scancode & 0x7f) == 0x1c) {
+		/*
+		 * enter key.  All done.  Absorb the release scancode.
+		 */
+		while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
+			;
+
+		/*
+		 * Fetch the scancode
+		 */
+		scancode = inb(KBD_DATA_REG);
+		scanstatus = inb(KBD_STATUS_REG);
+
+		while (scanstatus & KBD_STAT_MOUSE_OBF) 
+                {
+		   scancode = inb(KBD_DATA_REG);
+		   scanstatus = inb(KBD_STATUS_REG);
+		}
+
+                // enter-release error
+		if (scancode != 0x9c) {} ;
+
+                if (!mdb_suppress_crlf)
+		   mdb_printf("\n");
+		return 13;
+	}
+
+	/*
+	 * echo the character.
+	 */
+	mdb_printf("%c", keychar & 0xff);
+	return keychar & 0xff;
+}
+
+int mdb_getkey(void)
+{
+   int key = -1;
+
+   for (;;) 
+   {
+      key = get_kbd_char();
+      if (key != -1)
+ 	 break;
+
+      touch_nmi_watchdog();
+   }
+   return key;
+}
+
+int mdb_copy(void *to, void *from, size_t size)
+{
+    return __copy_to_user_inatomic(to, from, size);
+}
+
+int mdb_verify_rw(void *addr, size_t size)
+{
+    unsigned char data[size];
+    return (mdb_copy(data, addr, size));
+}
+
+int mdb_getlword(unsigned long *word, unsigned long addr, size_t size)
+{
+	int err;
+
+	__u8  w1;
+	__u16 w2;
+	__u32 w4;
+	__u64 w8;
+
+	*word = 0;	/* Default value if addr or size is invalid */
+	switch (size) {
+	case 1:
+		if (!(err = mdb_copy(&w1, (void *)addr, size)))
+			*word = w1;
+		break;
+	case 2:
+		if (!(err = mdb_copy(&w2, (void *)addr, size)))
+			*word = w2;
+		break;
+	case 4:
+		if (!(err = mdb_copy(&w4, (void *)addr, size)))
+			*word = w4;
+		break;
+	case 8:
+		if (size <= sizeof(*word)) 
+                {
+			if (!(err = mdb_copy(&w8, (void *)addr, size)))
+				*word = w8;
+			break;
+		}
+	default:
+		err = -EFAULT;
+	}
+	return (err);
+}
+
+int mdb_putword(unsigned long addr, unsigned long word, size_t size)
+{
+	int err;
+	__u8  w1;
+	__u16 w2;
+	__u32 w4;
+	__u64 w8;
+
+	switch (size) {
+	case 1:
+		w1 = word;
+		err = mdb_copy((void *)addr, &w1, size);
+		break;
+	case 2:
+		w2 = word;
+		err = mdb_copy((void *)addr, &w2, size);
+		break;
+	case 4:
+		w4 = word;
+		err = mdb_copy((void *)addr, &w4, size);
+		break;
+	case 8:
+		if (size <= sizeof(word)) 
+                {
+		   w8 = word;
+		   err = mdb_copy((void *)addr, &w8, size);
+		   break;
+		}
+	default:
+		err = -EFAULT;
+	}
+	return (err);
+}
+
+unsigned long mdb_getword(unsigned long addr, size_t size)
+{
+   unsigned long data = 0;
+   register int ret;
+   
+   ret = mdb_getlword(&data, addr, size);
+   if (ret)
+      return 0;
+
+   return data;
+}
+
+int DisplayClosestSymbol(unsigned long address)
+{
+    char *modname;
+    const char *name;
+    unsigned long offset = 0, size;
+    char namebuf[KSYM_NAME_LEN+1];
+
+    name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
+    if (!name)
+       return -1;
+
+    if (modname)
+    {
+       if (offset)
+          DBGPrint("%s|%s+0x%X\n", modname, name, offset);
+       else
+          DBGPrint("%s|%s\n", modname, name);
+    }
+    else
+    {
+       if (offset)
+          DBGPrint("%s+0x%X\n", name, offset);
+       else
+          DBGPrint("%s\n", name);
+    }
+    return 0;
+}
+
+void DumpOSSymbolTableMatch(unsigned char *symbol)
+{
+    mdb_kallsyms(symbol, mdb_printf);
+    return;
+}
+
+unsigned long GetValueFromSymbol(unsigned char *symbol)
+{
+   return ((unsigned long)kallsyms_lookup_name(symbol));
+}
+
+
+unsigned char *GetModuleInfoFromSymbolValue(unsigned long value, unsigned char *buf, unsigned long len)
+{
+    char *modname;
+    const char *name;
+    unsigned long offset, size;
+    char namebuf[KSYM_NAME_LEN+1];
+
+    name = kallsyms_lookup(value, &size, &offset, &modname, namebuf);
+    if (modname && buf)
+    {
+       strncpy(buf, modname, len);
+       return (unsigned char *)buf;
+    }
+    return NULL;
+}
+
+unsigned char *GetSymbolFromValue(unsigned long value, unsigned char *buf, unsigned long len)
+{
+    char *modname;
+    const char *name;
+    unsigned long offset, size;
+    char namebuf[KSYM_NAME_LEN+1];
+
+    name = kallsyms_lookup(value, &size, &offset, &modname, namebuf);
+    if (!name)
+       return NULL;
+
+    if (!offset && buf)
+    {
+       strncpy(buf, namebuf, len);
+       return (unsigned char *)buf;
+    }
+
+    return NULL;
+}
+
+unsigned char *GetSymbolFromValueWithOffset(unsigned long value, unsigned long *sym_offset,
+                                   unsigned char *buf, unsigned long len)
+{
+    char *modname;
+    const char *name;
+    unsigned long offset, size;
+    char namebuf[KSYM_NAME_LEN+1];
+
+    name = kallsyms_lookup(value, &size, &offset, &modname, namebuf);
+    if (!name || !buf)
+       return NULL;
+
+    if (sym_offset)
+      *sym_offset = offset;
+
+    strncpy(buf, namebuf, len);
+    return (unsigned char *)buf;
+}
+
+unsigned char *GetSymbolFromValueOffsetModule(unsigned long value, unsigned long *sym_offset,
+                                     unsigned char **module, unsigned char *buf, unsigned long len)
+{
+    char *modname;
+    const char *name;
+    unsigned long offset, size;
+    char namebuf[KSYM_NAME_LEN+1];
+
+    name = kallsyms_lookup(value, &size, &offset, &modname, namebuf);
+    if (!name || !buf)
+       return NULL;
+
+    if (sym_offset)
+      *sym_offset = offset;
+
+    if (module)
+       *module = modname;
+
+    strncpy(buf, namebuf, len);
+    return (unsigned char *)buf;
+}
+
+unsigned long get_processor_id(void)
+{
+#if defined(CONFIG_SMP)
+   return smp_processor_id();
+#else
+   return 0;
+#endif
+}
+
+unsigned long get_physical_processor(void)
+{
+#if defined(CONFIG_SMP)
+   return smp_processor_id();
+#else
+   return 0;
+#endif
+}
+
+unsigned long fpu_present(void)
+{
+   if (boot_cpu_has(X86_FEATURE_FPU)) 
+       return 1;
+    return 0;
+}
+
+extern unsigned long cpu_mttr_on(void)
+{
+   if (boot_cpu_has(X86_FEATURE_MTRR)) 
+       return 1;
+    return 0;
+}
+
+unsigned char *UpcaseString(unsigned char *s)
+{
+   register int i;
+ 
+   for (i=0; i < strlen(s); i++)     
+      s[i] = toupper(s[i]);
+   return s;
+      
+}
+void ClearScreen(void)
+{
+    return;
+}
+
+unsigned short ReadFS(void)
+{
+    unsigned short contents = 0;
+
+    __asm__ ("mov %%fs,%0\n\t":"=r"(contents));
+    return contents;
+}
+
+unsigned short ReadGS(void)
+{
+    unsigned short contents = 0;
+
+    __asm__ ("mov %%gs,%0\n\t":"=r"(contents));
+    return contents;
+}
+
+unsigned long ReadDR(unsigned long regnum)
+{
+	unsigned long contents = 0;
+
+	switch(regnum) 
+        {
+	   case 0:
+		__asm__ ("movl %%db0,%0\n\t":"=r"(contents));
+		break;
+	   case 1:
+		__asm__ ("movl %%db1,%0\n\t":"=r"(contents));
+		break;
+	   case 2:
+		__asm__ ("movl %%db2,%0\n\t":"=r"(contents));
+		break;
+	   case 3:
+		__asm__ ("movl %%db3,%0\n\t":"=r"(contents));
+		break;
+	   case 4:
+	   case 5:
+		break;
+	   case 6:
+		__asm__ ("movl %%db6,%0\n\t":"=r"(contents));
+		break;
+	   case 7:
+		__asm__ ("movl %%db7,%0\n\t":"=r"(contents));
+		break;
+	   default:
+		break;
+	}
+
+	return contents;
+}
+
+void WriteDR(int regnum, unsigned long contents)
+{
+	switch(regnum) 
+        {
+	   case 0:
+		__asm__ ("movl %0,%%db0\n\t"::"r"(contents));
+		break;
+	   case 1:
+		__asm__ ("movl %0,%%db1\n\t"::"r"(contents));
+		break;
+	   case 2:
+		__asm__ ("movl %0,%%db2\n\t"::"r"(contents));
+		break;
+	   case 3:
+		__asm__ ("movl %0,%%db3\n\t"::"r"(contents));
+		break;
+	   case 4:
+	   case 5:
+		break;
+	   case 6:
+		__asm__ ("movl %0,%%db6\n\t"::"r"(contents));
+		break;
+	   case 7:
+		__asm__ ("movl %0,%%db7\n\t"::"r"(contents));
+		break;
+	   default:
+		break;
+	}
+}
+
+unsigned long ReadCR(int regnum)
+{
+	unsigned long contents = 0;
+
+	switch(regnum) 
+        {
+	   case 0:
+		__asm__ ("movl %%cr0,%0\n\t":"=r"(contents));
+		break;
+	   case 1:
+		break;
+	   case 2:
+		__asm__ ("movl %%cr2,%0\n\t":"=r"(contents));
+		break;
+	   case 3:
+		__asm__ ("movl %%cr3,%0\n\t":"=r"(contents));
+		break;
+	   case 4:
+		__asm__ ("movl %%cr4,%0\n\t":"=r"(contents));
+		break;
+	   default:
+		break;
+	}
+	return contents;
+}
+
+void WriteCR(int regnum, unsigned long contents)
+{
+	switch(regnum) 
+        {
+	   case 0:
+		__asm__ ("movl %0,%%cr0\n\t"::"r"(contents));
+		break;
+	   case 1:
+		break;
+	   case 2:
+		__asm__ ("movl %0,%%cr2\n\t"::"r"(contents));
+		break;
+	   case 3:
+		__asm__ ("movl %0,%%cr3\n\t"::"r"(contents));
+		break;
+	   case 4:
+		__asm__ ("movl %0,%%cr4\n\t"::"r"(contents));
+		break;
+	   default:
+		break;
+	}
+	return;
+}
+
+unsigned long ReadTR(void)
+{
+   unsigned short tr;
+
+   __asm__ __volatile__("str %0":"=a"(tr));
+
+   return (unsigned long) tr;
+}
+
+unsigned long ReadLDTR(void)
+{
+   unsigned short ldt;
+ 
+   __asm__ __volatile__("sldt %0":"=a"(ldt));
+
+   return (unsigned long) ldt;
+}
+
+void ReadGDTR(unsigned long *v)
+{
+   __asm__ __volatile__("sgdt %0":"=m"(*v));
+}
+
+void ReadIDTR(unsigned long *v)
+{
+    __asm__ __volatile__("sidt %0":"=m"(*v));
+}
+  
+void save_npx(NUMERIC_FRAME *v)
+{
+    __asm__ __volatile__("fsave %0":"=m"(*v));
+}
+
+void load_npx(NUMERIC_FRAME *v)
+{
+    __asm__ __volatile__("frstor %0":"=m"(*v));
+}
+
+unsigned long ReadDR0(void)  {  return (ReadDR(0)); }
+unsigned long ReadDR1(void)  {  return (ReadDR(1)); }
+unsigned long ReadDR2(void)  {  return (ReadDR(2)); }
+unsigned long ReadDR3(void)  {  return (ReadDR(3)); }
+unsigned long ReadDR6(void)  {  return (ReadDR(6)); }
+unsigned long ReadDR7(void)  {  return (ReadDR(7)); }
+
+void WriteDR0(unsigned long v) { WriteDR(0, v); }
+void WriteDR1(unsigned long v) { WriteDR(1, v); }
+void WriteDR2(unsigned long v) { WriteDR(2, v); }
+void WriteDR3(unsigned long v) { WriteDR(3, v); }
+void WriteDR6(unsigned long v) { WriteDR(6, v); }
+void WriteDR7(unsigned long v) { WriteDR(7, v); }
+
+unsigned long ReadCR0(void) {  return (ReadCR(0)); }
+unsigned long ReadCR2(void) {  return (ReadCR(2)); }
+unsigned long ReadCR3(void) {  return (ReadCR(3)); }
+unsigned long ReadCR4(void) {  return (ReadCR(4)); }
+
+void WriteCR0(unsigned long v) { WriteCR(0, v); }
+void WriteCR2(unsigned long v) { WriteCR(2, v); }
+void WriteCR3(unsigned long v) { WriteCR(3, v); }
+void WriteCR4(unsigned long v) { WriteCR(4, v); }
+
+void ReadMSR(unsigned long r, unsigned long *v1, unsigned long *v2)
+{
+    unsigned long vv1, vv2;
+
+    rdmsr(r, vv1, vv2);
+
+    if (v1)
+       *v1 = vv1;
+    if (v2)
+       *v2 = vv2;
+}
+
+void WriteMSR(unsigned long r, unsigned long *v1, unsigned long *v2)
+{
+    unsigned long vv1 = 0, vv2 = 0;
+
+    if (v1)
+       vv1 = *v1;
+    if (v2)
+       vv2 = *v2;
+
+    wrmsr(r, vv1, vv2);
+}
+
+#endif
