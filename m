Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZEDQih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZEDQih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZEDQiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:38:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54795 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbZEDQiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:38:21 -0400
Message-ID: <49FF1A17.5040706@redhat.com>
Date: Mon, 04 May 2009 12:38:47 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Jim Keniston <jkenisto@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: [RFC] x86 instruction decoder with userspace test code
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------000705000906080205070807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000705000906080205070807
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I've rewritten the x86(-64) instruction decoder with instruction
attribute table and a generator according to Peter's comments.

Currently, an opcode map file (x86-opcode-map.txt) is based on opcode
maps in Intel(R) Software Developers Manual Vol.2: Appendix.A, and it
contains below two types of opcode tables.

1-byte/2-bytes/3-bytes opcodes, which has 256 elements, are
written as below;
---
Table: table-name
Referrer: escaped-name
opcode: mnemonic|GrpXXX [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
 (or)
opcode: escape # escaped-name
EndTable
---

Group opcodes, which has 8 elements, are written as below;
---
GrpTable: GrpXXX
reg:  mnemonic [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
EndTable
---

These opcode maps do NOT include SSE and most of FP opcodes,
because those opcodes are not used in the kernel.

The generator(gen-insn-attr-x86.awk) translates the opcode maps
into a file which defines instruction attribute tables. The instruction
attributes are defined in inat.h and inat.c.


I attached insn decoder with user space test, which was originally
written by Jim. You can test the decoder can decode instruction length,
as following:

> Pull all the attached files into a directory and have a go -- e.g.,
> $ make
> $ objdump -d vmlinux | awk -f distill.awk | ./test_get_len [x86_64]

Known issues:
- 0x9b is an instruction (fwait), but the objdump treats it as a
  prefix.  For example 9b df ... can be disassembled as
	fstsw ...	// wait, then store status word
  or
	fwait		// wait
	fnstsw ...	// store status word without waiting
  and this instruction decoder decode 0x9b as an instruction.

  Anyway, according to Jim's investigation, the single-step stopped
  after the fwait, so it's no problem.

- Illegal instruction sequences(in some data/note sections), such
  as an x86_64 instruction that starts with 0x40, or a misplaced
  0x65 prefix. We can filtered out those instructions which start
  with "rex" or includes "(bad)".


I'll put x86-opcode-map.txt under arch/x86/lib, gen-insn-attr-x86.awk
under arch/x86/scripts/ and generate attribute tables at build time.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


--------------000705000906080205070807
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Makefile"

test_get_len: test_get_len.c insn.c inat.c inat.h insn.h insn_x86_user.h inat-tables.c
	$(CC) -Wall -g test_get_len.c insn.c inat.c -o test_get_len

inat-tables.c: gen-insn-attr-x86.awk x86-opcode-map.txt
	awk -f gen-insn-attr-x86.awk x86-opcode-map.txt > $@

clean:
	rm -f *.o

clobber: clean
	rm -f test_get_len inat-tables.c

--------------000705000906080205070807
Content-Type: text/plain;
 name="distill.awk"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="distill.awk"

# Usage: objdump -d a.out | awk -f distill.awk | ./test_get_len
# Distills the disassembly as follows:
# - Removes all lines except the disassembled instructions.
# - For instructions that exceed 1 line (7 bytes), crams all the hex bytes
# into a single line.

BEGIN {
	prev_addr = ""
	prev_hex = ""
	prev_mnemonic = ""
}

/^ *[0-9a-f]+:/ {
	if (split($0, field, "\t") < 3) {
		# This is a continuation of the same insn.
		prev_hex = prev_hex field[2]
	} else {
		if (prev_addr != "")
			printf "%s\t%s\t%s\n", prev_addr, prev_hex, prev_mnemonic
		prev_addr = field[1]
		prev_hex = field[2]
		prev_mnemonic = field[3]
	}
}

END {
	if (prev_addr != "")
		printf "%s\t%s\t%s\n", prev_addr, prev_hex, prev_mnemonic
}

--------------000705000906080205070807
Content-Type: text/plain;
 name="gen-insn-attr-x86.awk"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gen-insn-attr-x86.awk"

#!/bin/gawk -f

BEGIN {
	print "/* x86 opcode map generated from x86-opcode-map.txt */"
	print "/* Do not change this code. */"
	ggid = 1
	geid = 1

	opnd_expr = "^[A-Za-z]"
	ext_expr = "^\\("
	sep_expr = "^\\|$"
	group_expr = "^Grp[0-9]+A*"

	imm_expr = "^[IJAO][a-z]"
	imm_flag["Ib"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
	imm_flag["Jb"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
	imm_flag["Iw"] = "INAT_MAKE_IMM(INAT_IMM_WORD)"
	imm_flag["Id"] = "INAT_MAKE_IMM(INAT_IMM_DWORD)"
	imm_flag["Iq"] = "INAT_MAKE_IMM(INAT_IMM_QWORD)"
	imm_flag["Ap"] = "INAT_MAKE_IMM(INAT_IMM_PTR)"
	imm_flag["Iz"] = "INAT_MAKE_IMM(INAT_IMM_VWORD32)"
	imm_flag["Jz"] = "INAT_MAKE_IMM(INAT_IMM_VWORD32)"
	imm_flag["Iv"] = "INAT_MAKE_IMM(INAT_IMM_VWORD)"
	imm_flag["Ob"] = "INAT_MOFFSET"
	imm_flag["Ov"] = "INAT_MOFFSET"

	modrm_expr = "^([CDEGMNPQRSUVW][a-z]+|NTA|T[0-2])"
	force64_expr = "\\([df]64\\)"
	rex_expr = "^REX(\\.[XRWB]+)*"
	fpu_expr = "^ESC" # TODO

	lprefix1_expr = "\\(66\\)"
	delete lptable1
	lprefix2_expr = "\\(F2\\)"
	delete lptable2
	lprefix3_expr = "\\(F3\\)"
	delete lptable3
	max_lprefix = 4

	prefix_expr = "\\(Prefix\\)"
	prefix_num["Operand-Size"] = "INAT_PFX_OPNDSZ"
	prefix_num["REPNE"] = "INAT_PFX_REPNE"
	prefix_num["REP/REPE"] = "INAT_PFX_REPE"
	prefix_num["LOCK"] = "INAT_PFX_LOCK"
	prefix_num["SEG=CS"] = "INAT_PFX_CS"
	prefix_num["SEG=DS"] = "INAT_PFX_DS"
	prefix_num["SEG=ES"] = "INAT_PFX_ES"
	prefix_num["SEG=FS"] = "INAT_PFX_FS"
	prefix_num["SEG=GS"] = "INAT_PFX_GS"
	prefix_num["SEG=SS"] = "INAT_PFX_SS"
	prefix_num["Address-Size"] = "INAT_PFX_ADDRSZ"

	delete table
	delete etable
	delete gtable
	eid = -1
	gid = -1
}

function semantic_error(msg) {
	print "Semantic error at " NR ": " msg > "/dev/stderr"
	exit 1
}

function debug(msg) {
	print "DEBUG: " msg
}

function array_size(arr,   i,c) {
	c = 0
	for (i in arr)
		c++
	return c
}

/^Table:/ {
	print "/* " $0 " */"
}

/^Referrer:/ {
	if (NF == 1) {
		# primary opcode table
		tname = "inat_primary_table"
		eid = -1
	} else {
		# escape opcode table
		ref = ""
		for (i = 2; i <= NF; i++)
			ref = ref $i
		eid = escape[ref]
		tname = sprintf("inat_escape_table_%d", eid)
	}
}

/^GrpTable:/ {
	print "/* " $0 " */"
	if (!($2 in group))
		semantic_error("No group: " $2 )
	gid = group[$2]
	tname = "inat_group_table_" gid
}

function print_table(tbl,name,fmt,n)
{
	print "const insn_attr_t " name " = {"
	for (i = 0; i < n; i++) {
		id = sprintf(fmt, i)
		if (tbl[id])
			print "	[" id "] = " tbl[id] ","
	}
	print "};"
}

/^EndTable/ {
	if (gid != -1) {
		# print group tables
		if (array_size(table) != 0) {
			print_table(table, tname "[INAT_GROUP_TABLE_SIZE]",
				    "0x%x", 8)
			gtable[gid,0] = tname
		}
		if (array_size(lptable1) != 0) {
			print_table(lptable1, tname "_1[INAT_GROUP_TABLE_SIZE]",
				    "0x%x", 8)
			gtable[gid,1] = tname "_1"
		}
		if (array_size(lptable2) != 0) {
			print_table(lptable2, tname "_2[INAT_GROUP_TABLE_SIZE]",
				    "0x%x", 8)
			gtable[gid,2] = tname "_2"
		}
		if (array_size(lptable3) != 0) {
			print_table(lptable3, tname "_3[INAT_GROUP_TABLE_SIZE]",
				    "0x%x", 8)
			gtable[gid,3] = tname "_3"
		}
	} else {
		# print primary/escaped tables
		if (array_size(table) != 0) {
			print_table(table, tname "[INAT_OPCODE_TABLE_SIZE]",
				    "0x%02x", 256)
			etable[eid,0] = tname
		}
		if (array_size(lptable1) != 0) {
			print_table(lptable1,tname "_1[INAT_OPCODE_TABLE_SIZE]",
				    "0x%02x", 256)
			etable[eid,1] = tname "_1"
		}
		if (array_size(lptable2) != 0) {
			print_table(lptable2,tname "_2[INAT_OPCODE_TABLE_SIZE]",
				    "0x%02x", 256)
			etable[eid,2] = tname "_2"
		}
		if (array_size(lptable3) != 0) {
			print_table(lptable3,tname "_3[INAT_OPCODE_TABLE_SIZE]",
				    "0x%02x", 256)
			etable[eid,3] = tname "_3"
		}
	}
	print ""
	delete table
	delete lptable1
	delete lptable2
	delete lptable3
	gid = -1
	eid = -1
}

function add_flags(old,new) {
	if (old && new)
		return old " | " new
	else if (old)
		return old
	else
		return new
}

function convert_operands(opnd,       i,imm,mod)
{
	imm = null
	mod = null
	for (i in opnd) {
		i  = opnd[i]
		if (match(i, imm_expr) == 1) {
			if (!imm_flag[i])
				semantic_error("Unknown imm opnd: " i)
			if (imm) {
				if (i != "Ib")
					semantic_error("ADDIMM error")
				imm = add_flags(imm, "INAT_ADDIMM")
			} else
				imm = imm_flag[i] 
		} else if (match(i, modrm_expr))
			mod = "INAT_MODRM" 
	}
	return add_flags(imm, mod)
}

/^[0-9a-f]+\:/ {
	if (NR == 1)
		next
	# get index
	idx = "0x" substr($1, 1, index($1,":") - 1)
	if (idx in table)
		semantic_error("Redefine " idx " in " tname)

	# check if escaped opcode
	if ("escape" == $2) {
		if ($3 != "#")
			semantic_error("No escaped name")
		ref = ""
		for (i = 4; i <= NF; i++)
			ref = ref $i
		if (ref in escape)
			semantic_error("Redefine escape (" ref ")")
		escape[ref] = geid
		geid++
		table[idx] = "INAT_MAKE_ESCAPE(" escape[ref] ")"
		next
	}

	variant = null
	# converts
	i = 2
	while (i <= NF) {
		opcode = $(i++)
		delete opnds
		ext = null
		flags = null
		opnd = null
		# parse one opcode
		if (match($i, opnd_expr)) {
			opnd = $i
			split($(i++), opnds, ",")
			flags = convert_operands(opnds)
		}
		if (match($i, ext_expr))
			ext = $(i++)
		if (match($i, sep_expr))
			i++
		else if (i < NF)
			semantic_error($i " is not a separator")

		# check if group opcode
		if (match(opcode, group_expr)) {
			if (!(opcode in group)) {
				group[opcode] = ggid
				ggid++
			}
			flags = add_flags(flags, "INAT_MAKE_GROUP(" group[opcode] ")")
		}
		# check force(or default) 64bit
		if (match(ext, force64_expr))
			flags = add_flags(flags, "INAT_FORCE64")

		# check REX prefix
		if (match(opcode, rex_expr))
			flags = add_flags(flags, "INAT_REXPFX")

		# check coprocessor escape : TODO
		if (match(opcode, fpu_expr))
			flags = add_flags(flags, "INAT_MODRM")

		# check prefixes
		if (match(ext, prefix_expr)) {
			if (!prefix_num[opcode])
				semantic_error("Unknown prefix: " opcode)
			flags = add_flags(flags, "INAT_MAKE_PREFIX(" prefix_num[opcode] ")")
		}
		if (length(flags) == 0)
			continue
		# check if last prefix
		if (match(ext, lprefix1_expr)) {
			lptable1[idx] = add_flags(lptable1[idx],flags)
			variant = "INAT_VARIANT"
		} else if (match(ext, lprefix2_expr)) {
			lptable2[idx] = add_flags(lptable2[idx],flags)
			variant = "INAT_VARIANT"
		} else if (match(ext, lprefix3_expr)) {
			lptable3[idx] = add_flags(lptable3[idx],flags)
			variant = "INAT_VARIANT"
		} else {
			table[idx] = add_flags(table[idx],flags)
		}
	}
	if (variant)
		table[idx] = add_flags(table[idx],variant)
}

END {
	# print escape opcode map's array
	print "/* Escape opcode map array */"
	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1]" \
	      "[INAT_LPREFIX_MAX + 1] = {"
	for (i = 0; i < geid; i++)
		for (j = 0; j < max_lprefix; j++)
			if (etable[i,j])
				print "	["i"]["j"] = "etable[i,j]","
	print "};\n"
	# print group opcode map's array
	print "/* Group opcode map array */"
	print "const insn_attr_t const *inat_group_tables[INAT_GRP_MAX + 1]"\
	      "[INAT_LPREFIX_MAX + 1] = {"
	for (i = 0; i < ggid; i++)
		for (j = 0; j < max_lprefix; j++)
			if (gtable[i,j])
				print "	["i"]["j"] = "gtable[i,j]","
	print "};"
}

--------------000705000906080205070807
Content-Type: text/plain;
 name="inat.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="inat.c"

/*
 * x86 instruction attribute tables
 *
 * Written by Masami Hiramatsu <mhiramat@redhat.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 */
#ifdef __KERNEL__
#include <linux/string.h>
#include <linux/module.h>
#include <asm/insn.h>
#else
#include "insn.h"
#include "inat.h"
#endif

/* Attribute tables are generated from opcode map */
#include "inat-tables.c"

/* Attribute search APIs */
insn_attr_t inat_get_opcode_attribute(u8 opcode)
{
	return inat_primary_table[opcode];
}

insn_attr_t inat_get_escape_attribute(u8 opcode, u8 last_pfx,
				      insn_attr_t esc_attr)
{
	const insn_attr_t *table;
	insn_attr_t lpfx_attr = inat_get_opcode_attribute(last_pfx);
	int n, m;

	n = INAT_ESCAPE_NUM(esc_attr);
	m = INAT_LPREFIX_NUM(lpfx_attr);
	table = inat_escape_tables[n][0];
	if (!table)
		return 0;
	if (INAT_HAS_VARIANT(table[opcode]) && m) {
		table = inat_escape_tables[n][m];
		if (!table)
			return 0;
	}
	return table[opcode];
}

#define REGBITS(modrm) (((modrm) >> 3) & 0x7)

insn_attr_t inat_get_group_attribute(u8 modrm, u8 last_pfx,
				     insn_attr_t grp_attr)
{
	const insn_attr_t *table;
	insn_attr_t lpfx_attr = inat_get_opcode_attribute(last_pfx);
	int n, m;

	n = INAT_GROUP_NUM(grp_attr);
	m = INAT_LPREFIX_NUM(lpfx_attr);
	table = inat_group_tables[n][0];
	if (!table)
		return INAT_GROUP_COMMON(grp_attr);
	if (INAT_HAS_VARIANT(table[REGBITS(modrm)]) && m) {
		table = inat_escape_tables[n][m];
		if (!table)
			return INAT_GROUP_COMMON(grp_attr);
	}
	return table[REGBITS(modrm)] | INAT_GROUP_COMMON(grp_attr);
}


--------------000705000906080205070807
Content-Type: text/plain;
 name="inat.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="inat.h"

#ifndef _ASM_INAT_INAT_H
#define _ASM_INAT_INAT_H
/*
 * x86 instruction attributes
 *
 * Written by Masami Hiramatsu <mhiramat@redhat.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 */
#ifdef __KERNEL__
#include <linux/types.h>
#else
#include "insn_x86_user.h"
#endif

/* Instruction attributes */
typedef u32 insn_attr_t;

/*
 * Internal bits. Don't use bitmasks directly, because these bits are
 * unstable. You should add checking macros and use that macro in
 * your code.
 */

#define INAT_OPCODE_TABLE_SIZE 256
#define INAT_GROUP_TABLE_SIZE 8

/* Legacy instruction prefixes */
#define INAT_PFX_OPNDSZ	1	/* 0x66 */ /* LPFX1 */
#define INAT_PFX_REPNE	2	/* 0xF2 */ /* LPFX2 */
#define INAT_PFX_REPE	3	/* 0xF3 */ /* LPFX3 */
#define INAT_PFX_LOCK	4	/* 0xF0 */
#define INAT_PFX_CS	5	/* 0x2E */
#define INAT_PFX_DS	6	/* 0x3E */
#define INAT_PFX_ES	7	/* 0x26 */
#define INAT_PFX_FS	8	/* 0x64 */
#define INAT_PFX_GS	9	/* 0x65 */
#define INAT_PFX_SS	10	/* 0x36 */
#define INAT_PFX_ADDRSZ	11	/* 0x67 */

#define INAT_LPREFIX_MAX	3

/* Immediate size */
#define INAT_IMM_BYTE		1
#define INAT_IMM_WORD		2
#define INAT_IMM_DWORD		3
#define INAT_IMM_QWORD		4
#define INAT_IMM_PTR		5
#define INAT_IMM_VWORD32	6
#define INAT_IMM_VWORD		7

/* Legacy prefix */
#define INAT_PFX_OFFS	0
#define INAT_PFX_BITS	4
#define INAT_PFX_MAX    ((1 << INAT_PFX_BITS) - 1)
#define INAT_PFX_MASK	(INAT_PFX_MAX << INAT_PFX_OFFS)
/* Escape opcodes */
#define INAT_ESC_OFFS	(INAT_PFX_OFFS + INAT_PFX_BITS)
#define INAT_ESC_BITS	2
#define INAT_ESC_MAX	((1 << INAT_ESC_BITS) - 1)
#define INAT_ESC_MASK	(INAT_ESC_MAX << INAT_ESC_OFFS)
/* Group opcodes (1-16) */
#define INAT_GRP_OFFS	(INAT_ESC_OFFS + INAT_ESC_BITS)
#define INAT_GRP_BITS	5
#define INAT_GRP_MAX	((1 << INAT_GRP_BITS) - 1)
#define INAT_GRP_MASK	(INAT_GRP_MAX << INAT_GRP_OFFS)
/* Immediates */
#define INAT_IMM_OFFS	(INAT_GRP_OFFS + INAT_GRP_BITS)
#define INAT_IMM_BITS	3
#define INAT_IMM_MASK	(((1 << INAT_IMM_BITS) - 1) << INAT_IMM_OFFS)
/* Flags */
#define INAT_FLAG_OFFS	(INAT_IMM_OFFS + INAT_IMM_BITS)
#define INAT_REXPFX	(1 << INAT_FLAG_OFFS)
#define INAT_MODRM	(1 << (INAT_FLAG_OFFS + 1))
#define INAT_FORCE64	(1 << (INAT_FLAG_OFFS + 2))
#define INAT_ADDIMM	(1 << (INAT_FLAG_OFFS + 3))
#define INAT_MOFFSET	(1 << (INAT_FLAG_OFFS + 4))
#define INAT_VARIANT	(1 << (INAT_FLAG_OFFS + 5))

/* Attribute search APIs */
extern insn_attr_t inat_get_opcode_attribute(u8 opcode);
extern insn_attr_t inat_get_escape_attribute(u8 opcode, u8 last_pfx,
					     insn_attr_t esc_attr);
extern insn_attr_t inat_get_group_attribute(u8 modrm, u8 last_pfx,
					    insn_attr_t esc_attr);

/* Attribute checking macros. Use these macros in your code */
#define INAT_IS_PREFIX(attr)	(attr & INAT_PFX_MASK)
#define INAT_IS_ADDRSZ(attr)	((attr & INAT_PFX_MASK) == INAT_PFX_ADDRSZ)
#define INAT_IS_OPNDSZ(attr)	((attr & INAT_PFX_MASK) == INAT_PFX_OPNDSZ)
#define INAT_LPREFIX_NUM(attr)	\
	(((attr & INAT_PFX_MASK) > INAT_LPREFIX_MAX) ? 0 :\
	 (attr & INAT_PFX_MASK))
#define INAT_MAKE_PREFIX(pfx)	(pfx << INAT_PFX_OFFS)

#define INAT_IS_ESCAPE(attr)	(attr & INAT_ESC_MASK)
#define INAT_ESCAPE_NUM(attr)	((attr & INAT_ESC_MASK) >> INAT_ESC_OFFS)
#define INAT_MAKE_ESCAPE(esc)	(esc << INAT_ESC_OFFS)

#define INAT_IS_GROUP(attr)	(attr & INAT_GRP_MASK)
#define INAT_GROUP_NUM(attr)	((attr & INAT_GRP_MASK) >> INAT_GRP_OFFS)
#define INAT_GROUP_COMMON(attr)	(attr & ~INAT_GRP_MASK)
#define INAT_MAKE_GROUP(grp)	((grp << INAT_GRP_OFFS) | INAT_MODRM)

#define INAT_HAS_IMM(attr)	(attr & INAT_IMM_MASK)
#define INAT_IMM_SIZE(attr)	((attr & INAT_IMM_MASK) >> INAT_IMM_OFFS)
#define INAT_MAKE_IMM(imm)	(imm << INAT_IMM_OFFS)

#define INAT_IS_REX_PREFIX(attr)	(attr & INAT_REXPFX)
#define INAT_HAS_MODRM(attr)	(attr & INAT_MODRM)
#define INAT_IS_FORCE64(attr)	(attr & INAT_FORCE64)
#define INAT_HAS_ADDIMM(attr)	(attr & INAT_ADDIMM)
#define INAT_HAS_MOFFSET(attr)	(attr & INAT_MOFFSET)
#define INAT_HAS_VARIANT(attr)	(attr & INAT_VARIANT)

#endif

--------------000705000906080205070807
Content-Type: text/plain;
 name="insn.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="insn.c"

/*
 * x86 instruction analysis
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Copyright (C) IBM Corporation, 2002, 2004, 2009
 */

#ifdef __KERNEL__
#include <linux/string.h>
#include <linux/module.h>
#include <asm/insn.h>
#include <asm/inat.h>
#else
#include <string.h>
#include "insn.h"
#endif

#define get_next(t, insn)	\
	({t r; r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })

#define peek_next(t, insn)	\
	({t r; r = *(t*)insn->next_byte; r; })

/**
 * insn_init() - initialize struct insn
 * @insn:	&struct insn to be initialized
 * @kaddr:	address (in kernel memory) of instruction (or copy thereof)
 * @x86_64:	true for 64-bit kernel or 64-bit app
 */
void insn_init(struct insn *insn, const u8 *kaddr, bool x86_64)
{
	memset(insn, 0, sizeof(*insn));
	insn->kaddr = kaddr;
	insn->next_byte = kaddr;
	insn->x86_64 = x86_64;
	insn->opnd_bytes = 4;
	if (x86_64)
		insn->addr_bytes = 8;
	else
		insn->addr_bytes = 4;
}
EXPORT_SYMBOL_GPL(insn_init);

/**
 * insn_get_prefixes - scan x86 instruction prefix bytes
 * @insn:	&struct insn containing instruction
 *
 * Populates the @insn->prefixes bitmap, and updates @insn->next_byte
 * to point to the (first) opcode.  No effect if @insn->prefixes.got
 * is already true.
 */
void insn_get_prefixes(struct insn *insn)
{
	struct insn_field *prefixes = &insn->prefixes;
	insn_attr_t attr;
	u8 b;

	if (prefixes->got)
		return;

	prefixes->nbytes = 0;
	while (prefixes->nbytes < 4) {
		b = peek_next(u8, insn);
		attr = inat_get_opcode_attribute(b);
		if (!INAT_IS_PREFIX(attr))
			break;
		prefixes->bytes[prefixes->nbytes] = b;
		prefixes->nbytes++;
		insn->next_byte++;
		if (INAT_IS_ADDRSZ(attr)) {
			/* address size switches 2/4 or 4/8 */
			if (insn->x86_64)
				insn->addr_bytes ^= 12;
			else
				insn->addr_bytes ^= 6;
		} else if (INAT_IS_OPNDSZ(attr)) {
			/* oprand size switches 2/4 */
			insn->opnd_bytes ^= 6;
		}
	}
	if (insn->x86_64) {
		b = peek_next(u8, insn);
		attr = inat_get_opcode_attribute(b);
		if (INAT_IS_REX_PREFIX(attr)) {
			insn->rex_prefix.value = b;
			insn->rex_prefix.nbytes = 1;
			insn->rex_prefix.got = true;
			insn->next_byte++;
			if (REX_W(insn))
				/* REX.W overrides opnd_size */
				insn->opnd_bytes = 8;
		}
	}
	prefixes->got = true;
	return;
}
EXPORT_SYMBOL_GPL(insn_get_prefixes);

/**
 * insn_get_opcode - collect opcode(s)
 * @insn:	&struct insn containing instruction
 *
 * Populates @insn->opcode, updates @insn->next_byte to point past the
 * opcode byte(s), and set @insn->attr (except for groups).
 * If necessary, first collects any preceding (prefix) bytes.
 * Sets @insn->opcode.value = opcode1.  No effect if @insn->opcode.got
 * is already true.
 *
 */
void insn_get_opcode(struct insn *insn)
{
	struct insn_field *opcode = &insn->opcode;
	u8 op, pfx;
	if (opcode->got)
		return;
	if (!insn->prefixes.got)
		insn_get_prefixes(insn);

	/* Get first opcode */
	op = get_next(u8, insn);
	OPCODE1(insn) = op;
	opcode->nbytes = 1;
	insn->attr = inat_get_opcode_attribute(op);
	while (INAT_IS_ESCAPE(insn->attr)) {
		/* Get escaped opcode */
		op = get_next(u8, insn);
		opcode->bytes[opcode->nbytes++] = op;
		pfx = insn_last_prefix(insn);
		insn->attr = inat_get_escape_attribute(op, pfx, insn->attr);
	}
	opcode->got = true;
}
EXPORT_SYMBOL_GPL(insn_get_opcode);

/**
 * insn_get_modrm - collect ModRM byte, if any
 * @insn:	&struct insn containing instruction
 *
 * Populates @insn->modrm and updates @insn->next_byte to point past the
 * ModRM byte, if any.  If necessary, first collects the preceding bytes
 * (prefixes and opcode(s)).  No effect if @insn->modrm.got is already true.
 */
void insn_get_modrm(struct insn *insn)
{
	struct insn_field *modrm = &insn->modrm;
	u8 pfx, mod;
	if (modrm->got)
		return;
	if (!insn->opcode.got)
		insn_get_opcode(insn);

	if (INAT_HAS_MODRM(insn->attr)) {
		mod = get_next(u8, insn);
		modrm->value = mod;
		modrm->nbytes = 1;
		if (INAT_IS_GROUP(insn->attr)) {
			pfx = insn_last_prefix(insn);
			insn->attr = inat_get_group_attribute(mod, pfx,
							      insn->attr);
		}
	}

	if (insn->x86_64 && INAT_IS_FORCE64(insn->attr))
		insn->opnd_bytes = 8;
	modrm->got = true;
}
EXPORT_SYMBOL_GPL(insn_get_modrm);


/**
 * insn_rip_relative() - Does instruction use RIP-relative addressing mode?
 * @insn:	&struct insn containing instruction
 *
 * If necessary, first collects the instruction up to and including the
 * ModRM byte.  No effect if @insn->x86_64 is false.
 */
bool insn_rip_relative(struct insn *insn)
{
	struct insn_field *modrm = &insn->modrm;

	if (!insn->x86_64)
		return false;
	if (!modrm->got)
		insn_get_modrm(insn);
	/*
	 * For rip-relative instructions, the mod field (top 2 bits)
	 * is zero and the r/m field (bottom 3 bits) is 0x5.
	 */
	return (insn_field_exists(modrm) && (modrm->value & 0xc7) == 0x5);
}
EXPORT_SYMBOL_GPL(insn_rip_relative);

/**
 *
 * insn_get_sib() - Get the SIB byte of instruction
 * @insn:	&struct insn containing instruction
 *
 * If necessary, first collects the instruction up to and including the
 * ModRM byte.
 */
void insn_get_sib(struct insn *insn)
{
	if (insn->sib.got)
		return;
	if (!insn->modrm.got)
		insn_get_modrm(insn);
	if (insn->modrm.nbytes)
		if (insn->addr_bytes != 2 &&
		    MODRM_MOD(insn) != 3 && MODRM_RM(insn) == 4) {
			insn->sib.value = get_next(u8, insn);
			insn->sib.nbytes = 1;
		}
	insn->sib.got = true;
}
EXPORT_SYMBOL_GPL(insn_get_sib);


/**
 *
 * insn_get_displacement() - Get the displacement of instruction
 * @insn:	&struct insn containing instruction
 *
 * If necessary, first collects the instruction up to and including the
 * SIB byte.
 * Displacement value is sign-expanded.
 */
void insn_get_displacement(struct insn *insn)
{
	u8 mod;
	if (insn->displacement.got)
		return;
	if (!insn->sib.got)
		insn_get_sib(insn);
	if (insn->modrm.nbytes) {
		/*
		 * Interpreting the modrm byte:
		 * mod = 00 - no displacement fields (exceptions below)
		 * mod = 01 - 1-byte displacement field
		 * mod = 10 - displacement field is 4 bytes, or 2 bytes if
		 * 	address size = 2 (0x67 prefix in 32-bit mode)
		 * mod = 11 - no memory operand
		 *
		 * If address size = 2...
		 * mod = 00, r/m = 110 - displacement field is 2 bytes
		 *
		 * If address size != 2...
		 * mod != 11, r/m = 100 - SIB byte exists
		 * mod = 00, SIB base = 101 - displacement field is 4 bytes
		 * mod = 00, r/m = 101 - rip-relative addressing, displacement
		 * 	field is 4 bytes
		 */
		mod = MODRM_MOD(insn);
		if (mod == 3)
			goto out;
		if (mod == 1) {
			insn->displacement.value = get_next(s8, insn);
			insn->displacement.nbytes = 1;
		} else if (insn->addr_bytes == 2) {
			if ((mod == 0 && MODRM_RM(insn) == 6) || mod == 2) {
				insn->displacement.value = get_next(s16, insn);
				insn->displacement.nbytes = 2;
			}
		} else {
			if ((mod == 0 && MODRM_RM(insn) == 5) || mod == 2 ||
			    (mod == 0 && SIB_BASE(insn) == 5)) {
				insn->displacement.value = get_next(s32, insn);
				insn->displacement.nbytes = 4;
			}
		}
	}
out:
	insn->displacement.got = true;
}
EXPORT_SYMBOL_GPL(insn_get_displacement);

/* Decode moffset16/32/64 */
static void __get_moffset(struct insn *insn)
{
	switch (insn->addr_bytes) {
	case 2:
		insn->moffset1.value = get_next(s16, insn);
		insn->moffset1.nbytes = 2;
		break;
	case 4:
		insn->moffset1.value = get_next(s32, insn);
		insn->moffset1.nbytes = 4;
		break;
	case 8:
		insn->moffset1.value = get_next(s32, insn);
		insn->moffset1.nbytes = 4;
		insn->moffset2.value = get_next(s32, insn);
		insn->moffset2.nbytes = 4;
		break;
	}
	insn->moffset1.got = insn->moffset2.got = true;
}

/* Decode imm v32(Iz) */
static void __get_immv32(struct insn *insn)
{
	switch (insn->opnd_bytes) {
	case 2:
		insn->immediate.value = get_next(s16, insn);
		insn->immediate.nbytes = 2;
		break;
	case 4:
	case 8:
		insn->immediate.value = get_next(s32, insn);
		insn->immediate.nbytes = 4;
		break;
	}
}

/* Decode imm v64(Iv/Ov) */
static void __get_immv(struct insn *insn)
{
	switch (insn->opnd_bytes) {
	case 2:
		insn->immediate1.value = get_next(s16, insn);
		insn->immediate1.nbytes = 2;
		break;
	case 4:
		insn->immediate1.value = get_next(s32, insn);
		insn->immediate1.nbytes = 4;
		break;
	case 8:
		insn->immediate1.value = get_next(s32, insn);
		insn->immediate1.nbytes = 4;
		insn->immediate2.value = get_next(s32, insn);
		insn->immediate2.nbytes = 4;
		break;
	}
	insn->immediate1.got = insn->immediate2.got = true;
}

/* Decode ptr16:16/32(Ap) */
static void __get_immptr(struct insn *insn)
{
	switch (insn->opnd_bytes) {
	case 2:
		insn->immediate1.value = get_next(s16, insn);
		insn->immediate1.nbytes = 2;
		break;
	case 4:
		insn->immediate1.value = get_next(s32, insn);
		insn->immediate1.nbytes = 4;
		break;
	case 8:
		/* ptr16:64 is not supported (no segment) */
		WARN_ON(1);
		return;
	}
	insn->immediate2.value = get_next(u16, insn);
	insn->immediate2.nbytes = 2;
	insn->immediate1.got = insn->immediate2.got = true;
}

/**
 *
 * insn_get_immediate() - Get the immediates of instruction
 * @insn:	&struct insn containing instruction
 *
 * If necessary, first collects the instruction up to and including the
 * displacement bytes.
 * Basically, most of immediates are sign-expanded. Unsigned-value can be
 * get by bit masking with ((1 << (nbytes * 8)) - 1)
 */
void insn_get_immediate(struct insn *insn)
{
	if (insn->immediate.got)
		return;
	if (!insn->displacement.got)
		insn_get_displacement(insn);

	if (INAT_HAS_MOFFSET(insn->attr)) {
		__get_moffset(insn);
		goto done;
	}

	if (!INAT_HAS_IMM(insn->attr))
		/* no immediates */
		goto done;

	switch (INAT_IMM_SIZE(insn->attr)) {
	case INAT_IMM_BYTE:
		insn->immediate.value = get_next(s8, insn);
		insn->immediate.nbytes = 1;
		break;
	case INAT_IMM_WORD:
		insn->immediate.value = get_next(s16, insn);
		insn->immediate.nbytes = 2;
		break;
	case INAT_IMM_DWORD:
		insn->immediate.value = get_next(s32, insn);
		insn->immediate.nbytes = 4;
		break;
	case INAT_IMM_QWORD:
		insn->immediate1.value = get_next(s32, insn);
		insn->immediate1.nbytes = 4;
		insn->immediate2.value = get_next(s32, insn);
		insn->immediate2.nbytes = 4;
		break;
	case INAT_IMM_PTR:
		__get_immptr(insn);
		break;
	case INAT_IMM_VWORD32:
		__get_immv32(insn);
		break;
	case INAT_IMM_VWORD:
		__get_immv(insn);
		break;
	default:
		break;
	}
	if (INAT_HAS_ADDIMM(insn->attr)) {
		insn->immediate2.value = get_next(s8, insn);
		insn->immediate2.nbytes = 1;
	}
done:
	insn->immediate.got = true;
}
EXPORT_SYMBOL_GPL(insn_get_immediate);

/**
 *
 * insn_get_length() - Get the length of instruction
 * @insn:	&struct insn containing instruction
 *
 * If necessary, first collects the instruction up to and including the
 * immediates bytes.
 */
void insn_get_length(struct insn *insn)
{
	if (insn->length)
		return;
	if (!insn->immediate.got)
		insn_get_immediate(insn);
	insn->length = (u8)((unsigned long)insn->next_byte
			    - (unsigned long)insn->kaddr);
}
EXPORT_SYMBOL_GPL(insn_get_length);

--------------000705000906080205070807
Content-Type: text/plain;
 name="insn.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="insn.h"

#ifndef _ASM_X86_INSN_H
#define _ASM_X86_INSN_H
/*
 * x86 instruction analysis
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Copyright (C) IBM Corporation, 2009
 */

#ifdef __KERNEL__
#include <linux/types.h>
/* insn_attr_t is defined in inat.h */
#include <asm/inat.h>
#else
#include "insn_x86_user.h"
#include "inat.h"
#endif

struct insn_field {
	union {
		s32 value;
		u8 bytes[4];
	};
	bool got;	/* true if we've run insn_get_xxx() for this field */
	u8 nbytes;
};

struct insn {
	struct insn_field prefixes;	/* 4 prefixes */
	struct insn_field rex_prefix;	/* REX prefix */
	struct insn_field opcode;	/*
					 * opcode.bytes[0]: opcode1
					 * opcode.bytes[1]: opcode2
					 * opcode.bytes[2]: opcode3
					 */
	struct insn_field modrm;
	struct insn_field sib;
	struct insn_field displacement;
	union {
		struct insn_field immediate;
		struct insn_field moffset1;	/* for 64bit MOV */
		struct insn_field immediate1;	/* for 64bit imm or off16/32 */
	};
	union {
		struct insn_field moffset2;	/* for 64bit MOV */
		struct insn_field immediate2;	/* for 64bit imm or seg16 */
	};

	insn_attr_t attr;
	u8 opnd_bytes;
	u8 addr_bytes;
	u8 length;
	bool x86_64;

	const u8 *kaddr;	/* kernel address of insn (copy) to analyze */
	const u8 *next_byte;
};


#define OPCODE1(insn) ((insn)->opcode.bytes[0])
#define OPCODE2(insn) ((insn)->opcode.bytes[1])
#define OPCODE3(insn) ((insn)->opcode.bytes[2])

#define MODRM_MOD(insn) (((insn)->modrm.value & 0xc0) >> 6)
#define MODRM_REG(insn) (((insn)->modrm.value & 0x38) >> 3)
#define MODRM_RM(insn) ((insn)->modrm.value & 0x07)

#define SIB_SCALE(insn) (((insn)->sib.value & 0xc0) >> 6)
#define SIB_INDEX(insn) (((insn)->sib.value & 0x38) >> 3)
#define SIB_BASE(insn) ((insn)->sib.value & 0x07)

#define REX_W(insn) ((insn)->rex_prefix.value & 8)
#define REX_R(insn) ((insn)->rex_prefix.value & 4)
#define REX_X(insn) ((insn)->rex_prefix.value & 2)
#define REX_B(insn) ((insn)->rex_prefix.value & 1)

#define MOFFSET64(insn)	(((u64)((insn)->moffset2.value) << 32) | \
			  (u32)((insn)->moffset1.value))

#define IMMEDIATE64(insn)	(((u64)((insn)->immediate2.value) << 32) | \
				  (u32)((insn)->immediate1.value))

extern void insn_init(struct insn *insn, const u8 *kaddr, bool x86_64);
extern void insn_get_prefixes(struct insn *insn);
extern void insn_get_opcode(struct insn *insn);
extern void insn_get_modrm(struct insn *insn);
extern void insn_get_sib(struct insn *insn);
extern void insn_get_displacement(struct insn *insn);
extern void insn_get_immediate(struct insn *insn);
extern void insn_get_length(struct insn *insn);

/* Attribute will be determined after getting ModRM (for opcode groups) */
static inline void insn_get_attr(struct insn *insn)
{
	insn_get_modrm(insn);
}

/* The last prefix is needed for two-byte and three-byte opcodes */
static inline u8 insn_last_prefix(struct insn *insn)
{
	if (insn->prefixes.nbytes == 0)
		return 0;
	return (insn)->prefixes.bytes[(insn)->prefixes.nbytes - 1];
}

/* Instruction uses RIP-relative addressing */
extern bool insn_rip_relative(struct insn *insn);

#ifdef CONFIG_X86_64
/* Init insn for kernel text */
#define insn_init_kernel(insn, kaddr) insn_init(insn, kaddr, 1)
#else /* CONFIG_X86_32 */
#define insn_init_kernel(insn, kaddr) insn_init(insn, kaddr, 0)
#endif

static inline bool insn_field_exists(const struct insn_field *field)
{
	return (field->nbytes > 0);
}

#endif /* _ASM_X86_INSN_H */

--------------000705000906080205070807
Content-Type: text/plain;
 name="insn_x86_user.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="insn_x86_user.h"

#ifndef __INSN_X86_USER_H
#define __INSN_X86_USER_H

/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Copyright (C) IBM Corporation, 2009
 */

#ifdef __x86_64__
#define CONFIG_X86_64
#else
#define CONFIG_X86_32
#endif
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long long u64;

typedef signed char s8;
typedef short s16;
typedef int s32;
typedef long long s64;

typedef enum bool { false, true } bool;

/* any harmless file-scope decl */
#define NOP_DECL struct __nop
#define EXPORT_SYMBOL_GPL(symbol) NOP_DECL
#define MODULE_LICENSE(gpl) NOP_DECL

#define WARN_ON(cond) do{}while(0)

#define BITS_PER_LONG (8*sizeof(long))
/* from arch/x86/include/asm/bitops.h */
static inline int test_bit(int nr, const volatile unsigned long *addr)
{
	return ((1UL << (nr % BITS_PER_LONG)) &
		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
}

#endif /* __INSN_X86_USER_H */

--------------000705000906080205070807
Content-Type: text/plain;
 name="test_get_len.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test_get_len.c"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "insn.h"

/*
 * Test of instruction analysis in general and insn_get_length() in
 * particular.  See if insn_get_length() and the disassembler agree
 * on the length of each instruction in an elf disassembly.
 *
 * usage: test_get_len [x86_64] < distilled_disassembly
 */

const char *prog;

static void usage()
{
	fprintf(stderr, "usage: %s [x86_64] < distilled_disassembly\n", prog);
	exit(1);
}

static void malformed_line(const char *line, int line_nr)
{
	fprintf(stderr, "%s: malformed line %d:\n%s", prog, line_nr, line);
	exit(3);
}

int main(int argc, char **argv)
{
	char line[200];
	unsigned char insn_buf[16];
	struct insn insn;
	bool x86_64 = false;
	int errors = 0, insns = 0;
#define MAX_ERRORS 10

	prog = argv[0];
	if (argc == 2) {
		if (!strcmp(argv[1], "x86_64"))
			x86_64 = true;
		else
			usage();
	} else if (argc > 2)
		usage();

	while (fgets(line, 200, stdin)) {
		char copy[200], *s, *tab1, *tab2;
		int nb = 0;
		unsigned b;

		insns++;
		memset(insn_buf, 0, 16);
		strcpy(copy, line);
		tab1 = strchr(copy, '\t');
		if (!tab1)
			malformed_line(line, insns);
		s = tab1 + 1;
		s += strspn(s, " ");
		tab2 = strchr(s, '\t');
		if (!tab2)
			malformed_line(line, insns);
		*tab2 = '\0';  // so characters beyond tab2 aren't examined
		while (s < tab2) {
			if (sscanf(s, "%x", &b) == 1) {
				insn_buf[nb++] = (unsigned char) b;
				s += 3;
			} else
				break;
		}
		
		insn_init(&insn, insn_buf, x86_64);
		insn_get_length(&insn);
		if (insn.length != nb) {
			fprintf(stderr, "%s", line);
			fprintf(stderr, "objdump says %d bytes, but "
				"insn_get_length() says %d (attr:%x)\n", nb,
				insn.length, insn.attr);
			if (++errors > MAX_ERRORS) {
				fprintf(stderr, "Stopping after %d errors "
					"and %d instructions.\n",
					MAX_ERRORS, insns);
				exit(2);
			}
		}
	}
	return 0;
}

--------------000705000906080205070807
Content-Type: text/plain;
 name="x86-opcode-map.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86-opcode-map.txt"

# x86 Opcode Maps
#
#<Opcode maps>
# Table: table-name
# Referrer: escaped-name
# opcode: mnemonic|GrpXXX [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
# (or)
# opcode: escape # escaped-name
# EndTable
#
#<group maps>
# GrpTable: GrpXXX
# reg:  mnemonic [operand1[,operand2...]] [(extra1)[,(extra2)...] [| 2nd-mnemonic ...]
# EndTable
#

Table: one byte opcode
Referrer:
# 0x00 - 0x0f
00: ADD Eb,Gb
01: ADD Ev,Gv
02: ADD Gb,Eb
03: ADD Gv,Ev
04: ADD AL,Ib
05: ADD rAX,Iz
06: PUSH ES (i64)
07: POP ES (i64)
08: OR Eb,Gb
09: OR Ev,Gv
0a: OR Gb,Eb
0b: OR Gv,Ev
0c: OR AL,Ib
0d: OR rAX,Iz
0e: PUSH CS (i64)
0f: escape # 2-byte escape
# 0x10 - 0x1f
10: ADC Eb,Gb
11: ADC Ev,Gv
12: ADC Gb,Eb
13: ADC Gv,Ev
14: ADC AL,Ib
15: ADC rAX,Iz
16: PUSH SS (i64)
17: POP SS (i64)
18: SBB Eb,Gb
19: SBB Ev,Gv
1a: SBB Gb,Eb
1b: SBB Gv,Ev
1c: SBB AL,Ib
1d: SBB rAX,Iz
1e: PUSH DS (i64)
1f: POP DS (i64)
# 0x20 - 0x2f
20: AND Eb,Gb
21: AND Ev,Gv
22: AND Gb,Eb
23: AND Gv,Ev
24: AND AL,Ib
25: AND rAx,Iz
26: SEG=ES (Prefix)
27: DAA (i64)
28: SUB Eb,Gb
29: SUB Ev,Gv
2a: SUB Gb,Eb
2b: SUB Gv,Ev
2c: SUB AL,Ib
2d: SUB rAX,Iz
2e: SEG=CS (Prefix)
2f: DAS (i64)
# 0x30 - 0x3f
30: XOR Eb,Gb
31: XOR Ev,Gv
32: XOR Gb,Eb
33: XOR Gv,Ev
34: XOR AL,Ib
35: XOR rAX,Iz
36: SEG=SS (Prefix)
37: AAA (i64)
38: CMP Eb,Gb
39: CMP Ev,Gv
3a: CMP Gb,Eb
3b: CMP Gv,Ev
3c: CMP AL,Ib
3d: CMP rAX,Iz
3e: SEG=DS (Prefix)
3f: AAS (i64)
# 0x40 - 0x4f
40: INC eAX (i64) | REX (o64)
41: INC eCX (i64) | REX.B (o64)
42: INC eDX (i64) | REX.X (o64)
43: INC eBX (i64) | REX.XB (o64)
44: INC eSP (i64) | REX.R (o64)
45: INC eBP (i64) | REX.RB (o64)
46: INC eSI (i64) | REX.RX (o64)
47: INC eDI (i64) | REX.RXB (o64)
48: DEC eAX (i64) | REX.W (o64)
49: DEC eCX (i64) | REX.WB (o64)
4a: DEC eDX (i64) | REX.WX (o64)
4b: DEC eBX (i64) | REX.WXB (o64)
4c: DEC eSP (i64) | REX.WR (o64)
4d: DEC eBP (i64) | REX.WRB (o64)
4e: DEC eSI (i64) | REX.WRX (o64)
4f: DEC eDI (i64) | REX.WRXB (o64)
# 0x50 - 0x5f
50: PUSH rAX/r8 (d64)
51: PUSH rCX/r9 (d64)
52: PUSH rDX/r10 (d64)
53: PUSH rBX/r11 (d64)
54: PUSH rSP/r12 (d64)
55: PUSH rBP/r13 (d64)
56: PUSH rSI/r14 (d64)
57: PUSH rDI/r15 (d64)
58: POP rAX/r8 (d64)
59: POP rCX/r9 (d64)
5a: POP rDX/r10 (d64)
5b: POP rBX/r11 (d64)
5c: POP rSP/r12 (d64)
5d: POP rBP/r13 (d64)
5e: POP rSI/r14 (d64)
5f: POP rDI/r15 (d64)
# 0x60 - 0x6f
60: PUSHA/PUSHAD (i64)
61: POPA/POPAD (i64)
62: BOUND Gv,Ma (i64)
63: ARPL Ew,Gw (i64) | MOVSXD Gv,Ev (o64)
64: SEG=FS (Prefix)
65: SEG=GS (Prefix)
66: Operand-Size (Prefix)
67: Address-Size (Prefix)
68: PUSH Iz (d64)
69: IMUL Gv,Ev,Iz
6a: PUSH Ib (d64)
6b: IMUL Gv,Ev,Ib
6c: INS/INSB Yb,DX
6d: INS/INSW/INSD Yz,DX
6e: OUTS/OUTSB DX,Xb
6f: OUTS/OUTSW/OUTSD DX,Xz
# 0x70 - 0x7f
70: JO Jb
71: JNO Jb
72: JB/JNAE/JC Jb
73: JNB/JAE/JNC Jb
74: JZ/JE Jb
75: JNZ/JNE Jb
76: JBE/JNA Jb
77: JNBE/JA Jb
78: JS Jb
79: JNS Jb
7a: JP/JPE Jb
7b: JNP/JPO Jb
7c: JL/JNGE Jb
7d: JNL/JGE Jb
7e: JLE/JNG Jb
7f: JNLE/JG Jb
# 0x80 - 0x8f
80: Grp1 Eb,Ib (1A)
81: Grp1 Ev,Iz (1A)
82: Grp1 Eb,Ib (1A),(i64)
83: Grp1 Ev,Ib (1A)
84: TEST Eb,Gb
85: TEST Ev,Gv
86: XCHG Eb,Gb
87: XCHG Ev,Gv
88: MOV Eb,Gb
89: MOV Ev,Gv
8a: MOV Gb,Eb
8b: MOV Gv,Ev
8c: MOV Ev,Sw
8d: LEA Gv,M
8e: MOV Sw,Ew
8f: Grp1A (1A) | POP Ev (d64)
# 0x90 - 0x9f
90: NOP | PAUSE (F3) | XCHG r8,rAX
91: XCHG rCX/r9,rAX
92: XCHG rDX/r10,rAX
93: XCHG rBX/r11,rAX
94: XCHG rSP/r12,rAX
95: XCHG rBP/r13,rAX
96: XCHG rSI/r14,rAX
97: XCHG rDI/r15,rAX
98: CBW/CWDE/CDQE
99: CWD/CDQ/CQO
9a: CALLF Ap (i64)
9b: FWAIT/WAIT
9c: PUSHF/D/Q Fv (d64)
9d: POPF/D/Q Fv (d64)
9e: SAHF
9f: LAHF
# 0xa0 - 0xaf
a0: MOV AL,Ob
a1: MOV rAX,Ov
a2: MOV Ob,AL
a3: MOV Ov,rAX
a4: MOVS/B Xb,Yb
a5: MOVS/W/D/Q Xv,Yv
a6: CMPS/B Xb,Yb
a7: CMPS/W/D Xv,Yv
a8: TEST AL,Ib
a9: TEST rAX,Iz
aa: STOS/B Yb,AL
ab: STOS/W/D/Q Yv,rAX
ac: LODS/B AL,Xb
ad: LODS/W/D/Q rAX,Xv
ae: SCAS/B AL,Yb
af: SCAS/W/D/Q rAX,Xv
# 0xb0 - 0xbf
b0: MOV AL/R8L,Ib
b1: MOV CL/R9L,Ib
b2: MOV DL/R10L,Ib
b3: MOV BL/R11L,Ib
b4: MOV AH/R12L,Ib
b5: MOV CH/R13L,Ib
b6: MOV DH/R14L,Ib
b7: MOV BH/R15L,Ib
b8: MOV rAX/r8,Iv
b9: MOV rCX/r9,Iv
ba: MOV rDX/r10,Iv
bb: MOV rBX/r11,Iv
bc: MOV rSP/r12,Iv
bd: MOV rBP/r13,Iv
be: MOV rSI/r14,Iv
bf: MOV rDI/r15,Iv
# 0xc0 - 0xcf
c0: Grp2 Eb,Ib (1A)
c1: Grp2 Ev,Ib (1A)
c2: RETN Iw (f64)
c3: RETN
c4: LES Gz,Mp (i64)
c5: LDS Gz,Mp (i64)
c6: Grp11 Eb,Ib (1A)
c7: Grp11 Ev,Iz (1A)
c8: ENTER Iw,Ib
c9: LEAVE (d64)
ca: RETF Iw
cb: RETF
cc: INT3
cd: INT Ib
ce: INTO (i64)
cf: IRET/D/Q
# 0xd0 - 0xdf
d0: Grp2 Eb,1 (1A)
d1: Grp2 Ev,1 (1A)
d2: Grp2 Eb,CL (1A)
d3: Grp2 Ev,CL (1A)
d4: AAM Ib (i64)
d5: AAD Ib (i64)
d6:
d7: XLAT/XLATB
d8: ESC
d9: ESC
da: ESC
db: ESC
dc: ESC
dd: ESC
de: ESC
df: ESC
# 0xe0 - 0xef
e0: LOOPNE/LOOPNZ Jb (f64)
e1: LOOPE/LOOPZ Jb (f64)
e2: LOOP Jb (f64)
e3: JrCXZ Jb (f64)
e4: IN AL,Ib
e5: IN eAX,Ib
e6: OUT Ib,AL
e7: OUT Ib,eAX
e8: CALL Jz (f64)
e9: JMP-near Jz (f64)
ea: JMP-far Ap (i64)
eb: JMP-short Jb (f64)
ec: IN AL,DX
ed: IN eAX,DX
ee: OUT DX,AL
ef: OUT DX,eAX
# 0xf0 - 0xff
f0: LOCK (Prefix)
f1:
f2: REPNE (Prefix)
f3: REP/REPE (Prefix)
f4: HLT
f5: CMC
f6: Grp3_1 Eb (1A)
f7: Grp3_2 Ev (1A)
f8: CLC
f9: STC
fa: CLI
fb: STI
fc: CLD
fd: STD
fe: Grp4 (1A)
ff: Grp5 (1A)
EndTable

Table: 2-byte opcode # First Byte is 0x0f
Referrer: 2-byte escape
# 0x0f 0x00-0x0f
00: Grp6 (1A)
01: Grp7 (1A)
02: LAR Gv,Ew
03: LSL Gv,Ew
04:
05: SYSCALL (o64)
06: CLTS
07: SYSRET (o64)
08: INVD
09: WBINVD
0a:
0b: UD2 (1B)
0c:
0d: NOP Ev
0e:
0f:
# 0x0f 0x10-0x1f
10:
11:
12:
13:
14:
15:
16:
17:
18: Grp16 (1A)
19:
1a:
1b:
1c:
1d:
1e:
1f: NOP Ev
# 0x0f 0x20-0x2f
20: MOV Rd,Cd
21: MOV Rd,Dd
22: MOV Cd,Rd
23: MOV Dd,Rd
24:
25:
26:
27:
28:
29:
2a:
2b:
2c:
2d:
2e:
2f:
# 0x0f 0x30-0x3f
30: WRMSR
31: RDTSC
32: RDMSR
33: RDPMC
34: SYSENTER
35: SYSEXIT
36:
37: GETSEC
38: escape # 3-byte escape 1
39:
3a: escape # 3-byte escape 2
3b:
3c:
3d:
3e:
3f:
# 0x0f 0x40-0x4f
40: CMOVO Gv,Ev
41: CMOVNO Gv,Ev
42: CMOVB/C/NAE Gv,Ev
43: CMOVAE/NB/NC Gv,Ev
44: CMOVE/Z Gv,Ev
45: CMOVNE/NZ Gv,Ev
46: CMOVBE/NA Gv,Ev
47: CMOVA/NBE Gv,Ev
48: CMOVS Gv,Ev
49: CMOVNS Gv,Ev
4a: CMOVP/PE Gv,Ev
4b: CMOVNP/PO Gv,Ev
4c: CMOVL/NGE Gv,Ev
4d: CMOVNL/GE Gv,Ev
4e: CMOVLE/NG Gv,Ev
4f: CMOVNLE/G Gv,Ev
# 0x0f 0x50-0x5f
50:
51:
52:
53:
54:
55:
56:
57:
58:
59:
5a:
5b:
5c:
5d:
5e:
5f:
# 0x0f 0x60-0x6f
60:
61:
62:
63:
64:
65:
66:
67:
68:
69:
6a:
6b:
6c:
6d:
6e:
6f:
# 0x0f 0x70-0x7f
70:
71: Grp12 (1A)
72: Grp13 (1A)
73: Grp14 (1A)
74:
75:
76:
77:
78: VMREAD Ed/q,Gd/q
79: VMWRITE Gd/q,Ed/q
7a:
7b:
7c:
7d:
7e:
7f:
# 0x0f 0x80-0x8f
80: JO Jz (f64)
81: JNO Jz (f64)
82: JB/JNAE/JC Jz (f64)
83: JNB/JAE/JNC Jz (f64)
84: JZ/JE Jz (f64)
85: JNZ/JNE Jz (f64)
86: JBE/JNA Jz (f64)
87: JNBE/JA Jz (f64)
88: JS Jz (f64)
89: JNS Jz (f64)
8a: JP/JPE Jz (f64)
8b: JNP/JPO Jz (f64)
8c: JL/JNGE Jz (f64)
8d: JNL/JGE Jz (f64)
8e: JLE/JNG Jz (f64)
8f: JNLE/JG Jz (f64)
# 0x0f 0x90-0x9f
90: SETO Eb
91: SETNO Eb
92: SETB/C/NAE Eb
93: SETAE/NB/NC Eb
94: SETE/Z Eb
95: SETNE/NZ Eb
96: SETBE/NA Eb
97: SETA/NBE Eb
98: SETS Eb
99: SETNS Eb
9a: SETP/PE Eb
9b: SETNP/PO Eb
9c: SETL/NGE Eb
9d: SETNL/GE Eb
9e: SETLE/NG Eb
9f: SETNLE/G Eb
# 0x0f 0xa0-0xaf
a0: PUSH FS (d64)
a1: POP FS (d64)
a2: CPUID
a3: BT Ev,Gv
a4: SHLD Ev,Gv,Ib
a5: SHLD Ev,Gv,CL
a6:
a7:
a8: PUSH GS (d64)
a9: POP GS (d64)
aa: RSM
ab: BTS Ev,Gv
ac: SHRD Ev,Gv,Ib
ad: SHRD Ev,Gv,CL
ae: Grp15 (1A),(1C)
af: IMUL Gv,Ev
# 0x0f 0xb0-0xbf
b0: CMPXCHG Eb,Gb
b1: CMPXCHG Ev,Gv
b2: LSS Gv,Mp
b3: BTR Ev,Gv
b4: LFS Gv,Mp
b5: LGS Gv,Mp
b6: MOVZX Gv,Eb
b7: MOVZX Gv,Ew
b8: JMPE | POPCNT Gv,Ev (F3)
b9: Grp10 (1A)
ba: Grp8 Ev,Ib (1A)
bb: BTC Ev,Gv
bc: BSF Gv,Ev
bd: BSR Gv,Ev
be: MOVSX Gv,Eb
bf: MOVSX Gv,Ew
# 0x0f 0xc0-0xcf
c0: XADD Eb,Gb
c1: XADD Ev,Gv
c2:
c3: movnti Md/q,Gd/q
c4:
c5:
c6:
c7: Grp9 (1A)
c8: BSWAP RAX/EAX/R8/R8D
c9: BSWAP RCX/ECX/R9/R9D
ca: BSWAP RDX/EDX/R10/R10D
cb: BSWAP RBX/EBX/R11/R11D
cc: BSWAP RSP/ESP/R12/R12D
cd: BSWAP RBP/EBP/R13/R13D
ce: BSWAP RSI/ESI/R14/R14D
cf: BSWAP RDI/EDI/R15/R15D
# 0x0f 0xd0-0xdf
d0:
d1:
d2:
d3:
d4:
d5:
d6:
d7:
d8:
d9:
da:
db:
dc:
dd:
de:
df:
# 0x0f 0xe0-0xef
e0:
e1:
e2:
e3:
e4:
e5:
e6:
e7:
e8:
e9:
ea:
eb:
ec:
ed:
ee:
ef:
# 0x0f 0xf0-0xff
f0:
f1:
f2:
f3:
f4:
f5:
f6:
f7:
f8:
f9:
fa:
fb:
fc:
fd:
fe:
ff:
EndTable

Table: 3-byte opcode 1
Referrer: 3-byte escape 1
80: INVEPT Gd/q,Mdq (66)
81: INVPID Gd/q,Mdq (66)
f0: MOVBE Gv,Mv | CRC32 Gd,Eb (F2)
f1: MOVBE Mv,Gv | CRC32 Gd,Ev (F2)
EndTable

Table: 3-byte opcode 2
Referrer: 3-byte escape 2
# all opcode is for SSE
EndTable

GrpTable: Grp1
0: ADD
1: OR
2: ADC
3: SBB
4: AND
5: SUB
6: XOR
7: CMP
EndTable

GrpTable: Grp1A
0: POP
EndTable

GrpTable: Grp2
0: ROL
1: ROR
2: RCL
3: RCR
4: SHL/SAL
5: SHR
6:
7: SAR
EndTable

GrpTable: Grp3_1
0: TEST Eb,Ib
1:
2: NOT Eb
3: NEG Eb
4: MUL AL,Eb
5: IMUL AL,Eb
6: DIV AL,Eb
7: IDIV AL,Eb
EndTable

GrpTable: Grp3_2
0: TEST Ev,Iz
1:
2: NOT Ev
3: NEG Ev
4: MUL rAX,Ev
5: IMUL rAX,Ev
6: DIV rAX,Ev
7: IDIV rAX,Ev
EndTable

GrpTable: Grp4
0: INC Eb
1: DEC Eb
EndTable

GrpTable: Grp5
0: INC Ev
1: DEC Ev
2: CALLN Ev (f64)
3: CALLF Ep
4: JMPN Ev (f64)
5: JMPF Ep
6: PUSH Ev (d64)
7:
EndTable

GrpTable: Grp6
0: SLDT Rv/Mw
1: STR Rv/Mw
2: LLDT Ew
3: LTR Ew
4: VERR Ew
5: VERW Ew
EndTable

GrpTable: Grp7
0: SGDT Ms | VMCALL (11B),(001) | VMLAUNCH (11B),(010) | VMRESUME (011),(11B) | VMXOFF (100),(11B)
1: SIDT Ms | MONITOR (000),(11B) | MWAIT (001)
2: LGDT Ms | XGETBV (000),(11B) | XSETBV (001),(11B)
3: LIDT Ms
4: SMSW Mw/Rv
5:
6: LMSW Ew
7: INVLPG Mb | SWAPGS (000),(o64),(11B) | RDTSCP (001),(11B)
EndTable

GrpTable: Grp8
4: BT
5: BTS
6: BTR
7: BTC
EndTable

GrpTable: Grp9
1: CMPXCHG8B/16B Mq/Mdq
6: VMPTRLD Mq | VMCLEAR Mq (66) | VMXON Mq (F3)
7: VMPTRST Mq
EndTable

GrpTable: Grp10
EndTable

GrpTable: Grp11
0: MOV
EndTable

GrpTable: Grp12
EndTable

GrpTable: Grp13
EndTable

GrpTable: Grp14
EndTable

GrpTable: Grp15
0: fxsave
1: fxstor
2: ldmxcsr
3: stmxcsr
4: XSAVE
5: XRSTOR | lfence (11B)
6: mfence (11B)
7: clflush | sfence (11B)
EndTable

GrpTable: Grp16
0: prefetch NTA
1: prefetch T0
2: prefetch T1
3: prefetch T2
EndTable

--------------000705000906080205070807--
