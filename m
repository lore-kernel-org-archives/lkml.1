Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbYBJSyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbYBJSyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 13:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYBJSxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 13:53:55 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:53644 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbYBJSxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:53:54 -0500
Message-ID: <47AF483E.10905@web.de>
Date: Sun, 10 Feb 2008 19:53:50 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>, Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v5
References: <20080210071304.GA3788@elte.hu>	 <20080210104709.GB10790@uranus.ravnborg.org>	 <20080210163603.GB28201@elte.hu> <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com>
In-Reply-To: <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+eoKp6kFmxQKIcnj9yhAGdyeyZGuqetd11t4oJ
	B7h0mhCyYY2c7KGI8AXv19woRomaQG6jkx4QP084fUwFOvZTc+
	rjqN//kZg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This still runs fine here, but sharp eyes are always welcome!]


Cleanup of the way kgdb
 - accesses unsafe memory via probe_kernel_*
 - converts to/from hex representation
 - passes errors due to such accesses around

At this chance I also fix kgdb_ebin2mem, which was broken /wrt escape
sequence handling.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 include/linux/kgdb.h |    4 
 kernel/kgdb.c        |  349 +++++++++++++++------------------------------------
 2 files changed, 109 insertions(+), 244 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 7f4ee55..0359280 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -313,8 +313,8 @@ extern int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
 extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
 
 extern int kgdb_hex2long(char **ptr, long *long_val);
-extern char *kgdb_mem2hex(char *mem, char *buf, int count);
-extern char *kgdb_hex2mem(char *buf, char *mem, int count);
+extern int kgdb_mem2hex(char *mem, char *buf, int count);
+extern int kgdb_hex2mem(char *buf, char *mem, int count);
 
 extern int kgdb_isremovedbreak(unsigned long addr);
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index d55fdd1..ac9d196 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -145,38 +145,20 @@ static struct notifier_block kgdb_reboot_notifier = {
  * Finally, some KGDB code :-)
  */
 
-static char *kgdb_get_mem(char *addr, unsigned char *buf, int count)
+static int kgdb_get_mem(char *addr, unsigned char *buf, int count)
 {
-	while (count) {
-		if ((unsigned long)addr < TASK_SIZE)
-			return ERR_PTR(-EINVAL);
+	if ((unsigned long)addr < TASK_SIZE)
+		return -EFAULT;
 
-		if (probe_kernel_address(addr, *buf))
-			return ERR_PTR(-EINVAL);
-
-		buf++;
-		addr++;
-		count--;
-	}
-
-	return NULL;
+	return probe_kernel_read(buf, addr, count);
 }
 
-static char *kgdb_set_mem(char *addr, unsigned char *buf, int count)
+static int kgdb_set_mem(char *addr, unsigned char *buf, int count)
 {
-	while (count) {
-		if ((unsigned long)addr < TASK_SIZE)
-			return ERR_PTR(-EINVAL);
-
-		if (probe_kernel_write(addr, *buf))
-			return ERR_PTR(-EINVAL);
+	if ((unsigned long)addr < TASK_SIZE)
+		return -EINVAL;
 
-		buf++;
-		addr++;
-		count--;
-	}
-
-	return NULL;
+	return probe_kernel_write(addr, buf, count);
 }
 
 
@@ -188,27 +170,24 @@ int __weak kgdb_validate_break_address(unsigned long addr)
 {
 	char tmp_variable[BREAK_INSTR_SIZE];
 
-	if (!kgdb_get_mem((char *)addr, tmp_variable, BREAK_INSTR_SIZE))
-		return 0;
-	return -1;
+	return kgdb_get_mem((char *)addr, tmp_variable, BREAK_INSTR_SIZE);
 }
 
 int __weak kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr)
 {
-	if (kgdb_get_mem((char *)addr, saved_instr, BREAK_INSTR_SIZE))
-		return -1;
+	int err;
 
-	if (kgdb_set_mem((char *)addr, arch_kgdb_ops.gdb_bpt_instr,
-						BREAK_INSTR_SIZE))
-		return -1;
-	return 0;
+	err = kgdb_get_mem((char *)addr, saved_instr, BREAK_INSTR_SIZE);
+	if (err)
+		return err;
+
+	return kgdb_set_mem((char *)addr, arch_kgdb_ops.gdb_bpt_instr,
+			    BREAK_INSTR_SIZE);
 }
 
 int __weak kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)
 {
-	if (kgdb_set_mem((char *)addr, (char *)bundle, BREAK_INSTR_SIZE))
-		return -1;
-	return 0;
+	return kgdb_set_mem((char *)addr, (char *)bundle, BREAK_INSTR_SIZE);
 }
 
 unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs)
@@ -339,125 +318,47 @@ static void put_packet(char *buffer)
 	}
 }
 
-/*
- * Fault-tolerant memory accessor wrappers. Performance is a secondary
- * concern, the primary concern is not to crash the debugger (or the
- * debuggee):
- */
+static char *pack_hex_byte(char *pkt, u8 byte)
+{
+	*pkt++ = hexchars[byte >> 4];
+	*pkt++ = hexchars[byte & 0xf];
+
+	return pkt;
+}
 
 /*
  * Convert the memory pointed to by mem into hex, placing result in buf.
  * Return a pointer to the last char put in buf (null). May return an error.
  */
-char *kgdb_mem2hex(char *mem, char *buf, int count)
+int kgdb_mem2hex(char *mem, char *buf, int count)
 {
+	char *tmp;
+	int err;
+
 	/*
-	 * Accessing some registers in a single load instruction is
-	 * required to avoid bad side effects for some I/O registers.
+	 * We use the upper half of buf as an intermediate buffer for the
+	 * raw memory copy.  Hex conversion will work against this one.
 	 */
-	if ((count == 2) && (((long)mem & 1) == 0)) {
-		u16 tmp_s;
-
-		if (probe_kernel_address(mem, tmp_s))
-			return ERR_PTR(-EINVAL);
-
-		mem += 2;
-#ifdef __BIG_ENDIAN
-		*buf++ = hexchars[(tmp_s >> 12) & 0xf];
-		*buf++ = hexchars[(tmp_s >> 8) & 0xf];
-		*buf++ = hexchars[(tmp_s >> 4) & 0xf];
-		*buf++ = hexchars[tmp_s & 0xf];
-#else
-		*buf++ = hexchars[(tmp_s >> 4) & 0xf];
-		*buf++ = hexchars[tmp_s & 0xf];
-		*buf++ = hexchars[(tmp_s >> 12) & 0xf];
-		*buf++ = hexchars[(tmp_s >> 8) & 0xf];
-#endif
-	} else if ((count == 4) && (((long)mem & 3) == 0)) {
-		u32 tmp_l;
-		if (probe_kernel_address(mem, tmp_l))
-			return ERR_PTR(-EINVAL);
-
-
-		mem += 4;
-#ifdef __BIG_ENDIAN
-		*buf++ = hexchars[(tmp_l >> 28) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 24) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 20) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 16) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 12) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 8) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 4) & 0xf];
-		*buf++ = hexchars[tmp_l & 0xf];
-#else
-		*buf++ = hexchars[(tmp_l >> 4) & 0xf];
-		*buf++ = hexchars[tmp_l & 0xf];
-		*buf++ = hexchars[(tmp_l >> 12) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 8) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 20) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 16) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 28) & 0xf];
-		*buf++ = hexchars[(tmp_l >> 24) & 0xf];
-#endif
-#ifdef CONFIG_64BIT
-	} else if ((count == 8) && (((long)mem & 7) == 0)) {
-		u64 tmp_ll;
-		if (probe_kernel_address(mem, tmp_ll))
-			return ERR_PTR(-EINVAL);
-
-		mem += 8;
-#ifdef __BIG_ENDIAN
-		*buf++ = hexchars[(tmp_ll >> 60) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 56) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 52) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 48) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 44) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 40) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 36) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 32) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 28) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 24) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 20) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 16) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 12) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 8) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 4) & 0xf];
-		*buf++ = hexchars[tmp_ll & 0xf];
-#else
-		*buf++ = hexchars[(tmp_ll >> 4) & 0xf];
-		*buf++ = hexchars[tmp_ll & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 12) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 8) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 20) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 16) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 28) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 24) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 36) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 32) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 44) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 40) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 52) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 48) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 60) & 0xf];
-		*buf++ = hexchars[(tmp_ll >> 56) & 0xf];
-#endif
-#endif
-	} else {
-		while (count-- > 0) {
-			unsigned char ch;
+	tmp = buf + count;
+
+	if (count == 2 && ((long)mem & 1) == 0)
+		err = probe_kernel_read(tmp, mem, 2);
+	else if (count == 4 && ((long)mem & 3) == 0)
+		err = probe_kernel_read(tmp, mem, 4);
+	else if (count == 8 && ((long)mem & 7) == 0)
+		err = probe_kernel_read(tmp, mem, 8);
+	else
+		err = probe_kernel_read(tmp, mem, count);
 
-			if (probe_kernel_address(mem, ch))
-				return ERR_PTR(-EINVAL);
+	if (err)
+		return err;
 
-			mem++;
-			*buf++ = hexchars[ch >> 4];
-			*buf++ = hexchars[ch & 0xf];
-		}
-	}
+	while (count-- > 0)
+		buf = pack_hex_byte(buf, *tmp++);
 
 	*buf = 0;
 
-	return buf;
+	return 0;
 }
 
 /*
@@ -465,21 +366,24 @@ char *kgdb_mem2hex(char *mem, char *buf, int count)
  * 0x7d escaped with 0x7d.  Return a pointer to the character after
  * the last byte written.
  */
-static char *kgdb_ebin2mem(char *buf, char *mem, int count)
+static int kgdb_ebin2mem(char *buf, char *mem, int count)
 {
-	for (; count > 0; count--, buf++) {
-		if (*buf == 0x7d) {
-			if (probe_kernel_write(mem, (char)(*buf ^ 0x20)))
-				return ERR_PTR(-EINVAL);
-			buf++;
-		} else {
-			if (probe_kernel_write(mem, *buf))
-				return ERR_PTR(-EINVAL);
-		}
+	int err = 0;
+	char c;
+
+	while (count-- > 0) {
+		c = *buf++;
+		if (c == 0x7d)
+			c = *buf++ ^ 0x20;
+
+		err = probe_kernel_write(mem, &c, 1);
+		if (err)
+			break;
+
 		mem++;
 	}
 
-	return mem;
+	return err;
 }
 
 /*
@@ -487,65 +391,35 @@ static char *kgdb_ebin2mem(char *buf, char *mem, int count)
  * Return a pointer to the character AFTER the last byte written.
  * May return an error.
  */
-char *kgdb_hex2mem(char *buf, char *mem, int count)
+int kgdb_hex2mem(char *buf, char *mem, int count)
 {
-	if ((count == 2) && (((long)mem & 1) == 0)) {
-		u16 tmp_s = 0;
-
-#ifdef __BIG_ENDIAN
-		tmp_s |= hex(*buf++) << 12;
-		tmp_s |= hex(*buf++) << 8;
-		tmp_s |= hex(*buf++) << 4;
-		tmp_s |= hex(*buf++);
-#else
-		tmp_s |= hex(*buf++) << 4;
-		tmp_s |= hex(*buf++);
-		tmp_s |= hex(*buf++) << 12;
-		tmp_s |= hex(*buf++) << 8;
-#endif
-		if (probe_kernel_write(mem, tmp_s))
-			return ERR_PTR(-EINVAL);
-
-		mem += 2;
-	} else if ((count == 4) && (((long)mem & 3) == 0)) {
-		u32 tmp_l = 0;
-
-#ifdef __BIG_ENDIAN
-		tmp_l |= hex(*buf++) << 28;
-		tmp_l |= hex(*buf++) << 24;
-		tmp_l |= hex(*buf++) << 20;
-		tmp_l |= hex(*buf++) << 16;
-		tmp_l |= hex(*buf++) << 12;
-		tmp_l |= hex(*buf++) << 8;
-		tmp_l |= hex(*buf++) << 4;
-		tmp_l |= hex(*buf++);
-#else
-		tmp_l |= hex(*buf++) << 4;
-		tmp_l |= hex(*buf++);
-		tmp_l |= hex(*buf++) << 12;
-		tmp_l |= hex(*buf++) << 8;
-		tmp_l |= hex(*buf++) << 20;
-		tmp_l |= hex(*buf++) << 16;
-		tmp_l |= hex(*buf++) << 28;
-		tmp_l |= hex(*buf++) << 24;
-#endif
-		if (probe_kernel_write(mem, tmp_l))
-			return ERR_PTR(-EINVAL);
-		mem += 4;
-	} else {
-		int i;
+	char *tmp_raw;
+	char *tmp_hex;
+	int err;
 
-		for (i = 0; i < count; i++) {
-			unsigned char ch = hex(*buf++) << 4;
+	/*
+	 * We use the upper half of buf as an intermediate buffer for the
+	 * raw memory that is converted from hex.
+	 */
+	tmp_raw = buf + count * 2;
 
-			ch |= hex(*buf++);
-			if (probe_kernel_write(mem, ch))
-				return ERR_PTR(-EINVAL);
-			mem++;
-		}
+	tmp_hex = tmp_raw - 1;
+	while (tmp_hex >= buf) {
+		tmp_raw--;
+		*tmp_raw = hex(*tmp_hex--);
+		*tmp_raw |= hex(*tmp_hex--) << 4;
 	}
 
-	return mem;
+	if (count == 2 && ((long)mem & 1) == 0)
+		err = probe_kernel_write(mem, tmp_raw, 2);
+	else if (count == 4 && ((long)mem & 3) == 0)
+		err = probe_kernel_write(mem, tmp_raw, 4);
+	else if (count == 8 && ((long)mem & 7) == 0)
+		err = probe_kernel_write(mem, tmp_raw, 8);
+	else
+		err = probe_kernel_write(mem, tmp_raw, count);
+
+	return err;
 }
 
 /*
@@ -573,37 +447,30 @@ int kgdb_hex2long(char **ptr, long *long_val)
 }
 
 /* Write memory due to an 'M' or 'X' packet. */
-static char *write_mem_msg(int binary)
+static int write_mem_msg(int binary)
 {
 	char *ptr = &remcom_in_buffer[1];
 	unsigned long addr;
 	unsigned long length;
+	int err;
 
 	if (kgdb_hex2long(&ptr, &addr) > 0 && *(ptr++) == ',' &&
 	    kgdb_hex2long(&ptr, &length) > 0 && *(ptr++) == ':') {
 		if (binary)
-			ptr = kgdb_ebin2mem(ptr, (char *)addr, length);
+			err = kgdb_ebin2mem(ptr, (char *)addr, length);
 		else
-			ptr = kgdb_hex2mem(ptr, (char *)addr, length);
-		if (IS_ERR(ptr))
-			return ptr;
+			err = kgdb_hex2mem(ptr, (char *)addr, length);
+		if (err)
+			return err;
 		if (CACHE_FLUSH_IS_SAFE)
 			flush_icache_range(addr, addr + length + 1);
-		return NULL;
+		return 0;
 	}
 
-	return ERR_PTR(-EINVAL);
+	return -EINVAL;
 }
 
-static inline char *pack_hex_byte(char *pkt, int byte)
-{
-	*pkt++ = hexchars[(byte >> 4) & 0xf];
-	*pkt++ = hexchars[(byte & 0xf)];
-
-	return pkt;
-}
-
-static inline void error_packet(char *pkt, int error)
+static void error_packet(char *pkt, int error)
 {
 	error = -error;
 	pkt[0] = 'E';
@@ -753,12 +620,12 @@ static int kgdb_activate_sw_breakpoints(void)
 
 static int kgdb_set_sw_break(unsigned long addr)
 {
-	int error = kgdb_validate_break_address(addr);
+	int err = kgdb_validate_break_address(addr);
 	int breakno = -1;
 	int i;
 
-	if (error < 0)
-		return error;
+	if (err)
+		return err;
 
 	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
 		if ((kgdb_break[i].state == BP_SET) &&
@@ -961,8 +828,7 @@ static void gdb_cmd_status(struct kgdb_state *ks)
 		kgdb_msg_write("Not all CPUs have been synced for KGDB\n", 39);
 
 	remcom_out_buffer[0] = 'S';
-	remcom_out_buffer[1] = hexchars[ks->signo >> 4];
-	remcom_out_buffer[2] = hexchars[ks->signo & 0xf];
+ 	pack_hex_byte(&remcom_out_buffer[1], ks->signo);
 }
 
 /* Handle the 'g' get registers request */
@@ -1044,13 +910,13 @@ static void gdb_cmd_memread(struct kgdb_state *ks)
 	char *ptr = &remcom_in_buffer[1];
 	unsigned long length;
 	unsigned long addr;
+	int err;
 
 	if (kgdb_hex2long(&ptr, &addr) > 0 && *ptr++ == ',' &&
 					kgdb_hex2long(&ptr, &length) > 0) {
-
-		ptr = kgdb_mem2hex((char *)addr, remcom_out_buffer, length);
-		if (IS_ERR(ptr))
-			error_packet(remcom_out_buffer, PTR_ERR(ptr));
+		err = kgdb_mem2hex((char *)addr, remcom_out_buffer, length);
+		if (err)
+			error_packet(remcom_out_buffer, err);
 	} else {
 		error_packet(remcom_out_buffer, -EINVAL);
 	}
@@ -1059,10 +925,10 @@ static void gdb_cmd_memread(struct kgdb_state *ks)
 /* Handle the 'M' memory write bytes */
 static void gdb_cmd_memwrite(struct kgdb_state *ks)
 {
-	char *ptr = write_mem_msg(0);
+	int err = write_mem_msg(0);
 
-	if (IS_ERR(ptr))
-		error_packet(remcom_out_buffer, PTR_ERR(ptr));
+	if (err)
+		error_packet(remcom_out_buffer, err);
 	else
 		strcpy(remcom_out_buffer, "OK");
 }
@@ -1070,10 +936,10 @@ static void gdb_cmd_memwrite(struct kgdb_state *ks)
 /* Handle the 'X' memory binary write bytes */
 static void gdb_cmd_binwrite(struct kgdb_state *ks)
 {
-	char *ptr = write_mem_msg(1);
+	int err = write_mem_msg(1);
 
-	if (IS_ERR(ptr))
-		error_packet(remcom_out_buffer, PTR_ERR(ptr));
+	if (err)
+		error_packet(remcom_out_buffer, err);
 	else
 		strcpy(remcom_out_buffer, "OK");
 }
@@ -1382,8 +1248,7 @@ static int gdb_serial_stub(struct kgdb_state *ks)
 		/* Reply to host that an exception has occurred */
 		ptr = remcom_out_buffer;
 		*ptr++ = 'T';
-		*ptr++ = hexchars[(ks->signo >> 4) & 0xf];
-		*ptr++ = hexchars[ks->signo & 0xf];
+		ptr = pack_hex_byte(ptr, ks->signo);
 		ptr += strlen(strcpy(ptr, "thread:"));
 		int_to_threadref(thref, shadow_pid(current->pid));
 		ptr = pack_threadid(ptr, thref);
