Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbZKJQPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbZKJQPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbZKJQNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:13:30 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59920 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917AbZKJQNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:13:23 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       John Johansen <john.johansen@canonical.com>
Subject: [PATCH 05/12] AppArmor: dfa match engine
Date: Tue, 10 Nov 2009 08:12:58 -0800
Message-Id: <1257869585-7092-6-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A basic dfa matching engine based off the dfa engine in the Dragon
Book.  It uses simple row compression with a check field.

This allows AppArmor to do pattern matching in linear time, and also
avoids stack issues that an nfa based engine may have.  The dfa
engine uses a byte based comparison, with all values being valid.
Any potential character encoding are handled user side when the dfa
tables are created.  By convention AppArmor uses \0 to separate two
dependent path matches since \0 is not a valid path character
(this is done in the link permission check).

The dfa tables are generated in user space and are verified at load
time to be internally consistent.

There are several future improvements planned for the dfa engine:
* Currently AppArmor permissions are embedded in the accept table.
  Inthe future AppArmor specific dependencies will be separated out,
  making the dfa a generic matching engine.
* The dfa engine may be converted to a hybrid nfa-dfa engine, with
  a fixed size limited stack.  This would allow for size time
  tradeoffs, by inserting limited nfa states to help control
  state explosion that can occur with dfas.
* The dfa engine may pickup the ability to do limited dynamic
  variable matching, instead of fixing all variables at policy
  load time.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/include/match.h |  104 +++++++++++++
 security/apparmor/match.c         |  301 +++++++++++++++++++++++++++++++++++++
 2 files changed, 405 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/include/match.h
 create mode 100644 security/apparmor/match.c

diff --git a/security/apparmor/include/match.h b/security/apparmor/include/match.h
new file mode 100644
index 0000000..bd5015d
--- /dev/null
+++ b/security/apparmor/include/match.h
@@ -0,0 +1,104 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor policy dfa matching engine definitions.
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#ifndef __AA_MATCH_H
+#define __AA_MATCH_H
+
+#define DFA_NOMATCH			0
+#define DFA_START			1
+
+#define DFA_VALID_PERM_MASK		0xffffffff
+#define DFA_VALID_PERM2_MASK		0xffffffff
+
+/**
+ * The format used for transition tables is based on the GNU flex table
+ * file format (--tables-file option; see Table File Format in the flex
+ * info pages and the flex sources for documentation). The magic number
+ * used in the header is 0x1B5E783D insted of 0xF13C57B1 though, because
+ * the YY_ID_CHK (check) and YY_ID_DEF (default) tables are used
+ * slightly differently (see the apparmor-parser package).
+ */
+
+#define YYTH_MAGIC	0x1B5E783D
+
+struct table_set_header {
+	u32 th_magic;		/* YYTH_MAGIC */
+	u32 th_hsize;
+	u32 th_ssize;
+	u16 th_flags;
+	char th_version[];
+};
+
+#define	YYTD_ID_ACCEPT	1
+#define YYTD_ID_BASE	2
+#define YYTD_ID_CHK	3
+#define YYTD_ID_DEF	4
+#define YYTD_ID_EC	5
+#define YYTD_ID_META	6
+#define YYTD_ID_ACCEPT2 7
+#define YYTD_ID_NXT	8
+
+#define YYTD_DATA8	1
+#define YYTD_DATA16	2
+#define YYTD_DATA32	4
+
+struct table_header {
+	u16 td_id;
+	u16 td_flags;
+	u32 td_hilen;
+	u32 td_lolen;
+	char td_data[];
+};
+
+#define DEFAULT_TABLE(DFA) ((u16 *)((DFA)->tables[YYTD_ID_DEF - 1]->td_data))
+#define BASE_TABLE(DFA) ((u32 *)((DFA)->tables[YYTD_ID_BASE - 1]->td_data))
+#define NEXT_TABLE(DFA) ((u16 *)((DFA)->tables[YYTD_ID_NXT - 1]->td_data))
+#define CHECK_TABLE(DFA) ((u16 *)((DFA)->tables[YYTD_ID_CHK - 1]->td_data))
+#define EQUIV_TABLE(DFA) ((u8 *)((DFA)->tables[YYTD_ID_EC - 1]->td_data))
+#define ACCEPT_TABLE(DFA) ((u32 *)((DFA)->tables[YYTD_ID_ACCEPT - 1]->td_data))
+#define ACCEPT_TABLE2(DFA) ((u32 *)\
+			    ((DFA)->tables[YYTD_ID_ACCEPT2 - 1]->td_data))
+
+struct aa_dfa {
+	struct table_header *tables[YYTD_ID_NXT];
+};
+
+#define byte_to_byte(X) (X)
+
+#define UNPACK_ARRAY(TABLE, BLOB, LEN, TYPE, NTOHX) \
+	do { \
+		typeof(LEN) __i; \
+		TYPE *__t = (TYPE *) TABLE; \
+		TYPE *__b = (TYPE *) BLOB; \
+		for (__i = 0; __i < LEN; __i++) { \
+			__t[__i] = NTOHX(__b[__i]); \
+		} \
+	} while (0)
+
+static inline size_t table_size(size_t len, size_t el_size)
+{
+	return ALIGN(sizeof(struct table_header) + len * el_size, 8);
+}
+
+struct aa_dfa *aa_match_alloc(void);
+void aa_match_free(struct aa_dfa *dfa);
+int unpack_dfa(struct aa_dfa *dfa, void *blob, size_t size);
+int verify_dfa(struct aa_dfa *dfa);
+unsigned int aa_dfa_match_len(struct aa_dfa *dfa, unsigned int start,
+			      const char *str, int len);
+unsigned int aa_dfa_match(struct aa_dfa *dfa, unsigned int start,
+			  const char *str);
+unsigned int aa_dfa_null_transition(struct aa_dfa *dfa, unsigned int start);
+
+#endif /* __AA_MATCH_H */
diff --git a/security/apparmor/match.c b/security/apparmor/match.c
new file mode 100644
index 0000000..c76807b
--- /dev/null
+++ b/security/apparmor/match.c
@@ -0,0 +1,301 @@
+/*
+ * AppArmor security module
+ *
+ * This file contains AppArmor dfa based regular expression matching engine
+ *
+ * Copyright (C) 1998-2008 Novell/SUSE
+ * Copyright 2009 Canonical Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include "include/apparmor.h"
+#include "include/match.h"
+#include "include/file.h"
+
+static void free_table(struct table_header *table)
+{
+	if (is_vmalloc_addr(table))
+		vfree(table);
+	else
+		kfree(table);
+}
+
+static struct table_header *unpack_table(void *blob, size_t bsize)
+{
+	struct table_header *table = NULL;
+	struct table_header th;
+	size_t tsize;
+
+	if (bsize < sizeof(struct table_header))
+		goto out;
+
+	th.td_id = be16_to_cpu(*(u16 *) (blob));
+	th.td_flags = be16_to_cpu(*(u16 *) (blob + 2));
+	th.td_lolen = be32_to_cpu(*(u32 *) (blob + 8));
+	blob += sizeof(struct table_header);
+
+	if (!(th.td_flags == YYTD_DATA16 || th.td_flags == YYTD_DATA32 ||
+	      th.td_flags == YYTD_DATA8))
+		goto out;
+
+	tsize = table_size(th.td_lolen, th.td_flags);
+	if (bsize < tsize)
+		goto out;
+
+	/* freed by free_table */
+	table = kmalloc(tsize, GFP_KERNEL);
+	if (!table)
+		table = vmalloc(tsize);
+	if (table) {
+		*table = th;
+		if (th.td_flags == YYTD_DATA8)
+			UNPACK_ARRAY(table->td_data, blob, th.td_lolen,
+				     u8, byte_to_byte);
+		else if (th.td_flags == YYTD_DATA16)
+			UNPACK_ARRAY(table->td_data, blob, th.td_lolen,
+				     u16, be16_to_cpu);
+		else
+			UNPACK_ARRAY(table->td_data, blob, th.td_lolen,
+				     u32, be32_to_cpu);
+	}
+
+out:
+	return table;
+}
+
+int unpack_dfa(struct aa_dfa *dfa, void *blob, size_t size)
+{
+	int hsize, i;
+	int error = -ENOMEM;
+
+	/* get dfa table set header */
+	if (size < sizeof(struct table_set_header))
+		goto fail;
+
+	if (ntohl(*(u32 *) blob) != YYTH_MAGIC)
+		goto fail;
+
+	hsize = ntohl(*(u32 *) (blob + 4));
+	if (size < hsize)
+		goto fail;
+
+	blob += hsize;
+	size -= hsize;
+
+	error = -EPROTO;
+	while (size > 0) {
+		struct table_header *table;
+		table = unpack_table(blob, size);
+		if (!table)
+			goto fail;
+
+		switch (table->td_id) {
+		case YYTD_ID_ACCEPT:
+		case YYTD_ID_ACCEPT2:
+		case YYTD_ID_BASE:
+			dfa->tables[table->td_id - 1] = table;
+			if (table->td_flags != YYTD_DATA32)
+				goto fail;
+			break;
+		case YYTD_ID_DEF:
+		case YYTD_ID_NXT:
+		case YYTD_ID_CHK:
+			dfa->tables[table->td_id - 1] = table;
+			if (table->td_flags != YYTD_DATA16)
+				goto fail;
+			break;
+		case YYTD_ID_EC:
+			dfa->tables[table->td_id - 1] = table;
+			if (table->td_flags != YYTD_DATA8)
+				goto fail;
+			break;
+		default:
+			free_table(table);
+			goto fail;
+		}
+
+		blob += table_size(table->td_lolen, table->td_flags);
+		size -= table_size(table->td_lolen, table->td_flags);
+	}
+
+	return 0;
+
+fail:
+	for (i = 0; i < ARRAY_SIZE(dfa->tables); i++) {
+		free_table(dfa->tables[i]);
+		dfa->tables[i] = NULL;
+	}
+	return error;
+}
+
+/**
+ * verify_dfa - verify that all the transitions and states in the dfa tables
+ *              are in bounds.
+ * @dfa: dfa to test
+ *
+ * assumes dfa has gone through the verification done by unpacking
+ */
+int verify_dfa(struct aa_dfa *dfa)
+{
+	size_t i, state_count, trans_count;
+	int error = -EPROTO;
+
+	/* check that required tables exist */
+	if (!(dfa->tables[YYTD_ID_ACCEPT - 1] &&
+	      dfa->tables[YYTD_ID_ACCEPT2 - 1] &&
+	      dfa->tables[YYTD_ID_DEF - 1] &&
+	      dfa->tables[YYTD_ID_BASE - 1] &&
+	      dfa->tables[YYTD_ID_NXT - 1] && dfa->tables[YYTD_ID_CHK - 1]))
+		goto out;
+
+	/* accept.size == default.size == base.size */
+	state_count = dfa->tables[YYTD_ID_BASE - 1]->td_lolen;
+	if (!(state_count == dfa->tables[YYTD_ID_DEF - 1]->td_lolen &&
+	      state_count == dfa->tables[YYTD_ID_ACCEPT - 1]->td_lolen &&
+	      state_count == dfa->tables[YYTD_ID_ACCEPT2 - 1]->td_lolen))
+		goto out;
+
+	/* next.size == chk.size */
+	trans_count = dfa->tables[YYTD_ID_NXT - 1]->td_lolen;
+	if (trans_count != dfa->tables[YYTD_ID_CHK - 1]->td_lolen)
+		goto out;
+
+	/* if equivalence classes then its table size must be 256 */
+	if (dfa->tables[YYTD_ID_EC - 1] &&
+	    dfa->tables[YYTD_ID_EC - 1]->td_lolen != 256)
+		goto out;
+
+	for (i = 0; i < state_count; i++) {
+		if (DEFAULT_TABLE(dfa)[i] >= state_count)
+			goto out;
+		if (BASE_TABLE(dfa)[i] >= trans_count + 256)
+			goto out;
+	}
+
+	for (i = 0; i < trans_count; i++) {
+		if (NEXT_TABLE(dfa)[i] >= state_count)
+			goto out;
+		if (CHECK_TABLE(dfa)[i] >= state_count)
+			goto out;
+	}
+
+	/* verify accept permissions */
+	for (i = 0; i < state_count; i++) {
+		int mode = ACCEPT_TABLE(dfa)[i];
+
+		if (mode & ~DFA_VALID_PERM_MASK)
+			goto out;
+		if (ACCEPT_TABLE2(dfa)[i] & ~DFA_VALID_PERM2_MASK)
+			goto out;
+
+	}
+
+	error = 0;
+out:
+	return error;
+}
+
+struct aa_dfa *aa_match_alloc(void)
+{
+	/* freed by aa_match_free, by caller */
+	return kzalloc(sizeof(struct aa_dfa), GFP_KERNEL);
+}
+
+void aa_match_free(struct aa_dfa *dfa)
+{
+	if (dfa) {
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(dfa->tables); i++)
+			free_table(dfa->tables[i]);
+	}
+	kfree(dfa);
+}
+
+/**
+ * aa_dfa_match_len - traverse @dfa to find state @str stops at
+ * @dfa: the dfa to match @str against
+ * @start: the state of the dfa to start matching in
+ * @str: the string of bytes to match against the dfa
+ * @len: length of the string of bytes to match
+ *
+ * aa_dfa_match_len will match @str against the dfa and return the state it
+ * finished matching in. The final state can be used to look up the accepting
+ * label, or as the start state of a continuing match.
+ *
+ * This function will happily match again the 0 byte and only finishes
+ * when @len input is consumed.
+ */
+unsigned int aa_dfa_match_len(struct aa_dfa *dfa, unsigned int start,
+			      const char *str, int len)
+{
+	u16 *def = DEFAULT_TABLE(dfa);
+	u32 *base = BASE_TABLE(dfa);
+	u16 *next = NEXT_TABLE(dfa);
+	u16 *check = CHECK_TABLE(dfa);
+	unsigned int state = start, pos;
+
+	if (state == 0)
+		return 0;
+
+	/* current state is <state>, matching character *str */
+	if (dfa->tables[YYTD_ID_EC - 1]) {
+		u8 *equiv = EQUIV_TABLE(dfa);
+		for (; len; len--) {
+			pos = base[state] + equiv[(u8) *str++];
+			if (check[pos] == state)
+				state = next[pos];
+			else
+				state = def[state];
+		}
+	} else {
+		for (; len; len--) {
+			pos = base[state] + (u8) *str++;
+			if (check[pos] == state)
+				state = next[pos];
+			else
+				state = def[state];
+		}
+	}
+	return state;
+}
+
+/**
+ * aa_dfa_next_state - traverse @dfa to find state @str stops at
+ * @dfa: the dfa to match @str against
+ * @start: the state of the dfa to start matching in
+ * @str: the null terminated string of bytes to match against the dfa
+ *
+ * aa_dfa_next_state will match @str against the dfa and return the state it
+ * finished matching in. The final state can be used to look up the accepting
+ * label, or as the start state of a continuing match.
+ */
+unsigned int aa_dfa_match(struct aa_dfa *dfa, unsigned int start,
+			  const char *str)
+{
+	return aa_dfa_match_len(dfa, start, str, strlen(str));
+}
+
+/**
+ * aa_dfa_null_transition - step to next state after null character
+ * @dfa: the dfa to match against
+ * @start: the state of the dfa to start matching in
+ *
+ * aa_dfa_null_transition transitions to the next state after a null
+ * character which is not used in standard matching and is only
+ * used to seperate pairs.
+ */
+unsigned int aa_dfa_null_transition(struct aa_dfa *dfa, unsigned int start)
+{
+	return aa_dfa_match_len(dfa, start, "", 1);
+}
-- 
1.6.3.3

